import express from 'express';
import { authenticate } from '../middleware/authMiddleware.js';
import { getProfile, updateProfile, getWeightHistory, updateWeight } from '../controllers/auth_controller/profileController.js';

const profileRouter = express.Router();


// Protected route for getting and updating user profile
profileRouter.get('/profile',authenticate, getProfile);
profileRouter.put('/profile',authenticate, updateProfile);

profileRouter.post('/weight',authenticate, updateWeight);

// get users weight history
// Route to fetch weight history
profileRouter.get('/weight-history',authenticate, getWeightHistory);


export default profileRouter;