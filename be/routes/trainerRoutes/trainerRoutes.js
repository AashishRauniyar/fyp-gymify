import express from 'express';
import { getAllUsers, getUserOverallStats, getUsersStatsSummary } from '../../controllers/trainer_analytics_controller.dart/trainerAnalyticsController.js';
import { authenticate } from '../../middleware/authMiddleware.js';

export const trainerRoutes = express.Router();

// Route to get overall statistics for a specific user (Trainers only)
trainerRoutes.get('/user-stats/:userId', authenticate, getUserOverallStats);

// Route to get all users (for trainers to select from)
trainerRoutes.get('/all-users', authenticate, getAllUsers);

// Route to get summary statistics for all users (for dashboard view)
trainerRoutes.get('/users-stats-summary', authenticate, getUsersStatsSummary);