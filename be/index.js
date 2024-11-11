import dotenv from 'dotenv';
import express from 'express';
import authRoutes from './routes/authRoutes.js';

dotenv.config();

const app = express();
app.use(express.json());

// Routes
app.use('/api/auth', authRoutes);

const PORT = process.env.PORT || 8000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
