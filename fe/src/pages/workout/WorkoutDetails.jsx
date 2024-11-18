/* eslint-disable react/react-in-jsx-scope */
// import { useState, useEffect } from 'react';
// import { useParams } from 'react-router-dom';
// import { userInstance } from '../../utils/axios';

// const WorkoutDetails = () => {
//     const { workoutId } = useParams();
//     const [workout, setWorkout] = useState(null);
//     const [exercises, setExercises] = useState([]);
//     const [loading, setLoading] = useState(true);
//     const [error, setError] = useState('');

//     // Fetch workout details and exercises
//     const fetchWorkoutDetails = async () => {
//         try {
//             const response = await userInstance.get(`/workouts/${workoutId}`);
//             setWorkout(response.data.workout);
//             setExercises(response.data.workout.workoutexercises);
//             setLoading(false);
//         } catch (error) {
//             setError(error.response?.data?.message || 'Failed to fetch workout details');
//             setLoading(false);
//         }
//     };

//     // Fetch workout details on component mount
//     useEffect(() => {
//         fetchWorkoutDetails();
//     }, [workoutId]);

//     return (
//         <div className="flex flex-col items-center justify-center min-h-screen bg-gray-100 p-6">
//             {loading ? (
//                 <p className="text-blue-500">Loading...</p>
//             ) : error ? (
//                 <p className="text-red-500">{error}</p>
//             ) : workout ? (
//                 <div className="w-full max-w-3xl bg-white p-8 rounded-lg shadow-md">
//                     <h2 className="text-3xl font-bold mb-6">{workout.workout_name}</h2>
//                     <p className="mb-4 text-gray-700">{workout.description}</p>
//                     <p className="text-sm text-gray-600 mb-2">
//                         <strong>Target Muscle Group:</strong> {workout.target_muscle_group}
//                     </p>
//                     <p className="text-sm text-gray-600 mb-2">
//                         <strong>Difficulty:</strong> {workout.difficulty}
//                     </p>
//                     <p className="text-sm text-gray-600 mb-6">
//                         <strong>Trainer ID:</strong> {workout.trainer_id}
//                     </p>

//                     <h3 className="text-2xl font-semibold mb-4">Exercises</h3>
//                     {exercises.length === 0 ? (
//                         <p className="text-gray-500">No exercises added to this workout.</p>
//                     ) : (
//                         <ul className="space-y-4">
//                             {exercises.map((exercise) => (
//                                 <li
//                                     key={exercise.workout_exercise_id}
//                                     className="bg-gray-100 p-4 rounded-lg shadow"
//                                 >
//                                     <h4 className="text-lg font-bold">{exercise.exercises.exercise_name}</h4>
//                                     <p className="text-sm text-gray-600">
//                                         {exercise.exercises.description}
//                                     </p>
//                                     <p className="text-sm">
//                                         <strong>Sets:</strong> {exercise.sets}
//                                     </p>
//                                     <p className="text-sm">
//                                         <strong>Reps:</strong> {exercise.reps}
//                                     </p>
//                                     <p className="text-sm">
//                                         <strong>Duration:</strong> {exercise.duration} mins
//                                     </p>
//                                 </li>
//                             ))}
//                         </ul>
//                     )}
//                 </div>
//             ) : (
//                 <p className="text-gray-500">Workout not found</p>
//             )}
//         </div>
//     );
// };

// export default WorkoutDetails;



import { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import { userInstance } from '../../utils/axios';

const WorkoutDetails = () => {
    const { workoutId } = useParams();
    const [workout, setWorkout] = useState(null);
    const [exercises, setExercises] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');

    // Fetch workout details and exercises
    const fetchWorkoutDetails = async () => {
        try {
            const response = await userInstance.get(`/workouts/${workoutId}`);
            setWorkout(response.data.workout);
            setExercises(response.data.workout.workoutexercises);
            setLoading(false);
        } catch (error) {
            setError(error.response?.data?.message || 'Failed to fetch workout details');
            setLoading(false);
        }
    };

    // Fetch workout details on component mount
    useEffect(() => {
        fetchWorkoutDetails();
    }, [workoutId]);

    return (
        <div className="flex flex-col items-center justify-center min-h-screen bg-gray-100 p-6">
            {loading ? (
                <p className="text-blue-500">Loading...</p>
            ) : error ? (
                <p className="text-red-500">{error}</p>
            ) : workout ? (
                <div className="w-full max-w-3xl bg-white p-8 rounded-lg shadow-md">
                    {/* Workout Details */}
                    <h2 className="text-3xl font-bold mb-6">{workout.workout_name}</h2>
                    <p className="mb-4 text-gray-700">{workout.description}</p>
                    <div className="mb-6">
                        <p className="text-sm text-gray-600">
                            <strong>Target Muscle Group:</strong> {workout.target_muscle_group}
                        </p>
                        <p className="text-sm text-gray-600">
                            <strong>Difficulty:</strong> {workout.difficulty}
                        </p>
                        <p className="text-sm text-gray-600">
                            <strong>Trainer ID:</strong> {workout.trainer_id}
                        </p>
                    </div>

                    {/* Exercises List */}
                    <h3 className="text-2xl font-semibold mb-4">Exercises</h3>
                    {exercises.length === 0 ? (
                        <p className="text-gray-500">No exercises added to this workout.</p>
                    ) : (
                        <ul className="space-y-4">
                            {exercises.map((exercise) => (
                                <li
                                    key={exercise.workout_exercise_id}
                                    className="bg-gray-100 p-4 rounded-lg shadow"
                                >
                                    <h4 className="text-lg font-bold">{exercise.exercises.exercise_name}</h4>
                                    <p className="text-gray-700">{exercise.exercises.description}</p>
                                    <div className="mt-3">
                                        <p className="text-sm">
                                            <strong>Target Muscle Group:</strong> {exercise.exercises.target_muscle_group}
                                        </p>
                                        <p className="text-sm">
                                            <strong>Calories Burned:</strong> {exercise.exercises.calories_burned_per_minute} per minute
                                        </p>
                                    </div>
                                    <div className="mt-4">
                                        <p className="text-sm">
                                            <strong>Sets:</strong> {exercise.sets}
                                        </p>
                                        <p className="text-sm">
                                            <strong>Reps:</strong> {exercise.reps}
                                        </p>
                                        <p className="text-sm">
                                            <strong>Duration:</strong> {exercise.duration} seconds
                                        </p>
                                    </div>
                                    {exercise.exercises.image_url && (
                                        <img
                                            src={exercise.exercises.image_url}
                                            alt={exercise.exercises.exercise_name}
                                            className="w-full h-48 object-cover rounded mt-4"
                                        />
                                    )}
                                    {exercise.exercises.video_url && (
                                        <div className="mt-4">
                                            <a
                                                href={exercise.exercises.video_url}
                                                target="_blank"
                                                rel="noopener noreferrer"
                                                className="text-blue-500 hover:underline"
                                            >
                                                Watch Video
                                            </a>
                                        </div>
                                    )}
                                </li>
                            ))}
                        </ul>
                    )}
                </div>
            ) : (
                <p className="text-gray-500">Workout not found</p>
            )}
        </div>
    );
};

export default WorkoutDetails;
