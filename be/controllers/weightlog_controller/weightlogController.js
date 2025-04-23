import prisma from '../../prisma/prisma.js';

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