import express from 'express';

import { isAdmin } from '../../middleware/isAdminMiddleware.js';
import { getAttendanceTrends, getDashboardStats, getMonthlyRevenue, getUserDemographics, getUserGrowthStats } from '../../controllers/admin_controller/admin_dashboard_controller.js';


const adminDashboardRouter = express.Router();


adminDashboardRouter.get('/dashboard/stats',isAdmin, getDashboardStats);
adminDashboardRouter.get('/dashboard/revenue',isAdmin, getMonthlyRevenue);
adminDashboardRouter.get('/dashboard/user-growth',isAdmin, getUserGrowthStats);
adminDashboardRouter.get('/dashboard/attendance-trends',isAdmin, getAttendanceTrends);
adminDashboardRouter.get('/dashboard/user-demographics',isAdmin, getUserDemographics);

export default adminDashboardRouter;