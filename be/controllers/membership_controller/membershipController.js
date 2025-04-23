import prisma from '../../prisma/prisma.js';
import { body, validationResult } from 'express-validator';
import { sendMembershipApprovalEmail, sendWelcomeEmail } from '../../utils/sendMail.js';



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
            message: 'Membership plan crated successfully',
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

export const createMembership = async (req, res) => {
    try {

        // convert the user id to integer
        // req.body.user_id = parseInt(req.body.user_id);


        // Validate input
        await Promise.all([
            body('plan_id').isInt().withMessage('Invalid plan ID').run(req),
            body('payment_method').isIn(['Khalti', 'Cash']).withMessage('Invalid payment method').run(req)
        ]);

        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({
                status: 'failure',
                message: 'Validation failed',
                errors: errors.array()
            });
        }

        const { user_id, plan_id, payment_method } = req.body;

        // Check if user exists
        const user = await prisma.users.findUnique({
            where: { user_id: parseInt(user_id) }
        });

        if (!user) {
            return res.status(404).json({
                status: 'failure',
                message: 'User not found'
            });
        }

        // Check if plan exists
        const plan = await prisma.membership_plan.findUnique({
            where: { plan_id: parseInt(plan_id) }
        });

        if (!plan) {
            return res.status(404).json({
                status: 'failure',
                message: 'Membership plan not found'
            });
        }


        const existingMembership = await prisma.memberships.findFirst({
            where: {
                user_id: parseInt(user_id),
                OR: [
                    { status: 'Pending' },
                    {
                        status: 'Active',
                        end_date: { gte: new Date() }
                    }
                ]
            }
        });

        if (existingMembership) {
            return res.status(400).json({
                status: 'failure',
                message: 'User already has an active or pending membership'
            });
        }

        // Create membership with pending status
        const membership = await prisma.memberships.create({
            data: {
                user_id: parseInt(user_id),
                plan_id: parseInt(plan_id),
                status: 'Pending', // Initial status
                start_date: new Date(),
                end_date: new Date(),
                payments: {
                    create: {
                        user_id: parseInt(user_id),
                        price: plan.price,
                        payment_method,
                        payment_status: 'Pending',
                        transaction_id: `TXN-${Date.now()}-${user_id}`,
                        payment_date: new Date()
                    }
                }
            },
            include: {
                payments: true,
                membership_plan: true
            }
        });

        res.status(201).json({
            status: 'success',
            message: 'Membership application submitted for admin approval',
            data: membership
        });

    } catch (error) {
        console.error('Error creating membership:', error);
        res.status(500).json({
            status: 'failure',
            message: 'Internal server error',
            error: error.message
        });
    }
};


export const getUserMembershipStatus = async (req, res) => {
    try {
        const { user_id } = req.params;

        // Fetch the user's latest membership (Pending or Active)
        const membership = await prisma.memberships.findFirst({
            where: {
                user_id: parseInt(user_id),
                status: {
                    in: ['Pending', 'Active', 'Expired']
                }
            },
            orderBy: {
                created_at: 'desc'
            },
            include: {
                membership_plan: true,
                payments: true
            }
        });

        if (!membership) {
            return res.status(404).json({
                status: 'failure',
                message: 'No membership found for this user'
            });
        }

        // Construct the response
        res.status(200).json({
            status: 'success',
            message: 'Membership status retrieved successfully',
            data: {
                membership_id: membership.membership_id,
                plan_type: membership.membership_plan.plan_type,
                price: membership.membership_plan.price,
                start_date: membership.start_date,
                end_date: membership.end_date,
                status: membership.status,
                payment_status: membership.payments.length > 0 ? membership.payments[0].payment_status : 'Not Paid',
                payment_method: membership.payments.length > 0 ? membership.payments[0].payment_method : 'N/A'
            }
        });
    } catch (error) {
        console.error('Error fetching membership status:', error);
        res.status(500).json({
            status: 'failure',
            message: 'Server error',
            error: error.message
        });
    }
};


//! for admin


// Create a membership plan
export const createMembershipPlan = async (req, res) => {
    try {
        // Validation
        await body('plan_type').isIn(['Monthly', 'Yearly', 'Quaterly']).withMessage('Invalid plan type').run(req);
        await body('price').isFloat({ min: 0 }).withMessage('Invalid price').run(req);
        await body('duration').isInt({ min: 1 }).withMessage('Invalid duration').run(req); // Duration should be an integer greater than 0
        await body('description').isLength({ min: 1 }).withMessage('Description cannot be empty').run(req); // Ensure description is not empty


        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({
                status: 'failure',
                message: 'Validation failed',
                errors: errors.array()
            });
        }

        const { plan_type, price, duration, description } = req.body;

        const plan = await prisma.membership_plan.create({
            data: {
                plan_type,
                price,
                duration,
                description
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
            message: 'Active membership found',
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

//! new one


// Get pending memberships for admin approval
export const getPendingMemberships = async (req, res) => {
    try {
        const pendingMemberships = await prisma.memberships.findMany({
            where: { status: 'Pending' },
            include: {
                users: true,
                membership_plan: true,
                payments: true
            }
        });

        res.status(200).json({ status: 'success', data: pendingMemberships });
    } catch (error) {
        console.error('Error fetching pending memberships:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};




// Approve membership and assign card number
export const approveMembership = async (req, res) => {
    try {
        const { membershipId } = req.params;
        const { card_number } = req.body;

        // Validate input
        if (!card_number) {
            return res.status(400).json({
                status: 'failure',
                message: 'Card number is required'
            });
        }

        // Check membership existence
        const membership = await prisma.memberships.findUnique({
            where: { membership_id: parseInt(membershipId) },
            include: {
                membership_plan: true,
                payments: true,
                users: true
            }
        });

        if (!membership || membership.status !== 'Pending') {
            return res.status(404).json({
                status: 'failure',
                message: 'Membership not found or not pending'
            });
        }

        // Check if card number is unique
        const existingUser = await prisma.users.findFirst({
            where: { card_number }
        });

        if (existingUser) {
            return res.status(400).json({
                status: 'failure',
                message: 'Card number already in use'
            });
        }

        // Calculate membership dates
        const start_date = new Date();
        let end_date = new Date(start_date);

        switch (membership.membership_plan.plan_type) {
            case 'Monthly':
                end_date.setMonth(end_date.getMonth() + 1);
                break;
            case 'Quaterly':
                end_date.setMonth(end_date.getMonth() + 3);
                break;
            case 'Yearly':
                end_date.setFullYear(end_date.getFullYear() + 1);
                break;
            default:
                return res.status(400).json({
                    status: 'failure',
                    message: 'Invalid plan type'
                });
        }

        // Update membership
        const updatedMembership = await prisma.memberships.update({
            where: { membership_id: parseInt(membershipId) },
            data: {
                status: 'Active',
                start_date,
                end_date
            }
        });

        // Update payment status
        await prisma.payments.update({
            where: { payment_id: membership.payments[0].payment_id },
            data: { payment_status: 'Paid' }
        });

        // Assign card to user
        await prisma.users.update({
            where: { user_id: membership.user_id },
            data: { card_number }
        });

        // Get user details for email
        const user = await prisma.users.findUnique({
            where: { user_id: membership.user_id }
        });

        // Send membership approval email
        if (user && user.email) {
            try {
                const emailSent = await sendMembershipApprovalEmail(user.email, user.full_name || user.user_name);
                if (!emailSent) {
                    console.error("Failed to send membership approval email to user:", user.email);
                } else {
                    console.log("Successfully sent membership approval email to:", user.email);
                }
            } catch (emailError) {
                console.error("Error sending membership approval email:", emailError);
                // Don't return error response here - we still want to return success for the membership approval
            }
        }

        res.status(200).json({
            status: 'success',
            message: 'Membership approved successfully',
            data: updatedMembership
        });

    } catch (error) {
        console.error('Error approving membership:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};

// Update user card number
export const updateUserCard = async (req, res) => {
    try {
        // Validate input
        await Promise.all([
            body('card_number').isString().notEmpty().withMessage('Card number is required').run(req),
            body('user_id').isInt().withMessage('Invalid user ID').run(req)
        ]);

        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({
                status: 'failure',
                message: 'Validation failed',
                errors: errors.array()
            });
        }

        const { user_id } = req.params;
        const { card_number } = req.body;

        // Check if user exists
        const user = await prisma.users.findUnique({
            where: { user_id: parseInt(user_id) }
        });

        if (!user) {
            return res.status(404).json({
                status: 'failure',
                message: 'User not found'
            });
        }

        // Check if card number is already in use
        const existingCard = await prisma.users.findFirst({
            where: {
                card_number: card_number,
                NOT: {
                    user_id: parseInt(user_id)
                }
            }
        });

        if (existingCard) {
            return res.status(400).json({
                status: 'failure',
                message: 'Card number already assigned to another user'
            });
        }

        // Update user's card number
        const updatedUser = await prisma.users.update({
            where: { user_id: parseInt(user_id) },
            data: { card_number },
            select: {
                user_id: true,
                full_name: true,
                card_number: true,
                email: true
            }
        });

        res.status(200).json({
            status: 'success',
            message: 'Card number updated successfully',
            data: updatedUser
        });

    } catch (error) {
        console.error('Error updating card number:', error);
        res.status(500).json({
            status: 'failure',
            message: 'Internal server error',
            error: error.message
        });
    }
};


