import express from 'express';
import authRouter from './authRoutes.js';
import profileRouter from './profileRoutes.js';
import { userRouter } from './userRoutes.js';
import { exerciseRouter } from './exerciseRoutes.js';
import { workoutRouter } from './workoutRoutes.js';
import { customWorkoutRouter } from './customWorkoutRoutes.js';
import { personalBestRouter } from './personalBestRoutes.js';
import { workoutLogRouter } from './workoutLogRoutes.js';

const mainRouter = express.Router();

// Define the routes here
mainRouter.use('/api/auth', authRouter);
mainRouter.use('/api', profileRouter);
mainRouter.use('/api', userRouter);
mainRouter.use('/api', exerciseRouter);
mainRouter.use('/api', workoutRouter);
mainRouter.use('/api', customWorkoutRouter);
mainRouter.use('/api', personalBestRouter);
mainRouter.use('/api', workoutLogRouter)

export default mainRouter;
