import prisma from '../../prisma/prisma.js';

// Get all memberships for admin

// Get all memberships (admin only)
export const getAllMemberships = async (req, res) => {
    try {
        const memberships = await prisma.memberships.findMany({
            include: {
                users: true,
                membership_plan: true,
                payments: true
            }
        });

        res.status(200).json({
            status: 'success',
            message: 'All memberships fetched successfully',
            data: memberships
        });
    } catch (error) {
        console.error('Error fetching all memberships:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};



// Get membership details by ID (admin only)
export const getMembershipById = async (req, res) => {
    try {
        const { membershipId } = req.params;
        const membership = await prisma.memberships.findUnique({
            where: { membership_id: parseInt(membershipId) },
            include: {
                users: true,
                membership_plan: true,
                payments: true
            }
        });

        if (!membership) {
            return res.status(404).json({ status: 'failure', message: 'Membership not found' });
        }

        res.status(200).json({
            status: 'success',
            message: 'Membership fetched successfully',
            data: membership
        });
    } catch (error) {
        console.error('Error fetching membership:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};



// Update a member's membership plan (admin only)
export const updateMembershipPlan = async (req, res) => {
    try {
        const { membershipId } = req.params;
        const { plan_id } = req.body;

        // Validate new plan ID
        const newPlan = await prisma.membership_plan.findUnique({ where: { plan_id: parseInt(plan_id) } });
        if (!newPlan) {
            return res.status(404).json({ status: 'failure', message: 'Plan not found' });
        }

        // Update membership
        const updatedMembership = await prisma.memberships.update({
            where: { membership_id: parseInt(membershipId) },
            data: { plan_id: newPlan.plan_id }
        });

        res.status(200).json({
            status: 'success',
            message: 'Membership plan updated successfully',
            data: updatedMembership
        });
    } catch (error) {
        console.error('Error updating membership plan:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};


// Cancel a user's membership (admin only)
export const cancelMembership = async (req, res) => {
    try {
        const { membershipId } = req.params;

        // Cancel the membership by setting status to "Cancelled"
        const canceledMembership = await prisma.memberships.update({
            where: { membership_id: parseInt(membershipId) },
            data: { status: 'Cancelled' }
        });

        res.status(200).json({
            status: 'success',
            message: 'Membership cancelled successfully',
            data: canceledMembership
        });
    } catch (error) {
        console.error('Error cancelling membership:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};

//method to renew membership

export const renewMembership = async (req, res) => {
    try {
        const { membershipId } = req.params;

        // Cancel the membership by setting status to "Cancelled"
        const renewedMembership = await prisma.memberships.update({
            where: { membership_id: parseInt(membershipId) },
            data: { status: 'Active' }
        });

        res.status(200).json({
            status: 'success',
            message: 'Membership renewed successfully',
            data: renewedMembership
        });
    } catch (error) {
        console.error('Error renewing membership:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
}


// Get membership changes history
export const getMembershipChangesHistory = async (req, res) => {
    try {
        const { membershipId } = req.params;

        // Fetch subscription changes for the given membership
        const changes = await prisma.subscription_changes.findMany({
            where: { membership_id: parseInt(membershipId) },
            include: {
                memberships: true
            }
        });

        res.status(200).json({
            status: 'success',
            message: 'Membership change history fetched successfully',
            data: changes
        });
    } catch (error) {
        console.error('Error fetching membership changes:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};
