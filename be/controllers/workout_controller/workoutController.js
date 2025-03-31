import { PrismaClient } from '@prisma/client';
import { uploadWorkoutImageToCloudinary } from '../../middleware/cloudinaryMiddleware.js';

const prisma = new PrismaClient();


export const createWorkout = async (req, res) => {
    try {
        const { user_id, role } = req.user;

        // Ensure the user is a trainer
        if (role !== 'Trainer') {
            return res.status(403).json({ status: 'failure', message: 'Access denied. Trainers only' });
        }

        const { workout_name, description, target_muscle_group, difficulty, goal_type, fitness_level } = req.body;

        // Validate required fields
        if (!workout_name || !description || !target_muscle_group || !difficulty || !goal_type || !fitness_level) {
            return res.status(400).json({ status: 'failure', message: 'Missing required fields' });
        }

        // Validate difficulty level
        const validDifficulties = ['Easy', 'Intermediate', 'Hard'];
        if (!validDifficulties.includes(difficulty)) {
            return res.status(400).json({ status: 'failure', message: 'Invalid difficulty level' });
        }

        // Validate goal_type and fitness_level values
        const validGoalTypes = ['Weight_Loss', 'Muscle_Gain', 'Endurance', 'Maintenance', 'Flexibility'];
        if (!validGoalTypes.includes(goal_type)) {
            return res.status(400).json({ status: 'failure', message: 'Invalid goal type' });
        }

        const validFitnessLevels = ['Beginner', 'Intermediate', 'Advanced', 'Athlete'];
        if (!validFitnessLevels.includes(fitness_level)) {
            return res.status(400).json({ status: 'failure', message: 'Invalid fitness level' });
        }


        let workoutImageUrl = null;
        if (req.file) {
            try {
                workoutImageUrl = await uploadWorkoutImageToCloudinary(req.file.buffer); // Pass the file buffer directly
            } catch (error) {
                console.error('Error uploading image:', error);
                return res.status(500).json({ status: 'failure', message: 'Image upload failed' });
            }
        }

        // Create the workout
        const workout = await prisma.workouts.create({
            data: {
                workout_name,
                description,
                target_muscle_group,
                difficulty,
                goal_type,            // Add goal_type to the data
                fitness_level,
                workout_image: workoutImageUrl,        // Add fitness_level to the data
                trainer_id: user_id,
                created_at: new Date()
            }
        });

        res.status(201).json({
            status: 'success',
            message: 'Workout created successfully',
            data: workout
        });
    } catch (error) {
        console.error('Error creating workout:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};


// Add multiple exercises to a workout (Trainer only)
export const addExerciseToWorkout = async (req, res) => {
    try {
        const { user_id, role } = req.user;

        // Ensure the user is a trainer
        if (role !== 'Trainer') {
            return res.status(403).json({ status: 'failure', message: 'Access denied. Trainers only' });
        }

        const workoutId = parseInt(req.params.workoutId);
        const exercises = req.body.exercises; // Expecting an array of exercises

        console.log('Processing exercise:', exercises);

        console.log('Request payload:', req.body);
        console.log('Workout ID:', req.params.workoutId);

        if (!Array.isArray(exercises) || exercises.length === 0) {
            return res.status(400).json({ status: 'failure', message: 'No exercises provided' });
        }

        const addedExercises = [];

        for (const exercise of exercises) {

            const { exercise_id, sets, reps, duration } = exercise;

            // Validate required fields
            // fixed as duration was 0 which is a valid value

            if (!exercise_id || !sets || !reps || duration == undefined) {
                continue;
            }

            // Check if the exercise exists
            const existingExercise = await prisma.exercises.findUnique({ where: { exercise_id } });
            if (!existingExercise) continue;

            // Check if the exercise is already added to this workout
            const existingWorkoutExercise = await prisma.workoutexercises.findFirst({
                where: {
                    workout_id: workoutId,
                    exercise_id,
                },
            });

            if (existingWorkoutExercise) {
                continue; // Skip adding if it's already present
            }

            // Add the exercise to the workout
            const workoutExercise = await prisma.workoutexercises.create({
                data: {
                    workout_id: workoutId,
                    exercise_id,
                    sets,
                    reps,
                    duration,
                },
            });
            addedExercises.push(workoutExercise);
            console.log(addedExercises);
        }

        res.status(201).json({
            status: 'success',
            message: 'Exercises added to workout successfully',
            data: addedExercises,
        });
    } catch (error) {
        console.error('Error adding exercises to workout:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};


export const getAllWorkouts = async (req, res) => {

    const { user_id } = req.user;
    // Ensure only trainers can create exercises
    if (!user_id) {
        return res.status(403).json({ status: 'failure', message: 'Access denied. Please login first' });
    }

    try {
        const workouts = await prisma.workouts.findMany({
            include: { workoutexercises: true }
        });
        res.status(200).json({ status: 'success', message: 'successfully fetched exercise', data: workouts });
    } catch (error) {
        console.error('Error fetching workouts:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};


// get workout by ID 
export const getWorkoutById = async (req, res) => {

    const { user_id } = req.user;
    // Ensure only trainers can create exercises
    if (!user_id) {
        return res.status(403).json({ status: 'failure', message: 'Access denied. Please login first' });
    }

    try {
        const workoutId = parseInt(req.params.id);

        const workout = await prisma.workouts.findUnique({
            where: { workout_id: workoutId },
            include: { workoutexercises: { include: { exercises: true } } }
        });

        if (!workout) {
            return res.status(404).json({ status: 'failure', message: 'Workout not found' });
        }

        res.status(200).json({ status: 'success', message: "successfully fetched workout by id", data: workout });
    } catch (error) {
        console.error('Error fetching workout:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};




// Update workout by ID (Trainer only)
// export const updateWorkout = async (req, res) => {
//     try {
//         const { user_id, role } = req.user;
//         const workoutId = parseInt(req.params.id);

//         if (role !== 'Trainer') {
//             return res.status(403).json({ status: 'failure', message: 'Access denied' });
//         }

//         const { workout_name, description, target_muscle_group, difficulty } = req.body;

//         // Check if workout exists
//         const workoutExists = await prisma.workouts.findUnique({ where: { workout_id: workoutId } });
//         if (!workoutExists) {
//             return res.status(404).json({ status: 'failure', message: 'Workout not found' });
//         }

//         // Update the workout
//         const updatedWorkout = await prisma.workouts.update({
//             where: { workout_id: workoutId },
//             data: {
//                 workout_name,
//                 description,
//                 target_muscle_group,
//                 difficulty,
//                 goal_type,
//                 fitness_level,
//                 updated_at: new Date()
//             }
//         });

//         res.status(200).json({ status: 'success', message: 'Workout updated successfully', data: updatedWorkout });
//     } catch (error) {
//         console.error('Error updating workout:', error);
//         res.status(500).json({ status: 'failure', message: 'Server error' });
//     }
// };

// Update workout by ID (Trainer only)
export const updateWorkout = async (req, res) => {
    try {
        const { user_id, role } = req.user;
        const workoutId = parseInt(req.params.id);

        if (role !== 'Trainer') {
            return res.status(403).json({ status: 'failure', message: 'Access denied' });
        }

        // Extract ALL required fields from the request body
        const {
            workout_name,
            description,
            target_muscle_group,
            difficulty,
            goal_type,       // Add this line - you were missing it
            fitness_level    // Add this line - you were missing it
        } = req.body;

        // Check if workout exists
        const workoutExists = await prisma.workouts.findUnique({ where: { workout_id: workoutId } });
        if (!workoutExists) {
            return res.status(404).json({ status: 'failure', message: 'Workout not found' });
        }

        // Update the workout
        const updatedWorkout = await prisma.workouts.update({
            where: { workout_id: workoutId },
            data: {
                workout_name,
                description,
                target_muscle_group,
                difficulty,
                goal_type,
                fitness_level,
                updated_at: new Date()
            }
        });

        res.status(200).json({ status: 'success', message: 'Workout updated successfully', data: updatedWorkout });
    } catch (error) {
        console.error('Error updating workout:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};

// Delete workout by ID (Trainer only)
export const deleteWorkout = async (req, res) => {
    try {
        const { user_id, role } = req.user;
        const workoutId = parseInt(req.params.id);

        if (role !== 'Trainer') {
            return res.status(403).json({ status: 'failure', message: 'Access denied' });
        }

        // Check if workout exists
        const workoutExists = await prisma.workouts.findUnique({ where: { workout_id: workoutId } });
        if (!workoutExists) {
            return res.status(404).json({ status: 'failure', message: 'Workout not found' });
        }

        // Delete the workout
        await prisma.workouts.delete({ where: { workout_id: workoutId } });

        res.status(200).json({ status: 'success', message: 'Workout deleted successfully' });
    } catch (error) {
        console.error('Error deleting workout:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};




// // start workout logs for a user
// export const startWorkoutLog = async (req, res) => {
//     try {
//         const { user_id } = req.user;
//         const { workout_id } = req.body;

//         // Create a new workout log entry
//         const workoutLog = await prisma.workoutlogs.create({
//             data: {
//                 user_id: user_id,
//                 workout_id: workout_id,
//                 workout_date: new Date(),
//                 start_time: new Date()
//             }
//         });

//         res.status(201).json({ status: 'success', workoutLog });
//     } catch (error) {
//         console.error('Error starting workout log:', error);
//         res.status(500).json({ status: 'failure', message: 'Server error' });
//     }
// };

// // log exercise progress
// export const logExerciseProgress = async (req, res) => {
//     try {
//         const { workout_log_id, exercise_id, start_time, end_time, exercise_duration, rest_duration, skipped } = req.body;

//         // Create a new workout exercise log entry
//         const exerciseLog = await prisma.workoutexerciseslogs.create({
//             data: {
//                 workout_log_id,
//                 exercise_id,
//                 start_time,
//                 end_time,
//                 exercise_duration,
//                 rest_duration,
//                 skipped
//             }
//         });

//         res.status(201).json({ status: 'success', exerciseLog });
//     } catch (error) {
//         console.error('Error logging exercise:', error);
//         res.status(500).json({ status: 'failure', message: 'Server error' });
//     }
// };

// // complete workout log
// export const completeWorkoutLog = async (req, res) => {
//     try {
//         const { workout_log_id, end_time, total_duration, calories_burned, performance_notes } = req.body;

//         const updatedLog = await prisma.workoutlogs.update({
//             where: { log_id: workout_log_id },
//             data: {
//                 end_time,
//                 total_duration,
//                 calories_burned,
//                 performance_notes
//             }
//         });

//         res.status(200).json({ status: 'success', updatedLog });
//     } catch (error) {
//         console.error('Error completing workout log:', error);
//         res.status(500).json({ status: 'failure', message: 'Server error' });
//     }
// };



// //TODO: TO Implement workout logs

// 1. First, let's add a new route to your workoutRouter.js



// 2. Now, let's create the bulkCreateWorkouts controller function in workoutController.js

export const bulkCreateWorkouts = async (req, res) => {
    try {
        const { user_id, role } = req.user;

        // Ensure the user is a trainer
        if (role !== 'Trainer') {
            return res.status(403).json({ status: 'failure', message: 'Access denied. Trainers only' });
        }

        // Get the workouts data from the request body
        const { workouts } = req.body;

        // Validate workouts data
        if (!Array.isArray(workouts) || workouts.length === 0) {
            return res.status(400).json({ status: 'failure', message: 'No workouts provided or invalid format' });
        }

        // Get uploaded files
        const uploadedFiles = req.files || [];

        // Create a mapping between workout index and file
        const fileMap = {};
        uploadedFiles.forEach(file => {
            // Expecting filenames like "workout_0.jpg", "workout_1.png" where the number is the workout index
            const match = file.originalname.match(/workout_(\d+)/);
            if (match && match[1]) {
                const workoutIndex = parseInt(match[1]);
                fileMap[workoutIndex] = file;
            }
        });

        // Create workouts and their exercises
        const createdWorkouts = [];

        for (let i = 0; i < workouts.length; i++) {
            const workout = workouts[i];
            const {
                workout_name,
                description,
                target_muscle_group,
                difficulty,
                goal_type,
                fitness_level,
                exercises
            } = workout;

            // Validate required workout fields
            if (!workout_name || !description || !target_muscle_group || !difficulty || !goal_type || !fitness_level) {
                continue; // Skip invalid workouts
            }

            // Validate difficulty level
            const validDifficulties = ['Easy', 'Intermediate', 'Hard'];
            if (!validDifficulties.includes(difficulty)) {
                continue;
            }

            // Validate goal_type and fitness_level values
            const validGoalTypes = ['Weight_Loss', 'Muscle_Gain', 'Endurance', 'Maintenance', 'Flexibility'];
            if (!validGoalTypes.includes(goal_type)) {
                continue;
            }

            const validFitnessLevels = ['Beginner', 'Intermediate', 'Advanced', 'Athlete'];
            if (!validFitnessLevels.includes(fitness_level)) {
                continue;
            }

            // Upload image if available for this workout
            let workoutImageUrl = null;
            if (fileMap[i]) {
                try {
                    workoutImageUrl = await uploadWorkoutImageToCloudinary(fileMap[i].buffer);
                } catch (error) {
                    console.error(`Error uploading image for workout ${i}:`, error);
                    // Continue without image if upload fails
                }
            }

            // Create the workout
            const createdWorkout = await prisma.workouts.create({
                data: {
                    workout_name,
                    description,
                    target_muscle_group,
                    difficulty,
                    goal_type,
                    fitness_level,
                    workout_image: workoutImageUrl,
                    trainer_id: user_id,
                    created_at: new Date()
                }
            });

            // Process exercises if any
            if (Array.isArray(exercises) && exercises.length > 0) {
                const addedExercises = [];

                for (const exercise of exercises) {
                    const { exercise_id, sets, reps, duration } = exercise;

                    // Validate required fields
                    if (!exercise_id || !sets || !reps || duration === undefined) {
                        continue;
                    }

                    // Check if the exercise exists
                    const existingExercise = await prisma.exercises.findUnique({ where: { exercise_id } });
                    if (!existingExercise) continue;

                    // Add the exercise to the workout
                    const workoutExercise = await prisma.workoutexercises.create({
                        data: {
                            workout_id: createdWorkout.workout_id,
                            exercise_id,
                            sets,
                            reps,
                            duration,
                        },
                    });
                    addedExercises.push(workoutExercise);
                }

                // Add the exercises to the created workout object for response
                createdWorkout.exercises = addedExercises;
            }

            createdWorkouts.push(createdWorkout);
        }

        res.status(201).json({
            status: 'success',
            message: `Successfully created ${createdWorkouts.length} workouts`,
            data: createdWorkouts
        });
    } catch (error) {
        console.error('Error bulk creating workouts:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};