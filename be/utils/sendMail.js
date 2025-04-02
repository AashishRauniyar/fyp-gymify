import nodemailer from 'nodemailer';
import dotenv from 'dotenv';
dotenv.config();



// Email configuration
const transporter = nodemailer.createTransport({
    service: 'Gmail',
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS, // Use app-specific password
    },
});


// Helper function to send OTP email for password recovery
export const sendOTPEmail = async (email, otp, isResend = false) => {
    try {
        await transporter.sendMail({
            from: `"Gymify Support" <${process.env.EMAIL_USER}>`,
            to: email,
            subject: `${isResend ? 'Resend: ' : ''}Password Reset Request - Gymify`,
            html: `
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Password Reset</title>
                    <style type="text/css">
                        body {
                            margin: 0;
                            padding: 0;
                            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                            background-color: #f9f9f9;
                        }
                        .email-container {
                            max-width: 600px;
                            margin: 0 auto;
                            padding: 20px;
                            background-color: #ffffff;
                            border-radius: 10px;
                            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                        }
                        .email-header {
                            text-align: center;
                            padding-bottom: 20px;
                            border-bottom: 1px solid #eaeaea;
                        }
                        .email-header img {
                            max-width: 150px;
                            margin-bottom: 10px;
                        }
                        .email-body {
                            padding: 30px 0;
                            color: #333333;
                        }
                        .email-footer {
                            text-align: center;
                            padding-top: 20px;
                            border-top: 1px solid #eaeaea;
                            color: #666666;
                            font-size: 12px;
                        }
                        h1 {
                            color: #3a3a3a;
                            margin-top: 0;
                        }
                        .otp-container {
                            text-align: center;
                            margin: 30px 0;
                        }
                        .otp-code {
                            font-family: monospace;
                            font-size: 32px;
                            letter-spacing: 5px;
                            background-color: #f1f8ff;
                            padding: 15px 25px;
                            border-radius: 8px;
                            color: #0066cc;
                            font-weight: bold;
                        }
                        .expire-text {
                            color: #e74c3c;
                            margin-top: 15px;
                            font-weight: 500;
                        }
                        .help-text {
                            color: #666666;
                            font-style: italic;
                            margin-top: 30px;
                        }
                        .btn-primary {
                            display: inline-block;
                            padding: 12px 30px;
                            background-color: #4A3298;
                            
                            color: white;
                            text-decoration: none;
                            border-radius: 5px;
                            font-weight: bold;
                            margin-top: 20px;
                        }
                        @media only screen and (max-width: 480px) {
                            .email-container {
                                padding: 10px;
                            }
                            .otp-code {
                                font-size: 28px;
                                padding: 10px 15px;
                            }
                        }
                    </style>
                </head>
                <body>
                    <div class="email-container">
                        <div class="email-header">
                            <h1 style="color: #4A3298;">GYMIFY</h1>
                            <p style="margin: 0;">Your Fitness Journey Partner</p>
                        </div>
                        <div class="email-body">
                            <h2>Password Reset Request</h2>
                            <p>Hello,</p>
                            <p>We received a request to reset your password for your Gymify account. To continue with the password reset process, please use the following verification code:</p>
                            
                            <div class="otp-container">
                                <div class="otp-code">${otp}</div>
                                <p class="expire-text">This code will expire in 10 minutes.</p>
                            </div>
                            
                            <p>If you didn't request this password reset, please ignore this email or contact our support team if you have any concerns.</p>
                            
                            <p class="help-text">Need help? Contact our support team at support@gymify.com</p>
                        </div>
                        <div class="email-footer">
                            <p>&copy; ${new Date().getFullYear()} Gymify. All rights reserved.</p>
                            <p>Your privacy is important to us. Read our <a href="#">Privacy Policy</a>.</p>
                            <p>2025 Fitness Lane, Active City, FT 12345</p>
                        </div>
                    </div>
                </body>
                </html>
            `
        });
        return true;
    } catch (error) {
        console.error('Error sending email:', error);
        return false;
    }
};