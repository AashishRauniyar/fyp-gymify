import express from 'express';

import { isAdmin } from '../../middleware/isAdminMiddleware.js';
import { addAttendanceRecord, deleteAttendanceRecord, getAllAttendanceRecords, getAttendanceStatistics, getUserAttendanceForAdmin } from '../../controllers/admin_controller/admin_attendance_controller.js';

const adminAttendanceRouter = express.Router();


adminAttendanceRouter.get('/attendance',isAdmin, getAllAttendanceRecords);
adminAttendanceRouter.get('/attendance/statistics',isAdmin, getAttendanceStatistics);
adminAttendanceRouter.get('/attendance/user/:id',isAdmin, getUserAttendanceForAdmin);
adminAttendanceRouter.post('/attendance',isAdmin, addAttendanceRecord);
adminAttendanceRouter.delete('/attendance/:id',isAdmin, deleteAttendanceRecord);

export default adminAttendanceRouter;
