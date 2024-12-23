import { PrismaClient } from '@prisma/client';
import { body, validationResult } from 'express-validator';

const prisma = new PrismaClient();

// Validation rules for the request body
export const validatePersonalBest = [
    body('userId').isInt().withMessage('User ID must be an integer'),
    body('exerciseId').isInt().withMessage('Exercise ID must be an integer'),
    body('weight').isDecimal({ decimal_digits: '2' }).withMessage('Weight must be a decimal with 2 digits'),
    body('reps').isInt({ min: 1 }).withMessage('Reps must be a positive integer'),
];


export const logPersonalBest = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    try {
        const { userId, exerciseId, weight, reps } = req.body;

        // Validate if the exercise exists
        const exercise = await prisma.supported_exercises.findUnique({
            where: { supported_exercise_id: exerciseId },
        });

        if (!exercise) {
            return res.status(404).json({ message: 'Exercise not found' });
        }

        // Create a new personal best entry
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
            message: 'Personal best logged successfully',
            data: newPersonalBest,
        });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ message: 'An error occurred while logging the personal best' });
    }
};


export const getUserPersonalBestHistory = async (req, res) => {
    try {
        const { userId, exerciseId } = req.params;

        // Validate if the exercise exists
        const exercise = await prisma.supported_exercises.findUnique({
            where: { supported_exercise_id: parseInt(exerciseId) },
        });

        if (!exercise) {
            return res.status(404).json({ message: 'Exercise not found' });
        }

        // Retrieve all personal best records for the specific user and exercise
        const history = await prisma.personal_bests.findMany({
            where: {
                user_id: parseInt(userId),
                supported_exercise_id: parseInt(exerciseId),
            },
            orderBy: {
                achieved_at: 'asc',
            },
        });

        if (!history.length) {
            return res.status(404).json({ message: 'No history found for this user and exercise' });
        }

        return res.status(200).json({
            status: 'success',
            message: 'Personal best history fetched successfully',
            data: history,
        });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ message: 'An error occurred while fetching history' });
    }
};
