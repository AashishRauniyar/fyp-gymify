import bcrypt from 'bcryptjs';
import { PrismaClient } from '@prisma/client';
import generateToken from '../../utils/generateToken.js';
import { uploadToCloudinary } from '../../middleware/cloudinaryMiddleware.js';
import fs from 'fs';
import crypto from 'crypto';
const prisma = new PrismaClient();
import nodemailer from 'nodemailer';


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


//!------------------------------------------------------------------------------------------------------------


// api to check username already exists or not

export const checkUsername = async (req, res) => {

    try {
        const { user_name } = req.body;

        const user = await prisma.users.findUnique({ where: { user_name } });

        if (user) {
            return res.status(200).json({ status: 'failure', message: 'User with this user name already exists' });
        }

        res.status(200).json({ status: 'success', message: 'User with this user name does not exist' });

    } catch (error) {
        console.error('Error during checking username:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
}



// api to check email already exists or not

export const checkEmail = async (req, res) => {

    try {
        const { email } = req.body;

        const user = await prisma.users.findUnique({ where: { email } });

        if (user) {
            return res.status(200).json({ status: 'failure', message: 'User with this email already exists' });
        }

        res.status(200).json({ status: 'success', message: 'User with this email does not exist' });

    } catch (error) {
        console.error('Error during checking email:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
}

// api to check phone number already exists or not

export const checkPhoneNumber = async (req, res) => {

    try {
        const { phone_number } = req.body;

        const user = await prisma.users.findUnique({ where: { phone_number } });

        if (user) {
            return res.status(200).json({ status: 'failure', message: 'User with this phone number already exists' });
        }

        res.status(200).json({ status: 'success', message: 'User with this phone number does not exist' });
        
    } catch (error) {
        console.error('Error during checking phone number:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });       
        
    }

}