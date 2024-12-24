import { forgetPassword, login, register, resetPassword, checkUsername, checkPhoneNumber, checkEmail } from "../controllers/auth_controller/authController.js";
import upload from "../middleware/multerMiddleware.js";
import express from 'express';

const authRouter = express.Router();


// Public routes for user registration and login



/**
 * @swagger
 * tags:
 *   name: Auth
 *   description: Authentication and user management
 */

/**
 * @swagger
 * /auth/register:
 *   post:
 *     tags: [Auth]
 *     summary: Register a new user
 *     description: This endpoint allows users to register with their details.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               user_name:
 *                 type: string
 *                 description: The user's username.
 *                 example: johndoe
 *               full_name:
 *                 type: string
 *                 description: The user's full name.
 *                 example: John Doe
 *               email:
 *                 type: string
 *                 description: The user's email address.
 *                 example: johndoe@example.com
 *               password:
 *                 type: string
 *                 description: The user's password (at least 8 characters).
 *                 example: password123
 *               phone_number:
 *                 type: string
 *                 description: The user's phone number (must be a 10-digit number).
 *                 example: '1234567890'
 *               gender:
 *                 type: string
 *                 description: The user's gender.
 *                 enum: [Male, Female, Other]
 *                 example: Male
 *               role:
 *                 type: string
 *                 description: The role of the user.
 *                 enum: [Member, Trainer, Admin]
 *                 example: Member
 *               age:
 *                 type: integer
 *                 description: The user's age.
 *                 example: 30
 *               height:
 *                 type: number
 *                 format: float
 *                 description: The user's height in centimeters.
 *                 example: 180.5
 *               current_weight:
 *                 type: number
 *                 format: float
 *                 description: The user's current weight in kilograms.
 *                 example: 75.3
 *               address:
 *                 type: string
 *                 description: The user's address.
 *                 example: '123 Main St, City, Country'
 *               fitness_level:
 *                 type: string
 *                 description: The user's fitness level.
 *                 example: Intermediate
 *               goal_type:
 *                 type: string
 *                 description: The user's fitness goal.
 *                 example: Weight Loss
 *               allergies:
 *                 type: string
 *                 description: Any known allergies the user has.
 *                 example: 'Peanuts'
 *               calorie_goals:
 *                 type: integer
 *                 description: The user's daily calorie goal.
 *                 example: 2500
 *               card_number:
 *                 type: string
 *                 description: The user's card number (if applicable).
 *                 example: '1234567812345678'
 *               profile_image:
 *                 type: string
 *                 description: The user's profile image URL (optional, uploaded to Cloudinary).
 *                 example: 'https://cloudinary.com/path/to/image.jpg'
 *     responses:
 *       201:
 *         description: User registered successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: string
 *                   example: success
 *                 message:
 *                   type: string
 *                   example: User registered successfully
 *                 data:
 *                   type: object
 *                   properties:
 *                     user_id:
 *                       type: integer
 *                       example: 1
 *                     user_name:
 *                       type: string
 *                       example: johndoe
 *                     email:
 *                       type: string
 *                       example: johndoe@example.com
 *                     role:
 *                       type: string
 *                       example: Member
 *                     full_name:
 *                       type: string
 *                       example: John Doe
 *                     profile_image:
 *                       type: string
 *                       example: 'https://cloudinary.com/path/to/image.jpg'
 *       400:
 *         description: Validation failed (e.g., missing required fields, invalid data format)
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: string
 *                   example: failure
 *                 message:
 *                   type: string
 *                   example: Validation failed
 *                 errors:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       msg:
 *                         type: string
 *                       param:
 *                         type: string
 *       500:
 *         description: Server error (e.g., database or image upload issues)
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: string
 *                   example: failure
 *                 message:
 *                   type: string
 *                   example: Server error
 */





/**
 * @swagger
 * /auth/login:
 *   post:
 *     summary: User login
 *     description: Login an existing user with email and password.
 *     tags:
 *       - Authentication
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - email
 *               - password
 *             properties:
 *               email:
 *                 type: string
 *                 format: email
 *                 description: User's email address.
 *               password:
 *                 type: string
 *                 description: User's password.
 *     responses:
 *       200:
 *         description: Login successful, returns user data and JWT token.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: string
 *                   example: "success"
 *                 message:
 *                   type: string
 *                   example: "Login successful"
 *                 data:
 *                   type: object
 *                   properties:
 *                     user_id:
 *                       type: integer
 *                       example: 1
 *                     user_name:
 *                       type: string
 *                       example: "johndoe"
 *                     email:
 *                       type: string
 *                       example: "johndoe@example.com"
 *                     role:
 *                       type: string
 *                       example: "Member"
 *                     full_name:
 *                       type: string
 *                       example: "John Doe"
 *                     phone_number:
 *                       type: string
 *                       example: "1234567890"
 *                     fitness_level:
 *                       type: string
 *                       example: "Intermediate"
 *                     goal_type:
 *                       type: string
 *                       example: "Weight Loss"
 *                 token:
 *                   type: string
 *                   example: "your-jwt-token-here"
 *       400:
 *         description: Validation failed, missing or invalid input fields.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: string
 *                   example: "failure"
 *                 message:
 *                   type: string
 *                   example: "Validation failed"
 *                 errors:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       msg:
 *                         type: string
 *                         example: "Invalid email format"
 *                       param:
 *                         type: string
 *                         example: "email"
 *                       location:
 *                         type: string
 *                         example: "body"
 *       404:
 *         description: User not found.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: string
 *                   example: "failure"
 *                 message:
 *                   type: string
 *                   example: "User not found"
 *       401:
 *         description: Invalid credentials.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: string
 *                   example: "failure"
 *                 message:
 *                   type: string
 *                   example: "Invalid credentials"
 *       500:
 *         description: Server error.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: string
 *                   example: "failure"
 *                 message:
 *                   type: string
 *                   example: "Server error"
 */


// Routes for user validation
authRouter.post('/check-username', checkUsername);
authRouter.post('/check-email', checkEmail);
authRouter.post('/check-phone-number', checkPhoneNumber);

authRouter.post('/register',upload.single('profile_image'), register);
authRouter.post('/login', login);
authRouter.post('/forget-password', forgetPassword );
authRouter.post('/reset-password', resetPassword);





export default authRouter;