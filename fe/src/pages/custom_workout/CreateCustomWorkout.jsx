import { useState } from 'react';
import { userInstance } from '../../utils/axios';
import React from 'react';

const CreateCustomWorkout = () => {
    const [customWorkoutName, setCustomWorkoutName] = useState('');
    const [message, setMessage] = useState('');

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {

            const token = localStorage.getItem('token');

            const response = await userInstance.post('/custom-workouts', { custom_workout_name: customWorkoutName },
                {
                    headers: {
                        Authorization: `Bearer ${token}`
                    }
                }
            );
            setMessage(response.data.message);
        } catch (error) {
            setMessage(error.response?.data?.message || 'Error creating custom workout');
        }
    };

    return (
        <div className="container">
            <h2>Create Custom Workout</h2>
            <form onSubmit={handleSubmit}>
                <input
                    type="text"
                    value={customWorkoutName}
                    onChange={(e) => setCustomWorkoutName(e.target.value)}
                    placeholder="Workout Name"
                    required
                />
                <button type="submit">Create Workout</button>
            </form>
            {message && <p>{message}</p>}
        </div>
    );
};

export default CreateCustomWorkout;
