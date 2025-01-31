import express from 'express';
import { authenticate } from '../middleware/authMiddleware.js';
import { createSupportedExercise, getAllSupportedExercises, getUserPersonalBestHistory, logPersonalBest, validatePersonalBest, validateSupportedExercise } from '../controllers/personal_best_controller/personalBestController.js';

export const personalBestRouter = express.Router();

// Trainer Creates a Supported Exercise
personalBestRouter.post(
    '/supported_exercise',
    authenticate,
    validateSupportedExercise,
    createSupportedExercise
);

// User Logs a Personal Best
personalBestRouter.post(
    '/personal_best',
    authenticate,
    validatePersonalBest,
    logPersonalBest
);

// User Retrieves Personal Best History
personalBestRouter.get(
    '/user/:userId/history/:exerciseId',
    authenticate,
    getUserPersonalBestHistory
);

personalBestRouter.get(
    '/supported_exercises',
    authenticate,
    getAllSupportedExercises
);
