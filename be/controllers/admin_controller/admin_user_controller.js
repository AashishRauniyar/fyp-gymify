import prisma from '../../prisma/prisma.js';

import bcrypt from 'bcryptjs';
import { uploadToCloudinary } from '../../middleware/cloudinaryMiddleware.js';



/**
 * Get all users for the admin panel
 * Retrieves a list of all users with basic information
 */
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

/**
 * Get a single user by ID
 * Retrieves detailed information about a specific user
 */
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
                fitness_level: true,
                goal_type: true,
                allergies: true,
                calorie_goals: true,
                current_weight: true,
                height: true,
                birthdate: true,
                gender: true,
                created_at: true,
                profile_image: true,
                verified: true
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

/**
 * Update user details
 * Allows admin to update user information
 */
export const updateUserForAdmin = async (req, res) => {
    const { id } = req.params;
    const { 
        full_name, 
        email, 
        phone_number, 
        role, 
        address, 
        fitness_level,
        goal_type,
        allergies,
        verified
    } = req.body;

    try {
        const updatedUser = await prisma.users.update({
            where: { user_id: parseInt(id) },
            data: { 
                full_name, 
                email, 
                phone_number, 
                role, 
                address, 
                fitness_level,
                goal_type,
                allergies,
                verified,
                updated_at: new Date()
            }
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

/**
 * Delete user
 * Permanently removes a user from the system
 */
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

/**
 * Get user membership details
 * Retrieves all membership information for a specific user
 */
export const getUserMembershipDetails = async (req, res) => {
    const { id } = req.params;
    try {
        const membershipDetails = await prisma.memberships.findMany({
            where: { user_id: parseInt(id) },
            include: {
                membership_plan: true,
                payments: true
            },
            orderBy: { created_at: 'desc' }
        });
        
        res.status(200).json({
            status: 'success',
            message: 'User membership details fetched successfully',
            data: membershipDetails
        });
    } catch (error) {
        console.error('Error fetching membership details:', error);
        res.status(500).json({ error: 'Failed to fetch membership details' });
    }
};

/**
 * Get user attendance history
 * Retrieves attendance records for a specific user with date filtering
 */
export const getUserAttendanceHistory = async (req, res) => {
    const { id } = req.params;
    const { startDate, endDate } = req.query;
    
    const dateFilter = {};
    if (startDate) dateFilter.gte = new Date(startDate);
    if (endDate) dateFilter.lte = new Date(endDate);
    
    try {
        const attendance = await prisma.attendance.findMany({
            where: { 
                user_id: parseInt(id),
                ...(startDate || endDate ? { attendance_date: dateFilter } : {})
            },
            orderBy: { attendance_date: 'desc' }
        });
        
        res.status(200).json({
            status: 'success',
            message: 'User attendance fetched successfully',
            data: attendance
        });
    } catch (error) {
        console.error('Error fetching attendance:', error);
        res.status(500).json({ error: 'Failed to fetch attendance records' });
    }
};

/**
 * Get user weight progress
 * Retrieves weight logs for a specific user
 */
export const getUserWeightProgress = async (req, res) => {
    const { id } = req.params;
    try {
        const weightLogs = await prisma.weight_logs.findMany({
            where: { user_id: parseInt(id) },
            orderBy: { logged_at: 'asc' }
        });
        
        res.status(200).json({
            status: 'success',
            message: 'Weight progress fetched successfully',
            data: weightLogs
        });
    } catch (error) {
        console.error('Error fetching weight logs:', error);
        res.status(500).json({ error: 'Failed to fetch weight logs' });
    }
};


// register a user by admin


// **
//  * Register a new user by admin
//  * Allows an admin to register new users directly into the system
//  */
export const registerUserByAdmin = async (req, res) => {
    try {
        const { 
            email, 
            password, 
            user_name, 
            full_name, 
            phone_number, 
            role, 
            address, 
            gender,
            birthdate,
            height,
            current_weight,
            fitness_level, 
            goal_type, 
            allergies,
            calorie_goals,
            card_number,
            profile_image
        } = req.body;

        // Check required fields
        if (!email || !password || !user_name) {
            return res.status(400).json({
                status: 'failure',
                message: 'Email, password, and username are required'
            });
        }

        // Check if email already exists
        const existingEmail = await prisma.users.findUnique({
            where: { email: email.toLowerCase() }
        });

        if (existingEmail) {
            return res.status(409).json({
                status: 'failure',
                message: 'Email already registered'
            });
        }

        // Check if username already exists
        const existingUsername = await prisma.users.findUnique({
            where: { user_name }
        });

        if (existingUsername) {
            return res.status(409).json({
                status: 'failure',
                message: 'Username already taken'
            });
        }

        // Check if phone number already exists (if provided)
        if (phone_number) {
            const existingPhone = await prisma.users.findUnique({
                where: { phone_number }
            });

            if (existingPhone) {
                return res.status(409).json({
                    status: 'failure',
                    message: 'Phone number already registered'
                });
            }
        }

        // Hash password
        const hashedPassword = await bcrypt.hash(password, 12);


        
                let profileImageUrl = null;
                if (req.file) {
                    try {
                        profileImageUrl = await uploadToCloudinary(req.file.buffer); // Pass the file buffer directly
                    } catch (error) {
                        console.error('Error uploading image:', error);
                        return res.status(500).json({ status: 'failure', message: 'Image upload failed' });
                    }
                }
        

        // Create new user
        const newUser = await prisma.users.create({
            data: {
                email: email.toLowerCase(),
                password: hashedPassword,
                user_name,
                full_name,
                phone_number,
                role: role || 'Member', // Default to Member if not specified
                address,
                gender,
                birthdate: birthdate ? new Date(birthdate) : null,
                height: height ? parseFloat(height) : null,
                current_weight: current_weight ? parseFloat(current_weight) : null,
                fitness_level,
                goal_type,
                allergies,
                calorie_goals: calorie_goals ? parseFloat(calorie_goals) : null,
                card_number,
                profile_image: profileImageUrl,
                verified: true // Users created by admin are automatically verified
            }
        });

        // Return success response with created user data
        res.status(201).json({
            status: 'success',
            message: 'User registered successfully',
            data: {
                user_id: newUser.user_id,
                email: newUser.email,
                user_name: newUser.user_name,
                role: newUser.role
            }
        });

    } catch (error) {
        console.error('Error registering user by admin:', error);
        res.status(500).json({
            status: 'failure',
            message: 'Server error',
            error: error.message
        });
    }
};