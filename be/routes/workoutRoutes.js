import express from 'express';
import { addExerciseToWorkout, bulkCreateWorkouts, createWorkout, deleteWorkout, getAllWorkouts, getWorkoutById, updateWorkout } from '../controllers/workout_controller/workoutController.js';
import { authenticate } from '../middleware/authMiddleware.js';
import upload from '../middleware/multerMiddleware.js';


export const workoutRouter = express.Router();



// Route to create a new workout (Trainers only)
workoutRouter.post('/create-workouts', upload.single('workout_image'), authenticate, createWorkout);

// Route to add an exercise to a workout (Trainer Only)
workoutRouter.post('/workouts/:workoutId/exercises', authenticate, addExerciseToWorkout);


// View all workouts (All users)
workoutRouter.get('/workouts', authenticate, getAllWorkouts);


// View details of a specific workout (All users)
workoutRouter.get('/workouts/:id', authenticate, getWorkoutById);

// Update a workout (Trainer Only)
workoutRouter.put('/workouts/:id', authenticate, updateWorkout);

// Delete a workout (Trainer Only)
workoutRouter.delete('/workouts/:id', authenticate, deleteWorkout);


// Add this to your workoutRouter.js file
workoutRouter.post('/bulk-create-workouts', upload.array('workout_images'), authenticate, bulkCreateWorkouts);