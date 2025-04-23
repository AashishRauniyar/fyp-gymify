import {
    verifyOTP,
    resendOTP,
    forgotPassword,
    resetPassword,
    checkEmailExists,
    checkUsername,
    checkPhoneNumber,
    completeRegistration,
    register,
    login
  } from '../controllers/auth_controller/authController.js';
  import { jest } from '@jest/globals';
  
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
  
  // Import mocked mail functions to access their mock functions
  import * as sendMailModule from '../utils/sendMail.js';
  
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
  
  // Mock express-validator
  jest.mock('express-validator', () => ({
    body: jest.fn().mockReturnValue({
      isEmail: jest.fn().mockReturnThis(),
      isLength: jest.fn().mockReturnThis(),
      matches: jest.fn().mockReturnThis(),
      withMessage: jest.fn().mockReturnThis(),
      normalizeEmail: jest.fn().mockReturnThis(),
      run: jest.fn().mockResolvedValue(undefined)
    }),
    validationResult: jest.fn().mockReturnValue({
      isEmpty: jest.fn().mockReturnValue(true),
      array: jest.fn().mockReturnValue([])
    })
  }));
  
  // Mock JWT token generation
  jest.mock('../utils/generateToken.js', () => {
    return jest.fn(() => 'mock-jwt-token');
  });
  
  // Import mocked token generator
  import generateToken from '../utils/generateToken.js';
  
  describe('Authentication Controller Tests', () => {
    let req, res;
  
    beforeEach(() => {
      req = {
        body: {},
        file: null
      };
  
      res = {
        status: jest.fn().mockReturnThis(),
        json: jest.fn(),
      };
  
      jest.clearAllMocks();
    });
  
    describe('Login Function', () => {
      beforeEach(() => {
        req.body = {
          email: 'test@example.com',
          password: 'Password123!'
        };
      });
  
      it('should login a user successfully', async () => {
        const mockUser = {
          user_id: 1,
          email: 'test@example.com',
          password: 'hashedPassword',
          user_name: 'testuser',
          role: 'Member',
          full_name: 'Test User',
          phone_number: '1234567890',
          fitness_level: 'Intermediate',
          goal_type: 'Weight_Loss'
        };
  
        mockPrismaClient.users.findUnique.mockResolvedValue(mockUser);
        bcrypt.compare.mockResolvedValueOnce(true);
        generateToken.mockReturnValueOnce('mock-token');
  
        await login(req, res);
  
        expect(mockPrismaClient.users.findUnique).toHaveBeenCalledWith({ 
          where: { email: 'test@example.com' } 
        });
        expect(bcrypt.compare).toHaveBeenCalledWith('Password123!', 'hashedPassword');
        expect(generateToken).toHaveBeenCalledWith(mockUser);
        expect(res.status).toHaveBeenCalledWith(200);
        expect(res.json).toHaveBeenCalledWith({
          status: 'success',
          message: 'Login successful',
          data: {
            user_id: 1,
            user_name: 'testuser',
            email: 'test@example.com',
            role: 'Member',
            full_name: 'Test User',
            phone_number: '1234567890',
            fitness_level: 'Intermediate',
            goal_type: 'Weight_Loss'
          },
          token: 'mock-token'
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
  
      it('should handle server errors', async () => {
        mockPrismaClient.users.findUnique.mockRejectedValue(new Error('Database error'));
  
        await login(req, res);
  
        expect(res.status).toHaveBeenCalledWith(500);
        expect(res.json).toHaveBeenCalledWith({
          status: 'failure',
          message: 'Server error'
        });
      });
    });
  
    describe('Register Function', () => {
      beforeEach(() => {
        req.body = {
          email: 'test@example.com',
          password: 'Password123!'
        };
      });
  
      it('should register a new user successfully', async () => {
        mockPrismaClient.users.findUnique.mockResolvedValue(null);
        mockPrismaClient.users.create.mockResolvedValue({
          user_id: 1,
          email: 'test@example.com',
          verified: false
        });
        sendMailModule.sendRegistrationOTPEmail.mockResolvedValue(true);
  
        await register(req, res);
  
        expect(mockPrismaClient.users.findUnique).toHaveBeenCalledWith({
          where: { email: 'test@example.com' },
          select: {
            email: true,
            verified: true,
            created_at: true
          }
        });
        expect(bcrypt.hash).toHaveBeenCalledWith('Password123!', 12);
        expect(mockPrismaClient.users.create).toHaveBeenCalled();
        expect(sendMailModule.sendRegistrationOTPEmail).toHaveBeenCalled();
        expect(res.status).toHaveBeenCalledWith(201);
        expect(res.json).toHaveBeenCalledWith({
          status: 'success',
          message: 'Registration initiated. Please verify your email.',
          data: { email: 'test@example.com' }
        });
      });
  
      it('should send new OTP if email exists but is not verified', async () => {
        mockPrismaClient.users.findUnique.mockResolvedValue({
          email: 'test@example.com',
          verified: false,
          created_at: new Date()
        });
        sendMailModule.sendWelcomeEmail.mockResolvedValue(true);
  
        await register(req, res);
  
        expect(mockPrismaClient.users.update).toHaveBeenCalled();
        expect(sendMailModule.sendWelcomeEmail).toHaveBeenCalled();
        expect(res.status).toHaveBeenCalledWith(200);
        expect(res.json).toHaveBeenCalledWith({
          status: 'success',
          message: 'Email already registered but not verified. New OTP sent.',
          details: expect.any(Object)
        });
      });
  
      it('should return error if email is already registered and verified', async () => {
        mockPrismaClient.users.findUnique.mockResolvedValue({
          email: 'test@example.com',
          verified: true,
          created_at: new Date()
        });
  
        await register(req, res);
  
        expect(res.status).toHaveBeenCalledWith(409);
        expect(res.json).toHaveBeenCalledWith({
          status: 'failure',
          message: 'Email already registered',
          details: expect.any(Object)
        });
      });
  
      it('should handle email sending failure for new users', async () => {
        mockPrismaClient.users.findUnique.mockResolvedValue(null);
        sendMailModule.sendRegistrationOTPEmail.mockResolvedValue(false);
  
        await register(req, res);
  
        expect(mockPrismaClient.users.delete).toHaveBeenCalled();
        expect(res.status).toHaveBeenCalledWith(500);
        expect(res.json).toHaveBeenCalledWith({
          status: 'failure',
          message: 'Failed to send OTP email'
        });
      });
    });
  
    describe('OTP Verification', () => {
      beforeEach(() => {
        req.body = {
          email: 'test@example.com',
          otp: '123456'
        };
      });
  
      it('should verify OTP successfully', async () => {
        mockPrismaClient.users.findUnique.mockResolvedValue({
          email: 'test@example.com',
          otp: '123456',
          otp_expiry: new Date(Date.now() + 60000), // 1 minute in the future
          verified: false
        });
  
        await verifyOTP(req, res);
  
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
  
      it('should return error for invalid OTP', async () => {
        mockPrismaClient.users.findUnique.mockResolvedValue({
          email: 'test@example.com',
          otp: '654321', // Different OTP
          otp_expiry: new Date(Date.now() + 60000),
          verified: false
        });
  
        await verifyOTP(req, res);
  
        expect(res.status).toHaveBeenCalledWith(400);
        expect(res.json).toHaveBeenCalledWith({
          status: 'failure',
          message: 'Invalid OTP'
        });
      });
  
      it('should return error for expired OTP', async () => {
        mockPrismaClient.users.findUnique.mockResolvedValue({
          email: 'test@example.com',
          otp: '123456',
          otp_expiry: new Date(Date.now() - 60000), // 1 minute in the past
          verified: false
        });
  
        await verifyOTP(req, res);
  
        expect(res.status).toHaveBeenCalledWith(400);
        expect(res.json).toHaveBeenCalledWith({
          status: 'failure',
          message: 'OTP has expired'
        });
      });
    });
  
    describe('Resend OTP', () => {
      beforeEach(() => {
        req.body = {
          email: 'test@example.com'
        };
      });
  
      it('should resend OTP successfully', async () => {
        mockPrismaClient.users.findUnique.mockResolvedValue({
          email: 'test@example.com',
          verified: false
        });
        sendMailModule.sendRegistrationOTPEmail.mockResolvedValue(true);
  
        await resendOTP(req, res);
  
        expect(mockPrismaClient.users.update).toHaveBeenCalled();
        expect(sendMailModule.sendRegistrationOTPEmail).toHaveBeenCalled();
        expect(res.status).toHaveBeenCalledWith(200);
        expect(res.json).toHaveBeenCalledWith({
          status: 'success',
          message: 'OTP resent successfully'
        });
      });
  
      it('should return error for already verified email', async () => {
        mockPrismaClient.users.findUnique.mockResolvedValue({
          email: 'test@example.com',
          verified: true
        });
  
        await resendOTP(req, res);
  
        expect(res.status).toHaveBeenCalledWith(400);
        expect(res.json).toHaveBeenCalledWith({
          status: 'failure',
          message: 'Email already verified'
        });
      });
    });
  
    describe('Forgot Password', () => {
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
  
        expect(mockPrismaClient.users.update).toHaveBeenCalled();
        expect(sendMailModule.sendOTPEmail).toHaveBeenCalled();
        expect(res.status).toHaveBeenCalledWith(200);
        expect(res.json).toHaveBeenCalledWith({
          status: 'success',
          message: 'OTP sent to your email for password reset'
        });
      });
  
      it('should return error for non-existent user', async () => {
        mockPrismaClient.users.findUnique.mockResolvedValue(null);
  
        await forgotPassword(req, res);
  
        expect(res.status).toHaveBeenCalledWith(404);
        expect(res.json).toHaveBeenCalledWith({
          status: 'failure',
          message: 'User not found'
        });
      });
    });
  
    describe('Reset Password', () => {
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
          otp_expiry: new Date(Date.now() + 60000) // 1 minute in the future
        });
  
        await resetPassword(req, res);
  
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
  
      it('should return error for invalid OTP', async () => {
        mockPrismaClient.users.findUnique.mockResolvedValue({
          email: 'test@example.com',
          otp: '654321', // Different OTP
          otp_expiry: new Date(Date.now() + 60000)
        });
  
        await resetPassword(req, res);
  
        expect(res.status).toHaveBeenCalledWith(400);
        expect(res.json).toHaveBeenCalledWith({
          status: 'failure',
          message: 'Invalid OTP'
        });
      });
  
      it('should return error for weak password', async () => {
        mockPrismaClient.users.findUnique.mockResolvedValue({
          email: 'test@example.com',
          otp: '123456',
          otp_expiry: new Date(Date.now() + 60000)
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
  
    describe('Check Username', () => {
      beforeEach(() => {
        req.body = {
          user_name: 'testuser'
        };
      });
  
      it('should confirm username is available', async () => {
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
  
      it('should confirm username is already taken', async () => {
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
  
    describe('Check Phone Number', () => {
      beforeEach(() => {
        req.body = {
          phone_number: '1234567890'
        };
      });
  
      it('should confirm phone number is available', async () => {
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
  
      it('should confirm phone number is already taken', async () => {
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
  
    describe('Complete Registration', () => {
      beforeEach(() => {
        req.body = {
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
        };
        req.file = {
          buffer: Buffer.from('mock image data')
        };
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
    });
  
    describe('Check Email Exists', () => {
      beforeEach(() => {
        req.body = {
          email: 'test@example.com'
        };
      });
  
      it('should confirm email is available', async () => {
        mockPrismaClient.users.findUnique.mockResolvedValue(null);
  
        await checkEmailExists(req, res);
  
        expect(mockPrismaClient.users.findUnique).toHaveBeenCalledWith({
          where: { email: 'test@example.com' },
          select: {
            email: true,
            verified: true
          }
        });
        expect(res.status).toHaveBeenCalledWith(200);
        expect(res.json).toHaveBeenCalledWith({
          status: 'success',
          exists: false,
          message: 'Email is available'
        });
      });
  
      it('should confirm email exists and is verified', async () => {
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
  
      it('should confirm email exists but is not verified', async () => {
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
        req.body.email = 'invalid-email';
  
        await checkEmailExists(req, res);
  
        expect(res.status).toHaveBeenCalledWith(400);
        expect(res.json).toHaveBeenCalledWith({
          status: 'failure',
          message: 'Invalid email format'
        });
      });
    });
  });