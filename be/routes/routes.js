import express from 'express';
import authRouter from './authRoutes.js';
import profileRouter from './profileRoutes.js';
import { userRouter } from './userRoutes.js';
import { exerciseRouter } from './exerciseRoutes.js';
import { workoutRouter } from './workoutRoutes.js';
import { customWorkoutRouter } from './customWorkoutRoutes.js';
import { personalBestRouter } from './personalBestRoutes.js';
import { workoutLogRouter } from './workoutLogRoutes.js';
import {dietPlanRouter} from './dietRoutes.js';
import attendanceRouter from './attendanceRoutes.js';
import membershipRouter from './membershipRoutes.js';
import chatRouter from './chatRoutes.js';
import khaltiRouter from './khaltiRoutes.js';
// import esewaRouter from './esewaRoutes.js';
import weightRouter from './weightRoutes.js';
import testRouter from './testRoute.js';
import adminUserRouter from './adminRoutes/adminUserRoutes.js';
import adminMembershipRouter from './adminRoutes/adminMembershipRouter.js';
import adminAttendanceRouter from './adminRoutes/adminAttendanceRoutes.js';
import adminNewMembershipRouter from './adminRoutes/adminNewMembershipRoutes.js';
import adminDashboardRouter from './adminRoutes/adminDashboardRouter.js';
import { trainerRoutes } from './trainerRoutes/trainerRoutes.js';
import esewaRouter from './payment_routes/esewaRoutes.js';


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
mainRouter.use('/api', dietPlanRouter);
mainRouter.use('/api', attendanceRouter);
mainRouter.use('/api', membershipRouter);
mainRouter.use('/api', chatRouter);
mainRouter.use('/api', khaltiRouter);
mainRouter.use('/api', esewaRouter);
mainRouter.use('/api', weightRouter);
mainRouter.use('/api', testRouter);

mainRouter.use('/api', trainerRoutes );

mainRouter.use('/api/admin', adminUserRouter);
mainRouter.use('/api/admin', adminMembershipRouter);
mainRouter.use('/api/admin', adminAttendanceRouter);

mainRouter.use('/api/admin', adminNewMembershipRouter);
mainRouter.use('/api/admin', adminDashboardRouter);

export default mainRouter;

