import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

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
                age: true,
                height: true,
                current_weight: true,
                gender: true,
                role: true,
                fitness_level: true,
                goal_type: true,
                allergies: true,
                profile_image: true,
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
            user
        });
    } catch (error) {
        console.error('Error retrieving profile:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};


export const updateProfile = async (req, res) => {
    try {
        // Access the authenticated user's details from req.user (set by the middleware)
        const { user_id } = req.user;

        // Extract fields to update from the request body
        const {
            full_name,
            phone_number,
            address,
            age,
            height,
            current_weight,
            fitness_level,
            allergies,
            goal_type
        } = req.body;

        // Validate that at least one field is being updated
        if (
            !full_name &&
            !phone_number &&
            !address &&
            !age &&
            !height &&
            !current_weight &&
            !fitness_level &&
            !allergies &&
            !goal_type
        ) {
            return res.status(400).json({ status: 'failure', message: 'No fields to update' });
        }

        // Update the user's profile in the database
        const updatedUser = await prisma.users.update({
            where: { user_id },
            data: {
                full_name,
                phone_number,
                address,
                age,
                height,
                current_weight,
                fitness_level,
                allergies,
                goal_type,
                updated_at: new Date()
            },
            select: {
                user_id: true,
                user_name: true,
                full_name: true,
                email: true,
                phone_number: true,
                address: true,
                age: true,
                height: true,
                current_weight: true,
                gender: true,
                role: true,
                fitness_level: true,
                goal_type: true,
                allergies: true
            }
        });

        // Return the updated profile data
        res.status(200).json({
            status: 'success',
            message: 'Profile updated successfully',
            user: updatedUser
        });
    } catch (error) {
        console.error('Error updating profile:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};
