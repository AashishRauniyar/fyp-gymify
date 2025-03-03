// import { PrismaClient } from '@prisma/client';
// import { body, validationResult } from 'express-validator';
// import { uploadMealPhotoToCloudinary } from '../../middleware/cloudinaryMiddleware.js';

// const prisma = new PrismaClient();

// export const createDietPlan = [
//     body('calorie_goal').notEmpty().withMessage('Calorie goal is required').isDecimal().withMessage('Calorie goal must be a decimal'),
//     body('goal_type').notEmpty().withMessage('Goal type is required'),
//     async (req, res) => {
//         const errors = validationResult(req);
//         if (!errors.isEmpty()) {
//             return res.status(400).json({ status: 'failure', errors: errors.array() });
//         }

//         try {
//             // Get the user from the request (from the authentication middleware)
//             const { user_id, role } = req.user;

//             // Check if the user has the role of trainer
//             if (role !== 'Trainer') {
//                 return res.status(403).json({ status: 'failure', message: 'Only trainers can create diet plans' });
//             }

//             // Extract other data from the request
//             const { name, calorie_goal, goal_type, description } = req.body;


//             // Create the diet plan in the database
//             const dietPlan = await prisma.dietplans.create({
//                 data: {
//                     name,
//                     user_id,  // The user creating the diet plan is the trainer
//                     trainer_id: user_id,  // Set trainer_id to the current trainer's user_id
//                     calorie_goal,
//                     goal_type,
//                     description,
//                     created_at: new Date(),
//                     updated_at: new Date()
//                 }
//             });

//             // Send the success response
//             res.status(201).json({ status: 'success', message: 'Diet plan created successfully', data: dietPlan });
//         } catch (error) {
//             console.error('Error creating diet plan:', error);
//             res.status(500).json({ status: 'failure', message: 'Server error' });
//         }
//     }
// ];

// // Add meals to a diet plan
// // export const addMealToDietPlan = [
// //     body('diet_plan_id').notEmpty().withMessage('Diet plan ID is required').isInt().withMessage('Diet plan ID must be an integer'),
// //     body('meals').isArray({ min: 1 }).withMessage('Meals must be an array with at least one item'),
// //     body('meals.*.meal_name').notEmpty().withMessage('Meal name is required'),
// //     body('meals.*.meal_time').notEmpty().withMessage('Meal time is required'),
// //     body('meals.*.calories').notEmpty().withMessage('Calories are required').isDecimal().withMessage('Calories must be a decimal'),

// //     async (req, res) => {
// //         const errors = validationResult(req);
// //         if (!errors.isEmpty()) {
// //             return res.status(400).json({ status: 'failure', errors: errors.array() });
// //         }

// //         try {

// //             // Get the user from the request (from the authentication middleware)
// //             const { user_id, role } = req.user;


// //             // Check if the user has the role of trainer
// //             if (role !== 'Trainer') {
// //                 return res.status(403).json({ status: 'failure', message: 'Only trainers can add meals to diet plans' });
// //             }


// //             const { diet_plan_id, meals } = req.body;

// //             const addedMeals = [];

// //             for (const meal of meals) {
// //                 const { meal_name, meal_time, calories, description, macronutrients } = meal;


// //                 let image = null;
// //                 if (req.file) {
// //                     console.log('Received file:', req.file);  // Log the file details
// //                     try {
// //                         image = await uploadMealPhotoToCloudinary(req.file.buffer); // Pass the file buffer directly
// //                     } catch (error) {
// //                         console.error('Error uploading image:', error);
// //                         return res.status(500).json({ status: 'failure', message: 'Image upload failed' });
// //                     }
// //                 }


// //                 const mealEntry = await prisma.meals.create({
// //                     data: {
// //                         diet_plan_id,
// //                         image: image,
// //                         meal_name,
// //                         meal_time,
// //                         calories,
// //                         description,
// //                         macronutrients,
// //                         created_at: new Date()
// //                     }
// //                 });

// //                 addedMeals.push(mealEntry);
// //             }

// //             res.status(201).json({ status: 'success', message: 'Meals added to diet plan successfully', data: addedMeals });
// //         } catch (error) {
// //             console.error('Error adding meals to diet plan:', error);
// //             res.status(500).json({ status: 'failure', message: 'Server error' });
// //         }
// //     }
// // ];

// export const addMealToDietPlan = [
//     body('diet_plan_id').notEmpty().withMessage('Diet plan ID is required').isInt().withMessage('Diet plan ID must be an integer'),
//     body('meals')
//         .notEmpty().withMessage('Meals are required')
//         .custom((value, { req }) => {
//             try {
//                 // If meals is a string, try to parse it
//                 const mealsArray = typeof value === 'string' ? JSON.parse(value) : value;

//                 // Check if it's an array with at least one item
//                 if (!Array.isArray(mealsArray) || mealsArray.length === 0) {
//                     throw new Error('Meals must be an array with at least one item');
//                 }

//                 // Store the parsed array for later use
//                 req.body.meals = mealsArray;
//                 return true;
//             } catch (error) {
//                 throw new Error('Invalid meals format. Must be a valid JSON array');
//             }
//         }),

//     async (req, res) => {
//         try {
//             // Get the user from the request (from the authentication middleware)
//             const { user_id, role } = req.user;

//             // Check if the user has the role of trainer
//             if (role !== 'Trainer') {
//                 return res.status(403).json({ status: 'failure', message: 'Only trainers can add meals to diet plans' });
//             }

//             // Parse diet_plan_id as integer
//             const diet_plan_id = parseInt(req.body.diet_plan_id);
//             const mealsData = Array.isArray(req.body.meals) ? req.body.meals : JSON.parse(req.body.meals);

//             let image = null;
//             if (req.file) {
//                 console.log('Received file:', req.file);
//                 try {
//                     image = await uploadMealPhotoToCloudinary(req.file.buffer);
//                 } catch (error) {
//                     console.error('Error uploading image:', error);
//                     return res.status(500).json({ status: 'failure', message: 'Image upload failed' });
//                 }
//             }

//             const addedMeals = [];

//             // Process each meal in the array
//             for (const meal of mealsData) {
//                 console.log('Processing meal:', meal); // Debug log

//                 const mealEntry = await prisma.meals.create({
//                     data: {
//                         diet_plan_id,
//                         image,
//                         meal_name: meal.meal_name,
//                         meal_time: meal.meal_time,
//                         calories: parseFloat(meal.calories),
//                         description: meal.description,
//                         macronutrients: meal.macronutrients,
//                         created_at: new Date()
//                     }
//                 });

//                 addedMeals.push(mealEntry);
//             }

//             res.status(201).json({
//                 status: 'success',
//                 message: 'Meals added to diet plan successfully',
//                 data: addedMeals
//             });
//         } catch (error) {
//             console.error('Error adding meals to diet plan:', error);
//             res.status(500).json({
//                 status: 'failure',
//                 message: 'Server error',
//                 error: error.message
//             });
//         }
//     }
// ];


// // Log a meal
// export const logMeal = [
//     body('diet_plan_id').notEmpty().withMessage('Diet plan ID is required').isInt().withMessage('Diet plan ID must be an integer'),
//     body('consumed_calories').notEmpty().withMessage('Consumed calories are required').isDecimal().withMessage('Consumed calories must be a decimal'),
//     body('custom_meal').optional().isString().withMessage('Custom meal must be a string'),
//     body('notes').optional().isString().withMessage('Notes must be a string'),
//     async (req, res) => {
//         const errors = validationResult(req);
//         if (!errors.isEmpty()) {
//             return res.status(400).json({ status: 'failure', errors: errors.array() });
//         }

//         try {
//             const { user_id } = req.user;
//             const { diet_plan_id, meal_id, consumed_calories, custom_meal, notes } = req.body;

//             const mealLog = await prisma.dietlogs.create({
//                 data: {
//                     user_id,
//                     diet_plan_id,
//                     meal_id,
//                     consumed_calories,
//                     custom_meal,
//                     notes,
//                     log_date: new Date()
//                 }
//             });

//             res.status(201).json({ status: 'success', message: 'Meal logged successfully', data: mealLog });
//         } catch (error) {
//             console.error('Error logging meal:', error);
//             res.status(500).json({ status: 'failure', message: 'Server error' });
//         }
//     }
// ];

// // Get all diet plans of a user
// // export const getDietPlansOfUser = async (req, res) => {
// //     try {
// //         const { user_id } = req.user;

// //         const dietPlans = await prisma.dietplans.findMany({
// //             where: { user_id },
// //             include: {
// //                 meals: true
// //             }
// //         });

// //         res.status(200).json({ status: 'success', message: 'Diet plans fetched successfully', data: dietPlans });
// //     } catch (error) {
// //         console.error('Error fetching diet plans:', error);
// //         res.status(500).json({ status: 'failure', message: 'Server error' });
// //     }
// // };


// // get all the diet plans
// export const getAllDietPlans = async (req, res) => {
//     try {
//         // Fetching all diet plans from all trainers
//         const dietPlans = await prisma.dietplans.findMany({
//             include: {
//                 meals: true,
//             }
//         });

//         // Return the fetched diet plans with all related data
//         res.status(200).json({
//             status: 'success',
//             message: 'Diet plans fetched successfully',
//             data: dietPlans
//         });
//     } catch (error) {
//         console.error('Error fetching diet plans:', error);
//         res.status(500).json({ status: 'failure', message: 'Server error' });
//     }
// };


// // Get meal logs of a user
// export const getMealLogsOfUser = async (req, res) => {
//     try {
//         const { user_id } = req.user;

//         const mealLogs = await prisma.dietlogs.findMany({
//             where: { user_id },
//             include: {
//                 meals: true,
//                 dietplans: true
//             }
//         });

//         res.status(200).json({ status: 'success', message: 'Meal logs fetched successfully', data: mealLogs });
//     } catch (error) {
//         console.error('Error fetching meal logs:', error);
//         res.status(500).json({ status: 'failure', message: 'Server error' });
//     }
// };

// // Delete a meal log
// export const deleteMealLog = async (req, res) => {
//     try {
//         const logId = parseInt(req.params.id);

//         await prisma.dietlogs.delete({
//             where: { log_id: logId }
//         });

//         res.status(200).json({ status: 'success', message: 'Meal log deleted successfully' });
//     } catch (error) {
//         console.error('Error deleting meal log:', error);
//         res.status(500).json({ status: 'failure', message: 'Server error' });
//     }
// };



import { PrismaClient } from '@prisma/client';
import { body, validationResult } from 'express-validator';
import { uploadMealPhotoToCloudinary } from '../../middleware/cloudinaryMiddleware.js';

const prisma = new PrismaClient();

// =====================
// Diet Plan Endpoints
// =====================

// Create a new Diet Plan (only accessible to Trainers)
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

// Get all Diet Plans (with their associated meals)
export const getAllDietPlans = async (req, res) => {
    try {
        const dietPlans = await prisma.dietplans.findMany({
            include: { meals: true }
        });
        res.status(200).json({ status: 'success', message: 'Diet plans fetched successfully', data: dietPlans });
    } catch (error) {
        console.error('Error fetching diet plans:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};

// Get a single Diet Plan by ID
export const getDietPlanById = async (req, res) => {
    try {
        const diet_plan_id = parseInt(req.params.id);
        const dietPlan = await prisma.dietplans.findUnique({
            where: { diet_plan_id },
            include: { meals: true }
        });
        if (!dietPlan) {
            return res.status(404).json({ status: 'failure', message: 'Diet plan not found' });
        }
        res.status(200).json({ status: 'success', message: 'Diet plan fetched successfully', data: dietPlan });
    } catch (error) {
        console.error('Error fetching diet plan:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};

// Update a Diet Plan
export const updateDietPlan = async (req, res) => {
    try {
        const diet_plan_id = parseInt(req.params.id);
        const { name, calorie_goal, goal_type, description } = req.body;
        const updatedDietPlan = await prisma.dietplans.update({
            where: { diet_plan_id },
            data: {
                name,
                calorie_goal,
                goal_type,
                description,
                updated_at: new Date()
            }
        });
        res.status(200).json({ status: 'success', message: 'Diet plan updated successfully', data: updatedDietPlan });
    } catch (error) {
        console.error('Error updating diet plan:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};

// Delete a Diet Plan
export const deleteDietPlan = async (req, res) => {
    try {
        const diet_plan_id = parseInt(req.params.id);
        await prisma.dietplans.delete({
            where: { diet_plan_id }
        });
        res.status(200).json({ status: 'success', message: 'Diet plan deleted successfully' });
    } catch (error) {
        console.error('Error deleting diet plan:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};

// =====================
// Meals Endpoints
// =====================

// Create a new Meal (only accessible to Trainers)
export const createMeal = [
    // Validate required fields
    body('diet_plan_id')
        .notEmpty().withMessage('Diet plan ID is required')
        .isInt().withMessage('Diet plan ID must be an integer'),
    body('meal_name')
        .notEmpty().withMessage('Meal name is required'),
    body('meal_time')
        .notEmpty().withMessage('Meal time is required'),
    body('calories')
        .notEmpty().withMessage('Calories are required')
        .isDecimal().withMessage('Calories must be a decimal'),
    async (req, res) => {
        // Check for validation errors
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ status: 'failure', errors: errors.array() });
        }
        try {
            // Get the current user from authentication middleware
            const { user_id, role } = req.user;
            if (role !== 'Trainer') {
                return res.status(403).json({ status: 'failure', message: 'Only trainers can create meals' });
            }

            // Extract meal details from request body
            const { diet_plan_id, meal_name, meal_time, calories, description, macronutrients } = req.body;

            // Upload an image if provided
            let image = null;
            if (req.file) {
                try {
                    image = await uploadMealPhotoToCloudinary(req.file.buffer);
                } catch (error) {
                    console.error('Error uploading image:', error);
                    return res.status(500).json({ status: 'failure', message: 'Image upload failed' });
                }
            }

            // Create the meal in the database
            const meal = await prisma.meals.create({
                data: {
                    diet_plan_id: parseInt(diet_plan_id),
                    meal_name,
                    meal_time,
                    calories: parseFloat(calories),
                    description,
                    macronutrients,
                    image,
                    created_at: new Date()
                }
            });

            // Send success response
            res.status(201).json({ status: 'success', message: 'Meal created successfully', data: meal });
        } catch (error) {
            console.error('Error creating meal:', error);
            res.status(500).json({ status: 'failure', message: 'Server error' });
        }
    }
];


// Add one or more Meals to a Diet Plan (only accessible to Trainers)
export const addMealToDietPlan = [
    body('diet_plan_id')
        .notEmpty().withMessage('Diet plan ID is required')
        .isInt().withMessage('Diet plan ID must be an integer'),
    body('meals')
        .notEmpty().withMessage('Meals are required')
        .custom((value, { req }) => {
            try {
                const mealsArray = typeof value === 'string' ? JSON.parse(value) : value;
                if (!Array.isArray(mealsArray) || mealsArray.length === 0) {
                    throw new Error('Meals must be an array with at least one item');
                }
                req.body.meals = mealsArray;
                return true;
            } catch (error) {
                throw new Error('Invalid meals format. Must be a valid JSON array');
            }
        }),
    async (req, res) => {
        try {
            const { user_id, role } = req.user;
            if (role !== 'Trainer') {
                return res.status(403).json({ status: 'failure', message: 'Only trainers can add meals to diet plans' });
            }
            const diet_plan_id = parseInt(req.body.diet_plan_id);
            const mealsData = req.body.meals;
            let image = null;
            if (req.file) {
                try {
                    image = await uploadMealPhotoToCloudinary(req.file.buffer);
                } catch (error) {
                    console.error('Error uploading image:', error);
                    return res.status(500).json({ status: 'failure', message: 'Image upload failed' });
                }
            }
            const addedMeals = [];
            for (const meal of mealsData) {
                const mealEntry = await prisma.meals.create({
                    data: {
                        diet_plan_id,
                        image,
                        meal_name: meal.meal_name,
                        meal_time: meal.meal_time,
                        calories: parseFloat(meal.calories),
                        description: meal.description,
                        macronutrients: meal.macronutrients,
                        created_at: new Date()
                    }
                });
                addedMeals.push(mealEntry);
            }
            res.status(201).json({
                status: 'success',
                message: 'Meals added to diet plan successfully',
                data: addedMeals
            });
        } catch (error) {
            console.error('Error adding meals to diet plan:', error);
            res.status(500).json({ status: 'failure', message: 'Server error', error: error.message });
        }
    }
];

// Get all Meals for a given Diet Plan (nested route)
export const getMealsByDietPlan = async (req, res) => {
    try {
        const diet_plan_id = parseInt(req.params.dietPlanId);
        const meals = await prisma.meals.findMany({
            where: { diet_plan_id }
        });
        res.status(200).json({ status: 'success', message: 'Meals fetched successfully', data: meals });
    } catch (error) {
        console.error('Error fetching meals:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};

export const getMeals = async (req, res) => {
    try {
        const meals = await prisma.meals.findMany();
        res.status(200).json({ status: 'success', message: 'Meals fetched successfully', data: meals });
    } catch (error) {
        console.error('Error fetching meals:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
}

// Get a single Meal by its ID
export const getMealById = async (req, res) => {
    try {
        const meal_id = parseInt(req.params.id);
        const meal = await prisma.meals.findUnique({
            where: { meal_id }
        });
        if (!meal) {
            return res.status(404).json({ status: 'failure', message: 'Meal not found' });
        }
        res.status(200).json({ status: 'success', message: 'Meal fetched successfully', data: meal });
    } catch (error) {
        console.error('Error fetching meal:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};

// Update a Meal
export const updateMeal = async (req, res) => {
    try {
        const meal_id = parseInt(req.params.id);
        const { meal_name, meal_time, calories, description, macronutrients } = req.body;
        let image;
        if (req.file) {
            try {
                image = await uploadMealPhotoToCloudinary(req.file.buffer);
            } catch (error) {
                console.error('Error uploading image:', error);
                return res.status(500).json({ status: 'failure', message: 'Image upload failed' });
            }
        }
        const updatedMeal = await prisma.meals.update({
            where: { meal_id },
            data: {
                meal_name,
                meal_time,
                calories: calories ? parseFloat(calories) : undefined,
                description,
                macronutrients,
                image,
                created_at: new Date()
            }
        });
        res.status(200).json({ status: 'success', message: 'Meal updated successfully', data: updatedMeal });
    } catch (error) {
        console.error('Error updating meal:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};

// Delete a Meal
export const deleteMeal = async (req, res) => {
    try {
        const meal_id = parseInt(req.params.id);
        await prisma.meals.delete({
            where: { meal_id }
        });
        res.status(200).json({ status: 'success', message: 'Meal deleted successfully' });
    } catch (error) {
        console.error('Error deleting meal:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};

// =====================
// Meal Logs Endpoints
// =====================

// Log a Meal (Create a Meal Log)
// Note: Here we assume a meal log only needs the meal_id and quantity (e.g., number of servings)
// Optionally, a log_time can be provided.
export const logMeal = [
    body('meal_id')
        .notEmpty().withMessage('Meal ID is required')
        .isInt().withMessage('Meal ID must be an integer'),
    body('quantity')
        .notEmpty().withMessage('Quantity is required')
        .isDecimal().withMessage('Quantity must be a decimal'),
    async (req, res) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ status: 'failure', errors: errors.array() });
        }
        try {
            const { user_id } = req.user;
            const { meal_id, quantity, log_time } = req.body;
            const mealLog = await prisma.meallogs.create({
                data: {
                    user_id,
                    meal_id,
                    quantity,
                    log_time: log_time ? new Date(log_time) : new Date()
                }
            });
            res.status(201).json({ status: 'success', message: 'Meal logged successfully', data: mealLog });
        } catch (error) {
            console.error('Error logging meal:', error);
            res.status(500).json({ status: 'failure', message: 'Server error' });
        }
    }
];

// Get all Meal Logs for the authenticated user
export const getMealLogsOfUser = async (req, res) => {
    try {
        const { user_id } = req.user;
        const mealLogs = await prisma.meallogs.findMany({
            where: { user_id },
            include: { meal: true } // optionally include related meal details
        });
        res.status(200).json({ status: 'success', message: 'Meal logs fetched successfully', data: mealLogs });
    } catch (error) {
        console.error('Error fetching meal logs:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};

// Get a single Meal Log by its ID
export const getMealLogById = async (req, res) => {
    try {
        const meal_log_id = parseInt(req.params.id);
        const mealLog = await prisma.meallogs.findUnique({
            where: { meal_log_id },
            include: { meal: true }
        });
        if (!mealLog) {
            return res.status(404).json({ status: 'failure', message: 'Meal log not found' });
        }
        res.status(200).json({ status: 'success', message: 'Meal log fetched successfully', data: mealLog });
    } catch (error) {
        console.error('Error fetching meal log:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};

// Update a Meal Log
export const updateMealLog = async (req, res) => {
    try {
        const meal_log_id = parseInt(req.params.id);
        const { quantity, log_time } = req.body;
        const updatedMealLog = await prisma.meallogs.update({
            where: { meal_log_id },
            data: {
                quantity,
                log_time: log_time ? new Date(log_time) : undefined
            }
        });
        res.status(200).json({ status: 'success', message: 'Meal log updated successfully', data: updatedMealLog });
    } catch (error) {
        console.error('Error updating meal log:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};

// Delete a Meal Log
export const deleteMealLog = async (req, res) => {
    try {
        const meal_log_id = parseInt(req.params.id);
        await prisma.meallogs.delete({
            where: { meal_log_id }
        });
        res.status(200).json({ status: 'success', message: 'Meal log deleted successfully' });
    } catch (error) {
        console.error('Error deleting meal log:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};
