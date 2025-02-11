
// routes/attendanceRoutes.js
import express from 'express';
import { getAttendanceHistory, getTodayAttendance, markAttendance } from '../controllers/attendance_controller/attendanceController.js';


const attendanceRouter = express.Router();

attendanceRouter.post('/attendance', markAttendance);
attendanceRouter.get('/attendance/user/:user_id', getAttendanceHistory);
attendanceRouter.get('/attendance/today', getTodayAttendance);

export default attendanceRouter;