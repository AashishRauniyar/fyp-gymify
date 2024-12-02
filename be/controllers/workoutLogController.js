import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();


// export const startWorkout = async (req, res) => {
//     try {
//         const { user_id } = req.user;
//         let { workout_id } = req.body;

//         // Validate the workout ID
//         if (!workout_id) {
//             return res.status(400).json({ status: 'failure', message: 'Workout ID is required' });
//         }

//         // Convert workout_id to integer if it's a string
//         workout_id = parseInt(workout_id, 10);

//         if (isNaN(workout_id)) {
//             return res.status(400).json({ status: 'failure', message: 'Invalid Workout ID' });
//         }

//         // Check if the workout exists
//         const workout = await prisma.workouts.findUnique({ where: { workout_id } });
//         if (!workout) {
//             return res.status(404).json({ status: 'failure', message: 'Workout not found' });
//         }

//         // Create a new workout log
//         const workoutLog = await prisma.workoutlogs.create({
//             data: {
//                 user_id,
//                 workout_id,
//                 workout_date: new Date(),
//                 start_time: new Date(),
//             },
//         });

//         res.status(201).json({ status: 'success', message: 'Workout started successfully', workoutLog });
//     } catch (error) {
//         console.error('Error starting workout:', error);
//         res.status(500).json({ status: 'failure', message: 'Server error' });
//     }
// };




// export const logExercise = async (req, res) => {
//     try {
//         const { workout_log_id, exercise_id, duration, skipped } = req.body;

//         // Validate required fields
//         if (!workout_log_id || !exercise_id) {
//             return res.status(400).json({ status: 'failure', message: 'Workout log ID and exercise ID are required' });
//         }

//         // Parse and validate duration
//         const parsedDuration = parseFloat(duration);
//         if (isNaN(parsedDuration)) {
//             return res.status(400).json({ status: 'failure', message: 'Invalid exercise duration' });
//         }

//         // Check if the workout log exists
//         const workoutLog = await prisma.workoutlogs.findUnique({
//             where: { log_id: workout_log_id },
//         });
//         if (!workoutLog) {
//             return res.status(404).json({ status: 'failure', message: 'Workout log not found' });
//         }

//         // Check if the exercise exists
//         const exercise = await prisma.exercises.findUnique({
//             where: { exercise_id },
//         });
//         if (!exercise) {
//             return res.status(404).json({ status: 'failure', message: 'Exercise not found' });
//         }

//         // Create a new exercise log
//         const exerciseLog = await prisma.workoutexerciseslogs.create({
//             data: {
//                 workout_log_id,
//                 exercise_id,
//                 start_time: new Date(),
//                 exercise_duration: parsedDuration,
//                 rest_duration: skipped ? null : 60, // Default rest duration is 60s
//                 skipped,
//             },
//         });

//         res.status(201).json({ status: 'success', message: 'Exercise logged successfully', exerciseLog });
//     } catch (error) {
//         console.error('Error logging exercise:', error);
//         res.status(500).json({ status: 'failure', message: 'Server error' });
//     }
// };



// export const finishWorkout = async (req, res) => {
//     try {
//         const { workout_log_id, calories_burned, performance_notes } = req.body;

//         // Validate required fields
//         if (!workout_log_id) {
//             return res.status(400).json({ status: 'failure', message: 'Workout log ID is required' });
//         }

//         // Check if the workout log exists
//         const workoutLog = await prisma.workoutlogs.findUnique({ where: { log_id: workout_log_id } });
//         if (!workoutLog) {
//             return res.status(404).json({ status: 'failure', message: 'Workout log not found' });
//         }

//         // Update the workout log with end time and performance details
//         const updatedLog = await prisma.workoutlogs.update({
//             where: { log_id: workout_log_id },
//             data: {
//                 end_time: new Date(),
//                 total_duration: new Date().getTime() - new Date(workoutLog.start_time).getTime(),
//                 calories_burned,
//                 performance_notes
//             }
//         });

//         res.status(200).json({ status: 'success', message: 'Workout finished successfully', updatedLog });
//     } catch (error) {
//         console.error('Error finishing workout:', error);
//         res.status(500).json({ status: 'failure', message: 'Server error' });
//     }
// };

export const startWorkout = async (req, res) => {
    try {
        const { user_id } = req.user;
        const { workout_id, workout_date } = req.body;

        if (!user_id) {
            return res.status(400).json({ status: 'failure', message: 'User ID is required' });
        }

        if (!workout_id) {
            return res.status(400).json({ status: 'failure', message: 'Workout ID is required' });
        }

        // Validate workout_date is provided
        if (!workout_date) {
            return res.status(400).json({ status: 'failure', message: 'Workout date is required' });
        }

        const workout = await prisma.workouts.findUnique({ where: { workout_id } });
        if (!workout) {
            return res.status(404).json({ status: 'failure', message: 'Workout not found' });
        }

        const workoutLog = await prisma.workoutlogs.create({
            data: {
                user_id,
                workout_id,
                workout_date: new Date(workout_date),  // Use the provided workout_date
                start_time: new Date(), // Start time is the current timestamp
            },
        });

        res.status(201).json({ status: 'success', message: 'Workout started', workoutLog });
    } catch (error) {
        console.error('Error starting workout:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};



export const logExercise = async (req, res) => {
    try {
        const { workout_log_id, exercise_id, duration, skipped } = req.body;

        if (!workout_log_id || !exercise_id) {
            return res.status(400).json({ status: 'failure', message: 'Workout log ID and exercise ID are required' });
        }

        const parsedDuration = parseFloat(duration);
        if (isNaN(parsedDuration) || parsedDuration <= 0) {
            return res.status(400).json({ status: 'failure', message: 'Invalid exercise duration' });
        }

        const workoutLog = await prisma.workoutlogs.findUnique({ where: { log_id: workout_log_id } });
        if (!workoutLog) {
            return res.status(404).json({ status: 'failure', message: 'Workout log not found' });
        }

        const exercise = await prisma.exercises.findUnique({ where: { exercise_id } });
        if (!exercise) {
            return res.status(404).json({ status: 'failure', message: 'Exercise not found' });
        }

        // Use current time as start time for the exercise log
        const exerciseLog = await prisma.workoutexerciseslogs.create({
            data: {
                workout_log_id,
                exercise_id,
                start_time: new Date(),
                exercise_duration: parsedDuration,
                rest_duration: skipped ? 0 : 60,  // Default rest duration is 60s if not skipped
                skipped: skipped || false,  // If skipped is not provided, default to false
            },
        });

        res.status(201).json({ status: 'success', message: 'Exercise logged', exerciseLog });
    } catch (error) {
        console.error('Error logging exercise:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};


export const finishWorkout = async (req, res) => {
    try {
        const { workout_log_id, calories_burned, performance_notes } = req.body;

        if (!workout_log_id) {
            return res.status(400).json({ status: 'failure', message: 'Workout log ID is required' });
        }

        const workoutLog = await prisma.workoutlogs.findUnique({ where: { log_id: workout_log_id } });
        if (!workoutLog) {
            return res.status(404).json({ status: 'failure', message: 'Workout log not found' });
        }

        const parsedCaloriesBurned = parseFloat(calories_burned) || 0;

        // Calculate the total duration in minutes
        const endTime = new Date();
        const startTime = new Date(workoutLog.start_time);
        const totalDuration = (endTime - startTime) / 60000;  // Duration in minutes

        const updatedLog = await prisma.workoutlogs.update({
            where: { log_id: workout_log_id },
            data: {
                end_time: endTime,
                total_duration: totalDuration,
                calories_burned: parsedCaloriesBurned,
                performance_notes: performance_notes || '',  // Default to empty string if no performance notes
            },
        });

        res.status(200).json({ status: 'success', message: 'Workout finished', updatedLog });
    } catch (error) {
        console.error('Error finishing workout:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};



