import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();


export const logWorkout = async (req, res) => {
    const {
        user_id,
        workout_id,
        start_time,
        end_time,
        total_duration,
        calories_burned,
        performance_notes,
    } = req.body;

    try {
        const workoutLog = await prisma.workoutlogs.create({
            data: {
                user_id,
                workout_id,
                start_time: start_time ? new Date(start_time) : null,
                end_time: end_time ? new Date(end_time) : null,
                total_duration,
                calories_burned,
                performance_notes,
            },
        });

        res.status(200).json({ status: 'success', message: "workout logged succesfully", data: workoutLog });
    } catch (error) {
        console.error('Error logging workout:', error.message);
        res.status(500).json({ status: 'error', message: 'Failed to log workout' });
    }
};


export const logExercise = async (req, res) => {
    const {
        workout_log_id,
        exercise_id,
        start_time,
        end_time,
        exercise_duration,
        rest_duration,
        skipped,
    } = req.body;

    try {
        const exerciseLog = await prisma.workoutexerciseslogs.create({
            data: {
                workout_log_id,
                exercise_id,
                start_time: start_time ? new Date(start_time) : null,
                end_time: end_time ? new Date(end_time) : null,
                exercise_duration,
                rest_duration,
                skipped,
            },
        });

        res.status(200).json({ status: 'success', message: "exercise logged succesfully", data: exerciseLog });
    } catch (error) {
        console.error('Error logging exercise:', error.message);
        res.status(500).json({ status: 'error', message: 'Failed to log exercise' });
    }
};

export const getWorkoutLogs = async (req, res) => {
    const { workout_id } = req.params;

    try {
        const logs = await prisma.workoutlogs.findMany({
            where: { workout_id: parseInt(workout_id) },
            include: {
                workoutexerciseslogs: {
                    include: { exercises: true },
                },
            },
        });

        if (!logs) {
            return res.status(404).json({ status: 'error', message: 'No logs found' });
        }

        res.status(200).json({ status: 'success', data: logs });
    } catch (error) {
        console.error('Error fetching workout logs:', error.message);
        res.status(500).json({ status: 'error', message: 'Failed to fetch logs' });
    }
};



export const deleteLog = async (req, res) => {
    const { log_id, type } = req.params; // `type` can be 'workout' or 'exercise'

    try {
        if (type === 'workout') {
            await prisma.workoutlogs.delete({
                where: { log_id: parseInt(log_id) },
            });
        } else if (type === 'exercise') {
            await prisma.workoutexerciseslogs.delete({
                where: { log_id: parseInt(log_id) },
            });
        } else {
            return res.status(400).json({ status: 'error', message: 'Invalid log type' });
        }

        res.status(200).json({ status: 'success', message: 'Log deleted successfully' });
    } catch (error) {
        console.error('Error deleting log:', error.message);
        res.status(500).json({ status: 'error', message: 'Failed to delete log' });
    }
};



export const updateExerciseLog = async (req, res) => {
    const { log_id } = req.params;
    const { start_time, end_time, exercise_duration, rest_duration, skipped } = req.body;

    try {
        const updatedLog = await prisma.workoutexerciseslogs.update({
            where: { log_id: parseInt(log_id) },
            data: {
                start_time: start_time ? new Date(start_time) : null,
                end_time: end_time ? new Date(end_time) : null,
                exercise_duration,
                rest_duration,
                skipped,
            },
        });

        res.status(200).json({ status: 'success', data: updatedLog });
    } catch (error) {
        console.error('Error updating exercise log:', error.message);
        res.status(500).json({ status: 'error', message: 'Failed to update log' });
    }
};


export const getUserLogs = async (req, res) => {
    const { user_id } = req.params;

    try {
        const logs = await prisma.workoutlogs.findMany({
            where: { user_id: parseInt(user_id) },
            include: {
                workoutexerciseslogs: {
                    include: { exercises: true },
                },
            },
        });

        res.status(200).json({ status: 'success', data: logs });
    } catch (error) {
        console.error('Error fetching user logs:', error.message);
        res.status(500).json({ status: 'error', message: 'Failed to fetch logs' });
    }
};



//!-----------------------------------------------


export const logMultipleExercises = async (req, res) => {
    const { exercises } = req.body; // Expecting an array of exercise logs

    try {
        // Use Prisma's `createMany` to insert multiple exercise logs
        const logs = await prisma.workoutexerciseslogs.createMany({
            data: exercises.map((exercise) => ({
                workout_log_id: exercise.workout_log_id,
                exercise_id: exercise.exercise_id,
                start_time: exercise.start_time ? new Date(exercise.start_time) : null,
                end_time: exercise.end_time ? new Date(exercise.end_time) : null,
                exercise_duration: exercise.exercise_duration,
                rest_duration: exercise.rest_duration,
                skipped: exercise.skipped,
            })),
        });

        res.status(200).json({ status: 'success', message:"all exercise logged", data: logs });
    } catch (error) {
        console.error('Error logging multiple exercises:', error.message);
        res
            .status(500)
            .json({ status: 'error', message: 'Failed to log multiple exercises' });
    }
};
