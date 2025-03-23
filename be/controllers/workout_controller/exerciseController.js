import { PrismaClient } from '@prisma/client';
import { uploadExerciseImageToCloudinary, uploadExerciseVideoToCloudinary } from '../../middleware/cloudinaryMiddleware.js';

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

        //? working for images
        // let exerciseImageUrl = null;
        // if (req.file) {
        //     try {
        //         exerciseImageUrl = await uploadExerciseImageToCloudinary(req.file.buffer); // Pass the file buffer directly
        //     } catch (error) {
        //         console.error('Error uploading image:', error);
        //         return res.status(500).json({ status: 'failure', message: 'Image upload failed' });
        //     }
        // }


        //! testing for videos

        // Image upload handling
        let exerciseImageUrl = null;
        if (req.files && req.files.image) {
            try {
                exerciseImageUrl = await uploadExerciseImageToCloudinary(req.files.image[0].buffer); // Access the first image file in the array
            } catch (error) {
                console.error('Error uploading image:', error);
                return res.status(500).json({ status: 'failure', message: 'Image upload failed' });
            }
        }

        // Video upload handling
        let exerciseVideoUrl = null;
        if (req.files && req.files.video) {
            try {
                exerciseVideoUrl = await uploadExerciseVideoToCloudinary(req.files.video[0].buffer); // Access the first video file in the array
            } catch (error) {
                console.error('Error uploading video:', error);
                return res.status(500).json({ status: 'failure', message: 'Video upload failed' });
            }
        }

        const exercise = await prisma.exercises.create({
            data: {
                exercise_name,
                description,
                target_muscle_group,
                calories_burned_per_minute,
                image_url : exerciseImageUrl,
                video_url : exerciseVideoUrl,
                created_at: new Date()
            }
        });

        res.status(201).json({ status: 'success', message: 'Exercise created successfully', data: exercise });
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
        res.status(200).json({ status: 'success', message: "data fetched successfully", data: exercises });
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

        res.status(200).json({ status: 'success', message: "Exercise fetched successfully" , data: exercise });
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


export const bulkCreateExercises = async (req, res) => {
    try {
        const { user_id, role } = req.user;
        // Ensure the user is a trainer
        if (role !== 'Trainer') {
            return res.status(403).json({ status: 'failure', message: 'Access denied. Trainers only' });
        }
        // Get the exercises data from the request body
        const { exercises } = req.body;
        // Parse JSON if it's a string
        const exercisesData = typeof exercises === 'string' ? JSON.parse(exercises) : exercises;
        // Validate exercises data
        if (!Array.isArray(exercisesData) || exercisesData.length === 0) {
            return res.status(400).json({ status: 'failure', message: 'No exercises provided or invalid format' });
        }
        // Get uploaded files
        const uploadedImages = req.files?.images || [];
        const uploadedVideos = req.files?.videos || [];
        
        // Create mappings between exercise index and files
        const imageMap = {};
        uploadedImages.forEach(file => {
            // Expecting filenames like "exercise_0_image.jpg", "exercise_1_image.png" 
            const match = file.originalname.match(/exercise_(\d+)_image/);
            if (match && match[1]) {
                const exerciseIndex = parseInt(match[1]);
                imageMap[exerciseIndex] = file;
            }
        });
        const videoMap = {};
        uploadedVideos.forEach(file => {
            // Expecting filenames like "exercise_0_video.mp4", "exercise_1_video.mov"
            const match = file.originalname.match(/exercise_(\d+)_video/);
            if (match && match[1]) {
                const exerciseIndex = parseInt(match[1]);
                videoMap[exerciseIndex] = file;
            }
        });
        // Create exercises with their media files
        const createdExercises = [];
        
        for (let i = 0; i < exercisesData.length; i++) {
            const exercise = exercisesData[i];
            const { 
                exercise_name, 
                description, 
                target_muscle_group, 
                calories_burned_per_minute
            } = exercise;
            // Validate required exercise fields
            if (!exercise_name || !description || !target_muscle_group || calories_burned_per_minute === undefined) {
                continue; // Skip invalid exercises
            }

            // Upload image if available for this exercise
            let exerciseImageUrl = null;
            if (imageMap[i]) {
                try {
                    exerciseImageUrl = await uploadExerciseImageToCloudinary(imageMap[i].buffer);
                } catch (error) {
                    console.error(`Error uploading image for exercise ${i}:`, error);
                    // Continue without image if upload fails
                }
            }

            // Upload video if available for this exercise
            let exerciseVideoUrl = null;
            if (videoMap[i]) {
                try {
                    exerciseVideoUrl = await uploadExerciseVideoToCloudinary(videoMap[i].buffer);
                } catch (error) {
                    console.error(`Error uploading video for exercise ${i}:`, error);
                    // Continue without video if upload fails
                }
            }

            // Create the exercise
            const createdExercise = await prisma.exercises.create({
                data: {
                    exercise_name,
                    description,
                    target_muscle_group,
                    calories_burned_per_minute,
                    image_url: exerciseImageUrl,
                    video_url: exerciseVideoUrl,
                    created_at: new Date()
                }
            });

            createdExercises.push(createdExercise);
        }

        res.status(201).json({
            status: 'success',
            message: `Successfully created ${createdExercises.length} exercises`,
            data: createdExercises
        });
    } catch (error) {
        console.error('Error bulk creating exercises:', error);
        res.status(500).json({ status: 'failure', message: 'Server error' });
    }
};