import express from 'express';
import { authenticate } from '../middleware/authMiddleware.js';
import { getWeightHistory, updateWeight } from '../controllers/weightlog_controller/weightlogController.js';


const weightRouter = express.Router();

weightRouter.post('/weight',authenticate, updateWeight);

// get users weight history
// Route to fetch weight history
weightRouter.get('/weight-history',authenticate, getWeightHistory);

export default weightRouter;
