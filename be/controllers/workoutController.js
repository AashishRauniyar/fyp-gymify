import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

// Create a new workout (Trainer only)
export const createWorkout = async (req, res) => {
    try {
        const { user_id, role } = req.user;

        // Ensure the user is a trainer
        if (role !== 'Trainer') {
            return res.status(403).json({ status: 'failure', message: 'Access denied. Trainers only' });
        }

        const { workout_name, description, target_muscle_group, difficulty } = req.body;

        // Validate required fields
        if (!workout_name || !description || !target_muscle_group || !difficulty) {
            return res.status(400).json({ status: 'failure', message: 'Missing required fields' });
        }

        // Validate difficulty level
        const validDifficulties = ['Easy', 'Intermediate', 'Hard'];
        if (!validDifficulties.includes(difficulty)) {
            return res.status(400).json({ status: 'failure', message: 'Invalid difficulty level' });
        }

        // Create the workout
        const workout = await prisma.workouts.create({
            data: {
                workout_name,
                description,
                target_muscle_group,
                difficulty,
                trainer_id: user_id,
                created_at: new Date()
            }
        });

        res.status(201).json({
            status: 'success',
            message: 'Workout created successfully',
            workout
        });
    } catch (error) {
        console.error('Error creating workout:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};

// // Add exercise to workout (Trainer only)
// export const addExerciseToWorkout = async (req, res) => {
//     try {
//         const { user_id, role } = req.user;
        
//         // Ensure the user is a trainer
//         if (role !== 'Trainer') {
//             return res.status(403).json({ status: 'failure', message: 'Access denied. Trainers only' });
//         }

//         const workoutId = parseInt(req.params.workoutId);
//         const { exercise_id, sets, reps, duration } = req.body;

//         // Validate required fields
//         if (!exercise_id || !sets || !reps || !duration) {
//             return res.status(400).json({ status: 'failure', message: 'Missing required fields' });
//         }

//         // Check if the workout exists
//         const workout = await prisma.workouts.findUnique({ where: { workout_id: workoutId } });
//         if (!workout) {
//             return res.status(404).json({ status: 'failure', message: 'Workout not found' });
//         }

//         // Check if the exercise exists
//         const exercise = await prisma.exercises.findUnique({ where: { exercise_id: exercise_id } });
//         if (!exercise) {
//             return res.status(404).json({ status: 'failure', message: 'Exercise not found' });
//         }

//         // Add the exercise to the workout
//         const workoutExercise = await prisma.workoutexercises.create({
//             data: {
//                 workout_id: workoutId,
//                 exercise_id: exercise_id,
//                 sets: sets,
//                 reps: reps,
//                 duration: duration
//             }
//         });

//         res.status(201).json({
//             status: 'success',
//             message: 'Exercise added to workout successfully',
//             workoutExercise
//         });
//     } catch (error) {
//         console.error('Error adding exercise to workout:', error);
//         res.status(500).json({ status: 'failure', message: 'Server error' });
//     }
// };

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

        if (!Array.isArray(exercises) || exercises.length === 0) {
            return res.status(400).json({ status: 'failure', message: 'No exercises provided' });
        }

        const addedExercises = [];

        for (const exercise of exercises) {
            const { exercise_id, sets, reps, duration } = exercise;

            // Validate required fields
            if (!exercise_id || !sets || !reps || !duration) {
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
        }

        res.status(201).json({
            status: 'success',
            message: 'Exercises added to workout successfully',
            addedExercises,
        });
    } catch (error) {
        console.error('Error adding exercises to workout:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};


export const getAllWorkouts = async (req, res) => {
    try {
        const workouts = await prisma.workouts.findMany({
            include: { workoutexercises: true }
        });
        res.status(200).json({ status: 'success', workouts });
    } catch (error) {
        console.error('Error fetching workouts:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};


// get workout by ID 
export const getWorkoutById = async (req, res) => {
    try {
        const workoutId = parseInt(req.params.id);

        const workout = await prisma.workouts.findUnique({
            where: { workout_id: workoutId },
            include: { workoutexercises: { include: { exercises: true } } }
        });

        if (!workout) {
            return res.status(404).json({ status: 'failure', message: 'Workout not found' });
        }

        res.status(200).json({ status: 'success', workout });
    } catch (error) {
        console.error('Error fetching workout:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};




// Update workout by ID (Trainer only)
export const updateWorkout = async (req, res) => {
    try {
        const { user_id, role } = req.user;
        const workoutId = parseInt(req.params.id);

        if (role !== 'Trainer') {
            return res.status(403).json({ status: 'failure', message: 'Access denied' });
        }

        const { workout_name, description, target_muscle_group, difficulty } = req.body;

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
                updated_at: new Date()
            }
        });

        res.status(200).json({ status: 'success', message: 'Workout updated successfully', updatedWorkout });
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




// start workout logs for a user
export const startWorkoutLog = async (req, res) => {
    try {
        const { user_id } = req.user;
        const { workout_id } = req.body;

        // Create a new workout log entry
        const workoutLog = await prisma.workoutlogs.create({
            data: {
                user_id: user_id,
                workout_id: workout_id,
                workout_date: new Date(),
                start_time: new Date()
            }
        });

        res.status(201).json({ status: 'success', workoutLog });
    } catch (error) {
        console.error('Error starting workout log:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};

// log exercise progress
export const logExerciseProgress = async (req, res) => {
    try {
        const { workout_log_id, exercise_id, start_time, end_time, exercise_duration, rest_duration, skipped } = req.body;

        // Create a new workout exercise log entry
        const exerciseLog = await prisma.workoutexerciseslogs.create({
            data: {
                workout_log_id,
                exercise_id,
                start_time,
                end_time,
                exercise_duration,
                rest_duration,
                skipped
            }
        });

        res.status(201).json({ status: 'success', exerciseLog });
    } catch (error) {
        console.error('Error logging exercise:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};

// complete workout log
export const completeWorkoutLog = async (req, res) => {
    try {
        const { workout_log_id, end_time, total_duration, calories_burned, performance_notes } = req.body;

        const updatedLog = await prisma.workoutlogs.update({
            where: { log_id: workout_log_id },
            data: {
                end_time,
                total_duration,
                calories_burned,
                performance_notes
            }
        });

        res.status(200).json({ status: 'success', updatedLog });
    } catch (error) {
        console.error('Error completing workout log:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};
