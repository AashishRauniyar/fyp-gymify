import generateToken from '../utils/generateToken.js';
import { jest } from '@jest/globals';

// Mock jsonwebtoken
jest.mock('jsonwebtoken', () => ({
  sign: jest.fn()
}));

import jwt from 'jsonwebtoken';

describe('Token Generator', () => {
  beforeEach(() => {
    // Reset all mocks
    jest.clearAllMocks();
    
    // Set environment variable for tests
    process.env.JWT_SECRET = 'test-secret';
    process.env.JWT_EXPIRE = '30d';
  });

  it('should generate a token with user ID and role', () => {
    // Mock user object
    const user = {
      user_id: 1,
      role: 'Member',
      email: 'test@example.com'
    };
    
    // Set up the mock implementation
    jwt.sign.mockReturnValue('generated-token');
    
    // Call the function
    const token = generateToken(user);
    
    // Verify JWT sign was called with correct parameters
    expect(jwt.sign).toHaveBeenCalledWith(
      { user_id: 1, role: 'Member' },
      'test-secret',
      { expiresIn: '30d' }
    );
    
    // Verify the token was returned
    expect(token).toBe('generated-token');
  });

  it('should work with admin role', () => {
    // Mock admin user
    const adminUser = {
      user_id: 2,
      role: 'Admin',
      email: 'admin@example.com'
    };
    
    jwt.sign.mockReturnValue('admin-token');
    
    const token = generateToken(adminUser);
    
    expect(jwt.sign).toHaveBeenCalledWith(
      { user_id: 2, role: 'Admin' }, 
      'test-secret',
      { expiresIn: '30d' }
    );
    
    expect(token).toBe('admin-token');
  });

  it('should work with trainer role', () => {
    // Mock trainer user
    const trainerUser = {
      user_id: 3,
      role: 'Trainer',
      email: 'trainer@example.com'
    };
    
    jwt.sign.mockReturnValue('trainer-token');
    
    const token = generateToken(trainerUser);
    
    expect(jwt.sign).toHaveBeenCalledWith(
      { user_id: 3, role: 'Trainer' }, 
      'test-secret',
      { expiresIn: '30d' }
    );
    
    expect(token).toBe('trainer-token');
  });

  it('should handle undefined environment variables', () => {
    // Temporarily remove environment variables
    const oldJwtSecret = process.env.JWT_SECRET;
    const oldJwtExpire = process.env.JWT_EXPIRE;
    delete process.env.JWT_SECRET;
    delete process.env.JWT_EXPIRE;
    
    // Mock user
    const user = { user_id: 1, role: 'Member' };
    
    // The function should use default values
    generateToken(user);
    
    // Verify JWT sign was called with some default values
    expect(jwt.sign).toHaveBeenCalled();
    
    // Restore environment variables
    process.env.JWT_SECRET = oldJwtSecret;
    process.env.JWT_EXPIRE = oldJwtExpire;
  });
});