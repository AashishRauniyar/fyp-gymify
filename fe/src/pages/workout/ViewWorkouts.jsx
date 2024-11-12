import { useState, useEffect } from 'react';
import { userInstance } from '../../utils/axios';
import { Link } from 'react-router-dom';

const ViewWorkouts = () => {
    const [workouts, setWorkouts] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');

    // Fetch workouts from the backend
    const fetchWorkouts = async () => {
        try {
            const response = await userInstance.get('/workouts');
            setWorkouts(response.data.workouts);
            setLoading(false);
        } catch (error) {
            setError(error.response?.data?.message || 'Failed to fetch workouts');
            setLoading(false);
        }
    };

    // Fetch workouts on component mount
    useEffect(() => {
        fetchWorkouts();
    }, []);

    return (
        <div className="flex flex-col items-center justify-center min-h-screen bg-gray-100 p-6">
            <h2 className="text-3xl font-bold mb-8 text-center">Available Workouts</h2>
            
            {loading ? (
                <p className="text-blue-500">Loading...</p>
            ) : error ? (
                <p className="text-red-500">{error}</p>
            ) : workouts.length === 0 ? (
                <p className="text-gray-500">No workouts found</p>
            ) : (
                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                    {workouts.map((workout) => (
                        <div key={workout.workout_id} className="bg-white p-6 rounded-lg shadow-md">
                            <h3 className="text-xl font-semibold mb-2">{workout.workout_name}</h3>
                            <p className="mb-4 text-gray-700">{workout.description}</p>
                            <p className="text-sm text-gray-600">
                                <strong>Target Muscle Group:</strong> {workout.target_muscle_group}
                            </p>
                            <p className="text-sm text-gray-600">
                                <strong>Difficulty:</strong> {workout.difficulty}
                            </p>
                            <p className="text-sm text-gray-600">
                                <strong>Trainer ID:</strong> {workout.trainer_id}
                            </p>
                            <Link
                                to={`/workouts/${workout.workout_id}`}
                                className="block mt-4 text-blue-500 hover:underline"
                            >
                                View Details
                            </Link>
                        </div>
                    ))}
                </div>
            )}
        </div>
    );
};

export default ViewWorkouts;

