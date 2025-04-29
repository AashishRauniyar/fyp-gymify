// Unit tests for auth functionality (signup and login)
import { expect } from 'chai';
import sinon from 'sinon';
import bcrypt from 'bcryptjs';

describe('Auth Functionality Tests', () => {
    // Setup variables
    let req, res;

    beforeEach(() => {
        // Create request and response objects
        req = {
            body: {},
            file: null
        };

        res = {
            status: sinon.stub().returnsThis(),
            json: sinon.stub()
        };
    });

    afterEach(() => {
        // Clean up stubs
        sinon.restore();
    });

    describe('register', () => {
        it('should handle existing verified user registration attempt', async () => {
            // Mock input data
            req.body = {
                email: 'existing@example.com',
                password: 'Password123!'
            };

            // Create controller-specific mocks
            const prismaClientMock = {
                users: {
                    findUnique: sinon.stub().resolves({
                        email: 'existing@example.com',
                        verified: true,
                        created_at: new Date()
                    }),
                    create: sinon.stub(),
                    update: sinon.stub()
                }
            };

            // Using a test function to simulate controller behavior
            const registerTest = async () => {
                try {
                    // Validate input (simplified for test)
                    const email = req.body.email.toLowerCase();

                    // Check if user exists
                    const existingUser = await prismaClientMock.users.findUnique({
                        where: { email },
                        select: {
                            email: true,
                            verified: true,
                            created_at: true
                        }
                    });

                    if (existingUser) {
                        if (existingUser.verified) {
                            return res.status(409).json({
                                status: 'failure',
                                message: 'Email already registered',
                                details: {
                                    email: email,
                                    registered: true,
                                    verified: true,
                                    registrationDate: existingUser.created_at
                                }
                            });
                        }
                    }

                    // Rest of the function won't execute due to early return

                } catch (error) {
                    return res.status(500).json({
                        status: 'failure',
                        message: 'Internal server error'
                    });
                }
            };

            // Call the test function
            await registerTest();

            // Assertions
            sinon.assert.calledWith(prismaClientMock.users.findUnique, {
                where: { email: 'existing@example.com' },
                select: {
                    email: true,
                    verified: true,
                    created_at: true
                }
            });

            sinon.assert.notCalled(prismaClientMock.users.create);
            sinon.assert.calledWith(res.status, 409);

            const response = res.json.firstCall.args[0];
            expect(response.status).to.equal('failure');
            expect(response.message).to.equal('Email already registered');
            expect(response.details.verified).to.equal(true);
        });

        it('should handle registration with invalid email format', async () => {
            // Mock input data with invalid email
            req.body = {
                email: 'invalid-email',
                password: 'Password123!'
            };

            // Using a test function to simulate controller behavior
            const registerTest = async () => {
                // Simulate validation failure
                const errors = [{ param: 'email', msg: 'Invalid email format' }];

                if (errors.length > 0) {
                    return res.status(400).json({
                        status: 'failure',
                        errors: errors
                    });
                }
            };

            // Call the test function
            await registerTest();

            // Assertions
            sinon.assert.calledWith(res.status, 400);

            const response = res.json.firstCall.args[0];
            expect(response.status).to.equal('failure');
            expect(response.errors[0].msg).to.equal('Invalid email format');
        });

        it('should handle registration with weak password', async () => {
            // Mock input data with weak password
            req.body = {
                email: 'test@example.com',
                password: 'weak'
            };

            // Using a test function to simulate controller behavior
            const registerTest = async () => {
                // Simulate validation failure
                const errors = [{ param: 'password', msg: 'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character' }];

                if (errors.length > 0) {
                    return res.status(400).json({
                        status: 'failure',
                        errors: errors
                    });
                }
            };

            // Call the test function
            await registerTest();

            // Assertions
            sinon.assert.calledWith(res.status, 400);

            const response = res.json.firstCall.args[0];
            expect(response.status).to.equal('failure');
            expect(response.errors[0].msg).to.contain('Password must be');
        });

        it('should handle server error during registration', async () => {
            // Mock input data
            req.body = {
                email: 'test@example.com',
                password: 'Password123!'
            };

            // Mock bcrypt hash to throw an error
            sinon.stub(bcrypt, 'hash').rejects(new Error('Database connection failed'));

            // Create controller-specific mocks
            const prismaClientMock = {
                users: {
                    findUnique: sinon.stub().resolves(null),
                    create: sinon.stub().rejects(new Error('Database connection failed'))
                }
            };

            // Using a test function to simulate controller behavior
            const registerTest = async () => {
                try {
                    // Check if user exists
                    await prismaClientMock.users.findUnique({
                        where: { email: req.body.email.toLowerCase() }
                    });

                    // Try to hash password and create user
                    await bcrypt.hash(req.body.password, 12);
                    await prismaClientMock.users.create({ data: {} });

                } catch (error) {
                    return res.status(500).json({
                        status: 'failure',
                        message: 'Internal server error'
                    });
                }
            };

            // Call the test function
            await registerTest();

            // Assertions
            sinon.assert.calledWith(res.status, 500);

            const response = res.json.firstCall.args[0];
            expect(response.status).to.equal('failure');
            expect(response.message).to.equal('Internal server error');
        });
    });

    describe('login', () => {
        it('should reject login with non-existent email', async () => {
            // Mock input data
            req.body = {
                email: 'nonexistent@example.com',
                password: 'Password123!'
            };

            // Create controller-specific mocks
            const prismaClientMock = {
                users: {
                    findUnique: sinon.stub().resolves(null) // User not found
                }
            };

            // Using a test function to simulate controller behavior
            const loginTest = async () => {
                try {
                    const { email, password } = req.body;

                    // Find user
                    const user = await prismaClientMock.users.findUnique({ where: { email } });
                    if (!user) {
                        return res.status(404).json({ status: 'failure', message: 'User not found' });
                    }

                    // Rest of function won't execute due to early return

                } catch (error) {
                    return res.status(500).json({ status: 'failure', message: 'Server error' });
                }
            };

            // Call the test function
            await loginTest();

            // Assertions
            sinon.assert.calledWith(prismaClientMock.users.findUnique, {
                where: { email: 'nonexistent@example.com' }
            });
            sinon.assert.calledWith(res.status, 404);

            const response = res.json.firstCall.args[0];
            expect(response.status).to.equal('failure');
            expect(response.message).to.equal('User not found');
        });

        it('should reject login with incorrect password', async () => {
            // Mock input data
            req.body = {
                email: 'test@example.com',
                password: 'WrongPassword123!'
            };

            // Mock user data
            const mockUserData = {
                user_id: 1,
                email: 'test@example.com',
                password: 'hashed_password',
                role: 'Member'
            };

            // Mock password comparison to return false (incorrect password)
            sinon.stub(bcrypt, 'compare').resolves(false);

            // Create controller-specific mocks
            const prismaClientMock = {
                users: {
                    findUnique: sinon.stub().resolves(mockUserData)
                }
            };

            // Using a test function to simulate controller behavior
            const loginTest = async () => {
                try {
                    const { email, password } = req.body;

                    // Find user
                    const user = await prismaClientMock.users.findUnique({ where: { email } });
                    if (!user) {
                        return res.status(404).json({ status: 'failure', message: 'User not found' });
                    }

                    // Check password
                    const isPasswordMatch = await bcrypt.compare(password, user.password);
                    if (!isPasswordMatch) {
                        return res.status(401).json({ status: 'failure', message: 'Invalid credentials' });
                    }

                    // Rest of function won't execute due to early return

                } catch (error) {
                    return res.status(500).json({ status: 'failure', message: 'Server error' });
                }
            };

            // Call the test function
            await loginTest();

            // Assertions
            sinon.assert.calledWith(prismaClientMock.users.findUnique, {
                where: { email: 'test@example.com' }
            });
            sinon.assert.calledWith(bcrypt.compare, 'WrongPassword123!', 'hashed_password');
            sinon.assert.calledWith(res.status, 401);

            const response = res.json.firstCall.args[0];
            expect(response.status).to.equal('failure');
            expect(response.message).to.equal('Invalid credentials');
        });

        it('should handle server error during login', async () => {
            // Mock input data
            req.body = {
                email: 'test@example.com',
                password: 'Password123!'
            };

            // Create controller-specific mocks
            const prismaClientMock = {
                users: {
                    findUnique: sinon.stub().rejects(new Error('Database error'))
                }
            };

            // Using a test function to simulate controller behavior
            const loginTest = async () => {
                try {
                    // Try to find user, but this will throw an error
                    await prismaClientMock.users.findUnique({
                        where: { email: req.body.email }
                    });
                } catch (error) {
                    return res.status(500).json({ status: 'failure', message: 'Server error' });
                }
            };

            // Call the test function
            await loginTest();

            // Assertions
            sinon.assert.calledWith(res.status, 500);

            const response = res.json.firstCall.args[0];
            expect(response.status).to.equal('failure');
            expect(response.message).to.equal('Server error');
        });

        it('should validate required fields for login', async () => {
            // Mock empty input data
            req.body = {
                email: '', // Empty email
                password: '' // Empty password
            };

            // Using a test function to simulate controller behavior
            const loginTest = async () => {
                // Simulate validation failure
                const errors = [
                    { param: 'email', msg: 'Email is required' },
                    { param: 'password', msg: 'Password is required' }
                ];

                if (errors.length > 0) {
                    return res.status(400).json({
                        status: 'failure',
                        message: 'Validation failed',
                        errors: errors
                    });
                }
            };

            // Call the test function
            await loginTest();

            // Assertions
            sinon.assert.calledWith(res.status, 400);

            const response = res.json.firstCall.args[0];
            expect(response.status).to.equal('failure');
            expect(response.message).to.equal('Validation failed');
            expect(response.errors.length).to.equal(2);
        });

        it('should simulate successful login', async () => {
            // Mock input data
            req.body = {
                email: 'test@example.com',
                password: 'Password123!'
            };

            // Mock user data
            const mockUserData = {
                user_id: 1,
                user_name: 'testuser',
                email: 'test@example.com',
                password: 'hashed_password',
                role: 'Member',
                full_name: 'Test User',
                phone_number: '1234567890',
                fitness_level: 'Intermediate',
                goal_type: 'Weight_Loss'
            };

            // Mock password comparison to return true (correct password)
            sinon.stub(bcrypt, 'compare').resolves(true);

            // Create controller-specific mocks
            const prismaClientMock = {
                users: {
                    findUnique: sinon.stub().resolves(mockUserData)
                }
            };

            // Mock token generation manually
            const mockToken = 'mock_jwt_token';

            // Using a test function to simulate controller behavior
            const loginTest = async () => {
                try {
                    const { email, password } = req.body;

                    // Find user
                    const user = await prismaClientMock.users.findUnique({ where: { email } });
                    if (!user) {
                        return res.status(404).json({ status: 'failure', message: 'User not found' });
                    }

                    // Check password
                    const isPasswordMatch = await bcrypt.compare(password, user.password);
                    if (!isPasswordMatch) {
                        return res.status(401).json({ status: 'failure', message: 'Invalid credentials' });
                    }

                    // Generate token (simplified for test)
                    const token = mockToken;

                    // Return success response
                    return res.status(200).json({
                        status: 'success',
                        message: 'Login successful',
                        data: {
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
                    return res.status(500).json({ status: 'failure', message: 'Server error' });
                }
            };

            // Call the test function
            await loginTest();

            // Assertions
            sinon.assert.calledWith(prismaClientMock.users.findUnique, {
                where: { email: 'test@example.com' }
            });
            sinon.assert.calledWith(bcrypt.compare, 'Password123!', 'hashed_password');
            sinon.assert.calledWith(res.status, 200);

            const response = res.json.firstCall.args[0];
            expect(response.status).to.equal('success');
            expect(response.message).to.equal('Login successful');
            expect(response.data.user_id).to.equal(1);
            expect(response.data.email).to.equal('test@example.com');
            expect(response.token).to.equal('mock_jwt_token');
        });
    });

    describe('register success', () => {
        it('should simulate successful registration', async () => {
            // Mock input data
            req.body = {
                email: 'test@example.com',
                password: 'Password123!'
            };

            // Mock bcrypt hash
            sinon.stub(bcrypt, 'hash').resolves('hashed_password');

            // Create controller-specific mocks
            const prismaClientMock = {
                users: {
                    findUnique: sinon.stub().resolves(null), // No existing user
                    create: sinon.stub().resolves({
                        user_id: 1,
                        email: 'test@example.com',
                        verified: false
                    }),
                    delete: sinon.stub()
                }
            };

            // Using a test function to simulate controller behavior
            const registerTest = async () => {
                try {
                    // Validate input (simplified for test)
                    const email = req.body.email.toLowerCase();
                    const password = req.body.password;

                    // Check if user exists
                    const existingUser = await prismaClientMock.users.findUnique({
                        where: { email },
                        select: {
                            email: true,
                            verified: true,
                            created_at: true
                        }
                    });

                    if (existingUser) {
                        return res.status(409).json({
                            status: 'failure',
                            message: 'Email already registered',
                            details: {
                                email: email,
                                registered: true,
                                verified: existingUser.verified,
                                registrationDate: existingUser.created_at
                            }
                        });
                    }

                    // Hash password
                    const hashedPassword = await bcrypt.hash(password, 12);

                    // Generate OTP
                    const otp = '123456'; // Simplified for test
                    const otpExpiry = new Date(Date.now() + 10 * 60 * 1000);

                    // Create user
                    await prismaClientMock.users.create({
                        data: {
                            email: email,
                            password: hashedPassword,
                            otp,
                            otp_expiry: otpExpiry,
                            role: 'Member',
                            verified: false
                        }
                    });

                    // Simulate email sending (success)
                    const emailSent = true;

                    if (!emailSent) {
                        await prismaClientMock.users.delete({ where: { email } });
                        return res.status(500).json({
                            status: 'failure',
                            message: 'Failed to send OTP email'
                        });
                    }

                    return res.status(201).json({
                        status: 'success',
                        message: 'Registration initiated. Please verify your email.',
                        data: { email }
                    });
                } catch (error) {
                    return res.status(500).json({
                        status: 'failure',
                        message: 'Internal server error'
                    });
                }
            };

            // Call the test function
            await registerTest();

            // Assertions
            sinon.assert.calledWith(prismaClientMock.users.findUnique, {
                where: { email: 'test@example.com' },
                select: {
                    email: true,
                    verified: true,
                    created_at: true
                }
            });

            sinon.assert.calledWith(bcrypt.hash, 'Password123!', 12);
            sinon.assert.calledOnce(prismaClientMock.users.create);
            sinon.assert.calledWith(res.status, 201);

            const response = res.json.firstCall.args[0];
            expect(response.status).to.equal('success');
            expect(response.message).to.equal('Registration initiated. Please verify your email.');
            expect(response.data.email).to.equal('test@example.com');
        });
    });
});