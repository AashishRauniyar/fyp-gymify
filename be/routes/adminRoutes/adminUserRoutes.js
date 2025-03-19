// import express from 'express';
// import { getAllUsersForAdmin } from '../../controllers/admin_controller/admin_user_controller.js';
// import { authenticate } from '../../middleware/authMiddleware.js';



// const adminUserRouter = express.Router();


// // Routes for getting users based on roles
// adminUserRouter.get('/users', authenticate ,getAllUsersForAdmin);


// export default adminUserRouter;


import express from 'express';
import { getAllUsersForAdmin, getUserByIdForAdmin, updateUserForAdmin, deleteUserForAdmin } from '../../controllers/admin_controller/admin_user_controller.js';
import { authenticate } from '../../middleware/authMiddleware.js';

const adminUserRouter = express.Router();

// Get all users
adminUserRouter.get('/users', authenticate, getAllUsersForAdmin);

// Get user by ID
adminUserRouter.get('/users/:id', authenticate, getUserByIdForAdmin);

// Update user details
adminUserRouter.put('/users/:id', authenticate, updateUserForAdmin);

// Delete user
adminUserRouter.delete('/users/:id', authenticate, deleteUserForAdmin);

export default adminUserRouter;
