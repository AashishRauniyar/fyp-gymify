import prisma from '../../prisma/prisma.js';
import axios from 'axios';
import dotenv from 'dotenv';

dotenv.config();


const KHALTI_API_URL = process.env.NODE_ENV === "production"
    ? "https://khalti.com/api/v2/epayment/initiate/"
    : "https://dev.khalti.com/api/v2/epayment/initiate/";
const KHALTI_SECRET_KEY = process.env.KHALTI_SECRET_KEY;
const BASE_URL = process.env.BASE_URL;

export const initiatePayment = async (req, res) => {
    try {
        const { user_id, plan_id, amount, payment_method } = req.body;

        if (payment_method !== 'Khalti') {
            return res.status(400).json({
                status: 'failure',
                message: 'Invalid payment method. Please use "Khalti".'
            });
        }

        const user = await prisma.users.findUnique({ where: { user_id: parseInt(user_id) } });
        if (!user) {
            return res.status(404).json({ status: 'failure', message: 'User not found' });
        }

        const plan = await prisma.membership_plan.findUnique({ where: { plan_id: parseInt(plan_id) } });
        if (!plan) {
            return res.status(404).json({ status: 'failure', message: 'Membership plan not found' });
        }

        // Check for existing active or pending membership
        const existingMembership = await prisma.memberships.findFirst({
            where: {
                user_id: parseInt(user_id),
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

        // Create a new membership entry (Pending)
        const newMembership = await prisma.memberships.create({
            data: {
                user_id: parseInt(user_id),
                plan_id: parseInt(plan_id),
                status: 'Pending', // Initially pending until payment is verified
            }
        });

        const transactionId = `TXN-${Date.now()}-${user_id}`;

        const paymentPayload = {
            return_url: `${BASE_URL}payment-success?transaction_id=${transactionId}`,
            website_url: BASE_URL,
            amount: Math.round(amount * 100), // Convert amount to paisa

            purchase_order_id: transactionId,
            purchase_order_name: plan.plan_type,
        };

        const khaltiResponse = await axios.post(KHALTI_API_URL, paymentPayload, {
            headers: {
                Authorization: `Key ${KHALTI_SECRET_KEY}`,
                "Content-Type": "application/json",
            }
        });

        if (!khaltiResponse.data.pidx) {
            throw new Error("Failed to get Khalti pidx");
        }

        // Create a payment entry linked to the new membership
        await prisma.payments.create({
            data: {
                user_id: parseInt(user_id),
                membership_id: newMembership.membership_id, // 🔥 Link Payment to Membership
                price: amount,
                payment_method: 'Khalti',
                transaction_id: transactionId,
                pidx: khaltiResponse.data.pidx,
                payment_status: 'Pending',
                payment_date: new Date()
            }
        });

        res.status(200).json({
            status: 'success',
            data: {
                pidx: khaltiResponse.data.pidx,
                transaction_id: transactionId,
                payment_url: khaltiResponse.data.payment_url,
                amount: amount
            },
            message: 'Payment initiated successfully',
        });

    } catch (error) {
        console.error("Error initiating payment:", error);
        res.status(500).json({
            status: 'failure',
            message: 'Internal server error',
            error: error.message
        });
    }
};

export const verifyPayment = async (req, res) => {
    try {
        const { transaction_id, status } = req.body;

        const payment = await prisma.payments.findUnique({
            where: { transaction_id },
            include: {
                memberships: {
                    include: {
                        membership_plan: true
                    }
                }
            }
        });

        if (!payment) {
            return res.status(404).json({ status: 'failure', message: 'Payment not found' });
        }

        if (status !== 'Completed') {
            return res.status(400).json({
                status: 'failure',
                message: 'Payment was not successful'
            });
        }

        // Update payment status
        await prisma.payments.update({
            where: { transaction_id },
            data: { payment_status: 'Paid' }
        });

        // Calculate end date based on plan type
        const start_date = new Date();
        let end_date = new Date(start_date);

        const planType = payment.memberships.membership_plan.plan_type;
        const planDuration = payment.memberships.membership_plan.duration;

        if (planDuration) {
            // Use plan duration directly if available
            end_date.setMonth(end_date.getMonth() + planDuration);
        } else {
            // Fallback to plan type if duration is not available
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
                    end_date.setMonth(end_date.getMonth() + 1); // Default to 1 month
            }
        }

        // Update membership status to Active with correct end date
        await prisma.memberships.update({
            where: { membership_id: payment.membership_id },
            data: {
                status: 'Active',
                start_date,
                end_date
            }
        });

        res.status(200).json({
            status: 'success',
            message: 'Payment verified, membership activated',
            data: {
                status: 'Active',
                start_date,
                end_date
            }
        });
    } catch (error) {
        console.error("Error verifying payment:", error);
        res.status(500).json({
            status: 'failure',
            message: 'Internal server error',
            error: error.message
        });
    }
};
