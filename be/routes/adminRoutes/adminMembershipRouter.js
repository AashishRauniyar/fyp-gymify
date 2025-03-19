import express from 'express';
import { authenticate } from '../../middleware/authMiddleware.js';
import { cancelMembership, getAllMemberships, getMembershipById, getMembershipChangesHistory, renewMembership, updateMembershipPlan  } from '../../controllers/admin_controller/adminMembershipController.js';

const adminMembershipRouter = express.Router();

// Get all memberships
adminMembershipRouter.get('/memberships', authenticate, getAllMemberships );
adminMembershipRouter.get('/memberships/:id', authenticate, getMembershipById);
// Update membership plans
adminMembershipRouter.put('/memberships/:id', authenticate, updateMembershipPlan);



// Cancel a user's membership
adminMembershipRouter.put('/memberships/:membershipId/cancel', authenticate, cancelMembership);

// renew a user's membership
adminMembershipRouter.put('/memberships/:membershipId/renew', authenticate, renewMembership);

// Get membership changes history for a membership
adminMembershipRouter.get('/memberships/:membershipId/changes', authenticate, getMembershipChangesHistory);


export default adminMembershipRouter;
