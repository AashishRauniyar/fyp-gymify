import express from 'express';
import { authenticate } from '../middleware/authMiddleware.js';
import { logWorkout,  getWorkoutLogs, getUserLogs, updateExerciseLog, deleteLog, logMultipleExercises } from '../controllers/workoutLogController.js';

export const workoutLogRouter = express.Router();

// Routes for logging and fetching workout logs

// Log a workout (accessible to authenticated users)
workoutLogRouter.post('/workoutlogs', authenticate, logWorkout);



// Get logs for a specific workout (accessible to authenticated users)
workoutLogRouter.get('/workoutlogs/:workout_id', authenticate, getWorkoutLogs);

// Get all logs for a specific user (accessible to authenticated users)
workoutLogRouter.get('/userlogs/:user_id', authenticate, getUserLogs);

// Update a specific exercise log (accessible to authenticated users)
workoutLogRouter.put('/workoutexerciseslogs/:log_id', authenticate, updateExerciseLog);

// Delete a workout or exercise log (accessible to authenticated users)
// `:type` can be 'workout' or 'exercise' to specify the log type to delete
workoutLogRouter.delete('/logs/:log_id/:type', authenticate, deleteLog);



// Log multiple exercises (accessible to authenticated users)
workoutLogRouter.post('/bulkworkoutexerciseslogs',authenticate, logMultipleExercises);