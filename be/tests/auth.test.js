import { register } from '../controllers/authController.js'; // Adjust path
import { jest } from '@jest/globals';
import bcrypt from 'bcryptjs';
import { uploadToCloudinary } from '../middleware/cloudinaryMiddleware.js';

// Mock Prisma Client
const mockPrismaClient = {
    users: {
        findUnique: jest.fn(),
        create: jest.fn(),
    },
};

jest.mock('@prisma/client', () => {
    return {
        PrismaClient: jest.fn(() => mockPrismaClient),
    };
});

// Mock bcryptjs
jest.mock('bcryptjs', () => ({
    hash: jest.fn(() => Promise.resolve('hashedPassword')), // Mock bcrypt.hash
}));

// Mock Cloudinary Middleware
jest.mock('../middleware/cloudinaryMiddleware.js', () => ({
    uploadToCloudinary: jest.fn(() => Promise.resolve('mockImageUrl')), // Mock Cloudinary upload
}));

describe('Register Function', () => {
    let req, res;

    beforeEach(() => {
        req = {
            body: {
                user_name: 'testuser',
                full_name: 'Test User',
                email: 'testagain@example.com',
                password: 'password123',
                phone_number: '1234567890',
                address: '123 Test St',
                gender: 'Male',
                role: 'Member',
                fitness_level: 'Intermediate',
                goal_type: 'Weight Loss',
                age: 25,
                height: 170,
                current_weight: 70,
            },
            file: {
                buffer: Buffer.from('mock file'),
            },
        };

        res = {
            status: jest.fn().mockReturnThis(),
            json: jest.fn(),
        };

        jest.clearAllMocks();
    });

    it('should register a new user successfully', async () => {
        mockPrismaClient.users.findUnique.mockResolvedValue(null); // No existing user
        mockPrismaClient.users.create.mockResolvedValue({
            user_id: 1,
            user_name: 'testuser',
            email: 'test@example.com',
            role: 'Member',
            full_name: 'Test User',
            profile_image: 'mockImageUrl',
        });

        await register(req, res);

        expect(mockPrismaClient.users.findUnique).toHaveBeenCalledTimes(2);
        expect(mockPrismaClient.users.findUnique).toHaveBeenCalledWith({
            where: { email: 'test@example.com' },
        });
        expect(bcrypt.hash).toHaveBeenCalledWith('password123', 10);
        expect(uploadToCloudinary).toHaveBeenCalledWith(req.file.buffer);
        expect(mockPrismaClient.users.create).toHaveBeenCalledWith({
            data: expect.objectContaining({
                user_name: 'testuser',
                email: 'test@example.com',
                password: 'hashedPassword',
            }),
        });
        expect(res.status).toHaveBeenCalledWith(201);
        expect(res.json).toHaveBeenCalledWith({
            status: 'success',
            message: 'User registered successfully',
            user: expect.objectContaining({
                user_id: 1,
                user_name: 'testuser',
                email: 'test@example.com',
            }),
        });
    });

    it('should return an error if email already exists', async () => {
        mockPrismaClient.users.findUnique.mockResolvedValue({ email: 'test@example.com' }); // Existing user

        await register(req, res);

        expect(mockPrismaClient.users.findUnique).toHaveBeenCalledWith({
            where: { email: 'test@example.com' },
        });
        expect(res.status).toHaveBeenCalledWith(400);
        expect(res.json).toHaveBeenCalledWith({
            status: 'failure',
            message: 'User with this email already exists',
        });
    });

    it('should handle validation errors for missing fields', async () => {
        req.body.email = ''; // Missing email

        await register(req, res);

        expect(res.status).toHaveBeenCalledWith(400);
        expect(res.json).toHaveBeenCalledWith({
            status: 'failure',
            message: 'Missing required fields',
        });
    });
});
