import express from 'express';
import { authenticate } from '../../middleware/authMiddleware.js';
import { completeEsewaPayment, initializeEsewaPayment } from '../../controllers/membership_controller/esewaController.js';


const esewaRouter = express.Router();

// Initialize eSewa payment
esewaRouter.post('/initiate-payment-esewa', authenticate, initializeEsewaPayment);

// Complete eSewa payment
esewaRouter.post('/verify-payment-esewa', authenticate, completeEsewaPayment);

export default esewaRouter; 