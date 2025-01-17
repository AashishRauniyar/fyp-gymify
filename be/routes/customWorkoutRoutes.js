import express from 'express';


import { authenticate } from '../middleware/authMiddleware.js';
import { addExerciseToCustomWorkout, createCustomWorkout, getCustomWorkoutById, getCustomWorkoutExercisesById, getCustomWorkoutsOfUser, removeExerciseFromCustomWorkout } from '../controllers/customWorkoutController.js';

export const customWorkoutRouter = express.Router();


// Routes for managing custom workouts
customWorkoutRouter.post('/custom-workouts', authenticate, createCustomWorkout);
//route to get customer workouts of a user
customWorkoutRouter.get('/custom-workouts', authenticate, getCustomWorkoutsOfUser);

customWorkoutRouter.post('/custom-workouts/add-exercise', authenticate, addExerciseToCustomWorkout);
customWorkoutRouter.get('/custom-workouts/:id/exercises', authenticate, getCustomWorkoutExercisesById);
// Route to remove an exercise from a custom workout
customWorkoutRouter.delete('/custom-workouts/exercises/:id', authenticate, removeExerciseFromCustomWorkout);



customWorkoutRouter.get('/custom-workouts/:id', authenticate, getCustomWorkoutById);

