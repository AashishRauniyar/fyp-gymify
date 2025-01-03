// routes/membershipRoutes.js
import express from 'express';
import { createMembership, createMembershipPlan, getActiveMembership, getAllPlans } from '../controllers/membership_controller/membershipController.js';


const membershipRouter = express.Router();

// Membership plan routes
membershipRouter.post('/plans', createMembershipPlan);
membershipRouter.get('/plans', getAllPlans);

// Membership routes
membershipRouter.post('/memberships', createMembership);
membershipRouter.get('/memberships/active/:user_id', getActiveMembership);

export default membershipRouter;
