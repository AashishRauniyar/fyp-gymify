import express from 'express';
import { forgetPassword, register } from '../controllers/authController.js';
import { login, resetPassword } from '../controllers/authController.js';
import { getProfile } from '../controllers/profileController.js';
import { updateProfile } from '../controllers/profileController.js';
import { authenticate } from '../middleware/authMiddleware.js';
import { 
    createExercise, 
    getAllExercises, 
    getExerciseById, 
    updateExercise, 
    deleteExercise 
} from '../controllers/exerciseController.js';

import { 
    getAllWorkouts, 
    getWorkoutById, 
    updateWorkout, 
    deleteWorkout 
} from '../controllers/workoutController.js';

import { createWorkout, addExerciseToWorkout } from '../controllers/workoutController.js';

import {
    createCustomWorkout,
    addExerciseToCustomWorkout,
    getCustomWorkoutExercises,
    removeExerciseFromCustomWorkout
} from '../controllers/customWorkoutController.js';
import upload from '../middleware/multerMiddleware.js';




const router = express.Router();

// Public routes for user registration and login
router.post('/register',upload.single('profile_image'), register);
router.post('/login', login);
router.post('/forget-password', forgetPassword );
router.post('/reset-password', resetPassword);


// Protected route for getting and updating user profile
router.get('/profile',authenticate, getProfile);
router.put('/profile',authenticate, updateProfile);




// Routes accessible to everyone
router.get('/exercises', getAllExercises);
router.get('/exercises/:id', getExerciseById);

// Routes restricted to trainers
router.post('/exercises', authenticate, createExercise);
router.put('/exercises/:id', authenticate, updateExercise);
router.delete('/exercises/:id', authenticate, deleteExercise);




// Route to create a new workout (Trainers only)
router.post('/workouts', authenticate, createWorkout);

// Route to add an exercise to a workout (Trainer Only)
router.post('/workouts/:workoutId/exercises', authenticate, addExerciseToWorkout);

// View all workouts (All users)
router.get('/workouts', getAllWorkouts);

// View details of a specific workout (All users)
router.get('/workouts/:id', getWorkoutById);

// Update a workout (Trainer Only)
router.put('/workouts/:id', authenticate, updateWorkout);

// Delete a workout (Trainer Only)
router.delete('/workouts/:id', authenticate, deleteWorkout);



// Routes for managing custom workouts
router.post('/custom-workouts', authenticate, createCustomWorkout);
router.post('/custom-workouts/add-exercise', authenticate, addExerciseToCustomWorkout);
router.get('/custom-workouts/:id/exercises', authenticate, getCustomWorkoutExercises);
// Route to remove an exercise from a custom workout
router.delete('/custom-workouts/exercises/:id', authenticate, removeExerciseFromCustomWorkout);


// // log exercises
// router.post('/log-exercise', authenticate, logExercise);
// router.get('/log-exercise', authenticate, getLoggedExercises);

// // log workout
// router.post('/log-workout', authenticate, logWorkout);
// router.get('/log-workout', authenticate, getLoggedWorkouts);

export default router;
