import bcrypt from 'bcryptjs';
import { PrismaClient } from '@prisma/client';
import generateToken from '../../utils/generateToken.js';
import { uploadToCloudinary } from '../../middleware/cloudinaryMiddleware.js';
import fs from 'fs';
import crypto from 'crypto';
const prisma = new PrismaClient();


import { body, validationResult } from 'express-validator';
import { sendOTPEmail } from '../../utils/sendMail.js';



// Input validation middleware
const registerValidation = [
    body('email')
        .isEmail()
        .withMessage('Invalid email format')
        .normalizeEmail({ gmail_remove_dots: false }) // Prevents removing dots
        .withMessage('Invalid email format'),
    body('password')
        .isLength({ min: 8 })
        .withMessage('Password must be at least 8 characters long')
        .matches(/^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/)
        .withMessage('Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character')
];

// Helper function to generate OTP
const generateOTP = () => {
    return crypto.randomInt(100000, 999999).toString();
};

// Helper function to send OTP email
// const sendOTPEmail = async (email, otp, isResend = false) => {
//     try {
//         await transporter.sendMail({
//             from: process.env.EMAIL_USER,
//             to: email,
//             subject: `${isResend ? 'Resend: ' : ''}Email Verification Code`,
//             html: `
//                 <h2>Welcome to Our Platform</h2>
//                 <p>Your verification code is: <strong>${otp}</strong></p>
//                 <p>This code will expire in 10 minutes.</p>
//                 <p>If you didn't request this code, please ignore this email.</p>
//             `
//         });
//         return true;
//     } catch (error) {
//         console.error('Error sending email:', error);
//         return false;
//     }
// };

// Check if email exists
export const checkEmailExists = async (req, res) => {
    try {
        const { email } = req.body;

        if (!email) {
            return res.status(400).json({
                status: 'failure',
                message: 'Email is required'
            });
        }

        // Validate email format
        if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
            return res.status(400).json({
                status: 'failure',
                message: 'Invalid email format'
            });
        }

        const user = await prisma.users.findUnique({
            where: { email: email.toLowerCase() },
            select: {
                email: true,
                verified: true
            }
        });

        if (user) {
            return res.status(200).json({
                status: 'success',
                exists: true,
                verified: user.verified,
                message: user.verified
                    ? 'Email is already registered and verified'
                    : 'Email is registered but not verified'
            });
        }

        return res.status(200).json({
            status: 'success',
            exists: false,
            message: 'Email is available'
        });

    } catch (error) {
        console.error('Email check error:', error);
        return res.status(500).json({
            status: 'failure',
            message: 'Internal server error'
        });
    }
};

// Registration endpoint
export const register = async (req, res) => {
    try {
        // Validate input
        await Promise.all(registerValidation.map(validation => validation.run(req)));
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({
                status: 'failure',
                errors: errors.array()
            });
        }

        const { email, password } = req.body;
        const normalizedEmail = email.toLowerCase();

        // Check existing user
        const existingUser = await prisma.users.findUnique({
            where: { email: normalizedEmail },
            select: {
                email: true,
                verified: true,
                created_at: true
            }
        });


        // TODO: change this if necessary
        if (existingUser) {
            if (existingUser.verified) {
                return res.status(409).json({
                    status: 'failure',
                    // message: 'Email already registered and verified',
                    message: 'Email already registered',
                    details: {
                        email: normalizedEmail,
                        registered: true,
                        verified: true,
                        registrationDate: existingUser.created_at
                    }
                });
            }

            // Handle unverified existing user
            const newOtp = generateOTP();
            const newOtpExpiry = new Date(Date.now() + 10 * 60 * 1000);

            await prisma.users.update({
                where: { email: normalizedEmail },
                data: {
                    otp: newOtp,
                    otp_expiry: newOtpExpiry,
                }
            });

            const emailSent = await sendOTPEmail(normalizedEmail, newOtp, true);
            if (!emailSent) {
                return res.status(500).json({
                    status: 'failure',
                    message: 'Failed to send OTP email',
                    details: {
                        email: normalizedEmail,
                        registered: true,
                        verified: false
                    }
                });
            }

            return res.status(200).json({
                status: 'success',
                message: 'Email already registered but not verified. New OTP sent.',
                details: {
                    email: normalizedEmail,
                    registered: true,
                    verified: false,
                    registrationDate: existingUser.created_at
                }
            });
        }

        // Create new user
        const hashedPassword = await bcrypt.hash(password, 12);
        const otp = generateOTP();
        const otpExpiry = new Date(Date.now() + 10 * 60 * 1000);

        await prisma.users.create({
            data: {
                email: normalizedEmail,
                password: hashedPassword,
                otp,
                otp_expiry: otpExpiry,
                role: 'Member',
                verified: false
            }
        });

        const emailSent = await sendOTPEmail(normalizedEmail, otp);
        if (!emailSent) {
            // Rollback user creation if email fails
            await prisma.users.delete({ where: { email: normalizedEmail } });
            return res.status(500).json({
                status: 'failure',
                message: 'Failed to send OTP email'
            });
        }

        return res.status(201).json({
            status: 'success',
            message: 'Registration initiated. Please verify your email.',
            data: { email: normalizedEmail }
        });

    } catch (error) {
        console.error('Registration error:', error);
        return res.status(500).json({
            status: 'failure',
            message: 'Internal server error'
        });
    }
};

// OTP verification endpoint
export const verifyOTP = async (req, res) => {
    try {
        const { email, otp } = req.body;

        if (!email || !otp) {
            return res.status(400).json({
                status: 'failure',
                message: 'Email and OTP are required'
            });
        }

        const normalizedEmail = email.toLowerCase();
        const user = await prisma.users.findUnique({
            where: { email: normalizedEmail }
        });

        if (!user) {
            return res.status(404).json({
                status: 'failure',
                message: 'User not found'
            });
        }

        if (user.verified) {
            return res.status(400).json({
                status: 'failure',
                message: 'Email already verified'
            });
        }

        if (!user.otp || !user.otp_expiry) {
            return res.status(400).json({
                status: 'failure',
                message: 'No OTP request found'
            });
        }

        if (new Date() > user.otp_expiry) {
            return res.status(400).json({
                status: 'failure',
                message: 'OTP has expired'
            });
        }

        if (user.otp !== otp) {
            return res.status(400).json({
                status: 'failure',
                message: 'Invalid OTP'
            });
        }

        await prisma.users.update({
            where: { email: normalizedEmail },
            data: {
                verified: true,
                otp: null,
                otp_expiry: null
            }
        });

        return res.status(200).json({
            status: 'success',
            message: 'Email verified successfully'
        });

    } catch (error) {
        console.error('OTP verification error:', error);
        return res.status(500).json({
            status: 'failure',
            message: 'Internal server error'
        });
    }
};

// Resend OTP endpoint
export const resendOTP = async (req, res) => {
    try {
        const { email } = req.body;

        if (!email) {
            return res.status(400).json({
                status: 'failure',
                message: 'Email is required'
            });
        }

        const normalizedEmail = email.toLowerCase();
        const user = await prisma.users.findUnique({
            where: { email: normalizedEmail }
        });

        if (!user) {
            return res.status(404).json({
                status: 'failure',
                message: 'User not found'
            });
        }

        if (user.verified) {
            return res.status(400).json({
                status: 'failure',
                message: 'Email already verified'
            });
        }

        const newOtp = generateOTP();
        const newOtpExpiry = new Date(Date.now() + 10 * 60 * 1000);

        await prisma.users.update({
            where: { email: normalizedEmail },
            data: {
                otp: newOtp,
                otp_expiry: newOtpExpiry
            }
        });

        const emailSent = await sendOTPEmail(normalizedEmail, newOtp, true);
        if (!emailSent) {
            return res.status(500).json({
                status: 'failure',
                message: 'Failed to send OTP email'
            });
        }

        return res.status(200).json({
            status: 'success',
            message: 'OTP resent successfully'
        });

    } catch (error) {
        console.error('Resend OTP error:', error);
        return res.status(500).json({
            status: 'failure',
            message: 'Internal server error'
        });
    }
};


/**
 * Step 3: Complete User Registration
 */
export const completeRegistration = async (req, res) => {
    const { email, user_name, full_name, phone_number, address, gender, birthdate, height, current_weight, fitness_level, goal_type, allergies, calorie_goals, card_number, profile_image } = req.body;

    try {
        const user = await prisma.users.findUnique({ where: { email } });
        if (!user) {
            return res.status(400).json({ status: 'failure', message: 'User not found' });
        }



        let profileImageUrl = null;
        if (req.file) {
            try {
                profileImageUrl = await uploadToCloudinary(req.file.buffer); // Pass the file buffer directly
            } catch (error) {
                console.error('Error uploading image:', error);
                return res.status(500).json({ status: 'failure', message: 'Image upload failed' });
            }
        }

        // check unique for user_name and phone_number
        const existingUserName = await prisma.users.findUnique({ where: { user_name } });
        if (existingUserName) {
            return res.status(400).json({ status: 'failure', message: 'Username already exists' });
        }

        const existingPhoneNumber = await prisma.users.findUnique({ where: { phone_number } });
        if (existingPhoneNumber) {
            return res.status(400).json({ status: 'failure', message: 'Phone number already exists' });
        }

        

        await prisma.users.update({
            where: { email },
            data: {
                user_name,
                full_name,
                phone_number,
                address,
                gender,
                birthdate: new Date(birthdate),
                height,
                current_weight,
                fitness_level,
                goal_type,
                allergies,
                calorie_goals,
                card_number,
                profile_image: profileImageUrl || user.profile_image, // Use existing image if upload fails
            },
        });

        res.status(200).json({ status: 'success', message: 'Registration completed', data: { user_id: user.user_id, user_name, email, role: user.role, full_name, profile_image } });
    } catch (error) {
        console.error('Error completing registration:', error);
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




// //!------------------------------------------------------------------------------------------------------------


// // api to check username already exists or not

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

// export const checkEmail = async (req, res) => {
//     try {
//         const { email } = req.body;
//         const user = await prisma.users.findUnique({ where: { email } });

//         if (user) {
//             if (user.verified) {
//                 return res.status(200).json({ status: 'failure', message: 'User with this email already exists' });
//             } else {
//                 return res.status(200).json({ status: 'pending', message: 'User exists but not verified' });
//             }
//         }

//         res.status(200).json({ status: 'success', message: 'User with this email does not exist' });
//     } catch (error) {
//         console.error('Error during checking email:', error);
//         res.status(500).json({ status: 'failure', message: 'Server error' });
//     }
// };

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


//-------------------------------------------------------------



// api to forget password


// Forgot Password Endpoint: Request OTP for password reset
export const forgotPassword = async (req, res) => {
    try {
        const { email } = req.body;

        if (!email) {
            return res.status(400).json({
                status: 'failure',
                message: 'Email is required'
            });
        }

        // Normalize email
        const normalizedEmail = email.toLowerCase();

        // Check if the user exists
        const user = await prisma.users.findUnique({
            where: { email: normalizedEmail }
        });

        if (!user) {
            return res.status(404).json({
                status: 'failure',
                message: 'User not found'
            });
        }

        // Generate OTP and expiry time (10 minutes from now)
        const otp = generateOTP();
        const otpExpiry = new Date(Date.now() + 10 * 60 * 1000);

        // Update the user's record with the new OTP and expiry
        await prisma.users.update({
            where: { email: normalizedEmail },
            data: {
                otp,
                otp_expiry: otpExpiry
            }
        });

        // Send OTP email
        const emailSent = await sendOTPEmail(normalizedEmail, otp);
        if (!emailSent) {
            return res.status(500).json({
                status: 'failure',
                message: 'Failed to send OTP email'
            });
        }

        return res.status(200).json({
            status: 'success',
            message: 'OTP sent to your email for password reset'
        });
    } catch (error) {
        console.error('Forgot password error:', error);
        return res.status(500).json({
            status: 'failure',
            message: 'Internal server error'
        });
    }
};

// Reset Password Endpoint: Verify OTP and update password
export const resetPassword = async (req, res) => {
    try {
        const { email, otp, newPassword } = req.body;

        if (!email || !otp || !newPassword) {
            return res.status(400).json({
                status: 'failure',
                message: 'Email, OTP, and new password are required'
            });
        }

        const normalizedEmail = email.toLowerCase();

        // Find the user
        const user = await prisma.users.findUnique({
            where: { email: normalizedEmail }
        });

        if (!user) {
            return res.status(404).json({
                status: 'failure',
                message: 'User not found'
            });
        }

        // Check if an OTP was generated and has not expired
        if (!user.otp || !user.otp_expiry) {
            return res.status(400).json({
                status: 'failure',
                message: 'No OTP request found'
            });
        }

        if (new Date() > user.otp_expiry) {
            return res.status(400).json({
                status: 'failure',
                message: 'OTP has expired'
            });
        }

        if (user.otp !== otp) {
            return res.status(400).json({
                status: 'failure',
                message: 'Invalid OTP'
            });
        }

        // Validate the new password meets criteria:
        // Minimum 8 characters, at least one uppercase, one lowercase, one number, and one special character
        const passwordRegex = /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
        if (!passwordRegex.test(newPassword)) {
            return res.status(400).json({
                status: 'failure',
                message: 'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character'
            });
        }

        // Hash the new password
        const hashedPassword = await bcrypt.hash(newPassword, 12);

        // Update the user record: set the new password and clear OTP fields
        await prisma.users.update({
            where: { email: normalizedEmail },
            data: {
                password: hashedPassword,
                otp: null,
                otp_expiry: null
            }
        });

        return res.status(200).json({
            status: 'success',
            message: 'Password reset successfully'
        });
    } catch (error) {
        console.error('Reset password error:', error);
        return res.status(500).json({
            status: 'failure',
            message: 'Internal server error'
        });
    }
};
