import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

// Get all users
export const getAllUsers = async (req, res) => {
    const { user_id } = req.user;

    try {
        const users = await prisma.users.findMany({
            select: {
                user_id: true,
                user_name: true,
                role: true,
            }
        });

        res.status(200).json(users);
    } catch (error) {
        console.error('Error fetching users:', error);
        res.status(500).json({ error: 'Failed to fetch users' });
    }
}

// Get all trainers
export const getAllTrainers = async (req, res) => {
    const { user_id, role } = req.user;

    try {
        const trainers = await prisma.users.findMany({
            where: {
                role: 'Trainer',
            },
            select: {
                user_id: true,
                user_name: true,
                role: true,
            }
        });

        res.status(200).json(trainers);
    } catch (error) {
        console.error('Error fetching trainers:', error);
        res.status(500).json({ error: 'Failed to fetch trainers' });
    }
}


export const getAllMembers = async (req, res) => {
    const { user_id, role } = req.user;

    try {
        const members = await prisma.users.findMany({
            where: {
                role: 'Member',
            },
            select: {
                user_id: true,
                user_name: true,
                role: true,
            }
        });

        res.status(200).json(members);
    } catch (error) {
        console.error('Error fetching members:', error);
        res.status(500).json({ error: 'Failed to fetch members' });
    }
}


export const getUserById = async (req, res) => {

    try 
    {
        const userId = parseInt(req.params.id);

        const user = await prisma.users.findUnique({
            where: { user_id: userId },
            select: {
                user_id: true,
                user_name: true,
                role: true,
                created_at: true,
                updated_at: true
            }
        });

        res.status(200).json(user);
    } catch (error) {
        console.error('Error fetching users:', error);
        res.status(500).json({ error: 'Failed to fetch users' });
        
    }

}