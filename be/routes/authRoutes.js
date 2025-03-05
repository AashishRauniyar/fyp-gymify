import {  login, register, completeRegistration, verifyOTP, checkUsername,  checkPhoneNumber, checkEmailExists, resendOTP, forgotPassword, resetPassword } from "../controllers/auth_controller/authController.js";
import upload from "../middleware/multerMiddleware.js";
import express from 'express';
import { rateLimiter } from "../middleware/ratelimiterMiddleware.js";

const authRouter = express.Router();



// Routes for user validation

// authRouter.post('/register',upload.single('profile_image'), register);
// authRouter.post('/login', login);
// authRouter.post('/forget-password', forgetPassword );
// authRouter.post('/reset-password', resetPassword);

authRouter.post('/register', rateLimiter ,register);
authRouter.post('/login', login);
// for verify otp
authRouter.post('/verify-otp', verifyOTP);
authRouter.post('/resend-otp', rateLimiter, resendOTP);
authRouter.post('/complete-profile', upload.single('profile_image'), completeRegistration);

// for checking username, email, phone number   
authRouter.post('/check-username', checkUsername);
authRouter.post('/check-email', checkEmailExists);
authRouter.post('/check-phone-number', checkPhoneNumber);

// for forgot password
authRouter.post('/forgot-password', forgotPassword);
authRouter.post('/reset-password', rateLimiter, resetPassword);

export default authRouter;