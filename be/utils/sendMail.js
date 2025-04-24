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
                            color: #333333;
                        }
                        .email-container {
                            max-width: 600px;
                            margin: 0 auto;
                            padding: 20px;
                            background-color: #ffffff;
                            border-radius: 16px;
                            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                        }
                        .email-header {
                            text-align: center;
                            padding-bottom: 20px;
                            border-bottom: 1px solid #eaeaea;
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
                            color: #4A3298;
                            margin-top: 0;
                        }
                        h2 {
                            color: #4A3298;
                        }
                        .otp-container {
                            text-align: center;
                            margin: 30px 0;
                        }
                        .otp-code {
                            font-family: monospace;
                            font-size: 32px;
                            letter-spacing: 5px;
                            background-color: #F3F0FF;
                            padding: 15px 25px;
                            border-radius: 12px;
                            color: #4A3298;
                            font-weight: bold;
                            border: 1px solid rgba(74, 50, 152, 0.2);
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
                            border-radius: 12px;
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
                            <h1>GYMIFY</h1>
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
                            <p>Your privacy is important to us. Read our <a href="#" style="color: #4A3298;">Privacy Policy</a>.</p>
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


// Helper function to send OTP email for user registration
export const sendRegistrationOTPEmail = async (email, otp, isResend = false) => {
    try {
        await transporter.sendMail({
            from: `"Gymify Support" <${process.env.EMAIL_USER}>`,
            to: email,
            subject: `${isResend ? 'Resend: ' : ''}Email Verification - Gymify`,
            html: `
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Email Verification</title>
                    <style type="text/css">
                        body {
                            margin: 0;
                            padding: 0;
                            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                            background-color: #f9f9f9;
                            color: #333333;
                        }
                        .email-container {
                            max-width: 600px;
                            margin: 0 auto;
                            padding: 20px;
                            background-color: #ffffff;
                            border-radius: 16px;
                            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                        }
                        .email-header {
                            text-align: center;
                            padding-bottom: 20px;
                            border-bottom: 1px solid #eaeaea;
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
                            color: #4A3298;
                            margin-top: 0;
                        }
                        h2 {
                            color: #4A3298;
                        }
                        .otp-container {
                            text-align: center;
                            margin: 30px 0;
                        }
                        .otp-code {
                            font-family: monospace;
                            font-size: 32px;
                            letter-spacing: 5px;
                            background-color: #F3F0FF;
                            padding: 15px 25px;
                            border-radius: 12px;
                            color: #4A3298;
                            font-weight: bold;
                            border: 1px solid rgba(74, 50, 152, 0.2);
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
                            border-radius: 12px;
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
                            <h1>GYMIFY</h1>
                            <p style="margin: 0;">Your Fitness Journey Partner</p>
                        </div>
                        <div class="email-body">
                            <h2>Email Verification</h2>
                            <p>Hello,</p>
                            <p>Thank you for registering with Gymify! To complete your registration, please use the following verification code:</p>
                            
                            <div class="otp-container">
                                <div class="otp-code">${otp}</div>
                                <p class="expire-text">This code will expire in 10 minutes.</p>
                            </div>
                            
                            <p>After verification, you'll be able to access all features of Gymify and start your fitness journey with us.</p>
                            
                            <p class="help-text">Need help? Contact our support team at support@gymify.com</p>
                        </div>
                        <div class="email-footer">
                            <p>&copy; ${new Date().getFullYear()} Gymify. All rights reserved.</p>
                            <p>Your privacy is important to us. Read our <a href="#" style="color: #4A3298;">Privacy Policy</a>.</p>
                            <p>2025 Fitness Lane, Active City, FT 12345</p>
                        </div>
                    </div>
                </body>
                </html>
            `
        });
        return true;
    } catch (error) {
        console.error('Error sending registration email:', error);
        return false;
    }
};




// New helper function to send a simple welcome email
export const sendWelcomeEmail = async (email, user_name) => {
    try {
        await transporter.sendMail({
            from: `"Gymify Support" <${process.env.EMAIL_USER}>`,
            to: email,
            subject: `Welcome to Gymify! Attendance Marked`,
            html: `
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Welcome to Gymify</title>
                    <style type="text/css">
                        body {
                            margin: 0;
                            padding: 0;
                            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                            background-color: #f9f9f9;
                            color: #333333;
                        }
                        .email-container {
                            max-width: 600px;
                            margin: 0 auto;
                            padding: 20px;
                            background-color: #ffffff;
                            border-radius: 16px;
                            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                        }
                        .email-header {
                            text-align: center;
                            padding-bottom: 20px;
                            border-bottom: 1px solid #eaeaea;
                        }
                        .email-body {
                            padding: 30px 0;
                            color: #333333;
                            text-align: center;
                        }
                        .email-footer {
                            text-align: center;
                            padding-top: 20px;
                            border-top: 1px solid #eaeaea;
                            color: #666666;
                            font-size: 12px;
                        }
                        h1 {
                            color: #4A3298;
                            margin-top: 0;
                        }
                        h2 {
                            color: #4A3298;
                        }
                        .btn-primary {
                            display: inline-block;
                            padding: 12px 30px;
                            background-color: #4A3298;
                            color: white;
                            text-decoration: none;
                            border-radius: 12px;
                            font-weight: bold;
                            margin-top: 20px;
                        }
                        .help-text {
                            color: #666666;
                            font-style: italic;
                            margin-top: 30px;
                        }
                        .highlight-text {
                            font-weight: bold;
                            color: #4A3298;
                        }
                        @media only screen and (max-width: 480px) {
                            .email-container {
                                padding: 10px;
                            }
                        }
                    </style>
                </head>
                <body>
                    <div class="email-container">
                        <div class="email-header">
                            <h1>GYMIFY</h1>
                            <p style="margin: 0;">Your Fitness Journey Partner</p>
                        </div>
                        <div class="email-body">
                            <h2>Welcome, ${user_name}! 💪</h2>
                            <p>Your attendance has been successfully marked for today.</p>
                            <p>We're excited to have you at the gym, and we're here to support your fitness journey every step of the way!</p>
                            
                            <div style="margin: 25px 0;">
                                <span class="highlight-text">Today's Date:</span> ${new Date().toLocaleDateString('en-US', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' })}
                            </div>
                            
                            <p>Keep up the great work and consistency!</p>
                            
                            <p class="help-text">Need assistance? Contact our support team at support@gymify.com</p>
                        </div>
                        <div class="email-footer">
                            <p>&copy; ${new Date().getFullYear()} Gymify. All rights reserved.</p>
                            <p>Your privacy is important to us. Read our <a href="#" style="color: #4A3298;">Privacy Policy</a>.</p>
                        </div>
                    </div>
                </body>
                </html>
            `
        });
        return true;
    } catch (error) {
        console.error('Error sending welcome email:', error);
        return false;
    }
};


// send email to user when he/she when membership is approved by Admin
export const sendMembershipApprovalEmail = async (email, user_name, card_number) => {
    try {
        await transporter.sendMail({
            from: `"Gymify Support" <${process.env.EMAIL_USER}>`,
            to: email,
            subject: `Welcome to Gymify! Membership Approved`,
            html: `
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Membership Approved</title>
                    <style type="text/css">
                        body {
                            margin: 0;
                            padding: 0;
                            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                            background-color: #f9f9f9;
                            color: #333333;
                        }
                        .email-container {
                            max-width: 600px;
                            margin: 0 auto;
                            padding: 20px;
                            background-color: #ffffff;
                            border-radius: 16px;
                            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                        }
                        .email-header {
                            text-align: center;
                            padding-bottom: 20px;
                            border-bottom: 1px solid #eaeaea;
                        }
                        .email-body {
                            padding: 30px 0;
                            color: #333333;
                            text-align: center;
                        }
                        .email-footer {
                            text-align: center;
                            padding-top: 20px;
                            border-top: 1px solid #eaeaea;
                            color: #666666;
                            font-size: 12px;
                        }
                        h1 {
                            color: #4A3298;
                            margin-top: 0;
                        }
                        h2 {
                            color: #4A3298;
                        }
                        .btn-primary {
                            display: inline-block;
                            padding: 12px 30px;
                            background-color: #4A3298;
                            color: white;
                            text-decoration: none;
                            border-radius: 12px;
                            font-weight: bold;
                            margin-top: 20px;
                        }
                        .help-text {
                            color: #666666;
                            font-style: italic;
                            margin-top: 30px;
                        }
                        .feature-section {
                            background-color: #F3F0FF;
                            border-radius: 12px;
                            padding: 20px;
                            margin: 25px 0;
                            border: 1px solid rgba(74, 50, 152, 0.2);
                        }
                        .feature-item {
                            margin: 12px 0;
                            text-align: left;
                        }
                        .feature-icon {
                            color: #4A3298;
                            font-weight: bold;
                            margin-right: 8px;
                        }
                        @media only screen and (max-width: 480px) {
                            .email-container {
                                padding: 10px;
                            }
                        }
                    </style>
                </head>
                <body>
                    <div class="email-container">
                        <div class="email-header">
                            <h1>GYMIFY</h1>
                            <p style="margin: 0;">Your Fitness Journey Partner</p>
                        </div>
                        <div class="email-body">
                            <h2>Membership Approved! 🎉</h2>
                            <p>Hello ${user_name},</p>
                            <p>Great news! Your membership has been successfully approved. You now have full access to all Gymify facilities and services.</p>
                            
                            <div class="feature-section">
                                <h3 style="color: #4A3298; margin-top: 0;">Your membership includes:</h3>
                                <div class="feature-item"><span class="feature-icon">✓</span> Access to all gym equipment and facilities</div>
                                <div class="feature-item"><span class="feature-icon">✓</span> Workout tracking and progress monitoring</div>
                                <div class="feature-item"><span class="feature-icon">✓</span> Personal best tracking for all exercises</div>
                                <div class="feature-item"><span class="feature-icon">✓</span> Access to trainer-created workout plans</div>
                                <div class="feature-item"><span class="feature-icon">✓</span> Ability to create custom workouts</div>
                            </div>
                            
                            <p>To get started, simply log in to your Gymify account and explore all the features we offer.</p>
                            <p>Please collect your Gym Card from your gym helpdesk</p>
                            <p>Your card number is "${card_number}"</p>
                            
                            <a href="#" class="btn-primary">Start Your Fitness Journey</a>
                            
                            <p class="help-text">Need assistance? Contact our support team at support@gymify.com</p>
                        </div>
                        <div class="email-footer">
                            <p>&copy; ${new Date().getFullYear()} Gymify. All rights reserved.</p>
                            <p>Your privacy is important to us. Read our <a href="#" style="color: #4A3298;">Privacy Policy</a>.</p>
                            <p>2025 Fitness Lane, Active City, FT 12345</p>
                        </div>
                    </div>
                </body>
                </html>
            `
        });
        return true;
    } catch (error) {
        console.error('Error sending membership approval email:', error);
        return false;
    }
}