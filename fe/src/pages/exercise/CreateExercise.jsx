import { useState } from 'react';
import { userInstance } from '../../utils/axios';
import { useNavigate } from 'react-router-dom';
import React from 'react';
const CreateExercise = () => {
    const [formData, setFormData] = useState({
        exercise_name: '',
        description: '',
        target_muscle_group: '',
        calories_burned_per_minute: '',
        image_url: '',
        video_url: '',
    });

    const [message, setMessage] = useState('');
    const [loading, setLoading] = useState(false);
    const navigate = useNavigate();

    // Handle form input changes
    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData({ ...formData, [name]: value });
    };

    // Handle form submission
    const handleSubmit = async (e) => {
        e.preventDefault();

        // Validate required fields
        if (!formData.exercise_name || !formData.description || !formData.target_muscle_group || !formData.calories_burned_per_minute) {
            setMessage('Please fill in all required fields.');
            return;
        }

        setLoading(true);
        setMessage('');

        try {
            const token = localStorage.getItem('token');
            const response = await userInstance.post('/exercises', formData, {
                headers: {
                    Authorization: `Bearer ${token}`
                }
            });

            setMessage(response.data.message);
            setLoading(false);
            navigate('/exercises'); // Redirect to exercises page after successful creation
        } catch (error) {
            setMessage(error.response?.data?.message || 'Failed to create exercise');
            setLoading(false);
        }
    };

    return (
        <div className="flex items-center justify-center min-h-screen bg-gray-100">
            <div className="w-full max-w-lg bg-white p-8 rounded-lg shadow-md">
                <h2 className="text-3xl font-bold mb-6 text-center">Create Exercise</h2>
                <form onSubmit={handleSubmit}>
                    <div className="mb-4">
                        <label className="block mb-2">Exercise Name</label>
                        <input
                            type="text"
                            name="exercise_name"
                            value={formData.exercise_name}
                            onChange={handleChange}
                            className="w-full px-3 py-2 border rounded"
                            required
                        />
                    </div>
                    <div className="mb-4">
                        <label className="block mb-2">Description</label>
                        <textarea
                            name="description"
                            value={formData.description}
                            onChange={handleChange}
                            className="w-full px-3 py-2 border rounded"
                            required
                        />
                    </div>
                    <div className="mb-4">
                        <label className="block mb-2">Target Muscle Group</label>
                        <input
                            type="text"
                            name="target_muscle_group"
                            value={formData.target_muscle_group}
                            onChange={handleChange}
                            className="w-full px-3 py-2 border rounded"
                            required
                        />
                    </div>
                    <div className="mb-4">
                        <label className="block mb-2">Calories Burned per Minute</label>
                        <input
                            type="number"
                            name="calories_burned_per_minute"
                            value={formData.calories_burned_per_minute}
                            onChange={handleChange}
                            className="w-full px-3 py-2 border rounded"
                            required
                        />
                    </div>
                    <div className="mb-4">
                        <label className="block mb-2">Image URL</label>
                        <input
                            type="text"
                            name="image_url"
                            value={formData.image_url}
                            onChange={handleChange}
                            className="w-full px-3 py-2 border rounded"
                        />
                    </div>
                    <div className="mb-4">
                        <label className="block mb-2">Video URL</label>
                        <input
                            type="text"
                            name="video_url"
                            value={formData.video_url}
                            onChange={handleChange}
                            className="w-full px-3 py-2 border rounded"
                        />
                    </div>
                    <button
                        type="submit"
                        className={`w-full bg-blue-500 text-white py-2 rounded ${loading ? 'opacity-50' : ''}`}
                        disabled={loading}
                    >
                        {loading ? 'Creating...' : 'Create Exercise'}
                    </button>
                </form>
                {message && <p className="mt-4 text-center text-red-500">{message}</p>}
            </div>
        </div>
    );
};

export default CreateExercise;
