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
        return res.status(400).json({ status: 'failure', message: 'Missing required fields' });
    }

    // Additional validation
    if (!validateEmail(email)) {
        return res.status(400).json({ status: 'failure', message: 'Invalid email format' });
    }

    if (typeof age !== 'number' || age < 0 || age > 120) {
        return res.status(400).json({ status: 'failure', message: 'Invalid age' });
    }

    if (typeof height !== 'number' || height <= 0) {
        return res.status(400).json({ status: 'failure', message: 'Invalid height' });
    }

    if (typeof current_weight !== 'number' || current_weight <= 0) {
        return res.status(400).json({ status: 'failure', message: 'Invalid weight' });
    }

    if (!/^\d{10}$/.test(phone_number)) {
        return res.status(400).json({ status: 'failure', message: 'Invalid phone number' });
    }

    if (password.length < 8) {
        return res.status(400).json({ status: 'failure', message: 'Password must be at least 8 characters long' });
    }

    if (!['Male', 'Female', 'Other'].includes(gender)) {
        return res.status(400).json({ status: 'failure', message: 'Invalid gender' });
    }

    if (!['Member', 'Trainer', 'Admin'].includes(role)) {
        return res.status(400).json({ status: 'failure', message: 'Invalid role' });
    }

    try {
        // Check if the user already exists by email or phone number
        const existingUser = await prisma.users.findUnique({ where: { email } });
        if (existingUser) {
            return res.status(400).json({ status: 'failure', message: 'User with this email already exists' });
        }

        const existingPhoneNumber = await prisma.users.findUnique({ where: { phone_number } });
        if (existingPhoneNumber) {
            return res.status(400).json({ status: 'failure', message: 'User with this phone number already exists' });
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
            status: 'success',
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
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};

// Utility function to validate email format
const validateEmail = (email) => {
    const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return regex.test(email);
};


// Login a user
// User login


export const login = async (req, res) => {
    try {
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
        console.error('Error during login:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};
