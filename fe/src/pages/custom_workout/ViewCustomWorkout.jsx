import { useState, useEffect } from 'react';
import { userInstance } from '../../utils/axios';
import React from 'react';

// eslint-disable-next-line react/prop-types
const ViewCustomWorkout = ({ customWorkoutId }) => {
    const [exercises, setExercises] = useState([]);

    const fetchCustomWorkoutExercises = async () => {
        const token = localStorage.getItem('token');
        try {
            const response = await userInstance.get(`/custom-workouts/${customWorkoutId}/exercises`,
                {
                    headers: {  
                            Authorization: `Bearer ${token}`
                    }
                }
            );
            setExercises(response.data.exercises);
        } catch (error) {
            console.error('Error fetching custom workout exercises:', error);
        }
    };

    const handleRemoveExercise = async (exerciseId) => {
        try {
            await userInstance.delete(`/custom-workouts/exercises/${exerciseId}`);
            setExercises((prev) => prev.filter((e) => e.custom_workout_exercise_id !== exerciseId));
        } catch (error) {
            console.error('Error removing exercise:', error);
        }
    };

    useEffect(() => {
        fetchCustomWorkoutExercises();
    }, [customWorkoutId]);

    return (
        <div className="container">
            <h2>Custom Workout Exercises</h2>
            <ul>
                {exercises.map((exercise) => (
                    <li key={exercise.custom_workout_exercise_id}>
                        {exercise.exercises.exercise_name}
                        <button onClick={() => handleRemoveExercise(exercise.custom_workout_exercise_id)}>
                            Remove
                        </button>
                    </li>
                ))}
            </ul>
        </div>
    );
};

export default ViewCustomWorkout;
