// import express from 'express';
// import { authenticate } from '../middleware/authMiddleware.js';
// import { createSupportedExercise, getAllSupportedExercises, getUserPersonalBestHistory, logPersonalBest, validatePersonalBest, validateSupportedExercise } from '../controllers/personal_best_controller/personalBestController.js';

// export const personalBestRouter = express.Router();

// // Trainer Creates a Supported Exercise
// personalBestRouter.post(
//     '/supported_exercise',
//     authenticate,
//     validateSupportedExercise,
//     createSupportedExercise
// );

// // User Logs a Personal Best
// personalBestRouter.post(
//     '/personal_best',
//     authenticate,
//     validatePersonalBest,
//     logPersonalBest
// );

// // User Retrieves Personal Best History
// personalBestRouter.get(
//     '/user/:userId/history/:exerciseId',
//     authenticate,
//     getUserPersonalBestHistory
// );

// personalBestRouter.get(
//     '/supported_exercises',
//     authenticate,
//     getAllSupportedExercises
// );


import express from 'express';
import { authenticate } from '../middleware/authMiddleware.js';
import {
    createSupportedExercise,
    getAllSupportedExercises,
    getCurrentUserPersonalBestHistory,
    logPersonalBest,
    getUserCurrentPersonalBests,
    deletePersonalBest,
    getExerciseProgressOverTime,
    validatePersonalBest,
    validateSupportedExercise,
    validateGetPersonalBestHistory,
    deleteSupportedExercise
} from '../controllers/personal_best_controller/personalBestController.js';


export const personalBestRouter = express.Router();

// ! Done
// Trainer Creates a Supported Exercise
personalBestRouter.post(
    '/supported_exercise',
    authenticate,
    validateSupportedExercise,
    createSupportedExercise
);


// delete supported exercise
personalBestRouter.delete(
    '/supported_exercise/:exerciseId',
    authenticate,
    validateSupportedExercise,
    deleteSupportedExercise
);

// ! Done
// User Logs a Personal Best
personalBestRouter.post(
    '/personal_best',
    authenticate,
    validatePersonalBest,
    logPersonalBest
);

// ! Done
// Get all supported exercises
personalBestRouter.get(
    '/supported_exercises',
    authenticate,
    getAllSupportedExercises
);

// ! Done
// Current user retrieves their personal best history for a specific exercise
personalBestRouter.get(
    '/history/:exerciseId',
    authenticate,
    validateGetPersonalBestHistory,
    getCurrentUserPersonalBestHistory
);


// ! Done
// Get current user's personal bests for all exercises
personalBestRouter.get(
    '/current_bests',
    authenticate,
    getUserCurrentPersonalBests
);

// ! Done
// Delete a personal best record
personalBestRouter.delete(
    '/personal_best/:personalBestId',
    authenticate,
    deletePersonalBest
);

// ! Done
// Get exercise progress over time
personalBestRouter.get(
    '/progress/:exerciseId',
    authenticate,
    validateGetPersonalBestHistory,
    getExerciseProgressOverTime
);
