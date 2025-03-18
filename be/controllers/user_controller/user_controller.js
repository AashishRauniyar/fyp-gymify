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

        res.status(200).json({
            status: 'success',
            message: 'Users fetched successfully',
            data: users
        });
    } catch (error) {
        console.error('Error fetching users:', error);
        res.status(500).json({ error: 'Failed to fetch users' });
    }
}



// export const getActiveMembers = async (req, res) => {
//     const { user_id } = req.user; // Assuming you have user authentication middleware to get the logged-in user

//     try {
//         // Fetching active members by checking the membership status
//         const activeMembers = await prisma.memberships.findMany({
//             where: {
//                 status: 'Active',  // We are looking for members with 'Active' status
//             },
//             include: {
//                 users: {  // Joining the users table to get user details
//                     select: {
//                         user_id: true,
//                         user_name: true,
//                         role: true,
//                     },
//                 },
//             },
//         });

//         // Mapping through the active members and extracting user details
//         const users = activeMembers.map((membership) => membership.users);

//         res.status(200).json({
//             status: 'success',
//             message: 'Active members fetched successfully',
//             data: users, // Returning the user details of active members
//         });
//     } catch (error) {
//         console.error('Error fetching active members:', error);
//         res.status(500).json({ error: 'Failed to fetch active members' });
//     }
// }

export const getActiveMembers = async (req, res) => {
    const { user_id } = req.user; // Assuming you have user authentication middleware to get the logged-in user

    try {
        // Fetching active members by checking the membership status and role 'Member'
        const activeMembers = await prisma.memberships.findMany({
            where: {
                status: 'Active',  // Membership status is Active
            },
            include: {
                users: {  // Joining the users table to get user details
                    where: {
                        role: 'Member'  // Filter only users with 'Member' role
                    },
                    select: {
                        user_id: true,
                        user_name: true,
                        role: true,
                    },
                },
            },
        });

        // Filter out null values that could arise from missing users or other issues
        const users = activeMembers
            .map((membership) => membership.users)  // Extract users
            .filter((user) => user !== null);  // Filter out null entries

        res.status(200).json({
            status: 'success',
            message: 'Active members fetched successfully',
            data: users, // Returning the user details of active members
        });
    } catch (error) {
        console.error('Error fetching active members:', error);
        res.status(500).json({ error: 'Failed to fetch active members' });
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

        res.status(200).json({
            status: 'success',
            message: 'Trainers fetched successfully',
            data: trainers
        });
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

        res.status(200).json({
            status: 'success',
            message: 'Members fetched successfully',
            data: members
        });
    } catch (error) {
        console.error('Error fetching members:', error);
        res.status(500).json({ error: 'Failed to fetch members' });
    }
}


export const getUserById = async (req, res) => {

    try {
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

        res.status(200).json(
            {
                status: 'success',
                message: 'User fetched successfully',
                data: user
            }
        );
    } catch (error) {
        console.error('Error fetching users:', error);
        res.status(500).json({ error: 'Failed to fetch users' });

    }

}