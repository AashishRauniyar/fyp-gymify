import express from 'express';
import { authenticate } from '../middleware/authMiddleware.js';
import upload from '../middleware/multerMiddleware.js';
import {
    createDietPlan,
    getAllDietPlans,
    getDietPlanById,
    updateDietPlan,
    deleteDietPlan,
    addMealToDietPlan,
    getMealsByDietPlan,
    getMealById,
    updateMeal,
    deleteMeal,
    logMeal,
    getMealLogsOfUser,
    getMealLogById,
    updateMealLog,
    deleteMealLog,
    createMeal,
    getMeals
} from '../controllers/diet_controller/dietController.js';

export const dietPlanRouter = express.Router();

// ----- Diet Plan Routes -----
dietPlanRouter.post('/diet-plans', upload.single('diet_image') , authenticate, createDietPlan);
dietPlanRouter.get('/diet-plans',  getAllDietPlans);
dietPlanRouter.get('/diet-plans/:id', authenticate, getDietPlanById);
dietPlanRouter.put('/diet-plans/:id', authenticate, updateDietPlan);
dietPlanRouter.delete('/diet-plans/:id', authenticate, deleteDietPlan);

// ----- Meals Routes -----
// Add one or more meals to a diet plan (with an optional image upload)
dietPlanRouter.post('/meals', upload.single('meal_image'), authenticate, createMeal);
dietPlanRouter.post('/diet-plans/add-meal', upload.single('meal_image'), authenticate, addMealToDietPlan);
dietPlanRouter.get('/diet-plans/:dietPlanId/meals', authenticate, getMealsByDietPlan);
dietPlanRouter.get('/meals', authenticate, getMeals);
dietPlanRouter.get('/meals/:id', authenticate, getMealById);
dietPlanRouter.put('/meals/:id', upload.single('meal_image'), authenticate, updateMeal);
dietPlanRouter.delete('/meals/:id', authenticate, deleteMeal);

// ----- Meal Logs Routes -----
// Log a meal consumption
dietPlanRouter.post('/meal-logs', authenticate, logMeal);
dietPlanRouter.get('/meal-logs', authenticate, getMealLogsOfUser);
dietPlanRouter.get('/meal-logs/:id', authenticate, getMealLogById);
dietPlanRouter.put('/meal-logs/:id', authenticate, updateMealLog);
dietPlanRouter.delete('/meal-logs/:id', authenticate, deleteMealLog);


