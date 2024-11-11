import bcrypt from 'bcryptjs';
import { PrismaClient } from '@prisma/client';
import generateToken from '../utils/generateToken.js';

const prisma = new PrismaClient();

// Register a new user
export const register = async (req, res) => {
    const {
        user_name,
        full_name,
        email,
        password,
        phone_number,
        address,
        age,
        height,
        current_weight,
        gender,
        role,
        fitness_level,
        goal_type,
        card_number
    } = req.body;

    // Log the request body for debugging
    console.log('Request Body:', req.body);

    // Validate required fields
    if (!email || !password || !user_name || !full_name || !phone_number || !gender || !role || !fitness_level || !goal_type) {
        return res.status(400).json({ message: 'Missing required fields' });
    }

    try {
        // Check if the user already exists by email or phone number
        const existingUser = await prisma.users.findUnique({
            where: { email },
        });

        if (existingUser) {
            return res.status(400).json({ message: 'User with this email already exists' });
        }

        const existingPhoneNumber = await prisma.users.findUnique({
            where: { phone_number },
        });

        if (existingPhoneNumber) {
            return res.status(400).json({ message: 'User with this phone number already exists' });
        }

        // Hash the password
        const hashedPassword = await bcrypt.hash(password, 10);

        // Create a new user with all fields
        const user = await prisma.users.create({
            data: {
                user_name,
                full_name,
                email,
                password: hashedPassword,
                phone_number,
                address,
                age,
                height,
                current_weight,
                gender,
                role,
                fitness_level,
                goal_type,
                card_number,
                created_at: new Date(),
                updated_at: new Date()
            }
        });

        // Generate a JWT token
        const token = generateToken(user.user_id);

        res.status(201).json({
            message: 'User registered successfully',
            user: {
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
        console.error('Error during registration:', error);
        res.status(500).json({ message: 'Server error' });
    }
};
