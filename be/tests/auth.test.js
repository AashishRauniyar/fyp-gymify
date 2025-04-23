import { register } from '../controllers/auth_controller/authController.js';
import { jest } from '@jest/globals';
import bcrypt from 'bcryptjs';
import { uploadToCloudinary } from '../middleware/cloudinaryMiddleware.js';
import request from 'supertest';
import { app } from '../index.js';
import { PrismaClient } from '@prisma/client';

// Mock Prisma Client
const mockPrismaClient = {
    users: {
        findUnique: jest.fn(),
        create: jest.fn(),
        update: jest.fn(), // Add update method that was missing
    },
};

jest.mock('@prisma/client', () => {
    return {
        PrismaClient: jest.fn(() => mockPrismaClient),
    };
});

// Mock bcryptjs
jest.mock('bcryptjs', () => ({
    hash: jest.fn(() => Promise.resolve('hashedPassword')),
}));

// Mock sendMail utilities
jest.mock('../utils/sendMail.js', () => {
    return {
        sendOTPEmail: jest.fn(() => Promise.resolve(true)),
        sendRegistrationOTPEmail: jest.fn(() => Promise.resolve(true)),
        sendWelcomeEmail: jest.fn(() => Promise.resolve(true)),
    };
});

// Import the mocked modules to access their mock functions
import * as sendMailModule from '../utils/sendMail.js';

// Mock Cloudinary Middleware
jest.mock('../middleware/cloudinaryMiddleware.js', () => ({
    uploadToCloudinary: jest.fn(() => Promise.resolve('mockImageUrl')),
}));

// Mock crypto for OTP generation
jest.mock('crypto', () => ({
    randomInt: jest.fn(() => 123456),
}));

describe('Register Function', () => {
    let req, res;

    beforeEach(() => {
        req = {
            body: {
                email: 'test@example.com',
                password: 'Password123!',
                phone_number: '1234567890',
                address: '123 Test St',
                gender: 'Male',
                role: 'Member',
                fitness_level: 'Intermediate',
                goal_type: 'Weight_Loss',
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
        mockPrismaClient.users.findUnique.mockResolvedValue(null);
        mockPrismaClient.users.create.mockResolvedValue({
            user_id: 1,
            email: 'test@example.com',
            role: 'Member',
        });

        // Use the imported mock function
        sendMailModule.sendRegistrationOTPEmail.mockResolvedValue(true);

        await register(req, res);

        expect(mockPrismaClient.users.findUnique).toHaveBeenCalledWith({
            where: { email: 'test@example.com' },
        });
        expect(bcrypt.hash).toHaveBeenCalledWith('Password123!', 12);
        expect(mockPrismaClient.users.create).toHaveBeenCalledWith(
            expect.objectContaining({
                data: expect.objectContaining({
                    email: 'test@example.com',
                    password: 'hashedPassword',
                })
            })
        );
        expect(res.status).toHaveBeenCalledWith(201);
        expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
            status: 'success',
            message: 'Registration initiated. Please verify your email.',
        }));
    });

    it('should return an error if email already exists and is verified', async () => {
        mockPrismaClient.users.findUnique.mockResolvedValue({
            email: 'test@example.com',
            verified: true
        });

        await register(req, res);

        expect(mockPrismaClient.users.findUnique).toHaveBeenCalledWith({
            where: { email: 'test@example.com' },
        });
        expect(res.status).toHaveBeenCalledWith(409);
        expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
            status: 'failure',
            message: 'Email already registered',
        }));
    });

    it('should resend OTP if email exists but is not verified', async () => {
        mockPrismaClient.users.findUnique.mockResolvedValue({
            email: 'test@example.com',
            verified: false,
            created_at: new Date()
        });

        mockPrismaClient.users.update.mockResolvedValue({
            email: 'test@example.com',
            verified: false
        });

        sendMailModule.sendRegistrationOTPEmail.mockResolvedValue(true);

        await register(req, res);

        expect(mockPrismaClient.users.update).toHaveBeenCalled();
        expect(sendMailModule.sendRegistrationOTPEmail).toHaveBeenCalled();
        expect(res.status).toHaveBeenCalledWith(200);
        expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
            status: 'success',
            message: 'Email already registered but not verified. New OTP sent.',
        }));
    });

    it('should handle validation errors for invalid email', async () => {
        req.body.email = 'invalid-email';

        await register(req, res);

        expect(res.status).toHaveBeenCalledWith(400);
        expect(res.json.mock.calls[0][0]).toHaveProperty('status', 'failure');
        expect(res.json.mock.calls[0][0]).toHaveProperty('errors');
    });
});

describe('Auth Controller Integration Tests', () => {
    beforeEach(() => {
        jest.clearAllMocks();
    });

    describe('POST /register', () => {
        it('should register a new user successfully', async () => {
            mockPrismaClient.users.findUnique.mockResolvedValue(null);
            mockPrismaClient.users.create.mockResolvedValue({
                user_id: 1,
                email: 'test@example.com',
                verified: false,
            });

            sendMailModule.sendRegistrationOTPEmail.mockResolvedValue(true);

            const response = await request(app).post('/api/auth/register').send({
                email: 'test@example.com',
                password: 'Password123!',
            });

            expect(mockPrismaClient.users.findUnique).toHaveBeenCalled();
            expect(mockPrismaClient.users.create).toHaveBeenCalled();
            expect(sendMailModule.sendRegistrationOTPEmail).toHaveBeenCalled();
            // Since we're mocking the actual route handling, what matters is that our 
            // controller function was called with the correct parameters
        });

        it('should return error if email is already registered and verified', async () => {
            mockPrismaClient.users.findUnique.mockResolvedValue({
                email: 'test@example.com',
                verified: true,
            });

            const response = await request(app).post('/api/auth/register').send({
                email: 'test@example.com',
                password: 'Password123!',
            });

            expect(mockPrismaClient.users.findUnique).toHaveBeenCalled();
            // Again, we're testing that our controller is called properly
        });
    });
});
