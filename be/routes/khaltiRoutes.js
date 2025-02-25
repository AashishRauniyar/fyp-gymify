import express from 'express';
import { initiatePayment, verifyPayment } from '../controllers/membership_controller/khaltiController.js';


const khaltiRouter = express.Router();

khaltiRouter.post('/initiate-payment', initiatePayment);
khaltiRouter.post('/verify-payment', verifyPayment);

export default khaltiRouter;
