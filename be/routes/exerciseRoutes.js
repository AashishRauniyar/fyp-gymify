import express from 'express';
import { authenticate } from '../middleware/authMiddleware.js';
import { createExercise, deleteExercise, getAllExercises, getExerciseById, updateExercise } from '../controllers/workout_controller/exerciseController.js';
import upload from '../middleware/multerMiddleware.js';


export const exerciseRouter = express.Router();



// Routes accessible to everyone
exerciseRouter.get('/exercises', authenticate ,getAllExercises);
exerciseRouter.get('/exercises/:id', authenticate, getExerciseById);



//! testing
// Routes restricted to trainers
exerciseRouter.post('/exercises', upload.fields([
    { name: 'image', maxCount: 1 },   // Image file upload
    { name: 'video', maxCount: 1 }    // Video file upload
]), authenticate, createExercise);
exerciseRouter.put('/exercises/:id', authenticate, updateExercise);
exerciseRouter.delete('/exercises/:id', authenticate, deleteExercise);




// Routes restricted to trainers
//? working
// exerciseRouter.post('/exercises', upload.single('exercise_image'),authenticate, createExercise);