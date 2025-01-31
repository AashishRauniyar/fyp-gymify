// import { PrismaClient } from '@prisma/client';
// import { body, validationResult } from 'express-validator';

// const prisma = new PrismaClient();

// // Validation rules for the request body
// export const validatePersonalBest = [
//     body('userId').isInt().withMessage('User ID must be an integer'),
//     body('exerciseId').isInt().withMessage('Exercise ID must be an integer'),
//     body('weight').isDecimal({ decimal_digits: '2' }).withMessage('Weight must be a decimal with 2 digits'),
//     body('reps').isInt({ min: 1 }).withMessage('Reps must be a positive integer'),
// ];


// export const logPersonalBest = async (req, res) => {
//     const errors = validationResult(req);
//     if (!errors.isEmpty()) {
//         return res.status(400).json({ errors: errors.array() });
//     }

//     try {
//         const { userId, exerciseId, weight, reps } = req.body;

//         // Validate if the exercise exists
//         const exercise = await prisma.supported_exercises.findUnique({
//             where: { supported_exercise_id: exerciseId },
//         });

//         if (!exercise) {
//             return res.status(404).json({ message: 'Exercise not found' });
//         }

//         // Create a new personal best entry
//         const newPersonalBest = await prisma.personal_bests.create({
//             data: {
//                 user_id: userId,
//                 supported_exercise_id: exerciseId,
//                 weight,
//                 reps,
//                 achieved_at: new Date(),
//             },
//         });

//         return res.status(201).json({
//             status: 'success',
//             message: 'Personal best logged successfully',
//             data: newPersonalBest,
//         });
//     } catch (error) {
//         console.error(error);
//         return res.status(500).json({ message: 'An error occurred while logging the personal best' });
//     }
// };


// export const getUserPersonalBestHistory = async (req, res) => {
//     try {
//         const { userId, exerciseId } = req.params;

//         // Validate if the exercise exists
//         const exercise = await prisma.supported_exercises.findUnique({
//             where: { supported_exercise_id: parseInt(exerciseId) },
//         });

//         if (!exercise) {
//             return res.status(404).json({ message: 'Exercise not found' });
//         }

//         // Retrieve all personal best records for the specific user and exercise
//         const history = await prisma.personal_bests.findMany({
//             where: {
//                 user_id: parseInt(userId),
//                 supported_exercise_id: parseInt(exerciseId),
//             },
//             orderBy: {
//                 achieved_at: 'asc',
//             },
//         });

//         if (!history.length) {
//             return res.status(404).json({ message: 'No history found for this user and exercise' });
//         }

//         return res.status(200).json({
//             status: 'success',
//             message: 'Personal best history fetched successfully',
//             data: history,
//         });
//     } catch (error) {
//         console.error(error);
//         return res.status(500).json({ message: 'An error occurred while fetching history' });
//     }
// };




import { PrismaClient } from '@prisma/client';
import { body, validationResult } from 'express-validator';

const prisma = new PrismaClient();




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
        const { role } = req.user; // Get user role from authentication middleware

        // Ensure only trainers can create exercises
        if (role !== 'Trainer') {
            return res.status(403).json({ message: 'Only trainers can create exercises' });
        }

        // Check if the exercise already exists
        const existingExercise = await prisma.supported_exercises.findUnique({
            where: { exercise_name: exerciseName },
        });

        if (existingExercise) {
            return res.status(409).json({ message: 'Exercise already exists' });
        }

        // Create the new supported exercise
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
        // Get user ID from authentication middleware
        const userId = req.user?.user_id;
        if (!userId) {
            return res.status(401).json({ message: 'Unauthorized: User ID not found in request' });
        }

        const { exerciseId, weight, reps } = req.body;

        // Validate if the user exists in the database
        const userExists = await prisma.users.findUnique({
            where: { user_id: userId },
        });

        if (!userExists) {
            return res.status(404).json({ message: 'User not found' });
        }

        // Validate if the exercise exists
        const exercise = await prisma.supported_exercises.findUnique({
            where: { supported_exercise_id: exerciseId },
        });

        if (!exercise) {
            return res.status(404).json({ message: 'Exercise not found' });
        }

        // Check if the user has a previous personal best for the exercise
        const existingBest = await prisma.personal_bests.findFirst({
            where: {
                user_id: userId,
                supported_exercise_id: exerciseId,
            },
            orderBy: {
                weight: 'desc', // Get the best record
            },
        });

        // If the new weight is not better than the existing best, do not update
        if (existingBest && existingBest.weight >= weight) {
            return res.status(200).json({
                status: 'info',
                message: 'Your new entry does not surpass your existing personal best',
                current_best: existingBest,
            });
        }

        // ✅ Create a new personal best entry
        const newPersonalBest = await prisma.personal_bests.create({
            data: {
                user_id: userId, // Ensure user_id is passed correctly
                supported_exercise_id: exerciseId,
                weight,
                reps,
                achieved_at: new Date(),
            },
        });

        return res.status(201).json({
            status: 'success',
            message: 'New personal best logged successfully!',
            data: newPersonalBest,
        });
    } catch (error) {
        console.error('Error logging personal best:', error);
        return res.status(500).json({ message: 'An error occurred while logging the personal best' });
    }
};


/**
 * Retrieve a user's personal best history for a specific exercise
 */
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

        // Retrieve all personal best records for the user and exercise
        const history = await prisma.personal_bests.findMany({
            where: {
                user_id: parseInt(userId),
                supported_exercise_id: parseInt(exerciseId),
            },
            orderBy: {
                achieved_at: 'desc', // Show latest first
            },
        });

        if (!history.length) {
            return res.status(404).json({ message: 'No history found for this user and exercise' });
        }

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



export const getAllSupportedExercises = async (req, res) => {
    try {
        // Retrieve all supported exercises
        const exercises = await prisma.supported_exercises.findMany({
            orderBy: {
                created_at: 'asc', // Sort by creation date (oldest first)
            },
        });

        if (!exercises.length) {
            return res.status(404).json({ message: 'No supported exercises found' });
        }

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
