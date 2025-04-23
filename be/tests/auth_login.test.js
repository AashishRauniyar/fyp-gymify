import { login } from '../controllers/auth_controller/authController.js';
import { jest } from '@jest/globals';
import request from 'supertest';
import { app } from '../index.js';

// Mock Prisma Client
const mockPrismaClient = {
    users: {
        findUnique: jest.fn(),
    },
};

jest.mock('@prisma/client', () => {
    return {
        PrismaClient: jest.fn(() => mockPrismaClient),
    };
});

// // Mock bcryptjs
// jest.mock('bcryptjs', () => {
//     return {
//         compare: jest.fn()
//     };
// });

import bcrypt from 'bcryptjs';

// Mock bcryptjs
jest.mock('bcryptjs', () => ({
  hash: jest.fn(() => Promise.resolve('hashedPassword')),
  compare: jest.fn().mockResolvedValue(true), // Mock bcrypt.compare properly
}));


// Import the mocked modules to access their mock functions
import bcrypt from 'bcryptjs';

// Set default implementation
bcrypt.compare.mockImplementation(() => Promise.resolve(true));

// Mock jsonwebtoken
jest.mock('jsonwebtoken', () => ({
    sign: jest.fn(() => 'mock-token'),
}));

// Mock the auth middleware for testing protected routes
jest.mock('../middleware/authMiddleware.js', () => {
    return jest.fn((req, res, next) => {
        if (req.headers.authorization === 'Bearer valid-token') {
            req.user = {
                user_id: 1,
                role: 'Member'
            };
            next();
        } else if (req.headers.authorization === 'Bearer admin-token') {
            req.user = {
                user_id: 2,
                role: 'Admin'
            };
            next();
        } else if (req.headers.authorization === 'Bearer trainer-token') {
            req.user = {
                user_id: 3,
                role: 'Trainer'
            };
            next();
        } else {
            res.status(401).json({
                status: 'failure',
                message: 'Not authorized, no token'
            });
        }
    });
});

describe('Login Function', () => {
    let req, res;

    beforeEach(() => {
        req = {
            body: {
                email: 'test@example.com',
                password: 'Password123!',
            }
        };

        res = {
            status: jest.fn().mockReturnThis(),
            json: jest.fn(),
        };

        jest.clearAllMocks();
    });

    it('should login user successfully', async () => {
        const mockUser = {
            user_id: 1,
            email: 'test@example.com',
            password: 'hashedPassword',
            user_name: 'testuser',
            role: 'Member',
            full_name: 'Test User',
            phone_number: '1234567890',
            fitness_level: 'Intermediate',
            goal_type: 'Weight_Loss',
        };

        mockPrismaClient.users.findUnique.mockResolvedValue(mockUser);
        bcrypt.compare.mockResolvedValueOnce(true);

        await login(req, res);

        expect(mockPrismaClient.users.findUnique).toHaveBeenCalledWith({
            where: { email: 'test@example.com' }
        });
        expect(bcrypt.compare).toHaveBeenCalledWith('Password123!', 'hashedPassword');
        expect(res.status).toHaveBeenCalledWith(200);
        expect(res.json).toHaveBeenCalledWith({
            status: 'success',
            message: 'Login successful',
            data: expect.objectContaining({
                user_id: 1,
                user_name: 'testuser',
                email: 'test@example.com'
            }),
            token: expect.any(String)
        });
    });

    it('should return error for invalid credentials', async () => {
        mockPrismaClient.users.findUnique.mockResolvedValue({
            email: 'test@example.com',
            password: 'hashedPassword'
        });
        bcrypt.compare.mockResolvedValueOnce(false);

        await login(req, res);

        expect(res.status).toHaveBeenCalledWith(401);
        expect(res.json).toHaveBeenCalledWith({
            status: 'failure',
            message: 'Invalid credentials'
        });
    });

    it('should return error for user not found', async () => {
        mockPrismaClient.users.findUnique.mockResolvedValue(null);

        await login(req, res);

        expect(res.status).toHaveBeenCalledWith(404);
        expect(res.json).toHaveBeenCalledWith({
            status: 'failure',
            message: 'User not found'
        });
    });

    it('should return error for invalid email format', async () => {
        req.body.email = 'invalid-email';

        await login(req, res);

        expect(res.status).toHaveBeenCalledWith(400);
        expect(res.json.mock.calls[0][0]).toHaveProperty('status', 'failure');
        expect(res.json.mock.calls[0][0]).toHaveProperty('message', 'Validation failed');
    });

    it('should return error for missing password', async () => {
        delete req.body.password;

        await login(req, res);

        expect(res.status).toHaveBeenCalledWith(400);
        expect(res.json.mock.calls[0][0]).toHaveProperty('status', 'failure');
        expect(res.json.mock.calls[0][0]).toHaveProperty('message', 'Validation failed');
    });

    it('should handle server errors', async () => {
        mockPrismaClient.users.findUnique.mockImplementationOnce(() => {
            throw new Error('Database error');
        });

        await login(req, res);

        expect(res.status).toHaveBeenCalledWith(500);
        expect(res.json).toHaveBeenCalledWith({
            status: 'failure',
            message: 'Server error'
        });
    });
});

describe('Login API Integration Tests', () => {
    beforeEach(() => {
        jest.clearAllMocks();
    });

    it('should return 200 for successful login', async () => {
        mockPrismaClient.users.findUnique.mockResolvedValue({
            user_id: 1,
            email: 'test@example.com',
            password: 'hashedPassword',
            user_name: 'testuser',
            role: 'Member'
        });
        bcrypt.compare.mockResolvedValueOnce(true);

        const response = await request(app)
            .post('/api/auth/login')
            .send({
                email: 'test@example.com',
                password: 'Password123!'
            });

        expect(response.status).toBe(200);
        expect(response.body.status).toBe('success');
        expect(response.body.message).toBe('Login successful');
        expect(response.body).toHaveProperty('token');
    });

    it('should return 401 for incorrect password', async () => {
        mockPrismaClient.users.findUnique.mockResolvedValue({
            email: 'test@example.com',
            password: 'hashedPassword'
        });
        bcrypt.compare.mockResolvedValueOnce(false);

        const response = await request(app)
            .post('/api/auth/login')
            .send({
                email: 'test@example.com',
                password: 'WrongPassword123!'
            });

        expect(response.status).toBe(401);
        expect(response.body.status).toBe('failure');
        expect(response.body.message).toBe('Invalid credentials');
    });

    it('should return 404 for non-existent user', async () => {
        mockPrismaClient.users.findUnique.mockResolvedValue(null);

        const response = await request(app)
            .post('/api/auth/login')
            .send({
                email: 'nonexistent@example.com',
                password: 'Password123!'
            });

        expect(response.status).toBe(404);
        expect(response.body.status).toBe('failure');
        expect(response.body.message).toBe('User not found');
    });

    it('should return 400 for invalid email format', async () => {
        const response = await request(app)
            .post('/api/auth/login')
            .send({
                email: 'invalid-email',
                password: 'Password123!'
            });

        expect(response.status).toBe(400);
        expect(response.body.status).toBe('failure');
    });

    it('should return 400 for missing password', async () => {
        const response = await request(app)
            .post('/api/auth/login')
            .send({
                email: 'test@example.com'
            });

        expect(response.status).toBe(400);
        expect(response.body.status).toBe('failure');
    });
});

describe('Protected Routes Authentication', () => {
    it('should process user with valid token', () => {
        const req = {
            headers: {
                authorization: 'Bearer valid-token'
            }
        };
        const res = {};
        const next = jest.fn();

        const authMiddleware = jest.requireMock('../middleware/authMiddleware.js');
        authMiddleware(req, res, next);

        expect(next).toHaveBeenCalled();
        expect(req.user).toEqual({
            user_id: 1,
            role: 'Member'
        });
    });

    it('should process admin with admin token', () => {
        const req = {
            headers: {
                authorization: 'Bearer admin-token'
            }
        };
        const res = {};
        const next = jest.fn();

        const authMiddleware = jest.requireMock('../middleware/authMiddleware.js');
        authMiddleware(req, res, next);

        expect(next).toHaveBeenCalled();
        expect(req.user).toEqual({
            user_id: 2,
            role: 'Admin'
        });
    });

    it('should reject requests without token', () => {
        const req = {
            headers: {}
        };
        const res = {
            status: jest.fn().mockReturnThis(),
            json: jest.fn()
        };
        const next = jest.fn();

        const authMiddleware = jest.requireMock('../middleware/authMiddleware.js');
        authMiddleware(req, res, next);

        expect(next).not.toHaveBeenCalled();
        expect(res.status).toHaveBeenCalledWith(401);
    });
});