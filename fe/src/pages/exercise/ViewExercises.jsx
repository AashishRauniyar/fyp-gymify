import { useEffect, useState } from 'react';
import { userInstance } from '../../utils/axios';
import React from 'react';
const ViewExercises = () => {
    const [exercises, setExercises] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');

    // Fetch exercises from the server
    const fetchExercises = async () => {
        try {

            const token = localStorage.getItem('token');

            const response = await userInstance.get('/exercises', {
                headers: {  
                        Authorization: `Bearer ${token}`
                }
            }
            );
            setExercises(response.data.exercises);
            setLoading(false);
        } catch (error) {
            setError(error.response?.data?.message || 'Failed to fetch workouts');
            setLoading(false);
        }
    };

    // Fetch exercises on component mount
    useEffect(() => {
        fetchExercises();
    }, []);

    return (
        <div className="flex flex-col items-center justify-center min-h-screen bg-gray-100">
            <div className="w-full max-w-4xl bg-white p-8 rounded-lg shadow-md">
                <h2 className="text-3xl font-bold mb-6 text-center">Exercise List</h2>

                {loading && <p className="text-center">Loading...</p>}
                {error && <p className="text-center text-red-500">{error}</p>}

                {!loading && exercises.length === 0 && (
                    <p className="text-center text-gray-500">No exercises found.</p>
                )}

                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                    {exercises.map((exercise) => (
                        <div
                            key={exercise.exercise_id}
                            className="bg-gray-200 p-4 rounded-lg shadow hover:shadow-lg transition"
                        >
                            <h3 className="text-xl font-semibold mb-2">{exercise.exercise_name}</h3>
                            <p className="text-gray-700 mb-2">{exercise.description}</p>
                            <p>
                                <span className="font-bold">Target Muscle Group:</span>{' '}
                                {exercise.target_muscle_group}
                            </p>
                            <p>
                                <span className="font-bold">Calories Burned:</span>{' '}
                                {exercise.calories_burned_per_minute} kcal/min
                            </p>
                            {exercise.image_url && (
                                <img
                                    src={exercise.image_url}
                                    alt={exercise.exercise_name}
                                    className="w-full h-48 object-cover rounded mt-4"
                                />
                            )}
                            {exercise.video_url && (
                                <a
                                    href={exercise.video_url}
                                    target="_blank"
                                    rel="noopener noreferrer"
                                    className="text-blue-500 underline mt-4 block"
                                >
                                    Watch Video
                                </a>
                            )}
                        </div>
                    ))}
                </div>
            </div>
        </div>
    );
};

export default ViewExercises;
