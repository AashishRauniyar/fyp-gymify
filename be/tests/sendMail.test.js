import { 
    sendOTPEmail, 
    sendRegistrationOTPEmail, 
    sendWelcomeEmail 
  } from '../utils/sendMail.js';
  import { jest } from '@jest/globals';
  
  // Mock nodemailer
  jest.mock('nodemailer', () => {
    // Create a mock transporter
    const mockTransporter = {
      sendMail: jest.fn()
    };
    
    return {
      createTransport: jest.fn(() => mockTransporter)
    };
  });
  
  // Import mocked nodemailer
  import nodemailer from 'nodemailer';
  
  describe('Email Sending Functions', () => {
    // Get access to the mock transporter
    const mockTransporter = nodemailer.createTransport();
    
    beforeEach(() => {
      // Reset all mocks before each test
      jest.clearAllMocks();
      
      // Mock environment variables
      process.env.EMAIL_USER = 'test@example.com';
      process.env.EMAIL_PASS = 'testpassword';
      process.env.EMAIL_HOST = 'smtp.example.com';
      process.env.EMAIL_PORT = '587';
      
      // Set up transporter.sendMail to resolve by default
      mockTransporter.sendMail.mockResolvedValue({ 
        messageId: 'mock-message-id'
      });
    });
  
    describe('sendOTPEmail', () => {
      it('should send password reset OTP email successfully', async () => {
        const email = 'user@example.com';
        const otp = '123456';
        
        const result = await sendOTPEmail(email, otp);
        
        // Verify transporter.sendMail was called with correct parameters
        expect(mockTransporter.sendMail).toHaveBeenCalledWith({
          from: 'test@example.com',
          to: 'user@example.com',
          subject: expect.stringContaining('Password Reset'),
          html: expect.stringContaining('123456')
        });
        
        // Verify function returns true on success
        expect(result).toBe(true);
      });
      
      it('should handle email sending failure', async () => {
        const email = 'user@example.com';
        const otp = '123456';
        
        // Make sendMail reject this time
        mockTransporter.sendMail.mockRejectedValueOnce(new Error('Failed to send'));
        
        const result = await sendOTPEmail(email, otp);
        
        // Verify function returns false on failure
        expect(result).toBe(false);
      });
    });
  
    describe('sendRegistrationOTPEmail', () => {
      it('should send registration OTP email successfully', async () => {
        const email = 'user@example.com';
        const otp = '123456';
        
        const result = await sendRegistrationOTPEmail(email, otp);
        
        // Verify transporter.sendMail was called with correct parameters
        expect(mockTransporter.sendMail).toHaveBeenCalledWith({
          from: 'test@example.com',
          to: 'user@example.com',
          subject: expect.stringContaining('Registration Verification'),
          html: expect.stringContaining('123456')
        });
        
        // Verify function returns true on success
        expect(result).toBe(true);
      });
      
      it('should handle email sending failure', async () => {
        const email = 'user@example.com';
        const otp = '123456';
        
        // Make sendMail reject this time
        mockTransporter.sendMail.mockRejectedValueOnce(new Error('Failed to send'));
        
        const result = await sendRegistrationOTPEmail(email, otp);
        
        // Verify function returns false on failure
        expect(result).toBe(false);
      });
      
      it('should include "Resend" in subject for resent OTPs', async () => {
        const email = 'user@example.com';
        const otp = '123456';
        const isResend = true;
        
        await sendRegistrationOTPEmail(email, otp, isResend);
        
        // Verify transporter.sendMail was called with resend text in subject
        expect(mockTransporter.sendMail).toHaveBeenCalledWith(
          expect.objectContaining({
            subject: expect.stringContaining('Resend')
          })
        );
      });
    });
  
    describe('sendWelcomeEmail', () => {
      it('should send welcome email successfully', async () => {
        const email = 'user@example.com';
        const otp = '123456';
        
        const result = await sendWelcomeEmail(email, otp);
        
        // Verify transporter.sendMail was called with correct parameters
        expect(mockTransporter.sendMail).toHaveBeenCalledWith({
          from: 'test@example.com',
          to: 'user@example.com',
          subject: expect.stringContaining('Welcome'),
          html: expect.stringContaining('123456')
        });
        
        // Verify function returns true on success
        expect(result).toBe(true);
      });
      
      it('should handle email sending failure', async () => {
        const email = 'user@example.com';
        const otp = '123456';
        
        // Make sendMail reject this time
        mockTransporter.sendMail.mockRejectedValueOnce(new Error('Failed to send'));
        
        const result = await sendWelcomeEmail(email, otp);
        
        // Verify function returns false on failure
        expect(result).toBe(false);
      });
      
      it('should include "Resend" in subject for resent OTPs', async () => {
        const email = 'user@example.com';
        const otp = '123456';
        const isResend = true;
        
        await sendWelcomeEmail(email, otp, isResend);
        
        // Verify transporter.sendMail was called with resend text in subject
        expect(mockTransporter.sendMail).toHaveBeenCalledWith(
          expect.objectContaining({
            subject: expect.stringContaining('Resend')
          })
        );
      });
    });
  });