import jwt from 'jsonwebtoken';

const generateToken = (user) => {
    return jwt.sign(
        {
            user_id: user.user_id,
            role: user.role
        },
        process.env.JWT_SECRET,
        { expiresIn: '24h' }
    );
};

export default generateToken;
