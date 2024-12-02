import express from 'express';
import { authenticate } from '../middleware/authMiddleware.js';
import { createExercise, deleteExercise, getAllExercises, getExerciseById, updateExercise } from '../controllers/workout_controller/exerciseController.js';


export const exerciseRouter = express.Router();



// Routes accessible to everyone
exerciseRouter.get('/exercises', authenticate ,getAllExercises);
exerciseRouter.get('/exercises/:id', authenticate, getExerciseById);



// Routes restricted to trainers
exerciseRouter.post('/exercises', authenticate, createExercise);
exerciseRouter.put('/exercises/:id', authenticate, updateExercise);
exerciseRouter.delete('/exercises/:id', authenticate, deleteExercise);