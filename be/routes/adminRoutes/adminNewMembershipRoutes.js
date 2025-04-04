import express from 'express';
import { isAdmin } from '../../middleware/isAdminMiddleware.js';
import { 
    // Membership management
    getAllMemberships, 
    getMembershipDetails, 
    createMembership, 
    updateMembership, 
    updateMembershipStatus,
    approveMembershipByAdmin,
    cancelMembershipByAdmin,
    
    // Payment management
    getAllPayments,
    
    // User card management
    updateUserCardByAdmin,
    
    // Membership plan management
    getAllMembershipPlans,
    createMembershipPlan,
    updateMembershipPlan,
    deleteMembershipPlan,
    
    // History
    getMembershipChangesHistoryByAdmin
} from '../../controllers/admin_controller/admin_membership_controller.js';

const adminMembershipRouter = express.Router();

// Debug middleware
adminMembershipRouter.use((req, res, next) => {
    console.log(`Admin Membership API Request: ${req.method} ${req.originalUrl}`);
    console.log('Request params:', req.params);
    console.log('Request body:', req.body);
    next();
});

// Membership management routes
adminMembershipRouter.get('/memberships', isAdmin, getAllMemberships);
adminMembershipRouter.get('/memberships/:id', isAdmin, getMembershipDetails);
adminMembershipRouter.post('/memberships', isAdmin, createMembership);
adminMembershipRouter.put('/memberships/:id', isAdmin, updateMembership);
adminMembershipRouter.patch('/memberships/:id/status', isAdmin, updateMembershipStatus);

// Payment routes
adminMembershipRouter.get('/payments', isAdmin, getAllPayments);

// Membership approval/cancellation
adminMembershipRouter.put('/approve/:membershipId', isAdmin, approveMembershipByAdmin);
adminMembershipRouter.put('/memberships/:membershipId/cancel', isAdmin, cancelMembershipByAdmin);

// User card management
adminMembershipRouter.put('/users/:userId/card', isAdmin, updateUserCardByAdmin);

// Membership plan management - NEW ROUTES
adminMembershipRouter.get('/membership-plans', isAdmin, getAllMembershipPlans);
adminMembershipRouter.post('/membership-plans', isAdmin, createMembershipPlan);
adminMembershipRouter.put('/membership-plans/:planId', isAdmin, updateMembershipPlan);
adminMembershipRouter.delete('/membership-plans/:planId', isAdmin, deleteMembershipPlan);

// Membership
// changes history
adminMembershipRouter.get('/memberships/:membershipId/changes', isAdmin, getMembershipChangesHistoryByAdmin);

export default adminMembershipRouter;