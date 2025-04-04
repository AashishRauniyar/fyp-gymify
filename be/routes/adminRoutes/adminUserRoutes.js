import express from 'express';
import { getAllUsersForAdmin, getUserByIdForAdmin, updateUserForAdmin, deleteUserForAdmin, getUserMembershipDetails, getUserAttendanceHistory, getUserWeightProgress, registerUserByAdmin } from '../../controllers/admin_controller/admin_user_controller.js';
import { isAdmin } from '../../middleware/isAdminMiddleware.js';
import upload from '../../middleware/multerMiddleware.js';



const adminUserRouter = express.Router();

adminUserRouter.get('/users', isAdmin, getAllUsersForAdmin);
adminUserRouter.get('/users/:id',isAdmin, getUserByIdForAdmin);
adminUserRouter.put('/users/:id',isAdmin, updateUserForAdmin);
adminUserRouter.delete('/users/:id',isAdmin, deleteUserForAdmin);
adminUserRouter.get('/users/:id/membership',isAdmin, getUserMembershipDetails);
adminUserRouter.get('/users/:id/attendance',isAdmin, getUserAttendanceHistory);
adminUserRouter.get('/users/:id/weight-progress',isAdmin, getUserWeightProgress);

// New route for user registration by admin
adminUserRouter.post('/users/register', isAdmin, upload.single('profile_image') ,registerUserByAdmin);


export default adminUserRouter;
