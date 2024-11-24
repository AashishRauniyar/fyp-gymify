import { useState, useEffect } from "react";
import { userInstance } from "../../utils/axios";
import React from "react";

const ViewCustomWorkouts = () => {
    const [customWorkouts, setCustomWorkouts] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState("");

    // Fetch custom workouts of the user

    

    const fetchCustomWorkouts = async () => {
        try {
            const response = await userInstance.get("/custom-workouts",
                {
                    headers: { Authorization: `Bearer ${localStorage.getItem("token")}` },
                }
            );
            setCustomWorkouts(response.data.customWorkouts);
            setLoading(false);
        } catch (error) {
            setError(
                error.response?.data?.message || "Failed to fetch custom workouts"
            );
            setLoading(false);
        }
    };

    // Fetch custom workouts on component mount
    useEffect(() => {
        fetchCustomWorkouts();
    }, []);

    return (
        <div className="flex flex-col items-center justify-center min-h-screen bg-gray-100 p-6">
            <h2 className="text-3xl font-bold mb-6 text-center">My Custom Workouts</h2>

            {loading ? (
                <p className="text-blue-500">Loading...</p>
            ) : error ? (
                <p className="text-red-500">{error}</p>
            ) : customWorkouts.length === 0 ? (
                <p className="text-gray-500">No custom workouts found</p>
            ) : (
                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 w-full max-w-6xl">
                    {customWorkouts.map((workout) => (
                        <div
                            key={workout.custom_workout_id}
                            className="bg-white p-6 rounded-lg shadow-md"
                        >
                            <h3 className="text-xl font-semibold mb-2">
                                {workout.custom_workout_name}
                            </h3>
                            <p className="mb-4 text-gray-700">
                                Created At: {new Date(workout.created_at).toLocaleDateString()}
                            </p>

                            <h4 className="text-lg font-semibold mb-2">Exercises:</h4>
                            {workout.customworkoutexercises.length === 0 ? (
                                <p className="text-gray-500">No exercises added yet</p>
                            ) : (
                                <ul className="list-disc list-inside">
                                    {workout.customworkoutexercises.map((exercise) => (
                                        <li key={exercise.custom_workout_exercise_id} className="mb-2">
                                            <p className="font-semibold">{exercise.exercises.exercise_name}</p>
                                            <p className="text-sm text-gray-600">
                                                Sets: {exercise.sets}, Reps: {exercise.reps}, Duration:{" "}
                                                {exercise.duration} mins
                                            </p>
                                        </li>
                                    ))}
                                </ul>
                            )}
                        </div>
                    ))}
                </div>
            )}
        </div>
    );
};

export default ViewCustomWorkouts;
