import express from 'express';

import { authenticate } from '../middleware/authMiddleware.js';
import { getUserPersonalBestHistory, logPersonalBest } from '../controllers/personal_best_controller/personalBestController.js';

export const personalBestRouter = express.Router(); 



personalBestRouter.post('/personal_best', authenticate, logPersonalBest);


personalBestRouter.get('/user/:userId/history/:exercise',authenticate, getUserPersonalBestHistory);