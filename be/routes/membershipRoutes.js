// routes/membershipRoutes.js
import express from 'express';
import { approveMembership, createMembership, createMembershipPlan, deleteMembershipRequest, getActiveMembership, getAllPlans, getPendingMemberships, getUserMembershipStatus, updateUserCard } from '../controllers/membership_controller/membershipController.js';
import { authenticate } from '../middleware/authMiddleware.js';

const membershipRouter = express.Router();

// Membership plan routes
membershipRouter.get('/plans', authenticate, getAllPlans);
membershipRouter.post('/memberships', authenticate, createMembership);
membershipRouter.get('/memberships/status/:user_id', authenticate, getUserMembershipStatus);


// delete membership by a user (before being approved)
membershipRouter.delete('/memberships/user/:user_id', authenticate, deleteMembershipRequest);

// Admin routes
membershipRouter.post('/plans', authenticate, createMembershipPlan);
membershipRouter.get('/memberships/active/:user_id', authenticate, getActiveMembership);
membershipRouter.get('/admin/pending', authenticate, getPendingMemberships);
membershipRouter.put('/admin/approve/:membershipId', authenticate, approveMembership);

// User card update (admin only)
membershipRouter.put('/users/:userId/card', authenticate, updateUserCard);




// User Membership Status Route


export default membershipRouter;
