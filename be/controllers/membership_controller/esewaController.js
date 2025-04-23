import prisma from '../../prisma/prisma.js';
import axios from 'axios';
import crypto from 'crypto';
import dotenv from 'dotenv';

dotenv.config();


const ESEWA_API_URL = process.env.NODE_ENV === "production"
    ? "https://epay.esewa.com.np/api/epay/main/v2/form"
    : "https://rc-epay.esewa.com.np/api/epay/main/v2/form";  // Test URL

const ESEWA_SECRET_KEY = process.env.ESEWA_SECRET_KEY;
const BASE_URL = process.env.BASE_URL;

// Helper function to generate HMAC-SHA256 signature for eSewa
function generateSignature(params) {
    const sortedKeys = Object.keys(params).sort();
    const stringToSign = sortedKeys.map(key => `${key}=${params[key]}`).join('&');

    const hmac = crypto.createHmac('sha256', ESEWA_SECRET_KEY);
    hmac.update(stringToSign);
    return hmac.digest('base64');
}

export const initiatePaymentEsewa = async (req, res) => {
    try {
        const { user_id, plan_id, amount, payment_method } = req.body;

        if (payment_method !== 'eSewa') {
            return res.status(400).json({
                status: 'failure',
                message: 'Invalid payment method. Please use "eSewa".'
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

        const transactionUuid = `TXN-${Date.now()}-${user_id}`;

        const total_amount = (parseFloat(amount) + 0).toString(); // For simplicity, no extra charges added.

        const params = {
            total_amount,
            transaction_uuid: transactionUuid,
            product_code: 'EPAYTEST',  // Define the product code
            signed_field_names: "total_amount,transaction_uuid,product_code",
        };

        // Generate signature
        const signature = generateSignature(params);

        const paymentPayload = {
            ...params,
            signature,
            success_url: `${BASE_URL}payment-success?transaction_uuid=${transactionUuid}`,
            failure_url: `${BASE_URL}payment-failure?transaction_uuid=${transactionUuid}`,
        };

        const esewaResponse = await axios.post(ESEWA_API_URL, paymentPayload, {
            headers: {
                'Content-Type': 'application/json',
            },
        });

        if (!esewaResponse.data.success_url) {
            throw new Error('Failed to get eSewa payment URL');
        }

        // Create a payment entry linked to the new membership
        await prisma.payments.create({
            data: {
                user_id: parseInt(user_id),
                membership_id: newMembership.membership_id, // 🔥 Link Payment to Membership
                price: amount,
                payment_method: 'eSewa',
                transaction_id: transactionUuid,
                pidx: esewaResponse.data.transaction_uuid, // Transaction UUID
                payment_status: 'Pending',
                payment_date: new Date(),
            },
        });

        res.status(200).json({
            status: 'success',
            data: {
                transaction_uuid: transactionUuid,
                payment_url: esewaResponse.data.success_url,
            },
            message: 'Payment initiated successfully',
        });

    } catch (error) {
        console.error("Error initiating payment:", error);
        res.status(500).json({
            status: 'failure',
            message: 'Internal server error',
            error: error.message,
        });
    }
};

export const verifyPaymentEsewa = async (req, res) => {
    try {
        const { transaction_uuid, status } = req.body;

        const payment = await prisma.payments.findUnique({
            where: { transaction_id: transaction_uuid },
            include: { memberships: true }, // Fetch the linked membership
        });

        if (!payment) {
            return res.status(404).json({ status: 'failure', message: 'Payment not found' });
        }

        if (status !== 'COMPLETE') {
            return res.status(400).json({
                status: 'failure',
                message: 'Payment was not successful'
            });
        }

        // Update payment status to 'Paid'
        await prisma.payments.update({
            where: { transaction_id: transaction_uuid },
            data: { payment_status: 'Paid' },
        });

        // Update membership status to Active
        await prisma.memberships.update({
            where: { membership_id: payment.membership_id },
            data: {
                status: 'Active',
                start_date: new Date(),
                end_date: new Date(new Date().setMonth(new Date().getMonth() + 1)) // Adjust based on plan
            }
        });

        res.status(200).json({
            status: 'success',
            message: 'Payment verified, membership activated',
        });

    } catch (error) {
        console.error("Error verifying payment:", error);
        res.status(500).json({
            status: 'failure',
            message: 'Internal server error',
            error: error.message,
        });
    }
};
