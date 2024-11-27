
// import React from 'react';

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
//             const token = localStorage.getItem('token');
//             const response = await userInstance.get(`/workouts/${workoutId}`, {
//                 headers: {  
//                         Authorization: `Bearer ${token}`
//                 }
//             });
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
//                     {/* Workout Details */}
//                     <h2 className="text-3xl font-bold mb-6">{workout.workout_name}</h2>
//                     <p className="mb-4 text-gray-700">{workout.description}</p>
//                     <div className="mb-6">
//                         <p className="text-sm text-gray-600">
//                             <strong>Target Muscle Group:</strong> {workout.target_muscle_group}
//                         </p>
//                         <p className="text-sm text-gray-600">
//                             <strong>Difficulty:</strong> {workout.difficulty}
//                         </p>
//                         <p className="text-sm text-gray-600">
//                             <strong>Trainer ID:</strong> {workout.trainer_id}
//                         </p>
//                     </div>

//                     {/* Exercises List */}
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
//                                     <p className="text-gray-700">{exercise.exercises.description}</p>
//                                     <div className="mt-3">
//                                         <p className="text-sm">
//                                             <strong>Target Muscle Group:</strong> {exercise.exercises.target_muscle_group}
//                                         </p>
//                                         <p className="text-sm">
//                                             <strong>Calories Burned:</strong> {exercise.exercises.calories_burned_per_minute} per minute
//                                         </p>
//                                     </div>
//                                     <div className="mt-4">
//                                         <p className="text-sm">
//                                             <strong>Sets:</strong> {exercise.sets}
//                                         </p>
//                                         <p className="text-sm">
//                                             <strong>Reps:</strong> {exercise.reps}
//                                         </p>
//                                         <p className="text-sm">
//                                             <strong>Duration:</strong> {exercise.duration} seconds
//                                         </p>
//                                     </div>
//                                     {exercise.exercises.image_url && (
//                                         <img
//                                             src={exercise.exercises.image_url}
//                                             alt={exercise.exercises.exercise_name}
//                                             className="w-full h-48 object-cover rounded mt-4"
//                                         />
//                                     )}
//                                     {exercise.exercises.video_url && (
//                                         <div className="mt-4">
//                                             <a
//                                                 href={exercise.exercises.video_url}
//                                                 target="_blank"
//                                                 rel="noopener noreferrer"
//                                                 className="text-blue-500 hover:underline"
//                                             >
//                                                 Watch Video
//                                             </a>
//                                         </div>
//                                     )}
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



// import React, { useState, useEffect } from 'react';
// import { useParams } from 'react-router-dom';
// import { userInstance } from '../../utils/axios';

// const WorkoutDetails = () => {
//     const { workoutId } = useParams();
//     const [workout, setWorkout] = useState(null);
//     const [exercises, setExercises] = useState([]);
//     const [currentExerciseIndex, setCurrentExerciseIndex] = useState(0);
//     const [loading, setLoading] = useState(true);
//     const [error, setError] = useState('');
//     const [workoutLogId, setWorkoutLogId] = useState(null);

//     // Fetch workout details and exercises
//     const fetchWorkoutDetails = async () => {
//         try {
//             const token = localStorage.getItem('token');
//             const response = await userInstance.get(`/workouts/${workoutId}`, {
//                 headers: {
//                     Authorization: `Bearer ${token}`,
//                 },
//             });
//             setWorkout(response.data.workout);
//             setExercises(response.data.workout.workoutexercises);
//             setLoading(false);
//         } catch (error) {
//             setError(error.response?.data?.message || 'Failed to fetch workout details');
//             setLoading(false);
//         }
//     };

//     // Start workout
//     const startWorkout = async () => {
//         try {
//             const token = localStorage.getItem('token');
//             const response = await userInstance.post(
//                 '/workouts/start',
//                 { workout_id: parseInt(workoutId, 10) },
//                 {
//                     headers: {
//                         Authorization: `Bearer ${token}`,
//                     },
//                 }
//             );
//             setWorkoutLogId(response.data.workoutLog.log_id);
//             alert('Workout started!');
//         } catch (error) {
//             setError(error.response?.data?.message || 'Failed to start workout');
//         }
//     };

//     // Log exercise
//     const logExercise = async (skipped = false) => {
//         if (!workoutLogId || currentExerciseIndex >= exercises.length) return;

//         const exercise = exercises[currentExerciseIndex];
//         try {
//             const token = localStorage.getItem('token');
//             await userInstance.post(
//                 '/workouts/log-exercise',
//                 {
//                     workout_log_id: workoutLogId,
//                     exercise_id: exercise.exercise_id,
//                     duration: exercise.duration,
//                     skipped,
//                 },
//                 {
//                     headers: {
//                         Authorization: `Bearer ${token}`,
//                     },
//                 }
//             );
//             if (currentExerciseIndex + 1 < exercises.length) {
//                 setCurrentExerciseIndex((prev) => prev + 1);
//             } else {
//                 alert('Workout completed!');
//             }
//         } catch (error) {
//             setError(error.response?.data?.message || 'Failed to log exercise');
//         }
//     };

//     // Finish workout
//     const finishWorkout = async () => {
//         try {
//             const token = localStorage.getItem('token');
//             await userInstance.post(
//                 '/workouts/finish',
//                 {
//                     workout_log_id: workoutLogId,
//                     calories_burned: exercises.reduce(
//                         (total, ex) => total + ex.exercises.calories_burned_per_minute * (ex.duration / 60),
//                         0
//                     ),
//                     performance_notes: 'Completed successfully!',
//                 },
//                 {
//                     headers: {
//                         Authorization: `Bearer ${token}`,
//                     },
//                 }
//             );
//             alert('Workout finished successfully!');
//         } catch (error) {
//             setError(error.response?.data?.message || 'Failed to finish workout');
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
//                     {/* Workout Details */}
//                     <h2 className="text-3xl font-bold mb-6">{workout.workout_name}</h2>
//                     <p className="mb-4 text-gray-700">{workout.description}</p>
//                     <div className="mb-6">
//                         <p className="text-sm text-gray-600">
//                             <strong>Target Muscle Group:</strong> {workout.target_muscle_group}
//                         </p>
//                         <p className="text-sm text-gray-600">
//                             <strong>Difficulty:</strong> {workout.difficulty}
//                         </p>
//                         <p className="text-sm text-gray-600">
//                             <strong>Trainer ID:</strong> {workout.trainer_id}
//                         </p>
//                     </div>

//                     {/* Start Workout Button */}
//                     {!workoutLogId && (
//                         <button
//                             onClick={startWorkout}
//                             className="bg-blue-500 text-white px-6 py-2 rounded shadow mb-6"
//                         >
//                             Start Workout
//                         </button>
//                     )}

//                     {/* Exercise Progress */}
//                     {workoutLogId && exercises.length > 0 && (
//                         <div className="w-full">
//                             <h3 className="text-2xl font-semibold mb-4">
//                                 Current Exercise: {currentExerciseIndex + 1}/{exercises.length}
//                             </h3>
//                             <div className="bg-gray-100 p-4 rounded-lg shadow mb-6">
//                                 <h4 className="text-lg font-bold">
//                                     {exercises[currentExerciseIndex].exercises.exercise_name}
//                                 </h4>
//                                 <p className="text-gray-700">{exercises[currentExerciseIndex].exercises.description}</p>
//                                 <div className="mt-3">
//                                     <p className="text-sm">
//                                         <strong>Duration:</strong> {exercises[currentExerciseIndex].duration} seconds
//                                     </p>
//                                     <p className="text-sm">
//                                         <strong>Sets:</strong> {exercises[currentExerciseIndex].sets}
//                                     </p>
//                                     <p className="text-sm">
//                                         <strong>Reps:</strong> {exercises[currentExerciseIndex].reps}
//                                     </p>
//                                 </div>
//                             </div>

//                             <button
//                                 onClick={() => logExercise(false)}
//                                 className="bg-green-500 text-white px-4 py-2 rounded shadow mr-2"
//                             >
//                                 Complete
//                             </button>
//                             <button
//                                 onClick={() => logExercise(true)}
//                                 className="bg-yellow-500 text-white px-4 py-2 rounded shadow"
//                             >
//                                 Skip
//                             </button>
//                         </div>
//                     )}

//                     {/* Finish Workout Button */}
//                     {workoutLogId && currentExerciseIndex === exercises.length && (
//                         <button
//                             onClick={finishWorkout}
//                             className="bg-red-500 text-white px-6 py-2 rounded shadow mt-6"
//                         >
//                             Finish Workout
//                         </button>
//                     )}
//                 </div>
//             ) : (
//                 <p className="text-gray-500">Workout not found</p>
//             )}
//         </div>
//     );
// };

// export default WorkoutDetails;


import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import { userInstance } from '../../utils/axios';

const WorkoutDetails = () => {
    const { workoutId } = useParams();
    const [workout, setWorkout] = useState(null);
    const [exercises, setExercises] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    const [isWorkoutStarted, setIsWorkoutStarted] = useState(false);
    const [workoutLog, setWorkoutLog] = useState(null);
    const [performanceNotes, setPerformanceNotes] = useState(''); // Performance notes input
    const [startTime, setStartTime] = useState(null); // To calculate end time

    // Fetch workout details and exercises
    const fetchWorkoutDetails = async () => {
        try {
            const token = localStorage.getItem('token');
            const { data } = await userInstance.get(`/workouts/${workoutId}`, {
                headers: {  
                    Authorization: `Bearer ${token}`
                }
            });

            setWorkout(data.workout);
            setExercises(data.workout.workoutexercises);
            setLoading(false);
        } catch (error) {
            setError(error.response?.data?.message || 'Failed to fetch workout details');
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchWorkoutDetails();
    }, [workoutId]);

    // Handle starting the workout
    const handleStartWorkout = async () => {
        try {
            // Convert workoutId to an integer
        const id = parseInt(workoutId, 10);
            const token = localStorage.getItem('token');
            const { data } = await userInstance.post(
                '/workouts/start', 
                { workout_id: id, workout_date: new Date() },
                { headers: { Authorization: `Bearer ${token}` } }
            );
            setIsWorkoutStarted(true);
            setWorkoutLog(data.workoutLog); // Save workout log data
            setStartTime(new Date()); // Set the start time
            alert('Workout started successfully!');
        } catch (error) {
            setError(error.response?.data?.message || 'Failed to start workout');
        }
    };

    // Handle logging exercise
    const handleLogExercise = async (exerciseId, duration, skipped) => {
        try {
            if (!workoutLog) {
                alert('Workout not started yet!');
                return;
            }

            const token = localStorage.getItem('token');
            const { data } = await userInstance.post(
                '/workouts/logExercise',
                { workout_log_id: workoutLog.log_id, exercise_id: exerciseId, duration, skipped },
                { headers: { Authorization: `Bearer ${token}` } }
            );
            console.log('Exercise logged:', data);  // Use the response data if needed
        } catch (error) {
            setError(error.response?.data?.message || 'Failed to log exercise');
        }
    };

    // Handle finishing the workout
    const handleFinishWorkout = async () => {
        try {
            if (!workoutLog) {
                alert('Workout not started yet!');
                return;
            }

            const endTime = new Date(); // Get current time as end time
            const totalDuration = Math.floor((endTime - startTime) / 1000); // Calculate total duration in seconds

            const token = localStorage.getItem('token');
            const { data } = await userInstance.post(
                '/workouts/finish', 
                {
                    workout_log_id: workoutLog.log_id,
                    performance_notes: performanceNotes,  // Send performance notes
                    calories_burned: workoutLog.calories_burned,  // Example: You may calculate this based on logged exercises
                    end_time: endTime, // Send end time
                    total_duration: totalDuration // Send total workout duration
                },
                { headers: { Authorization: `Bearer ${token}` } }
            );
            setIsWorkoutStarted(false);
            setWorkoutLog(null); // Reset the workout log after finishing
            setPerformanceNotes(''); // Reset performance notes
            setStartTime(null); // Reset start time
            alert('Workout finished successfully!');
        } catch (error) {
            setError(error.response?.data?.message || 'Failed to finish workout');
        }
    };

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

                    {/* Start Workout Button */}
                    {!isWorkoutStarted && (
                        <button
                            onClick={handleStartWorkout}
                            className="bg-blue-500 text-white px-6 py-2 rounded-lg shadow-md hover:bg-blue-600"
                        >
                            Start Workout
                        </button>
                    )}

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

                                    {/* Log Exercise Button */}
                                    {isWorkoutStarted && (
                                        <button
                                            onClick={() => handleLogExercise(exercise.exercise_id, exercise.duration, false)}
                                            className="mt-4 bg-green-500 text-white px-4 py-2 rounded-lg hover:bg-green-600"
                                        >
                                            Log Exercise
                                        </button>
                                    )}
                                </li>
                            ))}
                        </ul>
                    )}

                    {/* Performance Notes Section */}
                    {isWorkoutStarted && (
                        <div className="mt-6">
                            <label className="block text-sm font-semibold mb-2">Performance Notes</label>
                            <textarea
                                value={performanceNotes}
                                onChange={(e) => setPerformanceNotes(e.target.value)}
                                className="w-full p-3 border border-gray-300 rounded-lg shadow-sm"
                                placeholder="Enter your notes here"
                            ></textarea>
                        </div>
                    )}

                    {/* Finish Workout Button */}
                    {isWorkoutStarted && (
                        <button
                            onClick={handleFinishWorkout}
                            className="mt-6 bg-red-500 text-white px-6 py-2 rounded-lg shadow-md hover:bg-red-600"
                        >
                            Finish Workout
                        </button>
                    )}
                </div>
            ) : (
                <p className="text-gray-500">Workout not found</p>
            )}
        </div>
    );
};

export default WorkoutDetails;
