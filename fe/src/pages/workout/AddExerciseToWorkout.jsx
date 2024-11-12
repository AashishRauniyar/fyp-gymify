import { useState, useEffect } from 'react';
import { userInstance } from '../../utils/axios';

// eslint-disable-next-line react/prop-types
const AddExercisesToWorkout = ({ workoutId }) => {
    const [exercises, setExercises] = useState([]);
    const [selectedExercises, setSelectedExercises] = useState([]);
    const [message, setMessage] = useState('');

    useEffect(() => {
        const fetchExercises = async () => {
            const response = await userInstance.get('/exercises');
            setExercises(response.data.exercises);
        };
        fetchExercises();
    }, []);

    const handleSelectExercise = (exercise) => {
        if (!selectedExercises.find((ex) => ex.exercise_id === exercise.exercise_id)) {
            setSelectedExercises([...selectedExercises, { ...exercise, sets: '', reps: '', duration: '' }]);
        }
    };

    const handleDetailChange = (index, field, value) => {
        const updatedExercises = [...selectedExercises];
        updatedExercises[index][field] = value;
        setSelectedExercises(updatedExercises);
    };

    const handleAddExercises = async () => {
        try {
            const response = await userInstance.post(`/workouts/${workoutId}/exercises`, { exercises: selectedExercises });
            setMessage(response.data.message);
            setSelectedExercises([]);
        } catch (error) {
            
            setMessage(error,'Failed to add exercises');
        }
    };

    return (
        <div>
            <h2>Add Exercises to Workout</h2>
            <div className="exercise-list">
                {exercises.map((exercise) => (
                    <button
                        key={exercise.exercise_id}
                        onClick={() => handleSelectExercise(exercise)}
                        disabled={selectedExercises.find((ex) => ex.exercise_id === exercise.exercise_id)}
                        className="exercise-button"
                    >
                        {exercise.exercise_name}
                    </button>
                ))}
            </div>
            {selectedExercises.length > 0 && (
                <div>
                    {selectedExercises.map((exercise, index) => (
                        <div key={exercise.exercise_id}>
                            <h4>{exercise.exercise_name}</h4>
                            <input
                                type="number"
                                placeholder="Sets"
                                onChange={(e) => handleDetailChange(index, 'sets', e.target.value)}
                            />
                            <input
                                type="number"
                                placeholder="Reps"
                                onChange={(e) => handleDetailChange(index, 'reps', e.target.value)}
                            />
                            <input
                                type="number"
                                placeholder="Duration"
                                onChange={(e) => handleDetailChange(index, 'duration', e.target.value)}
                            />
                        </div>
                    ))}
                    <button onClick={handleAddExercises}>Add Exercises</button>
                </div>
            )}
            {message && <p>{message}</p>}
        </div>
    );
};

export default AddExercisesToWorkout;
