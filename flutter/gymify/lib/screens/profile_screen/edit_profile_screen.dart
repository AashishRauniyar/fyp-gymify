// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:go_router/go_router.dart';
// import 'package:gymify/providers/profile_provider/profile_provider.dart';
// import 'package:gymify/colors/custom_colors.dart';

// class EditProfileScreen extends StatelessWidget {
//   EditProfileScreen({super.key});

//   final List<String> _fitnessLevels = [
//     'Beginner',
//     'Intermediate',
//     'Advanced',
//     'Athlete'
//   ];
//   final List<String> _goalTypes = [
//     'Weight Loss',
//     'Muscle Gain',
//     'Endurance',
//     'Maintenance',
//     'Flexibility'
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final profileProvider = Provider.of<ProfileProvider>(context);
//     final user = context.read<ProfileProvider>().user;

//     if (profileProvider.isLoading) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Edit Profile'),
//         ),
//         body: const Center(
//           child: CustomLoadingAnimation(),
//         ),
//       );
//     }

//     if (user == null) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Edit Profile'),
//         ),
//         body: const Center(
//           child: Text('Error loading profile. Please try again.'),
//         ),
//       );
//     }

//     // Controllers for text fields
//     final fullNameController = TextEditingController(text: user.fullName);
//     final phoneNumberController = TextEditingController(text: user.phoneNumber);
//     final addressController = TextEditingController(text: user.address);
//     final heightController =
//         TextEditingController(text: user.height.toString());
//     final currentWeightController =
//         TextEditingController(text: user.currentWeight.toString());
//     final allergiesController = TextEditingController(text: user.allergies);

//     // Dropdown initial values
//     String selectedFitnessLevel = user.fitnessLevel;
//     String selectedGoalType = user.goalType;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Profile'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => context.pop(),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             TextField(
//               controller: fullNameController,
//               decoration: const InputDecoration(labelText: 'Full Name'),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: phoneNumberController,
//               decoration: const InputDecoration(labelText: 'Phone Number'),
//               keyboardType: TextInputType.phone,
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: addressController,
//               decoration: const InputDecoration(labelText: 'Address'),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: heightController,
//               decoration: const InputDecoration(labelText: 'Height (cm)'),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: currentWeightController,
//               decoration:
//                   const InputDecoration(labelText: 'Current Weight (kg)'),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 16),
//             DropdownButtonFormField<String>(
//               value: selectedFitnessLevel,
//               items: _fitnessLevels.map((level) {
//                 return DropdownMenuItem(
//                   value: level,
//                   child: Text(level),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 selectedFitnessLevel = value!;
//               },
//               decoration: const InputDecoration(labelText: 'Fitness Level'),
//             ),
//             const SizedBox(height: 16),
//             DropdownButtonFormField<String>(
//               value: selectedGoalType,
//               items: _goalTypes.map((type) {
//                 return DropdownMenuItem(
//                   value: type,
//                   child: Text(type),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 selectedGoalType = value!;
//               },
//               decoration: const InputDecoration(labelText: 'Goal Type'),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: allergiesController,
//               decoration: const InputDecoration(labelText: 'Allergies'),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () async {
//                 profileProvider.resetError(); // Reset error state
//                 await profileProvider.updateProfile({
//                   'full_name': fullNameController.text.trim(),
//                   'phone_number': phoneNumberController.text.trim(),
//                   'address': addressController.text.trim(),
//                   'height': double.tryParse(heightController.text.trim()) ??
//                       user.height,
//                   'current_weight':
//                       double.tryParse(currentWeightController.text.trim()) ??
//                           user.currentWeight,
//                   'fitness_level': selectedFitnessLevel,
//                   'goal_type': selectedGoalType,
//                   'allergies': allergiesController.text.trim(),
//                 });

//                 if (!profileProvider.hasError) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                         content: Text('Profile updated successfully!')),
//                   );
//                   context.pop();
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                         content: Text(
//                             'Failed to update profile. Please try again.')),
//                   );
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: CustomColors.primary,
//                 foregroundColor: Colors.white,
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: profileProvider.isLoading
//                   ? const CustomLoadingAnimation(color: Colors.white)
//                   : const Text('Save Changes'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/models/user_model.dart';
import 'package:gymify/colors/custom_colors.dart';
import 'package:gymify/providers/profile_provider/profile_provider.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatelessWidget {
  final Users user;

  const EditProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Dropdown options
    final List<String> fitnessLevels = [
      'Beginner',
      'Intermediate',
      'Advanced',
      'Athlete'
    ];
    final List<String> goalTypes = [
      'Weight Loss',
      'Muscle Gain',
      'Endurance',
      'Maintenance',
      'Flexibility'
    ];

    final profileProvider = Provider.of<ProfileProvider>(context);

    // Controllers for text fields
    final fullNameController = TextEditingController(text: user.fullName);
    final phoneNumberController = TextEditingController(text: user.phoneNumber);
    final addressController = TextEditingController(text: user.address);
    final heightController =
        TextEditingController(text: user.height.toString());
    final currentWeightController =
        TextEditingController(text: user.currentWeight.toString());
    final allergiesController = TextEditingController(text: user.allergies);

    String selectedFitnessLevel = user.fitnessLevel ?? 'Beginner';
    String selectedGoalType = user.goalType ?? 'Muscle Gain';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
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
              controller: currentWeightController,
              decoration:
                  const InputDecoration(labelText: 'Current Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedFitnessLevel,
              items: fitnessLevels.map((level) {
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
              items: goalTypes.map((type) {
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
                await profileProvider.updateProfile({
                  'full_name': fullNameController.text.trim(),
                  'phone_number': phoneNumberController.text.trim(),
                  'address': addressController.text.trim(),
                  'height': double.tryParse(heightController.text.trim()) ??
                      user.height,
                  'current_weight':
                      double.tryParse(currentWeightController.text.trim()) ??
                          user.currentWeight,
                  'fitness_level': selectedFitnessLevel,
                  'goal_type': selectedGoalType,
                  'allergies': allergiesController.text.trim(),
                });

                if (!profileProvider.hasError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Profile updated successfully!')),
                  );
                  context.pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Failed to update profile. Please try again.')),
                  );
                }
                // Navigate back after saving
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
