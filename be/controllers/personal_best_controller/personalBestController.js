// Import the shared Prisma client
import prisma from '../../prisma/prisma.js';
import { body, param, validationResult } from 'express-validator';

/**
 * Validation rules for creating a supported exercise
 */
export const validateSupportedExercise = [
    body('exerciseName')
        .isString()
        .trim()
        .notEmpty()
        .withMessage('Exercise name is required'),
];

/**
 * Create a new supported exercise (Trainer Only)
 */
export const createSupportedExercise = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    try {
        const { exerciseName } = req.body;
        const { role } = req.user;

        if (role !== 'Trainer') {
            return res.status(403).json({ message: 'Only trainers can create exercises' });
        }

        const existingExercise = await prisma.supported_exercises.findUnique({
            where: { exercise_name: exerciseName },
        });

        if (existingExercise) {
            return res.status(409).json({ message: 'Exercise already exists' });
        }

        const newExercise = await prisma.supported_exercises.create({
            data: {
                exercise_name: exerciseName,
            },
        });

        return res.status(201).json({
            status: 'success',
            message: 'Supported exercise created successfully',
            data: newExercise,
        });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ message: 'An error occurred while creating the exercise' });
    }
};


// delete supported exercise

export const deleteSupportedExercise = async (req, res) => {
    try {
        const { exerciseId } = req.params;
        const { role } = req.user;

        if (role !== 'Trainer') {
            return res.status(403).json({ message: 'Only trainers can delete exercises' });
        }

        const exercise = await prisma.supported_exercises.findUnique({
            where: { supported_exercise_id: parseInt(exerciseId) },
        });

        if (!exercise) {
            return res.status(404).json({ message: 'Exercise not found' });
        }

        await prisma.supported_exercises.delete({
            where: { supported_exercise_id: parseInt(exerciseId) },
        });

        return res.status(200).json({
            status: 'success',
            message: 'Supported exercise deleted successfully',
        });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ message: 'An error occurred while deleting the exercise' });
    }
}

/**
 * Validation rules for logging a personal best
 */
export const validatePersonalBest = [
    body('exerciseId').isInt().withMessage('Exercise ID must be an integer'),
    body('weight')
        .isFloat({ min: 0.1 })
        .withMessage('Weight must be a positive number'),
    body('reps')
        .isInt({ min: 1 })
        .withMessage('Reps must be a positive integer'),
];

/**
 * Log a personal best (User Only)
 */
export const logPersonalBest = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    try {
        const userId = req.user?.user_id;
        if (!userId) {
            return res.status(401).json({ message: 'Unauthorized: User ID not found in request' });
        }

        const { exerciseId, weight, reps } = req.body;

        const userExists = await prisma.users.findUnique({
            where: { user_id: userId },
        });

        if (!userExists) {
            return res.status(404).json({ message: 'User not found' });
        }

        const exercise = await prisma.supported_exercises.findUnique({
            where: { supported_exercise_id: exerciseId },
        });

        if (!exercise) {
            return res.status(404).json({ message: 'Exercise not found' });
        }

        // Create a new personal best entry regardless of previous records
        const newPersonalBest = await prisma.personal_bests.create({
            data: {
                user_id: userId,
                supported_exercise_id: exerciseId,
                weight,
                reps,
                achieved_at: new Date(),
            },
        });

        return res.status(201).json({
            status: 'success',
            message: 'Personal best logged successfully!',
            data: newPersonalBest,
        });
    } catch (error) {
        console.error('Error logging personal best:', error);
        return res.status(500).json({ message: 'An error occurred while logging the personal best' });
    }
};

/**
 * Validation rules for getting personal best history
 */
export const validateGetPersonalBestHistory = [
    param('exerciseId').isInt().withMessage('Exercise ID must be an integer'),
];

/**
 * Get current user's personal best history for a specific exercise
 */
export const getCurrentUserPersonalBestHistory = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    try {
        const userId = req.user?.user_id;
        if (!userId) {
            return res.status(401).json({ message: 'Unauthorized: User ID not found in request' });
        }

        const { exerciseId } = req.params;

        const exercise = await prisma.supported_exercises.findUnique({
            where: { supported_exercise_id: parseInt(exerciseId) },
        });

        if (!exercise) {
            return res.status(404).json({ message: 'Exercise not found' });
        }

        const history = await prisma.personal_bests.findMany({
            where: {
                user_id: userId,
                supported_exercise_id: parseInt(exerciseId),
            },
            orderBy: {
                achieved_at: 'desc',
            },
        });

        return res.status(200).json({
            status: 'success',
            message: 'Personal best history retrieved successfully',
            data: history,
        });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ message: 'An error occurred while fetching history' });
    }
};

/**
 * Get user's current personal best for each exercise
 */
export const getUserCurrentPersonalBests = async (req, res) => {
    try {
        const userId = req.user?.user_id;
        if (!userId) {
            return res.status(401).json({ message: 'Unauthorized: User ID not found in request' });
        }

        // Get all supported exercises
        const supportedExercises = await prisma.supported_exercises.findMany();

        // For each exercise, find the user's best record
        const personalBests = await Promise.all(
            supportedExercises.map(async (exercise) => {
                const best = await prisma.personal_bests.findFirst({
                    where: {
                        user_id: userId,
                        supported_exercise_id: exercise.supported_exercise_id,
                    },
                    orderBy: {
                        weight: 'desc',
                    },
                });

                return {
                    exercise: exercise,
                    personalBest: best || null
                };
            })
        );

        return res.status(200).json({
            status: 'success',
            message: 'Current personal bests retrieved successfully',
            data: personalBests,
        });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ message: 'An error occurred while fetching personal bests' });
    }
};

/**
 * Delete a personal best record
 */
export const deletePersonalBest = async (req, res) => {
    try {
        const userId = req.user?.user_id;
        if (!userId) {
            return res.status(401).json({ message: 'Unauthorized: User ID not found in request' });
        }

        const { personalBestId } = req.params;

        // Check if the record exists and belongs to the user
        const record = await prisma.personal_bests.findFirst({
            where: {
                personal_best_id: parseInt(personalBestId),
                user_id: userId,
            },
        });

        if (!record) {
            return res.status(404).json({ message: 'Personal best record not found or not owned by user' });
        }

        // Delete the record
        await prisma.personal_bests.delete({
            where: {
                personal_best_id: parseInt(personalBestId),
            },
        });

        return res.status(200).json({
            status: 'success',
            message: 'Personal best record deleted successfully',
        });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ message: 'An error occurred while deleting the record' });
    }
};

/**
 * Get all supported exercises
 */
export const getAllSupportedExercises = async (req, res) => {
    try {
        const exercises = await prisma.supported_exercises.findMany({
            orderBy: {
                exercise_name: 'asc',
            },
        });

        return res.status(200).json({
            status: 'success',
            message: 'Supported exercises retrieved successfully',
            data: exercises,
        });
    } catch (error) {
        console.error('Error fetching supported exercises:', error);
        return res.status(500).json({ message: 'An error occurred while fetching supported exercises' });
    }
};

/**
 * Get user's progress over time for a specific exercise
 */
export const getExerciseProgressOverTime = async (req, res) => {
    try {
        const userId = req.user?.user_id;
        if (!userId) {
            return res.status(401).json({ message: 'Unauthorized: User ID not found in request' });
        }

        const { exerciseId } = req.params;

        const exercise = await prisma.supported_exercises.findUnique({
            where: { supported_exercise_id: parseInt(exerciseId) },
        });

        if (!exercise) {
            return res.status(404).json({ message: 'Exercise not found' });
        }

        // Get all records for this exercise, ordered by date
        const progressData = await prisma.personal_bests.findMany({
            where: {
                user_id: userId,
                supported_exercise_id: parseInt(exerciseId),
            },
            orderBy: {
                achieved_at: 'asc',
            },
            select: {
                personal_best_id: true,
                weight: true,
                reps: true,
                achieved_at: true,
            },
        });

        return res.status(200).json({
            status: 'success',
            message: 'Exercise progress data retrieved successfully',
            data: {
                exercise: exercise,
                progressData: progressData,
            },
        });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ message: 'An error occurred while fetching progress data' });
    }
};
