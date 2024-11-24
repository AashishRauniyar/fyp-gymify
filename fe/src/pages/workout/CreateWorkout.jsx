// import { useState } from 'react';
// import { userInstance } from '../../utils/axios';
// import { useNavigate } from 'react-router-dom';

// const CreateWorkout = () => {
//     const [formData, setFormData] = useState({
//         workout_name: '',
//         description: '',
//         target_muscle_group: '',
//         difficulty: 'Intermediate'
//     });

//     const [message, setMessage] = useState('');
//     const [errors, setErrors] = useState({});
//     const navigate = useNavigate();

//     // Validate form inputs
//     const validateForm = () => {
//         const errors = {};
//         if (!formData.workout_name) errors.workout_name = 'Workout name is required';
//         if (!formData.description) errors.description = 'Description is required';
//         if (!formData.target_muscle_group) errors.target_muscle_group = 'Target muscle group is required';
//         setErrors(errors);
//         return Object.keys(errors).length === 0;
//     };

//     // Handle input changes
//     const handleChange = (e) => {
//         const { name, value } = e.target;
//         setFormData({ ...formData, [name]: value });
//     };

//     // Handle form submission
//     const handleSubmit = async (e) => {
//         e.preventDefault();

//         if (!validateForm()) return;

//         try {
//             const token = localStorage.getItem('token');
//             const response = await userInstance.post('/workouts', formData, {
//                 headers: {
//                     Authorization: `Bearer ${token}`
//                 }
//             });

//             setMessage(response.data.message);
//             // Redirect to the workouts page after successful creation
//             navigate('/workouts');
//         } catch (error) {
//             setMessage(error.response?.data?.message || 'An error occurred');
//         }
//     };

//     return (
//         <div className="flex items-center justify-center min-h-screen bg-gray-100">
//             <div className="w-full max-w-lg bg-white p-8 rounded-lg shadow-md">
//                 <h2 className="text-2xl font-bold mb-6 text-center">Create Workout</h2>
//                 <form onSubmit={handleSubmit}>
//                     {/* Workout Name */}
//                     <div className="mb-4">
//                         <label className="block mb-2">Workout Name</label>
//                         <input
//                             type="text"
//                             name="workout_name"
//                             value={formData.workout_name}
//                             onChange={handleChange}
//                             className="w-full px-3 py-2 border rounded"
//                         />
//                         {errors.workout_name && (
//                             <p className="text-red-500 text-sm">{errors.workout_name}</p>
//                         )}
//                     </div>

//                     {/* Description */}
//                     <div className="mb-4">
//                         <label className="block mb-2">Description</label>
//                         <textarea
//                             name="description"
//                             value={formData.description}
//                             onChange={handleChange}
//                             className="w-full px-3 py-2 border rounded"
//                         ></textarea>
//                         {errors.description && (
//                             <p className="text-red-500 text-sm">{errors.description}</p>
//                         )}
//                     </div>

//                     {/* Target Muscle Group */}
//                     <div className="mb-4">
//                         <label className="block mb-2">Target Muscle Group</label>
//                         <input
//                             type="text"
//                             name="target_muscle_group"
//                             value={formData.target_muscle_group}
//                             onChange={handleChange}
//                             className="w-full px-3 py-2 border rounded"
//                         />
//                         {errors.target_muscle_group && (
//                             <p className="text-red-500 text-sm">{errors.target_muscle_group}</p>
//                         )}
//                     </div>

//                     {/* Difficulty Level */}
//                     <div className="mb-4">
//                         <label className="block mb-2">Difficulty Level</label>
//                         <select
//                             name="difficulty"
//                             value={formData.difficulty}
//                             onChange={handleChange}
//                             className="w-full px-3 py-2 border rounded"
//                         >
//                             <option value="Easy">Easy</option>
//                             <option value="Intermediate">Intermediate</option>
//                             <option value="Hard">Hard</option>
//                         </select>
//                     </div>

//                     {/* Submit Button */}
//                     <button className="w-full bg-blue-500 text-white py-2 rounded mt-4">
//                         Create Workout
//                     </button>
//                 </form>

//                 {/* Display Message */}
//                 {message && <p className="mt-4 text-red-500">{message}</p>}
//             </div>
//         </div>
//     );
// };

// export default CreateWorkout;

import { useState, useEffect } from 'react';
import { userInstance } from '../../utils/axios';
import { useNavigate } from 'react-router-dom';
import React from 'react';

const CreateWorkout = () => {
    const [workoutData, setWorkoutData] = useState({
        workout_name: '',
        description: '',
        target_muscle_group: 'Full Body',
        difficulty: 'Easy'
    });

    const [exercises, setExercises] = useState([]);
    const [selectedExercises, setSelectedExercises] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    const navigate = useNavigate();

    // Fetch all exercises
    const fetchExercises = async () => {
        try {
            const token = localStorage.getItem('token');
            const response = await userInstance.get('/exercises', {
                headers: {  
                        Authorization: `Bearer ${token}`
                }
            });
            setExercises(response.data.exercises);
            setLoading(false);
        } catch (error) {
            setError(error,'Failed to fetch exercises');
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchExercises();
    }, []);

    // Handle form input changes
    const handleInputChange = (e) => {
        const { name, value } = e.target;
        setWorkoutData({ ...workoutData, [name]: value });
    };

    // Handle adding exercises with sets, reps, and duration
    const handleAddExercise = (exercise) => {
        if (selectedExercises.some((e) => e.exercise_id === exercise.exercise_id)) {
            alert('Exercise already added');
            return;
        }

        setSelectedExercises([...selectedExercises, {
            ...exercise,
            sets: 3,
            reps: 12,
            duration: 30
        }]);
    };

    const handleRemoveExercise = (exerciseId) => {
        setSelectedExercises(selectedExercises.filter((e) => e.exercise_id !== exerciseId));
    };

    const handleExerciseChange = (index, field, value) => {
        const updatedExercises = [...selectedExercises];
        updatedExercises[index][field] = value;
        setSelectedExercises(updatedExercises);
    };

    // Handle creating the workout
    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            const token = localStorage.getItem('token');
            const workoutResponse = await userInstance.post('/workouts', workoutData, {
                headers: { Authorization: `Bearer ${token}` }
            });
    
            const workoutId = workoutResponse.data.workout.workout_id;
    
            if (selectedExercises.length > 0) {
                await userInstance.post(`/workouts/${workoutId}/exercises`, 
                { exercises: selectedExercises }, 
                { headers: { Authorization: `Bearer ${token}` } });
            }
    
            navigate('/workouts');
        } catch (error) {
            console.error('Error creating workout:', error);
            setError(error.response?.data?.message || error.message);
        }
    };
    

    return (
        <div className="min-h-screen flex flex-col items-center justify-center p-6 bg-gray-100">
            <h2 className="text-3xl font-bold mb-6">Create Workout</h2>
            <form onSubmit={handleSubmit} className="w-full max-w-xl bg-white p-8 rounded shadow">
                <input
                    type="text"
                    name="workout_name"
                    placeholder="Workout Name"
                    value={workoutData.workout_name}
                    onChange={handleInputChange}
                    className="w-full mb-4 p-2 border rounded"
                />
                <textarea
                    name="description"
                    placeholder="Description"
                    value={workoutData.description}
                    onChange={handleInputChange}
                    className="w-full mb-4 p-2 border rounded"
                ></textarea>

                {/* Target Muscle Group */}
                <select
                    name="target_muscle_group"
                    value={workoutData.target_muscle_group}
                    onChange={handleInputChange}
                    className="w-full mb-4 p-2 border rounded"
                >
                    <option value="Full Body">Full Body</option>
                    <option value="Upper Body">Upper Body</option>
                    <option value="Lower Body">Lower Body</option>
                    <option value="Core">Core</option>
                    <option value="Legs">Legs</option>
                    <option value="Arms">Arms</option>
                </select>

                {/* Difficulty Level */}
                <select
                    name="difficulty"
                    value={workoutData.difficulty}
                    onChange={handleInputChange}
                    className="w-full mb-4 p-2 border rounded"
                >
                    <option value="Easy">Easy</option>
                    <option value="Intermediate">Intermediate</option>
                    <option value="Hard">Hard</option>
                </select>

                <h3 className="text-xl font-semibold mb-4">Select Exercises</h3>
                {loading ? (
                    <p>Loading exercises...</p>
                ) : (
                    <div className="mb-4">
                        {exercises.map((exercise) => (
                            <button
                                type="button"
                                key={exercise.exercise_id}
                                onClick={() => handleAddExercise(exercise)}
                                className="block bg-blue-500 text-white py-2 px-4 rounded mb-2"
                            >
                                {exercise.exercise_name}
                            </button>
                        ))}
                    </div>
                )}

                <h3 className="text-xl font-semibold mt-6 mb-4">Selected Exercises</h3>
                {selectedExercises.map((exercise, index) => (
                    <div key={exercise.exercise_id} className="bg-gray-200 p-4 rounded mb-2">
                        <span>{exercise.exercise_name}</span>
                        <div className="flex space-x-4 mt-2">
                            <input
                                type="number"
                                placeholder="Sets"
                                value={exercise.sets}
                                onChange={(e) => handleExerciseChange(index, 'sets', parseInt(e.target.value))}
                                className="w-20 p-2 border rounded"
                            />
                            <input
                                type="number"
                                placeholder="Reps"
                                value={exercise.reps}
                                onChange={(e) => handleExerciseChange(index, 'reps', parseInt(e.target.value))}
                                className="w-20 p-2 border rounded"
                            />
                            <input
                                type="number"
                                placeholder="Duration (sec)"
                                value={exercise.duration}
                                onChange={(e) => handleExerciseChange(index, 'duration', parseInt(e.target.value))}
                                className="w-32 p-2 border rounded"
                            />
                        </div>
                        <button
                            type="button"
                            onClick={() => handleRemoveExercise(exercise.exercise_id)}
                            className="text-red-500 mt-2"
                        >
                            Remove
                        </button>
                    </div>
                ))}

                <button type="submit" className="w-full bg-green-500 text-white py-2 rounded mt-6">
                    Create Workout
                </button>
            </form>
            {error && <p className="text-red-500 mt-4">{error}</p>}
        </div>
    );
};

export default CreateWorkout;
