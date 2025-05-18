import prisma from '../../prisma/prisma.js';
import { body, validationResult } from 'express-validator';
import { uploadToCloudinary } from '../../middleware/cloudinaryMiddleware.js';


// Get user profile
export const getProfile = async (req, res) => {
    try {
        // Access the authenticated user's details from req.user (set by the middleware)
        const { user_id } = req.user;

        // Fetch the user profile data from the database
        const user = await prisma.users.findUnique({
            where: { user_id },
            select: {
                user_id: true,
                user_name: true,
                full_name: true,
                email: true,
                phone_number: true,
                address: true,
                birthdate: true,
                height: true,
                current_weight: true,
                gender: true,
                role: true,
                fitness_level: true,
                goal_type: true,
                allergies: true,
                profile_image: true,
                card_number: true,
                calorie_goals: true,

                created_at: true,
                updated_at: true
            }
        });

        // If user does not exist, return an error
        if (!user) {
            return res.status(404).json({ status: 'failure', message: 'User not found' });
        }

        // Return the user profile data
        res.status(200).json({
            status: 'success',
            message: 'User profile retrieved successfully',
            data: user
        });
    } catch (error) {
        console.error('Error retrieving profile:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};

// Validation Middleware
export const validateUpdateProfile = [
    body('full_name').optional().isString().withMessage('Full name must be a string'),
    body('phone_number').optional().isMobilePhone().withMessage('Invalid phone number'),
    body('address').optional().isString().withMessage('Address must be a string'),
    body('height').optional().isFloat({ min: 0 }).withMessage('Height must be a positive number'),
    body('fitness_level').optional().isString().withMessage('Fitness level must be a string'),
    body('goal_type').optional().isString().withMessage('Goal type must be a string'),
    body('allergies').optional().isString().withMessage('Allergies must be a string'),
    (req, res, next) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ status: 'failure', errors: errors.array() });
        }
        next();
    }
];

export const updateProfile = async (req, res) => {
    try {
        const { user_id } = req.user;

        const {
            full_name,
            phone_number,
            address,
            height,
            fitness_level,
            allergies,
            goal_type
        } = req.body;

        // Handle profile image upload
        let profileImageUrl = null;
        if (req.file) {
            try {
                profileImageUrl = await uploadToCloudinary(req.file.buffer);
            } catch (error) {
                console.error('Error uploading image:', error);
                return res.status(500).json({ status: 'failure', message: 'Image upload failed' });
            }
        }

        // Check if phone number already exists for another user
        if (phone_number) {
            const existingPhoneNumber = await prisma.users.findFirst({
                where: {
                    phone_number,
                    NOT: {
                        user_id: user_id
                    }
                }
            });

            if (existingPhoneNumber) {
                return res.status(400).json({ status: 'failure', message: 'Phone number already exists' });
            }
        }

        if (
            !full_name &&
            !phone_number &&
            !address &&
            !height &&
            !fitness_level &&
            !allergies &&
            !goal_type &&
            !profileImageUrl
        ) {
            return res.status(400).json({ status: 'failure', message: 'No fields to update' });
        }

        // Start a database transaction
        const updatedUser = await prisma.$transaction(async (transaction) => {
            // Get current user to preserve existing profile image if not updating
            const currentUser = await transaction.users.findUnique({
                where: { user_id },
                select: { profile_image: true }
            });

            // Update the user's profile
            const user = await transaction.users.update({
                where: { user_id },
                data: {
                    full_name,
                    phone_number,
                    address,
                    height,
                    fitness_level,
                    allergies,
                    goal_type,
                    profile_image: profileImageUrl || currentUser.profile_image, // Use new image or keep existing
                    updated_at: new Date()
                },
                select: {
                    user_id: true,
                    user_name: true,
                    full_name: true,
                    email: true,
                    phone_number: true,
                    address: true,
                    birthdate: true,
                    height: true,
                    current_weight: true,
                    gender: true,
                    role: true,
                    fitness_level: true,
                    goal_type: true,
                    allergies: true,
                    profile_image: true,
                    card_number: true,
                    calorie_goals: true,
                    created_at: true,
                    updated_at: true
                }
            });

            return user;
        });

        res.status(200).json({
            status: 'success',
            message: 'Profile updated successfully',
            data: updatedUser
        });
    } catch (error) {
        console.error('Error updating profile:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};

export const updateWeight = async (req, res) => {
    try {
        const { user_id } = req.user; // Extract authenticated user's ID
        const { current_weight } = req.body; // Get the new weight from the request body

        // Validate weight input
        if (!current_weight || typeof current_weight !== 'number' || current_weight <= 0) {
            return res.status(400).json({ status: 'failure', message: 'Invalid weight input' });
        }

        // Start a transaction to update weight and log the change
        const updatedUser = await prisma.$transaction(async (transaction) => {
            // Update the user's weight in the users table
            const user = await transaction.users.update({
                where: { user_id },
                data: {
                    current_weight, // Update current weight
                    updated_at: new Date() // Update the timestamp
                },
                select: {
                    user_id: true,
                    current_weight: true,
                    updated_at: true
                }
            });

            // Log the weight change in the weight_logs table
            await transaction.weight_logs.create({
                data: {
                    user_id, // Foreign key linking the log to the user
                    weight: current_weight, // The updated weight
                    logged_at: new Date() // Timestamp for the log
                }
            });

            return user;
        });

        // Respond with the updated user details
        res.status(200).json({
            status: 'success',
            message: 'Weight updated and logged successfully',
            data: updatedUser
        });
    } catch (error) {
        console.error('Error updating weight:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};

//TODO: Add weight history , check error in deployment
export const getWeightHistory = async (req, res) => {
    try {
        const { user_id } = req.user;

        // Fetch the user's weight history
        const weightHistory = await prisma.weight_logs.findMany({
            where: { user_id },
            orderBy: { logged_at: 'desc' },
            select: {
                weight: true,
                logged_at: true,
            },
        });

        res.status(200).json({
            status: 'success',
            message: 'Weight history retrieved successfully',
            data: weightHistory,
        });
    } catch (error) {
        console.error('Error retrieving weight history:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};