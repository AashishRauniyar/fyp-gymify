import { useState, useEffect } from 'react';
import { userInstance } from '../../utils/axios';
import React from 'react';

// eslint-disable-next-line react/prop-types
const AddExercisesToCustomWorkout = ({ customWorkoutId }) => {

    

    const [exercises, setExercises] = useState([]);
    const [selectedExercises, setSelectedExercises] = useState([]);
    const [message, setMessage] = useState('');

    const token = localStorage.getItem('token');

    const fetchExercises = async () => {
        try {
            const response = await userInstance.get('/exercises',
                {
                    headers: {  
                            Authorization: `Bearer ${token}`
                    }
                }
            );
            setExercises(response.data.exercises);
        } catch (error) {
            console.error('Error fetching exercises:', error);
        }
    };

    const handleAddExercise = async () => {
        try {
            const response = await userInstance.post('/custom-workouts/exercises', {
                custom_workout_id: customWorkoutId,
                exercises: selectedExercises,
            });
            setMessage(response.data.message);
        } catch (error) {
            setMessage(error.response?.data?.message || 'Error adding exercises');
        }
    };

    const toggleExerciseSelection = (exercise) => {
        setSelectedExercises((prev) =>
            prev.some((e) => e.exercise_id === exercise.exercise_id)
                ? prev.filter((e) => e.exercise_id !== exercise.exercise_id)
                : [...prev, { exercise_id: exercise.exercise_id, sets: 3, reps: 12, duration: 10 }]
        );
    };

    useEffect(() => {
        fetchExercises();
    }, []);

    return (
        <div className="container">
            <h2>Add Exercises to Custom Workout</h2>
            {message && <p>{message}</p>}
            <div>
                {exercises.map((exercise) => (
                    <div key={exercise.exercise_id}>
                        <label>
                            <input
                                type="checkbox"
                                onChange={() => toggleExerciseSelection(exercise)}
                            />
                            {exercise.exercise_name}
                        </label>
                    </div>
                ))}
            </div>
            <button onClick={handleAddExercise}>Add Selected Exercises</button>
        </div>
    );
};

export default AddExercisesToCustomWorkout;
