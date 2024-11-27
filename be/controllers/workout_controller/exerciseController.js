import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

// Create a new exercise (Trainer only)
export const createExercise = async (req, res) => {
    try {
        const { user_id, role } = req.user;

        // Ensure only trainers can create exercises
        if (role !== 'Trainer') {
            return res.status(403).json({ status: 'failure', message: 'Access denied. Trainers only' });
        }

        const { exercise_name, description, target_muscle_group, calories_burned_per_minute, image_url, video_url } = req.body;

        if (!exercise_name || !description || !target_muscle_group || !calories_burned_per_minute) {
            return res.status(400).json({ status: 'failure', message: 'Missing required fields' });
        }

        const exercise = await prisma.exercises.create({
            data: {
                exercise_name,
                description,
                target_muscle_group,
                calories_burned_per_minute,
                image_url,
                video_url,
                created_at: new Date()
            }
        });

        res.status(201).json({ status: 'success', message: 'Exercise created successfully', exercise });
    } catch (error) {
        console.error('Error creating exercise:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};


// Get all Exercises
export const getAllExercises = async (req, res) => {

    const {user_id} = req.user;
    // Ensure only trainers can create exercises
    if (!user_id) {
        return res.status(403).json({ status: 'failure', message: 'Access denied. Please login first' });
    }

    try {
        const exercises = await prisma.exercises.findMany({
            select: {
                exercise_id: true,
                exercise_name: true,
                description: true,
                target_muscle_group: true,
                calories_burned_per_minute: true,
                image_url: true,
                video_url: true,
                created_at: true,
                updated_at: true
            }
        });
        res.status(200).json({ status: 'success', exercises });
    } catch (error) {
        console.error('Error fetching exercises:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};


export const getExerciseById = async (req, res) => {


    const {user_id} = req.user;
    // Ensure only trainers can create exercises
    if (!user_id) {
        return res.status(403).json({ status: 'failure', message: 'Access denied. Please login first' });
    }

    try {
        const exerciseId = parseInt(req.params.id);

        const exercise = await prisma.exercises.findUnique({
            where: { exercise_id: exerciseId },
            select: {
                exercise_id: true,
                exercise_name: true,
                description: true,
                target_muscle_group: true,
                calories_burned_per_minute: true,
                image_url: true,
                video_url: true,
                created_at: true,
                updated_at: true
            }
        });

        if (!exercise) {
            return res.status(404).json({ status: 'failure', message: 'Exercise not found' });
        }

        res.status(200).json({ status: 'success', exercise });
    } catch (error) {
        console.error('Error fetching exercise:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};


// Update Exercise by id
export const updateExercise = async (req, res) => {
    try {
        const { user_id, role } = req.user;

        if (role !== 'Trainer') {
            return res.status(403).json({ status: 'failure', message: 'Access denied. Trainers only' });
        }

        const exerciseId = parseInt(req.params.id);
        const { exercise_name, description, target_muscle_group, calories_burned_per_minute, image_url, video_url } = req.body;

        const exerciseExists = await prisma.exercises.findUnique({ where: { exercise_id: exerciseId } });
        if (!exerciseExists) {
            return res.status(404).json({ status: 'failure', message: 'Exercise not found' });
        }

        const exercise = await prisma.exercises.update({
            where: { exercise_id: exerciseId },
            data: {
                exercise_name,
                description,
                target_muscle_group,
                calories_burned_per_minute,
                image_url,
                video_url,
                updated_at: new Date()
            }
        });

        res.status(200).json({ status: 'success', message: 'Exercise updated successfully', exercise });
    } catch (error) {
        console.error('Error updating exercise:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};



// Delete Exercise by id
export const deleteExercise = async (req, res) => {
    try {
        const { user_id, role } = req.user;

        if (role !== 'Trainer') {
            return res.status(403).json({ status: 'failure', message: 'Access denied. Trainers only' });
        }

        const exerciseId = parseInt(req.params.id);

        const exerciseExists = await prisma.exercises.findUnique({ where: { exercise_id: exerciseId } });
        if (!exerciseExists) {
            return res.status(404).json({ status: 'failure', message: 'Exercise not found' });
        }

        await prisma.exercises.delete({ where: { exercise_id: exerciseId } });
        res.status(200).json({ status: 'success', message: 'Exercise deleted successfully' });
    } catch (error) {
        console.error('Error deleting exercise:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};
