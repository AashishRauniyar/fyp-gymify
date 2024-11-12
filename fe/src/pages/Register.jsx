import { useState } from 'react';
import { userInstance } from '../utils/axios';

const Register = () => {
    const [formData, setFormData] = useState({
        user_name: '',
        full_name: '',
        email: '',
        password: '',
        phone_number: '',
        address: '',
        age: '',
        height: '',
        current_weight: '',
        gender: 'Male',
        role: 'Member',
        fitness_level: 'Beginner',
        goal_type: 'Weight_Loss',
        card_number: ''
    });

    const [message, setMessage] = useState('');
    const [errors, setErrors] = useState({});

    // Validate form inputs before submission
    const validateForm = () => {
        const errors = {};

        // Required fields
        if (!formData.user_name) errors.user_name = 'Username is required';
        if (!formData.full_name) errors.full_name = 'Full name is required';
        if (!formData.email) errors.email = 'Email is required';
        if (!formData.password) errors.password = 'Password is required';
        if (!formData.phone_number) errors.phone_number = 'Phone number is required';
        if (!formData.gender) errors.gender = 'Gender is required';
        if (!formData.role) errors.role = 'Role is required';
        if (!formData.fitness_level) errors.fitness_level = 'Fitness level is required';
        if (!formData.goal_type) errors.goal_type = 'Goal type is required';

        // Type validations
        if (isNaN(Number(formData.age)) || formData.age < 0) errors.age = 'Age must be a positive number';
        if (isNaN(Number(formData.height)) || formData.height <= 0) errors.height = 'Height must be a positive number';
        if (isNaN(Number(formData.current_weight)) || formData.current_weight <= 0) errors.current_weight = 'Weight must be a positive number';

        setErrors(errors);
        return Object.keys(errors).length === 0;
    };

    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData({ ...formData, [name]: value });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        if (!validateForm()) return;

        try {
            const response = await userInstance.post('/register', {
                ...formData,
                age: parseInt(formData.age, 10),
                height: parseFloat(formData.height),
                current_weight: parseFloat(formData.current_weight)
            });
            setMessage(response.data.message);
            console.log("user registerd successfully")
        } catch (error) {
            setMessage(error.response?.data?.message || 'An error occurred during registration');
        }
    };

    return (
        <div className="flex items-center justify-center min-h-screen bg-gray-100">
            <div className="w-full max-w-md bg-white p-8 rounded-lg shadow-md">
                <h2 className="text-2xl font-bold mb-6 text-center">Register</h2>
                <form onSubmit={handleSubmit}>
                    {/* Loop through each input field */}
                    {Object.keys(formData).map((key) => (
                        <div key={key} className="mb-4">
                            <label className="block mb-2 capitalize">
                                {key.replace('_', ' ')}
                            </label>
                            <input
                                type={key === 'password' ? 'password' : 'text'}
                                name={key}
                                value={formData[key]}
                                onChange={handleChange}
                                className="w-full px-3 py-2 border rounded"
                            />
                            {errors[key] && <p className="text-red-500 text-sm">{errors[key]}</p>}
                        </div>
                    ))}

                    <button className="w-full bg-blue-500 text-white py-2 rounded mt-4">Sign Up</button>
                </form>
                {message && <p className="mt-4 text-green-500">{message}</p>}
            </div>
        </div>
    );
};

export default Register;
