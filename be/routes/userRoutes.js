import { authenticate } from "../middleware/authMiddleware.js";
import express from 'express';
import { getActiveMembers, getAllMembers, getAllTrainers, getAllUsers } from "../controllers/user_controller/user_controller.js";


export const userRouter = express.Router();

// Routes for getting users based on roles
userRouter.get('/users', authenticate, getAllUsers);
userRouter.get('/members', authenticate, getAllMembers);
userRouter.get('/activeMembers', authenticate, getActiveMembers)
userRouter.get('/trainers', authenticate, getAllTrainers);
