import prisma, { withRecovery } from '../../prisma/prisma.js';

export const updateWeight = async (req, res) => {
    try {
        const { user_id } = req.user;
        const { current_weight } = req.body;

        // Validate weight input
        if (!current_weight || typeof current_weight !== 'number' || current_weight <= 0) {
            return res.status(400).json({ status: 'failure', message: 'Invalid weight input' });
        }

        // Use the withRecovery function to handle potential connection issues
        const updatedUser = await withRecovery(async () => {
            return await prisma.$transaction(async (transaction) => {
                // Update the user's weight in the users table
                const user = await transaction.users.update({
                    where: { user_id },
                    data: {
                        current_weight,
                        updated_at: new Date()
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
                        user_id,
                        weight: current_weight,
                        logged_at: new Date()
                    }
                });

                return user;
            }, {
                timeout: 10000 // 10 seconds timeout
            });
        });

        // Respond with the updated user details
        res.status(200).json({
            status: 'success',
            message: 'Weight updated and logged successfully',
            data: updatedUser
        });
    } catch (error) {
        console.error('Error updating weight:', error);

        // Check for specific database connection errors
        if (error.code && (
            error.code.includes('P2037') || // Prisma connection error
            error.message.includes('connection') ||
            error.message.includes('timeout')
        )) {
            return res.status(503).json({
                status: 'failure',
                message: 'Database connection issue. Please try again later.'
            });
        }

        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};

export const getWeightHistory = async (req, res) => {
    try {
        const { user_id } = req.user;

        // Use the withRecovery function to handle potential connection issues
        const weightHistory = await withRecovery(async () => {
            return await prisma.weight_logs.findMany({
                where: { user_id },
                orderBy: { logged_at: 'desc' },
                select: {
                    weight: true,
                    logged_at: true,
                },
            });
        });

        res.status(200).json({
            status: 'success',
            message: 'Weight history retrieved successfully',
            data: weightHistory,
        });
    } catch (error) {
        console.error('Error retrieving weight history:', error);

        // Check for specific database connection errors
        if (error.code && (
            error.code.includes('P2037') || // Prisma connection error
            error.message.includes('connection') ||
            error.message.includes('timeout')
        )) {
            return res.status(503).json({
                status: 'failure',
                message: 'Database connection issue. Please try again later.'
            });
        }

        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};