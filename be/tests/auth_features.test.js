import { verifyOTP, resendOTP, forgotPassword, resetPassword, checkEmailExists, checkUsername, checkPhoneNumber, completeRegistration } from '../controllers/auth_controller/authController.js';
import { jest } from '@jest/globals';
import request from 'supertest';
import { app } from '../index.js';

// Mock Prisma Client
const mockPrismaClient = {
    users: {
        findUnique: jest.fn(),
        create: jest.fn(),
        update: jest.fn(),
        delete: jest.fn(),
    },
};

jest.mock('@prisma/client', () => {
    return {
        PrismaClient: jest.fn(() => mockPrismaClient),
    };
});

// Mock bcryptjs
jest.mock('bcryptjs', () => {
    return {
        hash: jest.fn(() => Promise.resolve('hashedPassword')),
        compare: jest.fn(() => Promise.resolve(true)),
    };
});

// Import mocked modules to access their mock functions
import bcrypt from 'bcryptjs';

// Mock sendMail utilities
jest.mock('../utils/sendMail.js', () => {
    return {
        sendOTPEmail: jest.fn(() => Promise.resolve(true)),
        sendRegistrationOTPEmail: jest.fn(() => Promise.resolve(true)),
        sendWelcomeEmail: jest.fn(() => Promise.resolve(true)),
    };
});

import * as sendMailModule from '../utils/sendMail.js';
// Import mocked mail functions to access their mock functions

// Mock Cloudinary Middleware
jest.mock('../middleware/cloudinaryMiddleware.js', () => {
    return {
        uploadToCloudinary: jest.fn(() => Promise.resolve('mockImageUrl')),
    };
});

// Import mocked cloudinary function to access its mock function
import * as cloudinaryModule from '../middleware/cloudinaryMiddleware.js';

// Mock crypto for OTP generation
jest.mock('crypto', () => ({
    randomInt: jest.fn(() => 123456),
}));

describe('OTP Verification Functions', () => {
    let req, res;

    beforeEach(() => {
        req = {
            body: {
                email: 'test@example.com',
                otp: '123456',
            }
        };

        res = {
            status: jest.fn().mockReturnThis(),
            json: jest.fn(),
        };

        jest.clearAllMocks();
    });

    describe('verifyOTP Function', () => {
        it('should verify OTP successfully', async () => {
            // Mock valid user with matching OTP
            mockPrismaClient.users.findUnique.mockResolvedValue({
                email: 'test@example.com',
                otp: '123456',
                otp_expiry: new Date(Date.now() + 10 * 60 * 1000), // 10 minutes in the future
                verified: false,
            });

            await verifyOTP(req, res);

            expect(mockPrismaClient.users.findUnique).toHaveBeenCalledWith({
                where: { email: 'test@example.com' }
            });
            expect(mockPrismaClient.users.update).toHaveBeenCalledWith({
                where: { email: 'test@example.com' },
                data: {
                    verified: true,
                    otp: null,
                    otp_expiry: null
                }
            });
            expect(res.status).toHaveBeenCalledWith(200);
            expect(res.json).toHaveBeenCalledWith({
                status: 'success',
                message: 'Email verified successfully'
            });
        });

        it('should return error for missing email or OTP', async () => {
            req.body = { email: 'test@example.com' }; // Missing OTP

            await verifyOTP(req, res);

            expect(res.status).toHaveBeenCalledWith(400);
            expect(res.json).toHaveBeenCalledWith({
                status: 'failure',
                message: 'Email and OTP are required'
            });
        });

        it('should return error for user not found', async () => {
            mockPrismaClient.users.findUnique.mockResolvedValue(null);

            await verifyOTP(req, res);

            expect(res.status).toHaveBeenCalledWith(404);
            expect(res.json).toHaveBeenCalledWith({
                status: 'failure',
                message: 'User not found'
            });
        });

        it('should return error for already verified email', async () => {
            mockPrismaClient.users.findUnique.mockResolvedValue({
                email: 'test@example.com',
                verified: true,
            });

            await verifyOTP(req, res);

            expect(res.status).toHaveBeenCalledWith(400);
            expect(res.json).toHaveBeenCalledWith({
                status: 'failure',
                message: 'Email already verified'
            });
        });

        it('should return error for expired OTP', async () => {
            mockPrismaClient.users.findUnique.mockResolvedValue({
                email: 'test@example.com',
                otp: '123456',
                otp_expiry: new Date(Date.now() - 1000), // 1 second in the past
                verified: false,
            });

            await verifyOTP(req, res);

            expect(res.status).toHaveBeenCalledWith(400);
            expect(res.json).toHaveBeenCalledWith({
                status: 'failure',
                message: 'OTP has expired'
            });
        });

        it('should return error for invalid OTP', async () => {
            mockPrismaClient.users.findUnique.mockResolvedValue({
                email: 'test@example.com',
                otp: '654321', // Different OTP
                otp_expiry: new Date(Date.now() + 10 * 60 * 1000), // 10 minutes in the future
                verified: false,
            });

            await verifyOTP(req, res);

            expect(res.status).toHaveBeenCalledWith(400);
            expect(res.json).toHaveBeenCalledWith({
                status: 'failure',
                message: 'Invalid OTP'
            });
        });
    });

    describe('resendOTP Function', () => {
        beforeEach(() => {
            req = {
                body: {
                    email: 'test@example.com'
                }
            };
        });

        it('should resend OTP successfully', async () => {
            mockPrismaClient.users.findUnique.mockResolvedValue({
                email: 'test@example.com',
                verified: false,
            });

            sendMailModule.sendRegistrationOTPEmail.mockResolvedValue(true);

            await resendOTP(req, res);

            expect(mockPrismaClient.users.findUnique).toHaveBeenCalledWith({
                where: { email: 'test@example.com' }
            });
            expect(mockPrismaClient.users.update).toHaveBeenCalledWith({
                where: { email: 'test@example.com' },
                data: expect.objectContaining({
                    otp: expect.any(String),
                    otp_expiry: expect.any(Date)
                })
            });
            expect(sendMailModule.sendRegistrationOTPEmail).toHaveBeenCalled();
            expect(res.status).toHaveBeenCalledWith(200);
            expect(res.json).toHaveBeenCalledWith({
                status: 'success',
                message: 'OTP resent successfully'
            });
        });

        it('should return error for missing email', async () => {
            req.body = {};

            await resendOTP(req, res);

            expect(res.status).toHaveBeenCalledWith(400);
            expect(res.json).toHaveBeenCalledWith({
                status: 'failure',
                message: 'Email is required'
            });
        });

        it('should return error if user not found', async () => {
            mockPrismaClient.users.findUnique.mockResolvedValue(null);

            await resendOTP(req, res);

            expect(res.status).toHaveBeenCalledWith(404);
            expect(res.json).toHaveBeenCalledWith({
                status: 'failure',
                message: 'User not found'
            });
        });

        it('should return error if email already verified', async () => {
            mockPrismaClient.users.findUnique.mockResolvedValue({
                email: 'test@example.com',
                verified: true,
            });

            await resendOTP(req, res);

            expect(res.status).toHaveBeenCalledWith(400);
            expect(res.json).toHaveBeenCalledWith({
                status: 'failure',
                message: 'Email already verified'
            });
        });

        it('should handle email sending error', async () => {
            mockPrismaClient.users.findUnique.mockResolvedValue({
                email: 'test@example.com',
                verified: false,
            });

            sendMailModule.sendRegistrationOTPEmail.mockResolvedValueOnce(false);

            await resendOTP(req, res);

            expect(res.status).toHaveBeenCalledWith(500);
            expect(res.json).toHaveBeenCalledWith({
                status: 'failure',
                message: 'Failed to send OTP email'
            });
        });
    });
});

describe('Password Reset Functions', () => {
    let req, res;

    beforeEach(() => {
        req = {
            body: {}
        };

        res = {
            status: jest.fn().mockReturnThis(),
            json: jest.fn(),
        };

        jest.clearAllMocks();
    });

    describe('forgotPassword Function', () => {
        beforeEach(() => {
            req.body = {
                email: 'test@example.com'
            };
        });

        it('should send forgot password OTP successfully', async () => {
            mockPrismaClient.users.findUnique.mockResolvedValue({
                email: 'test@example.com'
            });

            sendMailModule.sendOTPEmail.mockResolvedValue(true);

            await forgotPassword(req, res);

            expect(mockPrismaClient.users.findUnique).toHaveBeenCalledWith({
                where: { email: 'test@example.com' }
            });
            expect(mockPrismaClient.users.update).toHaveBeenCalledWith({
                where: { email: 'test@example.com' },
                data: expect.objectContaining({
                    otp: expect.any(String),
                    otp_expiry: expect.any(Date)
                })
            });
            expect(sendMailModule.sendOTPEmail).toHaveBeenCalled();
            expect(res.status).toHaveBeenCalledWith(200);
            expect(res.json).toHaveBeenCalledWith({
                status: 'success',
                message: 'OTP sent to your email for password reset'
            });
        });

        it('should return error for missing email', async () => {
            req.body = {};

            await forgotPassword(req, res);

            expect(res.status).toHaveBeenCalledWith(400);
            expect(res.json).toHaveBeenCalledWith({
                status: 'failure',
                message: 'Email is required'
            });
        });

        it('should return error if user not found', async () => {
            mockPrismaClient.users.findUnique.mockResolvedValue(null);

            await forgotPassword(req, res);

            expect(res.status).toHaveBeenCalledWith(404);
            expect(res.json).toHaveBeenCalledWith({
                status: 'failure',
                message: 'User not found'
            });
        });

        it('should handle error if email sending fails', async () => {
            mockPrismaClient.users.findUnique.mockResolvedValue({
                email: 'test@example.com'
            });

            sendMailModule.sendOTPEmail.mockResolvedValueOnce(false);

            await forgotPassword(req, res);

            expect(res.status).toHaveBeenCalledWith(500);
            expect(res.json).toHaveBeenCalledWith({
                status: 'failure',
                message: 'Failed to send OTP email'
            });
        });
    });

    describe('resetPassword Function', () => {
        beforeEach(() => {
            req.body = {
                email: 'test@example.com',
                otp: '123456',
                newPassword: 'NewPassword123!'
            };
        });

        it('should reset password successfully', async () => {
            mockPrismaClient.users.findUnique.mockResolvedValue({
                email: 'test@example.com',
                otp: '123456',
                otp_expiry: new Date(Date.now() + 10 * 60 * 1000) // 10 minutes in the future
            });

            await resetPassword(req, res);

            expect(mockPrismaClient.users.findUnique).toHaveBeenCalledWith({
                where: { email: 'test@example.com' }
            });
            expect(bcrypt.hash).toHaveBeenCalledWith('NewPassword123!', 12);
            expect(mockPrismaClient.users.update).toHaveBeenCalledWith({
                where: { email: 'test@example.com' },
                data: {
                    password: 'hashedPassword',
                    otp: null,
                    otp_expiry: null
                }
            });
            expect(res.status).toHaveBeenCalledWith(200);
            expect(res.json).toHaveBeenCalledWith({
                status: 'success',
                message: 'Password reset successfully'
            });
        });

        it('should return error for missing required fields', async () => {
            req.body = { email: 'test@example.com', otp: '123456' }; // Missing newPassword

            await resetPassword(req, res);

            expect(res.status).toHaveBeenCalledWith(400);
            expect(res.json).toHaveBeenCalledWith({
                status: 'failure',
                message: 'Email, OTP, and new password are required'
            });
        });

        it('should return error if user not found', async () => {
            mockPrismaClient.users.findUnique.mockResolvedValue(null);

            await resetPassword(req, res);

            expect(res.status).toHaveBeenCalledWith(404);
            expect(res.json).toHaveBeenCalledWith({
                status: 'failure',
                message: 'User not found'
            });
        });

        it('should return error if no OTP request found', async () => {
            mockPrismaClient.users.findUnique.mockResolvedValue({
                email: 'test@example.com',
                otp: null,
                otp_expiry: null
            });

            await resetPassword(req, res);

            expect(res.status).toHaveBeenCalledWith(400);
            expect(res.json).toHaveBeenCalledWith({
                status: 'failure',
                message: 'No OTP request found'
            });
        });

        it('should return error if OTP has expired', async () => {
            mockPrismaClient.users.findUnique.mockResolvedValue({
                email: 'test@example.com',
                otp: '123456',
                otp_expiry: new Date(Date.now() - 1000) // 1 second in the past
            });

            await resetPassword(req, res);

            expect(res.status).toHaveBeenCalledWith(400);
            expect(res.json).toHaveBeenCalledWith({
                status: 'failure',
                message: 'OTP has expired'
            });
        });

        it('should return error if OTP is invalid', async () => {
            mockPrismaClient.users.findUnique.mockResolvedValue({
                email: 'test@example.com',
                otp: '654321', // Different OTP
                otp_expiry: new Date(Date.now() + 10 * 60 * 1000) // 10 minutes in the future
            });

            await resetPassword(req, res);

            expect(res.status).toHaveBeenCalledWith(400);
            expect(res.json).toHaveBeenCalledWith({
                status: 'failure',
                message: 'Invalid OTP'
            });
        });

        it('should return error if password does not meet requirements', async () => {
            mockPrismaClient.users.findUnique.mockResolvedValue({
                email: 'test@example.com',
                otp: '123456',
                otp_expiry: new Date(Date.now() + 10 * 60 * 1000) // 10 minutes in the future
            });

            req.body.newPassword = 'password'; // Weak password

            await resetPassword(req, res);

            expect(res.status).toHaveBeenCalledWith(400);
            expect(res.json).toHaveBeenCalledWith({
                status: 'failure',
                message: 'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character'
            });
        });
    });
});

describe('User Information Validation', () => {
    let req, res;

    beforeEach(() => {
        req = {
            body: {}
        };

        res = {
            status: jest.fn().mockReturnThis(),
            json: jest.fn(),
        };

        jest.clearAllMocks();
    });

    describe('checkEmailExists Function', () => {
        beforeEach(() => {
            req.body = {
                email: 'test@example.com'
            };
        });

        it('should return success if email is available', async () => {
            mockPrismaClient.users.findUnique.mockResolvedValue(null);

            await checkEmailExists(req, res);

            expect(res.status).toHaveBeenCalledWith(200);
            expect(res.json).toHaveBeenCalledWith({
                status: 'success',
                exists: false,
                message: 'Email is available'
            });
        });

        it('should return info for verified email', async () => {
            mockPrismaClient.users.findUnique.mockResolvedValue({
                email: 'test@example.com',
                verified: true
            });

            await checkEmailExists(req, res);

            expect(res.status).toHaveBeenCalledWith(200);
            expect(res.json).toHaveBeenCalledWith({
                status: 'success',
                exists: true,
                verified: true,
                message: 'Email is already registered and verified'
            });
        });

        it('should return info for unverified email', async () => {
            mockPrismaClient.users.findUnique.mockResolvedValue({
                email: 'test@example.com',
                verified: false
            });

            await checkEmailExists(req, res);

            expect(res.status).toHaveBeenCalledWith(200);
            expect(res.json).toHaveBeenCalledWith({
                status: 'success',
                exists: true,
                verified: false,
                message: 'Email is registered but not verified'
            });
        });

        it('should return error for invalid email format', async () => {
            req.body = { email: 'invalid-email' };

            await checkEmailExists(req, res);

            expect(res.status).toHaveBeenCalledWith(400);
            expect(res.json).toHaveBeenCalledWith({
                status: 'failure',
                message: 'Invalid email format'
            });
        });

        it('should return error if email is missing', async () => {
            req.body = {};

            await checkEmailExists(req, res);

            expect(res.status).toHaveBeenCalledWith(400);
            expect(res.json).toHaveBeenCalledWith({
                status: 'failure',
                message: 'Email is required'
            });
        });
    });

    describe('checkUsername Function', () => {
        beforeEach(() => {
            req.body = {
                user_name: 'testuser'
            };
        });

        it('should return success if username is available', async () => {
            mockPrismaClient.users.findUnique.mockResolvedValue(null);

            await checkUsername(req, res);

            expect(mockPrismaClient.users.findUnique).toHaveBeenCalledWith({
                where: { user_name: 'testuser' }
            });
            expect(res.status).toHaveBeenCalledWith(200);
            expect(res.json).toHaveBeenCalledWith({
                status: 'success',
                message: 'User with this user name does not exist'
            });
        });

        it('should return failure if username already exists', async () => {
            mockPrismaClient.users.findUnique.mockResolvedValue({
                user_name: 'testuser'
            });

            await checkUsername(req, res);

            expect(res.status).toHaveBeenCalledWith(200);
            expect(res.json).toHaveBeenCalledWith({
                status: 'failure',
                message: 'User with this user name already exists'
            });
        });
    });

    describe('checkPhoneNumber Function', () => {
        beforeEach(() => {
            req.body = {
                phone_number: '1234567890'
            };
        });

        it('should return success if phone number is available', async () => {
            mockPrismaClient.users.findUnique.mockResolvedValue(null);

            await checkPhoneNumber(req, res);

            expect(mockPrismaClient.users.findUnique).toHaveBeenCalledWith({
                where: { phone_number: '1234567890' }
            });
            expect(res.status).toHaveBeenCalledWith(200);
            expect(res.json).toHaveBeenCalledWith({
                status: 'success',
                message: 'User with this phone number does not exist'
            });
        });

        it('should return failure if phone number already exists', async () => {
            mockPrismaClient.users.findUnique.mockResolvedValue({
                phone_number: '1234567890'
            });

            await checkPhoneNumber(req, res);

            expect(res.status).toHaveBeenCalledWith(200);
            expect(res.json).toHaveBeenCalledWith({
                status: 'failure',
                message: 'User with this phone number already exists'
            });
        });
    });
});

describe('Profile Completion', () => {
    let req, res;

    beforeEach(() => {
        req = {
            body: {
                email: 'test@example.com',
                user_name: 'testuser',
                full_name: 'Test User',
                phone_number: '1234567890',
                address: '123 Test St',
                gender: 'Male',
                birthdate: '1990-01-01',
                height: 170,
                current_weight: 70,
                fitness_level: 'Intermediate',
                goal_type: 'Weight_Loss',
                allergies: 'None',
                calorie_goals: 2000,
                card_number: '1234567890'
            },
            file: {
                buffer: Buffer.from('mock image data')
            }
        };

        res = {
            status: jest.fn().mockReturnThis(),
            json: jest.fn(),
        };

        jest.clearAllMocks();
    });

    it('should complete user registration successfully', async () => {
        mockPrismaClient.users.findUnique
            .mockResolvedValueOnce({
                user_id: 1,
                email: 'test@example.com',
                role: 'Member',
                profile_image: null
            })
            .mockResolvedValueOnce(null)  // username check
            .mockResolvedValueOnce(null);  // phone check

        mockPrismaClient.users.update.mockResolvedValue({
            user_id: 1,
            user_name: 'testuser',
            email: 'test@example.com',
            role: 'Member',
            full_name: 'Test User'
        });

        cloudinaryModule.uploadToCloudinary.mockResolvedValue('mockImageUrl');

        await completeRegistration(req, res);

        expect(mockPrismaClient.users.findUnique).toHaveBeenCalledWith({
            where: { email: 'test@example.com' }
        });
        expect(cloudinaryModule.uploadToCloudinary).toHaveBeenCalledWith(req.file.buffer);
        expect(mockPrismaClient.users.update).toHaveBeenCalledWith({
            where: { email: 'test@example.com' },
            data: expect.objectContaining({
                user_name: 'testuser',
                full_name: 'Test User',
                phone_number: '1234567890',
                profile_image: 'mockImageUrl'
            })
        });
        expect(res.status).toHaveBeenCalledWith(200);
        expect(res.json).toHaveBeenCalledWith({
            status: 'success',
            message: 'Registration completed',
            data: expect.objectContaining({
                user_id: 1,
                user_name: 'testuser',
                email: 'test@example.com'
            })
        });
    });

    it('should return error if user not found', async () => {
        mockPrismaClient.users.findUnique.mockResolvedValue(null);

        await completeRegistration(req, res);

        expect(res.status).toHaveBeenCalledWith(400);
        expect(res.json).toHaveBeenCalledWith({
            status: 'failure',
            message: 'User not found'
        });
    });

    it('should return error if username already exists', async () => {
        mockPrismaClient.users.findUnique
            .mockResolvedValueOnce({
                user_id: 1,
                email: 'test@example.com'
            })
            .mockResolvedValueOnce({
                user_id: 2,
                user_name: 'testuser'
            });

        await completeRegistration(req, res);

        expect(res.status).toHaveBeenCalledWith(400);
        expect(res.json).toHaveBeenCalledWith({
            status: 'failure',
            message: 'Username already exists'
        });
    });

    it('should return error if phone number already exists', async () => {
        mockPrismaClient.users.findUnique
            .mockResolvedValueOnce({
                user_id: 1,
                email: 'test@example.com'
            })
            .mockResolvedValueOnce(null)
            .mockResolvedValueOnce({
                user_id: 2,
                phone_number: '1234567890'
            });

        await completeRegistration(req, res);

        expect(res.status).toHaveBeenCalledWith(400);
        expect(res.json).toHaveBeenCalledWith({
            status: 'failure',
            message: 'Phone number already exists'
        });
    });

    it('should handle image upload failure', async () => {
        mockPrismaClient.users.findUnique
            .mockResolvedValueOnce({
                user_id: 1,
                email: 'test@example.com'
            })
            .mockResolvedValueOnce(null)
            .mockResolvedValueOnce(null);

        cloudinaryModule.uploadToCloudinary.mockRejectedValueOnce(new Error('Upload failed'));

        await completeRegistration(req, res);

        expect(res.status).toHaveBeenCalledWith(500);
        expect(res.json).toHaveBeenCalledWith({
            status: 'failure',
            message: 'Image upload failed'
        });
    });
});