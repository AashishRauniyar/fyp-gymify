import bcrypt from 'bcryptjs';
import { PrismaClient } from '@prisma/client';
import generateToken from '../../utils/generateToken.js';
import { uploadToCloudinary } from '../../middleware/cloudinaryMiddleware.js';
import fs from 'fs';
import crypto from 'crypto';
const prisma = new PrismaClient();
import nodemailer from 'nodemailer';

//? Old working code

// // Utility function to validate email format
// const validateEmail = (email) => {
//     const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
//     return regex.test(email);
// };

// // Registration function
// export const register = async (req, res) => {
//     const {
//         user_name,
//         full_name,
//         email,
//         password,
//         phone_number,
//         address,
//         gender,
//         role,
//         fitness_level,
//         goal_type,
//         allergies,
//         calorie_goals,
//         card_number
//     } = req.body;

//     // Parse string inputs to numbers
//     const age = parseInt(req.body.age);
//     const height = parseFloat(req.body.height);
//     const current_weight = parseFloat(req.body.current_weight);

//     // Log parsed inputs
//     console.log('Parsed Inputs:', { age, height, current_weight });

//     //TODO: Learn express validator

//     // Validate required fields
//     if (!user_name || !full_name || !email || !password || !phone_number || !gender || !role || !fitness_level || !goal_type) {
//         return res.status(400).json({ status: 'failure', message: 'Missing required fields' });
//     }

//     // Validate email format
//     if (!validateEmail(email)) {
//         return res.status(400).json({ status: 'failure', message: 'Invalid email format' });
//     }

//     // Validate age
//     if (isNaN(age) || age < 0 || age > 120) {
//         return res.status(400).json({ status: 'failure', message: 'Invalid age' });
//     }

//     // Validate height (Decimal)
//     if (isNaN(height) || height <= 0) {
//         return res.status(400).json({ status: 'failure', message: 'Invalid height' });
//     }

//     // Validate current_weight (Decimal)
//     if (isNaN(current_weight) || current_weight <= 0) {
//         return res.status(400).json({ status: 'failure', message: 'Invalid current weight' });
//     }

//     //TODO: Check validation for +977
//     // Validate phone number (must be 10 digits)
//     if (!/^\d{10}$/.test(phone_number)) {
//         return res.status(400).json({ status: 'failure', message: 'Invalid phone number' });
//     }

//     // Validate password length
//     if (password.length < 8) {
//         return res.status(400).json({ status: 'failure', message: 'Password must be at least 8 characters long' });
//     }

//     // Validate gender
//     if (!['Male', 'Female', 'Other'].includes(gender)) {
//         return res.status(400).json({ status: 'failure', message: 'Invalid gender' });
//     }

//     // Validate role
//     if (!['Member', 'Trainer', 'Admin'].includes(role)) {
//         return res.status(400).json({ status: 'failure', message: 'Invalid role' });
//     }

//     // Validate calorie goals (if provided)
//     if (calorie_goals && (isNaN(calorie_goals) || calorie_goals < 0)) {
//         return res.status(400).json({ status: 'failure', message: 'Invalid calorie goals' });
//     }

//     try {
//         // Check if the user already exists by email or phone number
//         const existingUser = await prisma.users.findUnique({ where: { email } });
//         if (existingUser) {
//             return res.status(400).json({ status: 'failure', message: 'User with this email already exists' });
//         }

//         const existingPhoneNumber = await prisma.users.findUnique({ where: { phone_number } });
//         if (existingPhoneNumber) {
//             return res.status(400).json({ status: 'failure', message: 'User with this phone number already exists' });
//         }

//         // Hash the password
//         const hashedPassword = await bcrypt.hash(password, 10);

//         // Upload profile image to Cloudinary
//         // let profileImageUrl = null;
//         // if (req.file) {
//         //     const imagePath = req.file.path;
//         //     try {
//         //         profileImageUrl = await uploadToCloudinary(imagePath);

//         //         // Remove the file from the server after uploading to Cloudinary
//         //         if (profileImageUrl) {
//         //             fs.unlinkSync(imagePath);
//         //         }
//         //     } catch (error) {
//         //         console.error('Error uploading image:', error);
//         //         if (fs.existsSync(imagePath)) {
//         //             fs.unlinkSync(imagePath);
//         //         }
//         //     }
//         // }


//         // Upload profile image to Cloudinary
//         let profileImageUrl = null;
//         if (req.file) {
//             try {
//                 profileImageUrl = await uploadToCloudinary(req.file.buffer); // Pass the file buffer directly
//             } catch (error) {
//                 console.error('Error uploading image:', error);
//                 return res.status(500).json({ status: 'failure', message: 'Image upload failed' });
//             }
//         }


//         // Create a new user with validated data
//         const user = await prisma.users.create({
//             data: {
//                 user_name,
//                 full_name,
//                 email,
//                 password: hashedPassword,
//                 phone_number,
//                 address,
//                 age,
//                 height,
//                 current_weight,
//                 gender,
//                 role,
//                 fitness_level,
//                 goal_type,
//                 allergies,
//                 calorie_goals,
//                 card_number,
//                 profile_image: profileImageUrl,
//                 created_at: new Date(),
//                 updated_at: new Date()
//             }
//         });



//         res.status(201).json({
//             status: 'success',
//             message: 'User registered successfully',
//             data: {
//                 user_id: user.user_id,
//                 user_name: user.user_name,
//                 email: user.email,
//                 role: user.role,
//                 full_name: user.full_name,
//                 profile_image: user.profile_image
//             },

//         });
//     } catch (error) {
//         console.error('Error during registration:', error);
//         res.status(500).json({ status: 'failure', message: 'Server error' });
//     }
// };


import { body, validationResult } from 'express-validator';

export const register = async (req, res) => {
    // Validation rules for input fields
    await body('user_name').notEmpty().withMessage('User name is required').run(req);
    await body('full_name').notEmpty().withMessage('Full name is required').run(req);
    await body('email').isEmail().withMessage('Invalid email format').run(req);
    await body('password').isLength({ min: 8 }).withMessage('Password must be at least 8 characters long').run(req);
    await body('phone_number').matches(/^\d{10}$/).withMessage('Invalid phone number').run(req);
    await body('gender').isIn(['Male', 'Female', 'Other']).withMessage('Invalid gender').run(req);
    await body('role').isIn(['Member', 'Trainer', 'Admin']).withMessage('Invalid role').run(req);
    await body('birthdate').isDate().withMessage('Invalid birthdate format').run(req); // Changed validation for age to birthdate
    await body('height').isFloat({ min: 0 }).withMessage('Invalid height').run(req);
    await body('current_weight').isFloat({ min: 0 }).withMessage('Invalid current weight').run(req);

    // Check if any validation errors occurred
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({
            status: 'failure',
            message: 'Validation failed',
            errors: errors.array()
        });
    }

    const {
        user_name,
        full_name,
        email,
        password,
        phone_number,
        address,
        gender,
        role,
        fitness_level,
        goal_type,
        allergies,
        calorie_goals,
        card_number,
        birthdate,
        height,
        current_weight // Now accepting birthdate
    } = req.body;

    try {
        // Check if the user already exists by user_name, email, or phone number
        const existingUser = await prisma.users.findUnique({ where: { user_name } });
        if (existingUser) {
            return res.status(400).json({ status: 'failure', message: 'User with this user name already exists' });
        }

        // Check if the user already exists by email or phone number
        const existingEmail = await prisma.users.findUnique({ where: { email } });
        if (existingEmail) {
            return res.status(400).json({ status: 'failure', message: 'User with this email already exists' });
        }

        const existingPhoneNumber = await prisma.users.findUnique({ where: { phone_number } });
        if (existingPhoneNumber) {
            return res.status(400).json({ status: 'failure', message: 'User with this phone number already exists' });
        }

        // Hash the password
        const hashedPassword = await bcrypt.hash(password, 10);

        // Upload profile image to Cloudinary
        let profileImageUrl = null;
        if (req.file) {
            try {
                profileImageUrl = await uploadToCloudinary(req.file.buffer); // Pass the file buffer directly
            } catch (error) {
                console.error('Error uploading image:', error);
                return res.status(500).json({ status: 'failure', message: 'Image upload failed' });
            }
        }

        // Create a new user with validated data
        const user = await prisma.users.create({
            data: {
                user_name,
                full_name,
                email,
                password: hashedPassword,
                phone_number,
                address,
                birthdate: new Date(birthdate), // Store birthdate as DateTime
                height,
                current_weight,
                gender,
                role,
                fitness_level,
                goal_type,
                allergies,
                calorie_goals,
                card_number,
                profile_image: profileImageUrl,
                created_at: new Date(),
                updated_at: new Date()
            }
        });

        res.status(201).json({
            status: 'success',
            message: 'User registered successfully',
            data: {
                user_id: user.user_id,
                user_name: user.user_name,
                email: user.email,
                role: user.role,
                full_name: user.full_name,
                profile_image: user.profile_image
            }
        });
    } catch (error) {
        console.error('Error during registration:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};



//?  Login a user



// export const login = async (req, res) => {
//     try {
//         const { email, password } = req.body;

//         const user = await prisma.users.findUnique({ where: { email } });

//         if (!user) {
//             return res.status(404).json({ status: 'failure', message: 'User not found' });
//         }

//         const isPasswordMatch = await bcrypt.compare(password, user.password);
//         if (!isPasswordMatch) {
//             return res.status(401).json({ status: 'failure', message: 'Invalid credentials' });
//         }

//         // Generate the token including user_id and role
//         const token = generateToken(user);

//         res.status(200).json({
//             status: 'success',
//             message: 'Login successful',
//             //TODO: Remove user details from response
//             data: {
//                 user_id: user.user_id,
//                 user_name: user.user_name,
//                 email: user.email,
//                 role: user.role,
//                 full_name: user.full_name,
//                 phone_number: user.phone_number,
//                 fitness_level: user.fitness_level,
//                 goal_type: user.goal_type
//             },
//             token
//         });
//     } catch (error) {
//         console.error('Error during login:', error);
//         res.status(500).json({ status: 'failure', message: 'Server error' });
//     }
// };

// export const forgetPassword = async (req, res) => {
//     try {
//         const { email } = req.body;

//         // Check if user exists
//         const user = await prisma.users.findUnique({ where: { email } });
//         if (!user) {
//             // For security, don't disclose whether the email exists
//             return res.status(200).json({ message: "If this email exists, a reset link will be sent." });
//         }

//         // Generate a reset token
//         const resetToken = crypto.randomBytes(20).toString("hex");
//         const resetTokenExpiry = new Date(Date.now() + 3600000); // 1 hour

//         // Save the reset token and expiry in the database
//         await prisma.users.update({
//             where: { email },
//             data: {
//                 reset_token: resetToken, // Consider hashing this
//                 reset_token_expiry: resetTokenExpiry,
//             },
//         });

//         // Configure email transporter
//         const transporter = nodemailer.createTransport({
//             service: "Gmail",
//             auth: {
//                 user: process.env.EMAIL_USER,
//                 pass: process.env.EMAIL_PASS,
//             },
//         });

//         // Create reset link
//         const resetLink = `http://localhost:5173/reset-password/${resetToken}`;

//         // Send email
//         const mailOptions = {
//             from: process.env.EMAIL_USER,
//             to: email,
//             subject: "Password Reset Request",
//             text: `You requested a password reset. Click the link to reset your password: ${resetLink}`,
//         };

//         transporter.sendMail(mailOptions, (err, info) => {
//             if (err) {
//                 console.error("Error sending email:", err);
//                 return res.status(500).json({ message: "Error sending email" });
//             }
//             res.status(200).json({ message: "A reset link is sent." });
//         });
//     } catch (error) {
//         console.error("Error during password reset request:", error);
//         res.status(500).json({ message: "Server error" });
//     }
// };


// export const resetPassword = async (req, res) => {
//     try {
//         const { token } = req.params; // Extract token from URL params
//         const { password } = req.body; // Extract new password from request body

//         // Validate input
//         if (!password || password.length < 8) {
//             return res.status(400).json({ error: "Password must be at least 8 characters long" });
//         }

//         // Find the user with the provided reset token and ensure the token is still valid
//         const user = await prisma.users.findFirst({
//             where: {
//                 reset_token: token,
//                 reset_token_expiry: { gte: new Date() }, // Ensure token is not expired
//             },
//         });

//         if (!user) {
//             return res.status(400).json({ error: "Invalid or expired token" });
//         }

//         // Hash the new password
//         const hashedPassword = await bcrypt.hash(password, 10);

//         // Update the user's password and clear the reset token and expiry
//         await prisma.users.update({
//             where: { email: user.email },
//             data: {
//                 password: hashedPassword,
//                 reset_token: null,
//                 reset_token_expiry: null,
//             },
//         });

//         res.status(200).json({ message: "Password has been reset successfully" });
//     } catch (error) {
//         console.error("Error in reset password:", error);
//         res.status(500).json({ error: "Internal server error" });
//     }
// };





// Login function with express-validator
export const login = async (req, res) => {
    try {
        // Validation for email and password
        await body('email').isEmail().withMessage('Invalid email format').run(req);
        await body('password').isLength({ min: 8 }).withMessage('Password must be at least 8 characters long').run(req);

        // Check if any validation errors occurred
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({
                status: 'failure',
                message: 'Validation failed',
                errors: errors.array()
            });
        }

        const { email, password } = req.body;

        const user = await prisma.users.findUnique({ where: { email } });

        if (!user) {
            return res.status(404).json({ status: 'failure', message: 'User not found' });
        }

        const isPasswordMatch = await bcrypt.compare(password, user.password);
        if (!isPasswordMatch) {
            return res.status(401).json({ status: 'failure', message: 'Invalid credentials' });
        }

        // Generate the token including user_id and role
        const token = generateToken(user);

        res.status(200).json({
            status: 'success',
            message: 'Login successful',
            data: {
                user_id: user.user_id,
                user_name: user.user_name,
                email: user.email,
                role: user.role,
                full_name: user.full_name,
                phone_number: user.phone_number,
                fitness_level: user.fitness_level,
                goal_type: user.goal_type
            },
            token
        });
    } catch (error) {
        console.error('Error during login:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};

// Forget Password function with express-validator
export const forgetPassword = async (req, res) => {
    try {
        // Validate email format
        await body('email').isEmail().withMessage('Invalid email format').run(req);

        // Check if any validation errors occurred
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({
                status: 'failure',
                message: 'Validation failed',
                errors: errors.array()
            });
        }

        const { email } = req.body;

        // Check if user exists
        const user = await prisma.users.findUnique({ where: { email } });
        if (!user) {
            // For security, don't disclose whether the email exists
            return res.status(200).json({ message: "If this email exists, a reset link will be sent." });
        }

        // Generate a reset token
        const resetToken = crypto.randomBytes(20).toString("hex");
        const resetTokenExpiry = new Date(Date.now() + 3600000); // 1 hour

        // Save the reset token and expiry in the database
        await prisma.users.update({
            where: { email },
            data: {
                reset_token: resetToken,
                reset_token_expiry: resetTokenExpiry,
            },
        });

        // Configure email transporter
        const transporter = nodemailer.createTransport({
            service: "Gmail",
            auth: {
                user: process.env.EMAIL_USER,
                pass: process.env.EMAIL_PASS,
            },
        });

        // Create reset link
        const resetLink = `http://localhost:5173/reset-password/${resetToken}`;

        // Send email
        const mailOptions = {
            from: process.env.EMAIL_USER,
            to: email,
            subject: "Password Reset Request",
            text: `You requested a password reset. Click the link to reset your password: ${resetLink}`,
        };

        transporter.sendMail(mailOptions, (err, info) => {
            if (err) {
                console.error("Error sending email:", err);
                return res.status(500).json({ message: "Error sending email" });
            }
            res.status(200).json({ message: "A reset link is sent." });
        });
    } catch (error) {
        console.error("Error during password reset request:", error);
        res.status(500).json({ message: "Server error" });
    }
};

// Reset Password function with express-validator
export const resetPassword = async (req, res) => {
    try {
        // Validate password length
        await body('password').isLength({ min: 8 }).withMessage('Password must be at least 8 characters long').run(req);

        // Check if any validation errors occurred
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({
                status: 'failure',
                message: 'Validation failed',
                errors: errors.array()
            });
        }

        const { token } = req.params;
        const { password } = req.body;

        // Find the user with the provided reset token and ensure the token is still valid
        const user = await prisma.users.findFirst({
            where: {
                reset_token: token,
                reset_token_expiry: { gte: new Date() }, // Ensure token is not expired
            },
        });

        if (!user) {
            return res.status(400).json({ error: "Invalid or expired token" });
        }

        // Hash the new password
        const hashedPassword = await bcrypt.hash(password, 10);

        // Update the user's password and clear the reset token and expiry
        await prisma.users.update({
            where: { email: user.email },
            data: {
                password: hashedPassword,
                reset_token: null,
                reset_token_expiry: null,
            },
        });

        res.status(200).json({ message: "Password has been reset successfully" });
    } catch (error) {
        console.error("Error in reset password:", error);
        res.status(500).json({ error: "Internal server error" });
    }
};
