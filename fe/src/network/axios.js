import axios from 'axios';

// Create an instance of axios with default settings
export const userInstance = axios.create({
  baseURL: 'http://localhost:8000/api',  // Set the base URL for API requests
  headers: {
    'Content-Type': 'application/json',
  },
});

// Add a request interceptor to add the authorization token
userInstance.interceptors.request.use(
  config => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers['Authorization'] = `Bearer ${token}`;
    }
    return config;
  },
  error => {
    return Promise.reject(error);
  }
);

// Optionally add a response interceptor for handling errors globally
userInstance.interceptors.response.use(
  response => response,
  error => {
    if (error.response && error.response.status === 401) {
      // Handle unauthorized error (for example, redirect to login)
      console.error('Unauthorized access. Please log in again.');
    }
    return Promise.reject(error);
  }
);

export default userInstance;
