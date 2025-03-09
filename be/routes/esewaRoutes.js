import express from 'express';
import { initiatePaymentEsewa,  verifyPaymentEsewa } from '../controllers/membership_controller/esewaController.js';



const esewaRouter = express.Router();


esewaRouter.post('/initiate-payment-esewa', initiatePaymentEsewa);
esewaRouter.post('/verify-payment-esewa', verifyPaymentEsewa);

export default esewaRouter;