import crypto from 'crypto';
import axios from 'axios';

export const getEsewaPaymentHash = async ({ amount, transaction_uuid }) => {
    try {
        // Ensure total_amount is formatted consistently by removing commas
        const formattedAmount = String(amount).replace(/,/g, "");

        // Construct the data string exactly as per eSewa's requirements
        const data = `total_amount=${formattedAmount},transaction_uuid=${transaction_uuid},product_code=${process.env.ESEWA_PRODUCT_CODE}`;

        console.log("Data to be signed:", data);

        const secretKey = process.env.ESEWA_SECRET_KEY;
        if (!secretKey) {
            throw new Error("ESEWA_SECRET_KEY is not configured");
        }

        // Generate HMAC SHA256 hash and convert to base64
        const hash = crypto
            .createHmac("sha256", secretKey)
            .update(data)
            .digest("base64");

        console.log("Generated hash (signature):", hash);

        return {
            signature: hash,
            signed_field_names: "total_amount,transaction_uuid,product_code",
        };
    } catch (error) {
        console.error("Error in generating eSewa payment hash:", error);
        throw error;
    }
};

export const verifyEsewaPayment = async (encodedData) => {
    try {
        console.log("Received Encoded Data:", encodedData);

        // Decode the base64 data received from eSewa
        let decodedData = Buffer.from(encodedData, 'base64').toString();
        console.log("Base64 Decoded Data:", decodedData);

        decodedData = JSON.parse(decodedData);
        console.log("Parsed JSON Data:", decodedData);

        // Debug print: show the full decodedData object received from eSewa
        console.log('Full decoded eSewa data for verification:', JSON.stringify(decodedData, null, 2));

        // Validate required fields
        const requiredFields = ['transaction_code', 'status', 'total_amount', 'transaction_uuid', 'product_code', 'signed_field_names', 'signature'];
        const missingFields = requiredFields.filter(field => !decodedData[field]);

        if (missingFields.length > 0) {
            throw new Error(`Missing required fields: ${missingFields.join(', ')}`);
        }

        // Get the signed field names from the response, only remove 'signature'
        const signedFields = decodedData.signed_field_names
            .split(',')
            .filter(field => field !== 'signature'); // Keep signed_field_names, only remove signature

        // Construct the data string in the exact order from signed_field_names
        const dataString = signedFields
            .map(field => `${field}=${decodedData[field]}`)
            .join(',');

        console.log("Data String for Signature Verification:", dataString);

        // Generate the hash to compare with eSewa's signature
        const secretKey = process.env.ESEWA_SECRET_KEY;
        if (!secretKey) {
            throw new Error("ESEWA_SECRET_KEY is not configured");
        }

        const hash = crypto.createHmac("sha256", secretKey).update(dataString).digest("base64");
        console.log("Generated Hash (for verification):", hash);
        console.log("Signature from eSewa:", decodedData.signature);

        // Compare the generated hash with the received signature
        if (hash !== decodedData.signature) {
            throw new Error("Invalid signature");
        }

        // Construct the URL for verifying the transaction status
        const statusUrl = 'https://rc.esewa.com.np/api/epay/transaction/status/';
        const params = new URLSearchParams({
            product_code: process.env.ESEWA_PRODUCT_CODE,
            total_amount: decodedData.total_amount,
            transaction_uuid: decodedData.transaction_uuid
        });

        const esewaUrl = `${statusUrl}?${params.toString()}`;
        console.log("eSewa Transaction Status URL:", esewaUrl);

        const response = await axios.get(esewaUrl, {
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            }
        });

        console.log("eSewa Payment Status Response:", response.data);

        if (!response.data || response.status !== 200) {
            throw new Error("Failed to verify payment status with eSewa");
        }

        // Check for specific status responses
        if (response.data.status === "NOT_FOUND") {
            throw new Error("Payment session expired");
        }

        if (response.data.status === "CANCELED") {
            throw new Error("Payment was canceled");
        }

        if (response.data.status === "AMBIGUOUS") {
            throw new Error("Payment status is ambiguous");
        }

        if (response.data.status === "FULL_REFUND" || response.data.status === "PARTIAL_REFUND") {
            throw new Error(`Payment has been ${response.data.status.toLowerCase()}`);
        }

        // Validate transaction details exactly as per RC API response format
        if (
            response.data.status !== "COMPLETE" ||
            response.data.transaction_uuid !== decodedData.transaction_uuid ||
            parseFloat(response.data.total_amount) !== parseFloat(decodedData.total_amount) ||
            response.data.product_code !== process.env.ESEWA_PRODUCT_CODE
        ) {
            throw new Error("Payment verification failed");
        }

        // Include ref_id in the response as it's part of the RC API response
        return {
            response: {
                ...response.data,
                ref_id: response.data.ref_id // Make sure ref_id is included
            },
            decodedData
        };

    } catch (error) {
        console.error("Error in verifying eSewa payment:", error);
        throw error;
    }
}; 