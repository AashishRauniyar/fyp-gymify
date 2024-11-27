import { forgetPassword, login, register, resetPassword } from "../controllers/auth_controller/authController.js";
import upload from "../middleware/multerMiddleware.js";
import express from 'express';

const authRouter = express.Router();


// Public routes for user registration and login

authRouter.post('/register',upload.single('profile_image'), register);
authRouter.post('/login', login);
authRouter.post('/forget-password', forgetPassword );
authRouter.post('/reset-password', resetPassword);


export default authRouter;