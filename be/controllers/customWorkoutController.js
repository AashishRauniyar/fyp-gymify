import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

// Create a new custom workout for the user
export const createCustomWorkout = async (req, res) => {
    try {
        const { user_id } = req.user;
        const { custom_workout_name } = req.body;

        if (!custom_workout_name) {
            return res.status(400).json({ status: 'failure', message: 'Workout name is required' });
        }

        const customWorkout = await prisma.customworkouts.create({
            data: {
                user_id,
                custom_workout_name,
                created_at: new Date()
            }
        });

        res.status(201).json({ status: 'success', message: 'Custom workout created successfully', data : customWorkout });
    } catch (error) {
        console.error('Error creating custom workout:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};

// Add multiple exercises to a custom workout
export const addExerciseToCustomWorkout = async (req, res) => {
    try {
        const { custom_workout_id, exercises } = req.body;

        // Validate that custom workout ID and exercises array are provided
        if (!custom_workout_id || !Array.isArray(exercises) || exercises.length === 0) {
            return res.status(400).json({ status: 'failure', message: 'Custom workout ID and exercises are required' });
        }

        const addedExercises = [];

        // Loop through the exercises array
        for (const exercise of exercises) {
            const { exercise_id, sets, reps, duration } = exercise;

            // Validate required fields
            if (!exercise_id || !sets || !reps || !duration) {
                continue; // Skip invalid entries
            }

            // Check if the exercise exists in the Exercises table
            const existingExercise = await prisma.exercises.findUnique({ where: { exercise_id } });
            if (!existingExercise) continue; // Skip if exercise does not exist

            // Check if the exercise is already added to this custom workout
            const existingCustomWorkoutExercise = await prisma.customworkoutexercises.findFirst({
                where: {
                    custom_workout_id,
                    exercise_id
                }
            });

            // Skip adding if it's already present
            if (existingCustomWorkoutExercise) {
                continue;
            }

            // Add the exercise to the custom workout
            const customWorkoutExercise = await prisma.customworkoutexercises.create({
                data: {
                    custom_workout_id,
                    exercise_id,
                    sets,
                    reps,
                    duration
                }
            });

            addedExercises.push(customWorkoutExercise);
        }

        // Check if any exercises were added
        if (addedExercises.length === 0) {
            return res.status(400).json({ status: 'failure', message: 'No new exercises were added. They might already exist in the custom workout.' });
        }

        res.status(201).json({
            status: 'success',
            message: 'Exercises added to custom workout successfully',
            data : addedExercises
        });
    } catch (error) {
        console.error('Error adding exercises to custom workout:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};



// get all exercises in custom workout

//TODO: Implement this function

export const getCustomWorkoutsOfUser = async (req, res) => {
    try {
        const { user_id } = req.user; // Extract user_id from the authenticated user

        // Fetch custom workouts for the user
        const customWorkouts = await prisma.customworkouts.findMany({
            where: { user_id }, // Use scalar value directly
            include: {
                customworkoutexercises: {
                    include: { exercises: true }, // Include related exercises
                },
            },
        });

        res.status(200).json({ status: 'success', message: "custom workouts" ,data : customWorkouts });
    } catch (error) {
        console.error('Error fetching custom workouts:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};




// get all exercises in custom workout by id

export const getCustomWorkoutExercisesById = async (req, res) => {
    try {
        const customWorkoutId = parseInt(req.params.id);

        const exercises = await prisma.customworkoutexercises.findMany({
            where: { custom_workout_id: customWorkoutId },
            include: { exercises: true }
        });

        res.status(200).json({ status: 'success', message : "custom workout fetched" ,data : exercises });
    } catch (error) {
        console.error('Error fetching exercises:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};

//! in use, working for flutter
export const getCustomWorkoutById = async (req, res) => {
    const { user_id } = req.user;

    // Ensure the user is authenticated
    if (!user_id) {
        return res.status(403).json({ status: 'failure', message: 'Access denied. Please login first' });
    }

    try {
        const customWorkoutId = parseInt(req.params.id);

        // Fetch the custom workout by ID, including exercises
        const customWorkout = await prisma.customworkouts.findUnique({
            where: { custom_workout_id: customWorkoutId },
            include: {
                customworkoutexercises: {
                    include: {
                        exercises: true // Include detailed information about each exercise
                    }
                }
            }
        });

        // If the custom workout doesn't exist
        if (!customWorkout) {
            return res.status(404).json({ status: 'failure', message: 'Custom workout not found' });
        }

        // Respond with the custom workout data
        res.status(200).json({
            status: 'success',
            message: 'Successfully fetched custom workout by ID',
            data: customWorkout,
        });
    } catch (error) {
        console.error('Error fetching custom workout:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};



// remove exercise from custom workout
export const removeExerciseFromCustomWorkout = async (req, res) => {
    try {
        const customWorkoutExerciseId = parseInt(req.params.id);

        await prisma.customworkoutexercises.delete({
            where: { custom_workout_exercise_id: customWorkoutExerciseId }
        });

        res.status(200).json({ status: 'success', message: 'Exercise removed from custom workout' });
    } catch (error) {
        console.error('Error removing exercise:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};



// Delete custom workout
export const deleteCustomWorkout = async (req, res) => {
    try {
        const customWorkoutId = parseInt(req.params.id);

        // Check if the custom workout exists
        const customWorkout = await prisma.customworkouts.findUnique({
            where: { custom_workout_id: customWorkoutId }
        });

        if (!customWorkout) {
            return res.status(404).json({ status: 'failure', message: 'Custom workout not found' });
        }

        // Remove all exercises related to this custom workout
        await prisma.customworkoutexercises.deleteMany({
            where: { custom_workout_id: customWorkoutId }
        });

        // Delete the custom workout
        await prisma.customworkouts.delete({
            where: { custom_workout_id: customWorkoutId }
        });

        res.status(200).json({ status: 'success', message: 'Custom workout deleted successfully' });
    } catch (error) {
        console.error('Error deleting custom workout:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};
