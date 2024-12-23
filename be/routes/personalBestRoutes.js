import express from 'express';
import { authenticate } from '../middleware/authMiddleware.js';
import {
    validatePersonalBest,
    logPersonalBest,
    getUserPersonalBestHistory,
} from '../controllers/personal_best_controller/personalBestController.js';

export const personalBestRouter = express.Router();

personalBestRouter.post(
    '/personal_best',
    authenticate,
    validatePersonalBest,
    logPersonalBest
);

personalBestRouter.get(
    '/user/:userId/history/:exerciseId',
    authenticate,
    getUserPersonalBestHistory
);
