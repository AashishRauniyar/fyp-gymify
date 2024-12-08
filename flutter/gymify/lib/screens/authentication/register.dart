// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:gymify/services/register_service.dart';
// import 'package:image_picker/image_picker.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({Key? key}) : super(key: key);

//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _authService = AuthService();

//   // Controllers for text fields
//   final TextEditingController _userNameController = TextEditingController();
//   final TextEditingController _fullNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _ageController = TextEditingController();
//   final TextEditingController _heightController = TextEditingController();
//   final TextEditingController _weightController = TextEditingController();
//   final TextEditingController _calorieGoalsController = TextEditingController();
//   final TextEditingController _cardNumberController = TextEditingController();
//   final TextEditingController _allergiesController = TextEditingController();

//   // Dropdown values
//   String _selectedGender = 'Male';
//   String _selectedRole = 'Member';
//   String _selectedFitnessLevel = 'Beginner';
//   String _selectedGoalType = 'Muscle Gain';

//   File? _profilePicture;
//   final ImagePicker _picker = ImagePicker();

//   // Function to pick profile picture
//   Future<void> _pickProfilePicture() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _profilePicture = File(pickedFile.path);
//       });
//     }
//   }

//   // Function to register user
//   Future<void> _register() async {
//     if (!_formKey.currentState!.validate()) return;

//     final result = await _authService.registerUser(
//       userName: _userNameController.text.trim(),
//       fullName: _fullNameController.text.trim(),
//       email: _emailController.text.trim(),
//       password: _passwordController.text.trim(),
//       phoneNumber: _phoneController.text.trim(),
//       address: _addressController.text.trim(),
//       gender: _selectedGender,
//       role: _selectedRole,
//       fitnessLevel: _selectedFitnessLevel,
//       goalType: _selectedGoalType,
//       age: int.parse(_ageController.text.trim()),
//       height: double.parse(_heightController.text.trim()),
//       weight: double.parse(_weightController.text.trim()),
//       calorieGoals: _calorieGoalsController.text.trim(),
//       cardNumber: _cardNumberController.text.trim(),
//       allergies: _allergiesController.text.trim(),
//       profilePicture: _profilePicture,
//     );

//     if (result['success']) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Registration successful!')),
//       );
//       Navigator.pushNamed(context, '/login');
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(result['message'] ?? 'Registration failed!')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Register')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               GestureDetector(
//                 onTap: _pickProfilePicture,
//                 child: CircleAvatar(
//                   radius: 60,
//                   backgroundImage: _profilePicture != null
//                       ? FileImage(_profilePicture!)
//                       : null,
//                   child: _profilePicture == null
//                       ? const Icon(Icons.camera_alt, size: 50)
//                       : null,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _userNameController,
//                 decoration: const InputDecoration(labelText: 'Username'),
//                 validator: (value) =>
//                     value!.isEmpty ? 'Enter your username' : null,
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _fullNameController,
//                 decoration: const InputDecoration(labelText: 'Full Name'),
//                 validator: (value) =>
//                     value!.isEmpty ? 'Enter your full name' : null,
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(labelText: 'Email'),
//                 validator: (value) => value!.isEmpty || !value.contains('@')
//                     ? 'Enter a valid email'
//                     : null,
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: const InputDecoration(labelText: 'Password'),
//                 obscureText: true,
//                 validator: (value) => value!.length < 8
//                     ? 'Password must be at least 8 characters'
//                     : null,
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _phoneController,
//                 decoration: const InputDecoration(labelText: 'Phone Number'),
//                 keyboardType: TextInputType.phone,
//                 validator: (value) =>
//                     value!.length != 10 ? 'Enter a valid phone number' : null,
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _addressController,
//                 decoration: const InputDecoration(labelText: 'Address'),
//                 validator: (value) =>
//                     value!.isEmpty ? 'Enter your address' : null,
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _ageController,
//                 decoration: const InputDecoration(labelText: 'Age'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) =>
//                     value!.isEmpty || int.tryParse(value) == null
//                         ? 'Enter a valid age'
//                         : null,
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _heightController,
//                 decoration: const InputDecoration(labelText: 'Height (in cm)'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) =>
//                     value!.isEmpty || double.tryParse(value) == null
//                         ? 'Enter a valid height'
//                         : null,
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _weightController,
//                 decoration: const InputDecoration(labelText: 'Weight (in kg)'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) =>
//                     value!.isEmpty || double.tryParse(value) == null
//                         ? 'Enter a valid weight'
//                         : null,
//               ),
//               const SizedBox(height: 8),
//               DropdownButtonFormField(
//                 value: _selectedGender,
//                 items: ['Male', 'Female', 'Other']
//                     .map((gender) => DropdownMenuItem(
//                           value: gender,
//                           child: Text(gender),
//                         ))
//                     .toList(),
//                 onChanged: (value) => setState(() => _selectedGender = value!),
//                 decoration: const InputDecoration(labelText: 'Gender'),
//               ),
//               const SizedBox(height: 8),
//               DropdownButtonFormField(
//                 value: _selectedFitnessLevel,
//                 items: ['Beginner', 'Intermediate', 'Advanced']
//                     .map((level) => DropdownMenuItem(
//                           value: level,
//                           child: Text(level),
//                         ))
//                     .toList(),
//                 onChanged: (value) =>
//                     setState(() => _selectedFitnessLevel = value!),
//                 decoration: const InputDecoration(labelText: 'Fitness Level'),
//               ),
//               const SizedBox(height: 8),
//               DropdownButtonFormField(
//                 value: _selectedGoalType,
//                 items: ['Endurance', 'Muscle Gain', 'Maintain Weight']
//                     .map((goal) => DropdownMenuItem(
//                           value: goal,
//                           child: Text(goal),
//                         ))
//                     .toList(),
//                 onChanged: (value) =>
//                     setState(() => _selectedGoalType = value!),
//                 decoration: const InputDecoration(labelText: 'Goal Type'),
//               ),
//               DropdownButtonFormField(
//                 value: _selectedRole,
//                 items: ['Member', 'Trainer', 'Admin']
//                     .map((role) => DropdownMenuItem(
//                           value: role,
//                           child: Text(role),
//                         ))
//                     .toList(),
//                 onChanged: (value) => setState(() => _selectedRole = value!),
//                 decoration: const InputDecoration(labelText: 'Role'),
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _calorieGoalsController,
//                 decoration: const InputDecoration(
//                     labelText: 'Calorie Goals (Optional)'),
//                 keyboardType: TextInputType.number,
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _cardNumberController,
//                 decoration: const InputDecoration(labelText: 'Card Number'),
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _allergiesController,
//                 decoration:
//                     const InputDecoration(labelText: 'Allergies (Optional)'),
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _register,
//                 child: const Text('Register'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gymify/services/register_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // For date formatting

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  // Controllers for text fields
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _calorieGoalsController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();

  // Date picker variables
  String _selectedBirthdate = ''; // Store birthdate as a string

  // Dropdown values
  String _selectedGender = 'Male';
  String _selectedRole = 'Member';
  String _selectedFitnessLevel = 'Beginner';
  String _selectedGoalType = 'Muscle Gain';

  File? _profilePicture;
  final ImagePicker _picker = ImagePicker();

  // Function to pick profile picture
  Future<void> _pickProfilePicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profilePicture = File(pickedFile.path);
      });
    }
  }

  // Function to register user
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final result = await _authService.registerUser(
      userName: _userNameController.text.trim(),
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      gender: _selectedGender,
      role: _selectedRole,
      fitnessLevel: _selectedFitnessLevel,
      goalType: _selectedGoalType,
      birthdate: _selectedBirthdate, // Pass birthdate here
      height: double.parse(_heightController.text.trim()),
      weight: double.parse(_weightController.text.trim()),
      calorieGoals: _calorieGoalsController.text.trim(),
      cardNumber: _cardNumberController.text.trim(),
      allergies: _allergiesController.text.trim(),
      profilePicture: _profilePicture,
    );

    if (result['success']) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!')),
        );
        Navigator.pushNamed(context, '/login');
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Registration failed!')),
        );
      }
    }
  }

  // Function to show date picker and set birthdate
  Future<void> _selectBirthdate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      setState(() {
        _selectedBirthdate = DateFormat('yyyy-MM-dd')
            .format(selectedDate); // Format date as YYYY-MM-DD
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickProfilePicture,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _profilePicture != null
                      ? FileImage(_profilePicture!)
                      : null,
                  child: _profilePicture == null
                      ? const Icon(Icons.camera_alt, size: 50)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _userNameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter your username' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter your full name' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty || !value.contains('@')
                    ? 'Enter a valid email'
                    : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value!.length < 8
                    ? 'Password must be at least 8 characters'
                    : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.length != 10 ? 'Enter a valid phone number' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter your address' : null,
              ),
              const SizedBox(height: 8),
              // Replace age input with date picker
              GestureDetector(
                onTap: () => _selectBirthdate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: _selectedBirthdate.isEmpty
                          ? 'Select Birthdate'
                          : _selectedBirthdate,
                    ),
                    validator: (value) => _selectedBirthdate.isEmpty
                        ? 'Please select your birthdate'
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(labelText: 'Height (in cm)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty || double.tryParse(value) == null
                        ? 'Enter a valid height'
                        : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Weight (in kg)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty || double.tryParse(value) == null
                        ? 'Enter a valid weight'
                        : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField(
                value: _selectedGender,
                items: ['Male', 'Female', 'Other']
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedGender = value!),
                decoration: const InputDecoration(labelText: 'Gender'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField(
                value: _selectedFitnessLevel,
                items: ['Beginner', 'Intermediate', 'Advanced']
                    .map((level) => DropdownMenuItem(
                          value: level,
                          child: Text(level),
                        ))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedFitnessLevel = value!),
                decoration: const InputDecoration(labelText: 'Fitness Level'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField(
                value: _selectedGoalType,
                items: ['Endurance', 'Muscle Gain', 'Maintain Weight']
                    .map((goal) => DropdownMenuItem(
                          value: goal,
                          child: Text(goal),
                        ))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedGoalType = value!),
                decoration: const InputDecoration(labelText: 'Goal Type'),
              ),
              DropdownButtonFormField(
                value: _selectedRole,
                items: ['Member', 'Trainer', 'Admin']
                    .map((role) => DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedRole = value!),
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _calorieGoalsController,
                decoration: const InputDecoration(
                    labelText: 'Calorie Goals (Optional)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(labelText: 'Card Number'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _allergiesController,
                decoration:
                    const InputDecoration(labelText: 'Allergies (Optional)'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
