import { PrismaClient } from '@prisma/client';
import { body, validationResult } from 'express-validator';

const prisma = new PrismaClient();

// Validation rules for the request body
export const validatePersonalBest = [
    // Check that the userId is a valid integer
    body('userId').isInt().withMessage('User ID must be an integer'),

    // Check that the exercise is one of the allowed values
    body('exercise')
        .isIn(['Squat', 'Bench Press', 'Deadlift'])
        .withMessage('Exercise must be Squat, Bench Press, or Deadlift'),

    // Validate that weight is a decimal number
    body('weight').isDecimal({ decimal_digits: '2' }).withMessage('Weight must be a decimal with 2 digits'),

    // Validate that reps is a positive integer
    body('reps').isInt({ min: 1 }).withMessage('Reps must be a positive integer'),
];

// Controller to log personal best
export const logPersonalBest = async (req, res) => {
    // Validate the request body
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    try {
        // Destructure the validated data from the request body
        const { userId, exercise, weight, reps } = req.body;

        // Create a new personal best entry
        const newPersonalBest = await prisma.personal_bests.create({
            
            data: {
                user_id: userId,
                exercise: exercise,
                weight: weight,
                reps: reps,
                achieved_at: new Date(), // Date when the personal best is achieved
            },
        });

        // Send success response
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



// Get user's history for a specific exercise
export const getUserPersonalBestHistory = async (req, res) => {
    try {
        const { userId, exercise } = req.params;

        // Retrieve all personal best records for the specific user and exercise
        const history = await prisma.personal_bests.findMany({
            where: {
                user_id: parseInt(userId),
                exercise: exercise,
            },
            orderBy: {
                achieved_at: 'asc', // Sort by date, so the progress bar can show it in order
            },
        });

        // If no history found, send an empty array
        if (!history.length) {
            return res.status(404).json({ message: 'No history found for this exercise' });
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
