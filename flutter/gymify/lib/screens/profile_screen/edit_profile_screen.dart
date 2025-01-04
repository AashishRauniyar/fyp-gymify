import 'package:flutter/material.dart';
import 'package:gymify/models/user_model.dart';
import 'package:gymify/providers/profile_provider/profile_provider.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatelessWidget {
  final Users user;

  EditProfileScreen({super.key, required this.user});

  final _fitnessLevels = ['Beginner', 'Intermediate', 'Advanced', 'Athlete'];
  final _goalTypes = [
    'Weight Loss',
    'Muscle Gain',
    'Endurance',
    'Maintenance',
    'Flexibility'
  ];

  @override
  Widget build(BuildContext context) {
    final fullNameController = TextEditingController(text: user.fullName);
    final phoneNumberController = TextEditingController(text: user.phoneNumber);
    final addressController = TextEditingController(text: user.address);
    final heightController = TextEditingController(text: user.height.toString());
    final weightController =
        TextEditingController(text: user.currentWeight.toString());
    final allergiesController = TextEditingController(text: user.allergies);

    String selectedFitnessLevel = user.fitnessLevel;
    String selectedGoalType = user.goalType;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneNumberController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: heightController,
              decoration: const InputDecoration(labelText: 'Height (cm)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: weightController,
              decoration: const InputDecoration(labelText: 'Current Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedFitnessLevel,
              items: _fitnessLevels.map((level) {
                return DropdownMenuItem(
                  value: level,
                  child: Text(level),
                );
              }).toList(),
              onChanged: (value) {
                selectedFitnessLevel = value!;
              },
              decoration: const InputDecoration(labelText: 'Fitness Level'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedGoalType,
              items: _goalTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                selectedGoalType = value!;
              },
              decoration: const InputDecoration(labelText: 'Goal Type'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: allergiesController,
              decoration: const InputDecoration(labelText: 'Allergies'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final profileProvider =
                    Provider.of<ProfileProvider>(context, listen: false);
                await profileProvider.updateProfile({
                  'full_name': fullNameController.text,
                  'phone_number': phoneNumberController.text,
                  'address': addressController.text,
                  'height': int.tryParse(heightController.text) ?? user.height,
                  'current_weight':
                      int.tryParse(weightController.text) ?? user.currentWeight,
                  'fitness_level': selectedFitnessLevel,
                  'goal_type': selectedGoalType,
                  'allergies': allergiesController.text,
                });
                Navigator.pop(context);
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
