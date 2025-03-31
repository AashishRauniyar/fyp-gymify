import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

// Get all users for the admin panel
export const getAllUsersForAdmin = async (req, res) => {
    try {
        const users = await prisma.users.findMany({
            select: {
                user_id: true,
                user_name: true,
                role: true,
                address: true,
                phone_number: true,
                email: true,
                card_number: true,
                created_at: true,
                updated_at: true,
                verified: true
            }
        });

        res.status(200).json({
            status: 'success',
            message: 'Users fetched successfully',
            data: users
        });
    } catch (error) {
        console.error('Error fetching users:', error);
        res.status(500).json({ error: 'Failed to fetch users' });
    }
};

// Get a single user by ID
export const getUserByIdForAdmin = async (req, res) => {
    const { id } = req.params;
    try {
        const user = await prisma.users.findUnique({
            where: { user_id: parseInt(id) },
            select: {
                user_id: true,
                user_name: true,
                role: true,
                full_name: true,
                address: true,
                email: true,
                phone_number: true,
                membership_status: true,
                gym: true,
                dietPlans: true,
                workoutlogs: true
            }
        });

        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        res.status(200).json({
            status: 'success',
            message: 'User fetched successfully',
            data: user
        });
    } catch (error) {
        console.error('Error fetching user:', error);
        res.status(500).json({ error: 'Failed to fetch user' });
    }
};

// Update user details
export const updateUserForAdmin = async (req, res) => {
    const { id } = req.params;
    const { full_name, email, phone_number, role } = req.body;

    try {
        const updatedUser = await prisma.users.update({
            where: { user_id: parseInt(id) },
            data: { full_name, email, phone_number, role }
        });

        res.status(200).json({
            status: 'success',
            message: 'User updated successfully',
            data: updatedUser
        });
    } catch (error) {
        console.error('Error updating user:', error);
        res.status(500).json({ error: 'Failed to update user' });
    }
};

// Delete user
export const deleteUserForAdmin = async (req, res) => {
    const { id } = req.params;

    try {
        await prisma.users.delete({
            where: { user_id: parseInt(id) }
        });

        res.status(200).json({
            status: 'success',
            message: 'User deleted successfully'
        });
    } catch (error) {
        console.error('Error deleting user:', error);
        res.status(500).json({ error: 'Failed to delete user' });
    }
};
