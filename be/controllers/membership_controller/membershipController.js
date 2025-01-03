// membershipController.js
import { PrismaClient } from '@prisma/client';
import { body, validationResult } from 'express-validator';

const prisma = new PrismaClient();

// Create a membership plan
export const createMembershipPlan = async (req, res) => {
    try {
        // Validation
        await body('plan_type').isIn(['Monthly', 'Yearly', 'Quaterly']).withMessage('Invalid plan type').run(req);
        await body('price').isFloat({ min: 0 }).withMessage('Invalid price').run(req);

        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({
                status: 'failure',
                message: 'Validation failed',
                errors: errors.array()
            });
        }

        const { plan_type, price } = req.body;

        const plan = await prisma.membership_plan.create({
            data: {
                plan_type,
                price
            }
        });

        res.status(201).json({
            status: 'success',
            message: 'Membership plan created successfully',
            data: plan
        });
    } catch (error) {
        console.error('Error creating membership plan:', error);
        res.status(500).json({
            status: 'failure',
            message: 'Server error'
        });
    }
};

// Get all membership plans
export const getAllPlans = async (req, res) => {
    try {
        const plans = await prisma.membership_plan.findMany({
            orderBy: {
                price: 'asc'
            }
        });

        res.status(200).json({
            status: 'success',
            data: plans
        });
    } catch (error) {
        console.error('Error fetching plans:', error);
        res.status(500).json({
            status: 'failure',
            message: 'Server error'
        });
    }
};

// Create a new membership
export const createMembership = async (req, res) => {
    try {
        // Validation
        await body('user_id').isInt().withMessage('Invalid user ID').run(req);
        await body('plan_id').isInt().withMessage('Invalid plan ID').run(req);
        await body('payment_method').isIn(['Khalti', 'Cash']).withMessage('Invalid payment method').run(req);

        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({
                status: 'failure',
                message: 'Validation failed',
                errors: errors.array()
            });
        }

        const { user_id, plan_id, payment_method } = req.body;

        // Check for existing active membership
        const existingMembership = await prisma.memberships.findFirst({
            where: {
                user_id,
                status: 'Active',
                end_date: {
                    gte: new Date()
                }
            }
        });

        if (existingMembership) {
            return res.status(400).json({
                status: 'failure',
                message: 'User already has an active membership'
            });
        }

        // Get plan details
        const plan = await prisma.membership_plan.findUnique({
            where: { plan_id }
        });

        if (!plan) {
            return res.status(404).json({
                status: 'failure',
                message: 'Plan not found'
            });
        }

        // Calculate membership duration
        const start_date = new Date();
        const end_date = new Date();
        
        switch (plan.plan_type) {
            case 'Monthly':
                end_date.setMonth(end_date.getMonth() + 1);
                break;
            case 'Quaterly':
                end_date.setMonth(end_date.getMonth() + 3);
                break;
            case 'Yearly':
                end_date.setFullYear(end_date.getFullYear() + 1);
                break;
        }

        // Create membership
        const membership = await prisma.memberships.create({
            data: {
                user_id,
                plan_id,
                start_date,
                end_date,
                status: 'Active'
            }
        });

        // Create payment record
        const payment = await prisma.payments.create({
            data: {
                membership_id: membership.membership_id,
                user_id,
                price: plan.price,
                payment_method,
                transaction_id: `TXN${Date.now()}`,
                payment_date: new Date(),
                payment_status: 'Paid'
            }
        });

        res.status(201).json({
            status: 'success',
            message: 'Membership created successfully',
            data: {
                membership,
                payment
            }
        });
    } catch (error) {
        console.error('Error creating membership:', error);
        res.status(500).json({
            status: 'failure',
            message: 'Server error'
        });
    }
};

// Get user's active membership
export const getActiveMembership = async (req, res) => {
    try {
        const { user_id } = req.params;

        const membership = await prisma.memberships.findFirst({
            where: {
                user_id: parseInt(user_id),
                status: 'Active',
                end_date: {
                    gte: new Date()
                }
            },
            include: {
                membership_plan: true,
                payments: true
            }
        });

        if (!membership) {
            return res.status(404).json({
                status: 'failure',
                message: 'No active membership found'
            });
        }

        res.status(200).json({
            status: 'success',
            data: membership
        });
    } catch (error) {
        console.error('Error fetching active membership:', error);
        res.status(500).json({
            status: 'failure',
            message: 'Server error'
        });
    }
};

// attendanceController.js
export const markAttendance = async (req, res) => {
    try {
        // Validate card number
        await body('card_number').notEmpty().withMessage('Card number is required').run(req);
        
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({
                status: 'failure',
                message: 'Validation failed',
                errors: errors.array()
            });
        }

        const { card_number } = req.body;

        // Find user by card number
        const user = await prisma.users.findFirst({
            where: { card_number },
            include: {
                memberships: {
                    where: {
                        status: 'Active',
                        end_date: {
                            gte: new Date()
                        }
                    }
                }
            }
        });

        if (!user) {
            return res.status(404).json({
                status: 'failure',
                message: 'Invalid card or user not found'
            });
        }

        // Check for active membership
        if (!user.memberships || user.memberships.length === 0) {
            return res.status(403).json({
                status: 'failure',
                message: 'No active membership found'
            });
        }

        // Check for existing attendance today
        const today = new Date();
        today.setHours(0, 0, 0, 0);

        const existingAttendance = await prisma.attendance.findFirst({
            where: {
                user_id: user.user_id,
                attendance_date: {
                    equals: today
                }
            }
        });

        if (existingAttendance) {
            return res.status(400).json({
                status: 'failure',
                message: 'Attendance already marked for today'
            });
        }

        // Mark attendance
        const attendance = await prisma.attendance.create({
            data: {
                user_id: user.user_id,
                attendance_date: today
            }
        });

        res.status(201).json({
            status: 'success',
            message: 'Attendance marked successfully',
            data: {
                attendance_id: attendance.attendance_id,
                user_name: user.user_name,
                date: attendance.attendance_date
            }
        });

    } catch (error) {
        console.error('Error marking attendance:', error);
        res.status(500).json({
            status: 'failure',
            message: 'Server error'
        });
    }
};

// Get attendance history
export const getAttendanceHistory = async (req, res) => {
    try {
        const { user_id } = req.params;
        const { start_date, end_date } = req.query;

        const attendanceHistory = await prisma.attendance.findMany({
            where: {
                user_id: parseInt(user_id),
                attendance_date: {
                    gte: start_date ? new Date(start_date) : undefined,
                    lte: end_date ? new Date(end_date) : undefined
                }
            },
            orderBy: {
                attendance_date: 'desc'
            },
            include: {
                users: {
                    select: {
                        user_name: true,
                        full_name: true
                    }
                }
            }
        });

        const totalAttendance = await prisma.attendance.count({
            where: {
                user_id: parseInt(user_id)
            }
        });

        res.status(200).json({
            status: 'success',
            data: {
                attendance: attendanceHistory,
                total: totalAttendance
            }
        });

    } catch (error) {
        console.error('Error fetching attendance history:', error);
        res.status(500).json({
            status: 'failure',
            message: 'Server error'
        });
    }
};

// Get today's attendance
export const getTodayAttendance = async (req, res) => {
    try {
        const today = new Date();
        today.setHours(0, 0, 0, 0);

        const attendance = await prisma.attendance.findMany({
            where: {
                attendance_date: {
                    equals: today
                }
            },
            include: {
                users: {
                    select: {
                        user_name: true,
                        full_name: true
                    }
                }
            },
            orderBy: {
                attendance_date: 'desc'
            }
        });

        res.status(200).json({
            status: 'success',
            data: attendance
        });

    } catch (error) {
        console.error('Error fetching today\'s attendance:', error);
        res.status(500).json({
            status: 'failure',
            message: 'Server error'
        });
    }
};