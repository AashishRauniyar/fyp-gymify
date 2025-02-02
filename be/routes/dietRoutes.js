import express from 'express';
import { authenticate } from '../middleware/authMiddleware.js';
import {
    createDietPlan,
    addMealToDietPlan,
    logMeal,
    getMealLogsOfUser,
    deleteMealLog,
    getAllDietPlans
} from '../controllers/diet_controller/dietController.js';

export const dietPlanRouter = express.Router();

// Routes for managing diet plans
dietPlanRouter.post('/diet-plans', authenticate, createDietPlan); // Create a new diet plan

//! This route is not necessary for the MVP
// dietPlanRouter.get('/diet-plans', authenticate, getDietPlansOfUser); // Get all diet plans for a user

dietPlanRouter.get('/diet-plans', authenticate,getAllDietPlans); // Get all diet plans for a user


// Routes for managing meals within a diet plan
dietPlanRouter.post('/diet-plans/add-meal', authenticate, addMealToDietPlan); // Add meals to a diet plan
dietPlanRouter.post('/diet-plans/log-meal', authenticate, logMeal); // Log a meal for a diet plan
dietPlanRouter.get('/diet-plans/meals', authenticate, getMealLogsOfUser); // Get meal logs of a user

// Route for deleting a meal log
dietPlanRouter.delete('/diet-plans/meals/:id', authenticate, deleteMealLog); // Delete a meal log
