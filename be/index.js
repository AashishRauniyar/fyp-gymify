import dotenv from 'dotenv';
import express from 'express';
import router from './routes/routes.js';
import cors from 'cors';
import authRouter from './routes/authRoutes.js';
import profileRouter from './routes/profileRoutes.js';
import { userRouter } from './routes/userRoutes.js';
import { exerciseRouter } from './routes/exerciseRoutes.js';
import { workoutRouter } from './routes/workoutRoutes.js';
import { customWorkoutRouter } from './routes/customWorkoutRoutes.js';
dotenv.config();

// Create express app
const app = express();

// for cross origin requests
app.use(cors());
// Middlewares
app.use(express.json());
app.use(express.urlencoded({ extended: true }));




// Routes
app.use('/api/auth', authRouter);
app.use('/api', router);
app.use('/api', profileRouter);
app.use('/api', userRouter);
app.use('/api', exerciseRouter);
app.use('/api', workoutRouter);
app.use('/api', customWorkoutRouter); 

// use cors


const PORT = process.env.PORT || 8000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});


