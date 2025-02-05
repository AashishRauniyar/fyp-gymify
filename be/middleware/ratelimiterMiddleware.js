import rateLimit from 'express-rate-limit';

// Rate limiting configuration
export const rateLimiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 5, // 5 requests per windowMs
    message: { status: 'failure', message: 'Too many requests. Please try again later.' }
});
