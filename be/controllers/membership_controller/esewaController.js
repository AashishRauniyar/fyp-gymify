import { v4 as uuidv4 } from 'uuid';
import prisma from '../../prisma/prisma.js';
import { getEsewaPaymentHash, verifyEsewaPayment } from '../../utils/esewa.js';
import { body, validationResult } from 'express-validator';

export const initializeEsewaPayment = async (req, res) => {
    try {
        // Validate input
        await Promise.all([
            body('plan_id').isInt().withMessage('Invalid plan ID').run(req),
            body('amount').isFloat({ min: 0 }).withMessage('Invalid amount').run(req)
        ]);

        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({
                status: 'failure',
                message: 'Validation failed',
                errors: errors.array()
            });
        }

        const { plan_id, amount } = req.body;
        const userId = req.user.user_id;

        // Check if user exists
        const user = await prisma.users.findUnique({
            where: { user_id: parseInt(userId) }
        });

        if (!user) {
            return res.status(404).json({
                status: 'failure',
                message: 'User not found'
            });
        }

        // Check if plan exists
        const plan = await prisma.membership_plan.findUnique({ where: { plan_id: parseInt(plan_id) } });
        if (!plan) {
            return res.status(404).json({ status: 'failure', message: 'Membership plan not found' });
        }

        // Validate amount matches plan price
        if (parseFloat(amount) !== parseFloat(plan.price)) {
            return res.status(400).json({
                status: 'failure',
                message: 'Amount does not match plan price'
            });
        }

        // Check for existing active or pending membership
        const existingMembership = await prisma.memberships.findFirst({
            where: {
                user_id: parseInt(userId),
                OR: [
                    { status: 'Pending' },
                    { status: 'Active', end_date: { gte: new Date() } }
                ]
            }
        });

        if (existingMembership) {
            return res.status(400).json({
                status: 'failure',
                message: 'User already has an active or pending membership'
            });
        }

        const transaction_uuid = uuidv4();

        // Create membership and payment in a single transaction
        const result = await prisma.$transaction(async (tx) => {
            // Create a new membership entry (Pending)
            const newMembership = await tx.memberships.create({
                data: {
                    user_id: parseInt(userId),
                    plan_id: parseInt(plan_id),
                    status: 'Pending', // Initially pending until payment is verified
                }
            });

            // Get eSewa payment hash
            const paymentHash = await getEsewaPaymentHash({
                amount: parseFloat(amount),
                transaction_uuid: transaction_uuid
            });

            // Create a payment entry linked to the new membership
            const payment = await tx.payments.create({
                data: {
                    memberships: {
                        connect: {
                            membership_id: newMembership.membership_id
                        }
                    },
                    users: {
                        connect: {
                            user_id: parseInt(userId)
                        }
                    },
                    price: parseFloat(amount),
                    payment_method: 'Online',
                    transaction_id: transaction_uuid,
                    payment_status: 'Pending',
                    payment_date: new Date()
                }
            });

            return { newMembership, payment, paymentHash };
        });

        // Calculate tax and total amount
        const tax_amount = 0; // Set your tax calculation logic here
        const product_service_charge = 0;
        const product_delivery_charge = 0;
        const total_amount = parseFloat(amount) + tax_amount + product_service_charge + product_delivery_charge;

        // Ensure FRONTEND_URL is set
        if (!process.env.FRONTEND_URL) {
            throw new Error('FRONTEND_URL environment variable is not set');
        }

        // Construct success and failure URLs
        const success_url = `${process.env.FRONTEND_URL}/payment/success`;
        const failure_url = `${process.env.FRONTEND_URL}/payment/failure`;

        res.status(200).json({
            status: 'success',
            data: {
                amount: amount,
                tax_amount: tax_amount,
                total_amount: total_amount,
                transaction_uuid: transaction_uuid,
                product_code: process.env.ESEWA_PRODUCT_CODE,
                product_service_charge: product_service_charge,
                product_delivery_charge: product_delivery_charge,
                success_url: success_url,
                failure_url: failure_url,
                signed_field_names: result.paymentHash.signed_field_names,
                signature: result.paymentHash.signature,
                plan_details: {
                    plan_name: plan.plan_type,
                    plan_type: plan.plan_type,
                    duration: plan.duration
                }
            },
            message: 'Payment initiated successfully'
        });

    } catch (error) {
        console.error('Error initializing eSewa payment:', error);
        res.status(500).json({
            status: 'failure',
            message: 'Internal server error',
            error: error.message
        });
    }
};

export const completeEsewaPayment = async (req, res) => {
    try {
        const { data } = req.body;
        const userId = req.user.user_id;

        // Verify payment with eSewa
        const paymentInfo = await verifyEsewaPayment(data);

        const transactionUuid = paymentInfo.decodedData.transaction_uuid;
        if (!transactionUuid) {
            return res.status(400).json({
                status: 'failure',
                message: 'Invalid transaction UUID'
            });
        }

        // Find payment record
        const payment = await prisma.payments.findFirst({
            where: {
                transaction_id: transactionUuid,
                user_id: parseInt(userId),
                payment_method: 'Online'  // Ensure it's an eSewa payment
            },
            include: {
                memberships: {
                    include: {
                        membership_plan: true
                    }
                }
            }
        });

        if (!payment) {
            return res.status(404).json({
                status: 'failure',
                message: 'Payment record not found'
            });
        }

        // Update payment status
        await prisma.payments.update({
            where: { payment_id: payment.payment_id },
            data: {
                payment_status: 'Paid',
                transaction_id: paymentInfo.decodedData.transaction_code,
                payment_date: new Date()
            }
        });

        // Calculate end date based on plan type
        const start_date = new Date();
        let end_date = new Date(start_date);

        const planType = payment.memberships.membership_plan.plan_type;
        const planDuration = payment.memberships.membership_plan.duration;

        if (planDuration) {
            end_date.setMonth(end_date.getMonth() + planDuration);
        } else {
            switch (planType) {
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
                    end_date.setMonth(end_date.getMonth() + 1);
            }
        }

        // Update membership status
        await prisma.memberships.update({
            where: { membership_id: payment.membership_id },
            data: {
                status: 'Active',
                start_date,
                end_date,
                updated_at: new Date()
            }
        });

        // Set payment details in cookie for the success page
        const paymentDetails = {
            transactionId: paymentInfo.decodedData.transaction_code,
            amount: `Rs. ${paymentInfo.decodedData.total_amount}`,
            date: new Date().toLocaleString(),
            paymentMethod: 'Online',
            planName: payment.memberships.membership_plan.plan_type,
            membershipEndDate: end_date.toLocaleDateString()
        };

        res.cookie('paymentDetails', JSON.stringify(paymentDetails), {
            maxAge: 300000, // 5 minutes
            httpOnly: false
        });

        res.status(200).json({
            status: 'success',
            message: 'Payment verified, membership activated',
            data: {
                status: 'Active',
                start_date,
                end_date,
                plan_name: payment.memberships.membership_plan.plan_type,
                plan_type: payment.memberships.membership_plan.plan_type
            }
        });

    } catch (error) {
        console.error('Error completing eSewa payment:', error);
        res.status(500).json({
            status: 'failure',
            message: 'Internal server error',
            error: error.message
        });
    }
};
