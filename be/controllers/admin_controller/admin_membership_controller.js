// import { PrismaClient } from '@prisma/client';
// import { body, validationResult, param, query } from 'express-validator';

// const prisma = new PrismaClient();

// /**
//  * Get all memberships
//  * Retrieves all membership records with optional status filter
//  * Includes user and plan details
//  */
// export const getAllMemberships = async (req, res) => {
//     const { status, page = 1, limit = 20 } = req.query;

//     try {
//         // Build query filter
//         const whereCondition = status ? { status } : {};

//         // Calculate pagination
//         const skip = (parseInt(page) - 1) * parseInt(limit);

//         // Get paginated membership records
//         const memberships = await prisma.memberships.findMany({
//             where: whereCondition,
//             include: {
//                 users: {
//                     select: {
//                         user_id: true,
//                         full_name: true,
//                         email: true,
//                         phone_number: true
//                     }
//                 },
//                 membership_plan: true,
//                 payments: {
//                     select: {
//                         payment_id: true,
//                         price: true,
//                         payment_method: true,
//                         payment_date: true,
//                         payment_status: true
//                     }
//                 }
//             },
//             orderBy: { created_at: 'desc' },
//             skip,
//             take: parseInt(limit)
//         });

//         // Get total count for pagination
//         const totalRecords = await prisma.memberships.count({
//             where: whereCondition
//         });

//         // Calculate total pages
//         const totalPages = Math.ceil(totalRecords / parseInt(limit));

//         res.status(200).json({
//             status: 'success',
//             message: 'Memberships fetched successfully',
//             data: {
//                 memberships,
//                 pagination: {
//                     total: totalRecords,
//                     pages: totalPages,
//                     current_page: parseInt(page),
//                     per_page: parseInt(limit)
//                 }
//             }
//         });
//     } catch (error) {
//         console.error('Error fetching memberships:', error);
//         res.status(500).json({
//             status: 'error',
//             message: 'Failed to fetch memberships'
//         });
//     }
// };

// /**
//  * Get membership details
//  * Retrieves detailed information about a specific membership
//  */
// export const getMembershipDetails = async (req, res) => {
//     try {
//         const { id } = req.params;

        

//         const membership = await prisma.memberships.findUnique({
//             where: { membership_id: parseInt(id) },
//             include: {
//                 users: {
//                     select: {
//                         user_id: true,
//                         full_name: true,
//                         email: true,
//                         phone_number: true
//                     }
//                 },
//                 membership_plan: true,
//                 payments: {
//                     orderBy: { payment_date: 'desc' }
//                 },
//                 subscription_changes: {
//                     include: {
//                         memberships: true
//                     },
//                     orderBy: { change_date: 'desc' }
//                 }
//             }
//         });

//         if (!membership) {
//             return res.status(404).json({
//                 status: 'error',
//                 message: 'Membership not found'
//             });
//         }

//         res.status(200).json({
//             status: 'success',
//             message: 'Membership details fetched successfully',
//             data: membership
//         });
//     } catch (error) {
//         console.error('Error fetching membership details:', error);
//         res.status(500).json({
//             status: 'error',
//             message: 'Failed to fetch membership details'
//         });
//     }
// };

// /**
//  * Update membership status
//  * Changes the status of a membership (Active, Expired, Cancelled, Pending)
//  */
// export const updateMembershipStatus = async (req, res) => {
//     try {
//         // Validate request
//         await param('id').isInt().withMessage('Valid membership ID is required').run(req);
//         await body('status').isIn(['Active', 'Expired', 'Cancelled', 'Pending'])
//             .withMessage('Status must be one of: Active, Expired, Cancelled, Pending').run(req);

//         const errors = validationResult(req);
//         if (!errors.isEmpty()) {
//             return res.status(400).json({
//                 status: 'error',
//                 message: 'Validation failed',
//                 errors: errors.array()
//             });
//         }

//         const { id } = req.params;
//         const { status } = req.body;

//         // Check if membership exists
//         const membership = await prisma.memberships.findUnique({
//             where: { membership_id: parseInt(id) }
//         });

//         if (!membership) {
//             return res.status(404).json({
//                 status: 'error',
//                 message: 'Membership not found'
//             });
//         }

//         // Update membership status
//         const updatedMembership = await prisma.memberships.update({
//             where: { membership_id: parseInt(id) },
//             data: {
//                 status,
//                 updated_at: new Date()
//             }
//         });

//         res.status(200).json({
//             status: 'success',
//             message: `Membership ${status.toLowerCase()} successfully`,
//             data: updatedMembership
//         });
//     } catch (error) {
//         console.error('Error updating membership:', error);
//         res.status(500).json({
//             status: 'error',
//             message: 'Failed to update membership status'
//         });
//     }
// };

// /**
//  * Create a new membership
//  * Allows admin to manually create a membership for a user
//  */
// export const createMembership = async (req, res) => {
//     try {
//         // Validate request
//         await body('user_id').isInt().withMessage('Valid user ID is required').run(req);
//         await body('plan_id').isInt().withMessage('Valid plan ID is required').run(req);
//         await body('start_date').isDate().withMessage('Valid start date is required').run(req);
//         await body('end_date').isDate().withMessage('Valid end date is required').run(req);
//         await body('status').isIn(['Active', 'Pending'])
//             .withMessage('Status must be either Active or Pending').run(req);

//         const errors = validationResult(req);
//         if (!errors.isEmpty()) {
//             return res.status(400).json({
//                 status: 'error',
//                 message: 'Validation failed',
//                 errors: errors.array()
//             });
//         }

//         const { user_id, plan_id, start_date, end_date, status } = req.body;

//         // Check if user exists
//         const user = await prisma.users.findUnique({
//             where: { user_id: parseInt(user_id) }
//         });

//         if (!user) {
//             return res.status(404).json({
//                 status: 'error',
//                 message: 'User not found'
//             });
//         }

//         // Check if plan exists
//         const plan = await prisma.membership_plan.findUnique({
//             where: { plan_id: parseInt(plan_id) }
//         });

//         if (!plan) {
//             return res.status(404).json({
//                 status: 'error',
//                 message: 'Membership plan not found'
//             });
//         }

//         // Create the membership
//         const newMembership = await prisma.memberships.create({
//             data: {
//                 user_id: parseInt(user_id),
//                 plan_id: parseInt(plan_id),
//                 start_date: new Date(start_date),
//                 end_date: new Date(end_date),
//                 status,
//                 created_at: new Date(),
//                 updated_at: new Date()
//             }
//         });

//         res.status(201).json({
//             status: 'success',
//             message: 'Membership created successfully',
//             data: newMembership
//         });
//     } catch (error) {
//         console.error('Error creating membership:', error);
//         res.status(500).json({
//             status: 'error',
//             message: 'Failed to create membership'
//         });
//     }
// };

// /**
//  * Update membership details
//  * Modifies membership information like dates and plan
//  */
// export const updateMembership = async (req, res) => {
//     try {
//         // Validate request
//         await param('id').isInt().withMessage('Valid membership ID is required').run(req);
//         await body('plan_id').optional().isInt().withMessage('Valid plan ID is required').run(req);
//         await body('start_date').optional().isDate().withMessage('Valid start date is required').run(req);
//         await body('end_date').optional().isDate().withMessage('Valid end date is required').run(req);

//         const errors = validationResult(req);
//         if (!errors.isEmpty()) {
//             return res.status(400).json({
//                 status: 'error',
//                 message: 'Validation failed',
//                 errors: errors.array()
//             });
//         }

//         const { id } = req.params;
//         const { plan_id, start_date, end_date } = req.body;

//         // Check if membership exists
//         const membership = await prisma.memberships.findUnique({
//             where: { membership_id: parseInt(id) }
//         });

//         if (!membership) {
//             return res.status(404).json({
//                 status: 'error',
//                 message: 'Membership not found'
//             });
//         }

//         // If changing plan, record the change
//         if (plan_id && plan_id !== membership.plan_id) {
//             // Check if new plan exists
//             const plan = await prisma.membership_plan.findUnique({
//                 where: { plan_id: parseInt(plan_id) }
//             });

//             if (!plan) {
//                 return res.status(404).json({
//                     status: 'error',
//                     message: 'New membership plan not found'
//                 });
//             }

//             // Record plan change
//             await prisma.subscription_changes.create({
//                 data: {
//                     membership_id: parseInt(id),
//                     previous_plan: membership.plan_id,
//                     new_plan: parseInt(plan_id),
//                     change_date: new Date(),
//                     action: 'Plan changed by admin'
//                 }
//             });
//         }

//         // Update the membership
//         const updatedMembership = await prisma.memberships.update({
//             where: { membership_id: parseInt(id) },
//             data: {
//                 ...(plan_id ? { plan_id: parseInt(plan_id) } : {}),
//                 ...(start_date ? { start_date: new Date(start_date) } : {}),
//                 ...(end_date ? { end_date: new Date(end_date) } : {}),
//                 updated_at: new Date()
//             }
//         });

//         res.status(200).json({
//             status: 'success',
//             message: 'Membership updated successfully',
//             data: updatedMembership
//         });
//     } catch (error) {
//         console.error('Error updating membership:', error);
//         res.status(500).json({
//             status: 'error',
//             message: 'Failed to update membership'
//         });
//     }
// };

// /**
//  * Get all payments with filtering options
//  * Retrieves payment records with date range and status filters
//  */
// export const getAllPayments = async (req, res) => {
//     const { status, startDate, endDate, page = 1, limit = 20 } = req.query;

//     const dateFilter = {};
//     if (startDate) dateFilter.gte = new Date(startDate);
//     if (endDate) dateFilter.lte = new Date(endDate);

//     try {
//         // Build query conditions
//         const whereCondition = {};
//         if (status) whereCondition.payment_status = status;
//         if (startDate || endDate) whereCondition.payment_date = dateFilter;

//         // Calculate pagination
//         const skip = (parseInt(page) - 1) * parseInt(limit);

//         // Get paginated payment records
//         const payments = await prisma.payments.findMany({
//             where: whereCondition,
//             include: {
//                 users: {
//                     select: {
//                         user_id: true,
//                         full_name: true,
//                         email: true
//                     }
//                 },
//                 memberships: {
//                     include: {
//                         membership_plan: true
//                     }
//                 }
//             },
//             orderBy: { payment_date: 'desc' },
//             skip,
//             take: parseInt(limit)
//         });

//         // Get total count for pagination
//         const totalRecords = await prisma.payments.count({
//             where: whereCondition
//         });

//         // Calculate total pages
//         const totalPages = Math.ceil(totalRecords / parseInt(limit));

//         // Calculate total revenue
//         const totalRevenue = await prisma.payments.aggregate({
//             where: {
//                 ...whereCondition,
//                 payment_status: 'Paid'
//             },
//             _sum: {
//                 price: true
//             }
//         });

//         res.status(200).json({
//             status: 'success',
//             message: 'Payments fetched successfully',
//             data: {
//                 payments,
//                 pagination: {
//                     total: totalRecords,
//                     pages: totalPages,
//                     current_page: parseInt(page),
//                     per_page: parseInt(limit)
//                 },
//                 summary: {
//                     totalRevenue: totalRevenue._sum.price || 0
//                 }
//             }
//         });
//     } catch (error) {
//         console.error('Error fetching payments:', error);
//         res.status(500).json({
//             status: 'error',
//             message: 'Failed to fetch payments'
//         });
//     }
// };




// // Approve membership and assign card number
// export const approveMembershipByAdmin = async (req, res) => {
//     try {
//         const { membershipId } = req.params;
//         const { card_number } = req.body;

//         // Validate input
//         if (!card_number) {
//             return res.status(400).json({
//                 status: 'failure',
//                 message: 'Card number is required'
//             });
//         }

//         // Check membership existence
//         const membership = await prisma.memberships.findUnique({
//             where: { membership_id: parseInt(membershipId) },
//             include: {
//                 membership_plan: true,
//                 payments: true,
//                 users: true
//             }
//         });

//         if (!membership || membership.status !== 'Pending') {
//             return res.status(404).json({
//                 status: 'failure',
//                 message: 'Membership not found or not pending'
//             });
//         }

//         // Check if card number is unique
//         const existingUser = await prisma.users.findFirst({
//             where: { card_number }
//         });

//         if (existingUser) {
//             return res.status(400).json({
//                 status: 'failure',
//                 message: 'Card number already in use'
//             });
//         }

//         // Calculate membership dates
//         const start_date = new Date();
//         let end_date = new Date(start_date);

//         switch (membership.membership_plan.plan_type) {
//             case 'Monthly':
//                 end_date.setMonth(end_date.getMonth() + 1);
//                 break;
//             case 'Quaterly':
//                 end_date.setMonth(end_date.getMonth() + 3);
//                 break;
//             case 'Yearly':
//                 end_date.setFullYear(end_date.getFullYear() + 1);
//                 break;
//             default:
//                 return res.status(400).json({
//                     status: 'failure',
//                     message: 'Invalid plan type'
//                 });
//         }

//         // Update membership
//         const updatedMembership = await prisma.memberships.update({
//             where: { membership_id: parseInt(membershipId) },
//             data: {
//                 status: 'Active',
//                 start_date,
//                 end_date
//             }
//         });

//         // Update payment status
//         await prisma.payments.update({
//             where: { payment_id: membership.payments[0].payment_id },
//             data: { payment_status: 'Paid' }
//         });

//         // Assign card to user
//         await prisma.users.update({
//             where: { user_id: membership.user_id },
//             data: { card_number }
//         });

//         res.status(200).json({
//             status: 'success',
//             message: 'Membership approved successfully',
//             data: updatedMembership
//         });

//     } catch (error) {
//         console.error('Error approving membership:', error);
//         res.status(500).json({ status: 'failure', message: 'Server error' });
//     }
// };


// // Update user card number
// export const updateUserCardByAdmin = async (req, res) => {
//     try {
//         // Validate input
//         await Promise.all([
//             body('card_number').isString().notEmpty().withMessage('Card number is required').run(req),
//             body('user_id').isInt().withMessage('Invalid user ID').run(req)
//         ]);

//         const errors = validationResult(req);
//         if (!errors.isEmpty()) {
//             return res.status(400).json({
//                 status: 'failure',
//                 message: 'Validation failed',
//                 errors: errors.array()
//             });
//         }

//         const { user_id } = req.params;
//         const { card_number } = req.body;

//         // Check if user exists
//         const user = await prisma.users.findUnique({
//             where: { user_id: parseInt(user_id) }
//         });

//         if (!user) {
//             return res.status(404).json({
//                 status: 'failure',
//                 message: 'User not found'
//             });
//         }

//         // Check if card number is already in use
//         const existingCard = await prisma.users.findFirst({
//             where: {
//                 card_number: card_number,
//                 NOT: {
//                     user_id: parseInt(user_id)
//                 }
//             }
//         });

//         if (existingCard) {
//             return res.status(400).json({
//                 status: 'failure',
//                 message: 'Card number already assigned to another user'
//             });
//         }

//         // Update user's card number
//         const updatedUser = await prisma.users.update({
//             where: { user_id: parseInt(user_id) },
//             data: { card_number },
//             select: {
//                 user_id: true,
//                 full_name: true,
//                 card_number: true,
//                 email: true
//             }
//         });

//         res.status(200).json({
//             status: 'success',
//             message: 'Card number updated successfully',
//             data: updatedUser
//         });

//     } catch (error) {
//         console.error('Error updating card number:', error);
//         res.status(500).json({
//             status: 'failure',
//             message: 'Internal server error',
//             error: error.message
//         });
//     }
// };


// /**
//  * Get all membership plans
//  * Retrieves all available membership plans
//  */
// export const getAllMembershipPlans = async (req, res) => {
//     try {
//         const plans = await prisma.membership_plan.findMany({
//             orderBy: { plan_type: 'asc' }
//         });

//         res.status(200).json({
//             status: 'success',
//             message: 'Membership plans fetched successfully',
//             data: plans
//         });
//     } catch (error) {
//         console.error('Error fetching membership plans:', error);
//         res.status(500).json({
//             status: 'error',
//             message: 'Failed to fetch membership plans'
//         });
//     }
// };

// // Cancel a user's membership (admin only)
// export const cancelMembershipByAdmin = async (req, res) => {
//     try {
//         const { membershipId } = req.params;

//         // Cancel the membership by setting status to "Cancelled"
//         const canceledMembership = await prisma.memberships.update({
//             where: { membership_id: parseInt(membershipId) },
//             data: { status: 'Cancelled' }
//         });

//         res.status(200).json({
//             status: 'success',
//             message: 'Membership cancelled successfully',
//             data: canceledMembership
//         });
//     } catch (error) {
//         console.error('Error cancelling membership:', error);
//         res.status(500).json({ status: 'failure', message: 'Server error' });
//     }
// };




// // Get membership changes history
// export const getMembershipChangesHistoryByAdmin = async (req, res) => {
//     try {
//         const { membershipId } = req.params;

//         // Fetch subscription changes for the given membership
//         const changes = await prisma.subscription_changes.findMany({
//             where: { membership_id: parseInt(membershipId) },
//             include: {
//                 memberships: true
//             }
//         });

//         res.status(200).json({
//             status: 'success',
//             message: 'Membership change history fetched successfully',
//             data: changes
//         });
//     } catch (error) {
//         console.error('Error fetching membership changes:', error);
//         res.status(500).json({ status: 'failure', message: 'Server error' });
//     }
// };



import { PrismaClient } from '@prisma/client';
import { body, validationResult, param, query } from 'express-validator';

const prisma = new PrismaClient();

/**
 * Get all memberships
 * Retrieves all membership records with optional status filter
 * Includes user and plan details
 */
export const getAllMemberships = async (req, res) => {
    const { status, page = 1, limit = 20 } = req.query;

    try {
        // Build query filter
        const whereCondition = status ? { status } : {};

        // Calculate pagination
        const skip = (parseInt(page) - 1) * parseInt(limit);

        // Get paginated membership records
        const memberships = await prisma.memberships.findMany({
            where: whereCondition,
            include: {
                users: {
                    select: {
                        user_id: true,
                        full_name: true,
                        email: true,
                        phone_number: true,
                        card_number: true,
                        profile_image: true,
                        user_name: true,
                        address: true,
                        role: true
                    }
                },
                membership_plan: true,
                payments: {
                    select: {
                        payment_id: true,
                        price: true,
                        payment_method: true,
                        payment_date: true,
                        payment_status: true
                    }
                }
            },
            orderBy: { created_at: 'desc' },
            skip,
            take: parseInt(limit)
        });

        // Get total count for pagination
        const totalRecords = await prisma.memberships.count({
            where: whereCondition
        });

        // Calculate total pages
        const totalPages = Math.ceil(totalRecords / parseInt(limit));

        res.status(200).json({
            status: 'success',
            message: 'Memberships fetched successfully',
            data: {
                memberships,
                pagination: {
                    total: totalRecords,
                    pages: totalPages,
                    current_page: parseInt(page),
                    per_page: parseInt(limit)
                }
            }
        });
    } catch (error) {
        console.error('Error fetching memberships:', error);
        res.status(500).json({
            status: 'error',
            message: 'Failed to fetch memberships'
        });
    }
};

/**
 * Get membership details
 * Retrieves detailed information about a specific membership
 */
export const getMembershipDetails = async (req, res) => {
    try {
        // Log the params to debug
        console.log('Request params:', req.params);
        
        const { id } = req.params;
        
        // Check if the ID exists and can be parsed as an integer
        if (!id || isNaN(parseInt(id))) {
            console.log('Invalid membership ID provided:', id);
            return res.status(400).json({
                status: 'error',
                message: 'Invalid membership ID format'
            });
        }
        
        const membershipId = parseInt(id);
        console.log('Looking up membership with ID:', membershipId);

        const membership = await prisma.memberships.findUnique({
            where: { membership_id: membershipId },
            include: {
                users: {
                    select: {
                        user_id: true,
                        full_name: true,
                        email: true,
                        phone_number: true,
                        card_number: true,
                        profile_image: true,
                        user_name: true,
                        address: true,
                        role: true
                    }
                },
                membership_plan: true,
                payments: {
                    orderBy: { payment_date: 'desc' }
                },
                subscription_changes: {
                    include: {
                        memberships: true
                    },
                    orderBy: { change_date: 'desc' }
                }
            }
        });

        if (!membership) {
            console.log('Membership not found with ID:', membershipId);
            return res.status(404).json({
                status: 'error',
                message: 'Membership not found'
            });
        }

        console.log('Membership found, returning data');
        res.status(200).json({
            status: 'success',
            message: 'Membership details fetched successfully',
            data: membership
        });
    } catch (error) {
        console.error('Error fetching membership details:', error);
        res.status(500).json({
            status: 'error',
            message: 'Failed to fetch membership details'
        });
    }
};

/**
 * Update membership status
 * Changes the status of a membership (Active, Expired, Cancelled, Pending)
 */
export const updateMembershipStatus = async (req, res) => {
    try {
        // Validate request
        await param('id').isInt().withMessage('Valid membership ID is required').run(req);
        await body('status').isIn(['Active', 'Expired', 'Cancelled', 'Pending'])
            .withMessage('Status must be one of: Active, Expired, Cancelled, Pending').run(req);

        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({
                status: 'error',
                message: 'Validation failed',
                errors: errors.array()
            });
        }

        const { id } = req.params;
        const { status } = req.body;

        // Check if membership exists
        const membership = await prisma.memberships.findUnique({
            where: { membership_id: parseInt(id) }
        });

        if (!membership) {
            return res.status(404).json({
                status: 'error',
                message: 'Membership not found'
            });
        }

        // Update membership status
        const updatedMembership = await prisma.memberships.update({
            where: { membership_id: parseInt(id) },
            data: {
                status,
                updated_at: new Date()
            }
        });

        res.status(200).json({
            status: 'success',
            message: `Membership ${status.toLowerCase()} successfully`,
            data: updatedMembership
        });
    } catch (error) {
        console.error('Error updating membership:', error);
        res.status(500).json({
            status: 'error',
            message: 'Failed to update membership status'
        });
    }
};

/**
 * Create a new membership
 * Allows admin to manually create a membership for a user
 */
// export const createMembership = async (req, res) => {
//     try {
//         // Validate request
//         await body('user_id').isInt().withMessage('Valid user ID is required').run(req);
//         await body('plan_id').isInt().withMessage('Valid plan ID is required').run(req);
//         await body('start_date').isDate().withMessage('Valid start date is required').run(req);
//         await body('end_date').isDate().withMessage('Valid end date is required').run(req);
//         await body('status').isIn(['Active', 'Pending'])
//             .withMessage('Status must be either Active or Pending').run(req);

//         const errors = validationResult(req);
//         if (!errors.isEmpty()) {
//             return res.status(400).json({
//                 status: 'error',
//                 message: 'Validation failed',
//                 errors: errors.array()
//             });
//         }

//         const { user_id, plan_id, start_date, end_date, status } = req.body;

//         // Check if user exists
//         const user = await prisma.users.findUnique({
//             where: { user_id: parseInt(user_id) }
//         });

//         if (!user) {
//             return res.status(404).json({
//                 status: 'error',
//                 message: 'User not found'
//             });
//         }

//         // Check if plan exists
//         const plan = await prisma.membership_plan.findUnique({
//             where: { plan_id: parseInt(plan_id) }
//         });

//         if (!plan) {
//             return res.status(404).json({
//                 status: 'error',
//                 message: 'Membership plan not found'
//             });
//         }

//         // Create the membership
//         const newMembership = await prisma.memberships.create({
//             data: {
//                 user_id: parseInt(user_id),
//                 plan_id: parseInt(plan_id),
//                 start_date: new Date(start_date),
//                 end_date: new Date(end_date),
//                 status,
//                 created_at: new Date(),
//                 updated_at: new Date()
//             }
//         });

//         res.status(201).json({
//             status: 'success',
//             message: 'Membership created successfully',
//             data: newMembership
//         });
//     } catch (error) {
//         console.error('Error creating membership:', error);
//         res.status(500).json({
//             status: 'error',
//             message: 'Failed to create membership'
//         });
//     }
// };

/**
 * Create a new membership
 * Allows admin to manually create a membership for a user
 */
export const createMembership = async (req, res) => {
    try {
        // Validate request
        await body('user_id').isInt().withMessage('Valid user ID is required').run(req);
        await body('plan_id').isInt().withMessage('Valid plan ID is required').run(req);
        await body('start_date').isDate().withMessage('Valid start date is required').run(req);
        await body('end_date').isDate().withMessage('Valid end date is required').run(req);
        await body('status').isIn(['Active', 'Pending'])
            .withMessage('Status must be either Active or Pending').run(req);
        await body('payment_method').isIn(['Cash', 'Khalti', 'Online'])
            .withMessage('Payment method must be Cash, Khalti, or Online').run(req);

        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({
                status: 'error',
                message: 'Validation failed',
                errors: errors.array()
            });
        }

        const { user_id, plan_id, start_date, end_date, status, payment_method } = req.body;

        // Check if user exists
        const user = await prisma.users.findUnique({
            where: { user_id: parseInt(user_id) }
        });

        if (!user) {
            return res.status(404).json({
                status: 'error',
                message: 'User not found'
            });
        }

        // Check if plan exists
        const plan = await prisma.membership_plan.findUnique({
            where: { plan_id: parseInt(plan_id) }
        });

        if (!plan) {
            return res.status(404).json({
                status: 'error',
                message: 'Membership plan not found'
            });
        }

        // Create the membership
        const newMembership = await prisma.memberships.create({
            data: {
                user_id: parseInt(user_id),
                plan_id: parseInt(plan_id),
                start_date: new Date(start_date),
                end_date: new Date(end_date),
                status,
                created_at: new Date(),
                updated_at: new Date()
            }
        });

        // Create payment record if payment method is provided
        if (payment_method) {
            const transaction_id = `MANUAL-${Date.now()}-${Math.floor(Math.random() * 1000)}`;
            
            await prisma.payments.create({
                data: {
                    membership_id: newMembership.membership_id,
                    user_id: parseInt(user_id),
                    price: plan.price,
                    payment_method,
                    transaction_id,
                    payment_date: new Date(),
                    payment_status: status === 'Active' ? 'Paid' : 'Pending'
                }
            });
        }

        res.status(201).json({
            status: 'success',
            message: 'Membership created successfully',
            data: newMembership
        });
    } catch (error) {
        console.error('Error creating membership:', error);
        res.status(500).json({
            status: 'error',
            message: 'Failed to create membership'
        });
    }
};

/**
 * Update membership details
 * Modifies membership information like dates and plan
 */
export const updateMembership = async (req, res) => {
    try {
        // Validate request
        await param('id').isInt().withMessage('Valid membership ID is required').run(req);
        await body('plan_id').optional().isInt().withMessage('Valid plan ID is required').run(req);
        await body('start_date').optional().isDate().withMessage('Valid start date is required').run(req);
        await body('end_date').optional().isDate().withMessage('Valid end date is required').run(req);

        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({
                status: 'error',
                message: 'Validation failed',
                errors: errors.array()
            });
        }

        const { id } = req.params;
        const { plan_id, start_date, end_date } = req.body;

        // Check if membership exists
        const membership = await prisma.memberships.findUnique({
            where: { membership_id: parseInt(id) }
        });

        if (!membership) {
            return res.status(404).json({
                status: 'error',
                message: 'Membership not found'
            });
        }

        // If changing plan, record the change
        if (plan_id && plan_id !== membership.plan_id) {
            // Check if new plan exists
            const plan = await prisma.membership_plan.findUnique({
                where: { plan_id: parseInt(plan_id) }
            });

            if (!plan) {
                return res.status(404).json({
                    status: 'error',
                    message: 'New membership plan not found'
                });
            }

            // Record plan change
            await prisma.subscription_changes.create({
                data: {
                    membership_id: parseInt(id),
                    previous_plan: membership.plan_id,
                    new_plan: parseInt(plan_id),
                    change_date: new Date(),
                    action: 'Plan changed by admin'
                }
            });
        }

        // Update the membership
        const updatedMembership = await prisma.memberships.update({
            where: { membership_id: parseInt(id) },
            data: {
                ...(plan_id ? { plan_id: parseInt(plan_id) } : {}),
                ...(start_date ? { start_date: new Date(start_date) } : {}),
                ...(end_date ? { end_date: new Date(end_date) } : {}),
                updated_at: new Date()
            }
        });

        res.status(200).json({
            status: 'success',
            message: 'Membership updated successfully',
            data: updatedMembership
        });
    } catch (error) {
        console.error('Error updating membership:', error);
        res.status(500).json({
            status: 'error',
            message: 'Failed to update membership'
        });
    }
};

/**
 * Get all payments with filtering options
 * Retrieves payment records with date range and status filters
 */
export const getAllPayments = async (req, res) => {
    const { status, startDate, endDate, page = 1, limit = 20 } = req.query;

    const dateFilter = {};
    if (startDate) dateFilter.gte = new Date(startDate);
    if (endDate) dateFilter.lte = new Date(endDate);

    try {
        // Build query conditions
        const whereCondition = {};
        if (status) whereCondition.payment_status = status;
        if (startDate || endDate) whereCondition.payment_date = dateFilter;

        // Calculate pagination
        const skip = (parseInt(page) - 1) * parseInt(limit);

        // Get paginated payment records
        const payments = await prisma.payments.findMany({
            where: whereCondition,
            include: {
                users: {
                    select: {
                        user_id: true,
                        full_name: true,
                        email: true
                    }
                },
                memberships: {
                    include: {
                        membership_plan: true
                    }
                }
            },
            orderBy: { payment_date: 'desc' },
            skip,
            take: parseInt(limit)
        });

        // Get total count for pagination
        const totalRecords = await prisma.payments.count({
            where: whereCondition
        });

        // Calculate total pages
        const totalPages = Math.ceil(totalRecords / parseInt(limit));

        // Calculate total revenue
        const totalRevenue = await prisma.payments.aggregate({
            where: {
                ...whereCondition,
                payment_status: 'Paid'
            },
            _sum: {
                price: true
            }
        });

        res.status(200).json({
            status: 'success',
            message: 'Payments fetched successfully',
            data: {
                payments,
                pagination: {
                    total: totalRecords,
                    pages: totalPages,
                    current_page: parseInt(page),
                    per_page: parseInt(limit)
                },
                summary: {
                    totalRevenue: totalRevenue._sum.price || 0
                }
            }
        });
    } catch (error) {
        console.error('Error fetching payments:', error);
        res.status(500).json({
            status: 'error',
            message: 'Failed to fetch payments'
        });
    }
};

// Approve membership and assign card number
export const approveMembershipByAdmin = async (req, res) => {
    try {
        const { membershipId } = req.params;
        const { card_number } = req.body;

        console.log('Approving membership:', membershipId, 'with card:', card_number);

        // Validate input
        if (!card_number) {
            return res.status(400).json({
                status: 'failure',
                message: 'Card number is required'
            });
        }

        if (!membershipId || isNaN(parseInt(membershipId))) {
            return res.status(400).json({
                status: 'failure',
                message: 'Invalid membership ID format'
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
        if (membership.payments && membership.payments.length > 0) {
            await prisma.payments.update({
                where: { payment_id: membership.payments[0].payment_id },
                data: { payment_status: 'Paid' }
            });
        }

        // Assign card to user
        await prisma.users.update({
            where: { user_id: membership.user_id },
            data: { card_number }
        });

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
export const updateUserCardByAdmin = async (req, res) => {
    try {
        console.log('Updating user card number. Request params:', req.params);
        console.log('Request body:', req.body);
        
        const { userId } = req.params;
        const { card_number } = req.body;

        // Validate inputs without using express-validator
        if (!card_number) {
            return res.status(400).json({
                status: 'failure',
                message: 'Card number is required'
            });
        }

        if (!userId || isNaN(parseInt(userId))) {
            return res.status(400).json({
                status: 'failure',
                message: 'Invalid user ID format'
            });
        }

        const parsedUserId = parseInt(userId);

        // Check if user exists
        const user = await prisma.users.findUnique({
            where: { user_id: parsedUserId }
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
                    user_id: parsedUserId
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
            where: { user_id: parsedUserId },
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

/**
 * Get all membership plans
 * Retrieves all available membership plans
 */
export const getAllMembershipPlans = async (req, res) => {
    try {
        const plans = await prisma.membership_plan.findMany({
            orderBy: { plan_type: 'asc' }
        });

        res.status(200).json({
            status: 'success',
            message: 'Membership plans fetched successfully',
            data: plans
        });
    } catch (error) {
        console.error('Error fetching membership plans:', error);
        res.status(500).json({
            status: 'error',
            message: 'Failed to fetch membership plans'
        });
    }
};

/**
 * Create a new membership plan
 * Allows admin to create a new plan
 */
export const createMembershipPlan = async (req, res) => {
    try {
        // Validate request
        await body('plan_type').isIn(['Monthly', 'Quaterly', 'Yearly'])
            .withMessage('Plan type must be one of: Monthly, Quaterly, Yearly').run(req);
        await body('price').isFloat({ min: 0 }).withMessage('Price must be a positive number').run(req);
        await body('duration').isInt({ min: 1 }).withMessage('Duration must be a positive integer').run(req);
        await body('description').isString().withMessage('Description is required').run(req);

        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({
                status: 'error',
                message: 'Validation failed',
                errors: errors.array()
            });
        }

        const { plan_type, price, duration, description } = req.body;

        // Create the plan
        const newPlan = await prisma.membership_plan.create({
            data: {
                plan_type,
                price: parseFloat(price),
                duration: parseInt(duration),
                description,
                created_at: new Date(),
                updated_at: new Date()
            }
        });

        res.status(201).json({
            status: 'success',
            message: 'Membership plan created successfully',
            data: newPlan
        });
    } catch (error) {
        console.error('Error creating membership plan:', error);
        res.status(500).json({
            status: 'error',
            message: 'Failed to create membership plan'
        });
    }
};

/**
 * Update a membership plan
 * Allows admin to modify an existing plan
 */
export const updateMembershipPlan = async (req, res) => {
    try {
        // Validate request
        await param('planId').isInt().withMessage('Valid plan ID is required').run(req);
        await body('plan_type').optional().isIn(['Monthly', 'Quaterly', 'Yearly'])
            .withMessage('Plan type must be one of: Monthly, Quaterly, Yearly').run(req);
        await body('price').optional().isFloat({ min: 0 }).withMessage('Price must be a positive number').run(req);
        await body('duration').optional().isInt({ min: 1 }).withMessage('Duration must be a positive integer').run(req);
        await body('description').optional().isString().withMessage('Description must be a string').run(req);

        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({
                status: 'error',
                message: 'Validation failed',
                errors: errors.array()
            });
        }

        const { planId } = req.params;
        const { plan_type, price, duration, description } = req.body;

        // Check if plan exists
        const plan = await prisma.membership_plan.findUnique({
            where: { plan_id: parseInt(planId) }
        });

        if (!plan) {
            return res.status(404).json({
                status: 'error',
                message: 'Membership plan not found'
            });
        }

        // Update the plan
        const updatedPlan = await prisma.membership_plan.update({
            where: { plan_id: parseInt(planId) },
            data: {
                ...(plan_type && { plan_type }),
                ...(price && { price: parseFloat(price) }),
                ...(duration && { duration: parseInt(duration) }),
                ...(description && { description }),
                updated_at: new Date()
            }
        });

        res.status(200).json({
            status: 'success',
            message: 'Membership plan updated successfully',
            data: updatedPlan
        });
    } catch (error) {
        console.error('Error updating membership plan:', error);
        res.status(500).json({
            status: 'error',
            message: 'Failed to update membership plan'
        });
    }
};

/**
 * Delete a membership plan
 * Allows admin to remove a plan if it's not in use
 */
export const deleteMembershipPlan = async (req, res) => {
    try {
        const { planId } = req.params;

        // Check if plan exists
        const plan = await prisma.membership_plan.findUnique({
            where: { plan_id: parseInt(planId) }
        });

        if (!plan) {
            return res.status(404).json({
                status: 'error',
                message: 'Membership plan not found'
            });
        }

        // Check if the plan is used by any membership
        const membershipCount = await prisma.memberships.count({
            where: { plan_id: parseInt(planId) }
        });

        if (membershipCount > 0) {
            return res.status(400).json({
                status: 'error',
                message: 'Cannot delete plan that is in use by memberships'
            });
        }

        // Delete the plan
        await prisma.membership_plan.delete({
            where: { plan_id: parseInt(planId) }
        });

        res.status(200).json({
            status: 'success',
            message: 'Membership plan deleted successfully'
        });
    } catch (error) {
        console.error('Error deleting membership plan:', error);
        res.status(500).json({
            status: 'error',
            message: 'Failed to delete membership plan'
        });
    }
};

// Cancel a user's membership (admin only)
export const cancelMembershipByAdmin = async (req, res) => {
    try {
        const { membershipId } = req.params;

        if (!membershipId || isNaN(parseInt(membershipId))) {
            return res.status(400).json({
                status: 'failure',
                message: 'Invalid membership ID format'
            });
        }

        // Cancel the membership by setting status to "Cancelled"
        const canceledMembership = await prisma.memberships.update({
            where: { membership_id: parseInt(membershipId) },
            data: { status: 'Cancelled' }
        });

        res.status(200).json({
            status: 'success',
            message: 'Membership cancelled successfully',
            data: canceledMembership
        });
    } catch (error) {
        console.error('Error cancelling membership:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};

// Get membership changes history
export const getMembershipChangesHistoryByAdmin = async (req, res) => {
    try {
        const { membershipId } = req.params;

        if (!membershipId || isNaN(parseInt(membershipId))) {
            return res.status(400).json({
                status: 'failure',
                message: 'Invalid membership ID format'
            });
        }

        // Fetch subscription changes for the given membership
        const changes = await prisma.subscription_changes.findMany({
            where: { membership_id: parseInt(membershipId) },
            include: {
                memberships: true
            },
            orderBy: { change_date: 'desc' }
        });

        res.status(200).json({
            status: 'success',
            message: 'Membership change history fetched successfully',
            data: changes
        });
    } catch (error) {
        console.error('Error fetching membership changes:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};