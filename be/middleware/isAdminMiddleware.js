import jwt from 'jsonwebtoken';

export const isAdmin = (req, res, next) => {
    try {
        // Extract the token from the Authorization header
        const token = req.headers.authorization?.split(' ')[1];
        if (!token) {
            return res.status(401).json({ status: 'failure', message: 'No token provided' });
        }

        // Verify the token and extract the payload
        const decoded = jwt.verify(token, process.env.JWT_SECRET);

        // Ensure that both user_id and role are present in the token
        if (!decoded.user_id || !decoded.role) {
            return res.status(403).json({ status: 'failure', message: 'Invalid token payload' });
        }

        // Check if the user is an admin
        if (decoded.role !== 'Admin') {
            return res.status(403).json({ status: 'failure', message: 'Access denied. Admins only' });
        }

        // Attach user details to req.user
        req.user = {
            user_id: decoded.user_id,
            role: decoded.role
        };

        // Proceed to the next middleware or route handler
        next();
    } catch (error) {
        console.error('Error verifying token:', error);
        return res.status(401).json({ status: 'failure', message: 'Invalid or expired token' });
    }
};
