import express from 'express';
import { authenticate } from '../middleware/authMiddleware.js';
import { getProfile, updateProfile } from '../controllers/auth_controller/profileController.js';

const profileRouter = express.Router();


// Protected route for getting and updating user profile
profileRouter.get('/profile',authenticate, getProfile);
profileRouter.put('/profile',authenticate, updateProfile);


export default profileRouter;