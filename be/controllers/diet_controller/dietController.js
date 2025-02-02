import { PrismaClient } from '@prisma/client';
import { body, validationResult } from 'express-validator';

const prisma = new PrismaClient();

export const createDietPlan = [
    body('calorie_goal').notEmpty().withMessage('Calorie goal is required').isDecimal().withMessage('Calorie goal must be a decimal'),
    body('goal_type').notEmpty().withMessage('Goal type is required'),
    async (req, res) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ status: 'failure', errors: errors.array() });
        }

        try {
            // Get the user from the request (from the authentication middleware)
            const { user_id, role } = req.user;

            // Check if the user has the role of trainer
            if (role !== 'Trainer') {
                return res.status(403).json({ status: 'failure', message: 'Only trainers can create diet plans' });
            }

            // Extract other data from the request
            const { name, calorie_goal, goal_type, description } = req.body;

            // Create the diet plan in the database
            const dietPlan = await prisma.dietplans.create({
                data: {
                    name,
                    user_id,  // The user creating the diet plan is the trainer
                    trainer_id: user_id,  // Set trainer_id to the current trainer's user_id
                    calorie_goal,
                    goal_type,
                    description,
                    created_at: new Date(),
                    updated_at: new Date()
                }
            });

            // Send the success response
            res.status(201).json({ status: 'success', message: 'Diet plan created successfully', data: dietPlan });
        } catch (error) {
            console.error('Error creating diet plan:', error);
            res.status(500).json({ status: 'failure', message: 'Server error' });
        }
    }
];

// Add meals to a diet plan
export const addMealToDietPlan = [
    body('diet_plan_id').notEmpty().withMessage('Diet plan ID is required').isInt().withMessage('Diet plan ID must be an integer'),
    body('meals').isArray({ min: 1 }).withMessage('Meals must be an array with at least one item'),
    body('meals.*.meal_name').notEmpty().withMessage('Meal name is required'),
    body('meals.*.meal_time').notEmpty().withMessage('Meal time is required'),
    body('meals.*.calories').notEmpty().withMessage('Calories are required').isDecimal().withMessage('Calories must be a decimal'),
    async (req, res) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ status: 'failure', errors: errors.array() });
        }

        try {

            // Get the user from the request (from the authentication middleware)
            const { user_id, role } = req.user;


            // Check if the user has the role of trainer
            if (role !== 'Trainer') {
                return res.status(403).json({ status: 'failure', message: 'Only trainers can add meals to diet plans' });
            }


            const { diet_plan_id, meals } = req.body;

            const addedMeals = [];

            for (const meal of meals) {
                const { meal_name, meal_time, calories, description, macronutrients } = meal;

                const mealEntry = await prisma.meals.create({
                    data: {
                        diet_plan_id,
                        meal_name,
                        meal_time,
                        calories,
                        description,
                        macronutrients,
                        created_at: new Date()
                    }
                });

                addedMeals.push(mealEntry);
            }

            res.status(201).json({ status: 'success', message: 'Meals added to diet plan successfully', data: addedMeals });
        } catch (error) {
            console.error('Error adding meals to diet plan:', error);
            res.status(500).json({ status: 'failure', message: 'Server error' });
        }
    }
];

// Log a meal
export const logMeal = [
    body('diet_plan_id').notEmpty().withMessage('Diet plan ID is required').isInt().withMessage('Diet plan ID must be an integer'),
    body('consumed_calories').notEmpty().withMessage('Consumed calories are required').isDecimal().withMessage('Consumed calories must be a decimal'),
    body('custom_meal').optional().isString().withMessage('Custom meal must be a string'),
    body('notes').optional().isString().withMessage('Notes must be a string'),
    async (req, res) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ status: 'failure', errors: errors.array() });
        }

        try {
            const { user_id } = req.user;
            const { diet_plan_id, meal_id, consumed_calories, custom_meal, notes } = req.body;

            const mealLog = await prisma.dietlogs.create({
                data: {
                    user_id,
                    diet_plan_id,
                    meal_id,
                    consumed_calories,
                    custom_meal,
                    notes,
                    log_date: new Date()
                }
            });

            res.status(201).json({ status: 'success', message: 'Meal logged successfully', data: mealLog });
        } catch (error) {
            console.error('Error logging meal:', error);
            res.status(500).json({ status: 'failure', message: 'Server error' });
        }
    }
];

// Get all diet plans of a user
// export const getDietPlansOfUser = async (req, res) => {
//     try {
//         const { user_id } = req.user;

//         const dietPlans = await prisma.dietplans.findMany({
//             where: { user_id },
//             include: {
//                 meals: true
//             }
//         });

//         res.status(200).json({ status: 'success', message: 'Diet plans fetched successfully', data: dietPlans });
//     } catch (error) {
//         console.error('Error fetching diet plans:', error);
//         res.status(500).json({ status: 'failure', message: 'Server error' });
//     }
// };


// get all the diet plans
export const getAllDietPlans = async (req, res) => {
    try {
        // Fetching all diet plans from all trainers
        const dietPlans = await prisma.dietplans.findMany({
            include: {
                meals: true,
            }
        });

        // Return the fetched diet plans with all related data
        res.status(200).json({
            status: 'success',
            message: 'Diet plans fetched successfully',
            data: dietPlans
        });
    } catch (error) {
        console.error('Error fetching diet plans:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};


// Get meal logs of a user
export const getMealLogsOfUser = async (req, res) => {
    try {
        const { user_id } = req.user;

        const mealLogs = await prisma.dietlogs.findMany({
            where: { user_id },
            include: {
                meals: true,
                dietplans: true
            }
        });

        res.status(200).json({ status: 'success', message: 'Meal logs fetched successfully', data: mealLogs });
    } catch (error) {
        console.error('Error fetching meal logs:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};

// Delete a meal log
export const deleteMealLog = async (req, res) => {
    try {
        const logId = parseInt(req.params.id);

        await prisma.dietlogs.delete({
            where: { log_id: logId }
        });

        res.status(200).json({ status: 'success', message: 'Meal log deleted successfully' });
    } catch (error) {
        console.error('Error deleting meal log:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};
