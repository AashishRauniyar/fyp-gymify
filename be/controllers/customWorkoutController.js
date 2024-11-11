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

        res.status(201).json({ status: 'success', message: 'Custom workout created successfully', customWorkout });
    } catch (error) {
        console.error('Error creating custom workout:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};


// add exercise to custom workout
export const addExerciseToCustomWorkout = async (req, res) => {
    try {
        const { custom_workout_id, exercise_id, sets, reps, duration } = req.body;

        if (!custom_workout_id || !exercise_id) {
            return res.status(400).json({ status: 'failure', message: 'Custom workout ID and exercise ID are required' });
        }

        const customWorkoutExercise = await prisma.customworkoutexercises.create({
            data: {
                custom_workout_id,
                exercise_id,
                sets,
                reps,
                duration
            }
        });

        res.status(201).json({ status: 'success', message: 'Exercise added to custom workout', customWorkoutExercise });
    } catch (error) {
        console.error('Error adding exercise to custom workout:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};


// get all exercises in custom workout

export const getCustomWorkoutExercises = async (req, res) => {
    try {
        const customWorkoutId = parseInt(req.params.id);

        const exercises = await prisma.customworkoutexercises.findMany({
            where: { custom_workout_id: customWorkoutId },
            include: { exercises: true }
        });

        res.status(200).json({ status: 'success', exercises });
    } catch (error) {
        console.error('Error fetching exercises:', error);
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
