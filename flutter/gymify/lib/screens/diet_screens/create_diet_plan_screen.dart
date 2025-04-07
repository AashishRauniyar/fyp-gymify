// // ignore_for_file: constant_identifier_names

// import 'package:flutter/material.dart';
// import 'package:gymify/screens/main_screens/membership_screen/membership_screen.dart';
// import 'package:gymify/utils/custom_appbar.dart';
// import 'package:provider/provider.dart';
// import 'package:gymify/providers/diet_provider/diet_provider.dart';
// import 'package:go_router/go_router.dart';

// enum GoalType {
//   // ignore: constant_identifier_names
//   Weight_Loss,
//   Muscle_Gain,
//   Endurance,
//   Maintenance,
//   Flexibility,
// }

// // Helper to convert enum to user-friendly text
// String goalTypeToString(GoalType type) {
//   switch (type) {
//     case GoalType.Weight_Loss:
//       return "Weight_Loss";
//     case GoalType.Muscle_Gain:
//       return "Muscle_Gain";
//     case GoalType.Endurance:
//       return "Endurance";
//     case GoalType.Maintenance:
//       return "Maintenance";
//     case GoalType.Flexibility:
//       return "Flexibility";
//   }
// }

// class CreateDietPlanScreen extends StatefulWidget {
//   const CreateDietPlanScreen({super.key});

//   @override
//   State<CreateDietPlanScreen> createState() => _CreateDietPlanScreenState();
// }

// class _CreateDietPlanScreenState extends State<CreateDietPlanScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _calorieGoalController = TextEditingController();
//   final _descriptionController = TextEditingController();

//   GoalType? _selectedGoalType; // Track selected goal type

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<DietProvider>(context);
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: const CustomAppBar(title: 'Create Diet Plan'),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               // Diet Plan Name
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: 'Diet Plan Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a name';
//                   }
//                   return null;
//                 },
//               ),

//               // Dropdown for Goal Type
//               DropdownButtonFormField<GoalType>(
//                 value: _selectedGoalType,
//                 decoration: const InputDecoration(labelText: 'Goal Type'),
//                 items: GoalType.values.map((goal) {
//                   return DropdownMenuItem(
//                     value: goal,
//                     child: Text(goalTypeToString(goal)),
//                   );
//                 }).toList(),
//                 onChanged: (GoalType? newValue) {
//                   setState(() {
//                     _selectedGoalType = newValue;
//                   });
//                 },
//                 validator: (value) {
//                   if (value == null) return 'Please select a goal type';
//                   return null;
//                 },
//               ),

//               // Calorie Goal
//               TextFormField(
//                 controller: _calorieGoalController,
//                 decoration: const InputDecoration(labelText: 'Calorie Goal'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a calorie goal';
//                   }
//                   return null;
//                 },
//               ),

//               // Description
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(labelText: 'Description'),
//               ),

//               const SizedBox(height: 20),

//               // Create Diet Plan Button
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState?.validate() ?? false) {
//                     final name = _nameController.text;
//                     final goalType = _selectedGoalType;
//                     final calorieGoal =
//                         double.tryParse(_calorieGoalController.text);
//                     final description = _descriptionController.text;

//                     if (calorieGoal != null && goalType != null) {
//                       provider.createDietPlan(
//                         name: name,
//                         calorieGoal: calorieGoal,
//                         goalType: goalTypeToString(goalType),
//                         description: description,
//                       );
//                     }

//                     showCoolSnackBar(
//                         context, "Diet Created Successfully", true);
//                   }
//                 },
//                 child: provider.isLoading
//                     ? const CircularProgressIndicator()
//                     : const Text('Create Diet Plan'),
//               ),
//               // if error show snackbar
//               Builder(
//                 builder: (context) {
//                   if (provider.hasError) {
//                     WidgetsBinding.instance.addPostFrameCallback((_) {
//                       showCoolSnackBar(
//                           context, "Error creating diet plan", false);
//                     });
//                   }
//                   return const SizedBox.shrink();
//                 },
//               ),

//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: constant_identifier_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:gymify/providers/diet_provider/diet_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:gymify/utils/custom_snackbar.dart';

enum GoalType {
  Weight_Loss,
  Muscle_Gain,
  // Endurance,
  Maintenance,
  // Flexibility,
}

String goalTypeToString(GoalType type) {
  switch (type) {
    case GoalType.Weight_Loss:
      return "Weight_Loss";
    case GoalType.Muscle_Gain:
      return "Muscle_Gain";
    // case GoalType.Endurance:
    //   return "Endurance";
    case GoalType.Maintenance:
      return "Maintenance";
    // case GoalType.Flexibility:
    //   return "Flexibility";
  }
}

class CreateDietPlanScreen extends StatefulWidget {
  const CreateDietPlanScreen({super.key});

  @override
  State<CreateDietPlanScreen> createState() => _CreateDietPlanScreenState();
}

class _CreateDietPlanScreenState extends State<CreateDietPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _calorieGoalController = TextEditingController();
  final _descriptionController = TextEditingController();

  GoalType? _selectedGoalType;
  File? dietImage;

  // Use ImagePicker to pick an image
  Future<void> _pickDietImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        dietImage = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _calorieGoalController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DietProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Create Diet Plan'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Diet Plan Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Diet Plan Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              // Dropdown for Goal Type
              DropdownButtonFormField<GoalType>(
                value: _selectedGoalType,
                decoration: const InputDecoration(labelText: 'Goal Type'),
                items: GoalType.values.map((goal) {
                  return DropdownMenuItem(
                    value: goal,
                    child: Text(
                      goalTypeToString(goal),
                      style: theme.textTheme.bodyMedium?.copyWith(
                          // fontWeight: FontWeight.bold,
                          ),
                    ),
                  );
                }).toList(),
                onChanged: (GoalType? newValue) {
                  setState(() {
                    _selectedGoalType = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) return 'Please select a goal type';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              // Calorie Goal
              TextFormField(
                controller: _calorieGoalController,
                decoration: const InputDecoration(labelText: 'Calorie Goal'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a calorie goal';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              // Description
              TextFormField(
                maxLines: 3,
                minLines: 3,
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 12),
              // Diet Plan Image Picker
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickDietImage,
                    icon: const Icon(Icons.image),
                    label: const Text("Select Diet Image"),
                  ),
                  const SizedBox(width: 12),
                  if (dietImage != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        dietImage!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              // Create Diet Plan Button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final name = _nameController.text;
                    final goalType = _selectedGoalType;
                    final calorieGoal =
                        double.tryParse(_calorieGoalController.text);
                    final description = _descriptionController.text;
                    if (calorieGoal != null && goalType != null) {
                      await provider.createDietPlan(
                        name: name,
                        calorieGoal: calorieGoal,
                        goalType: goalTypeToString(goalType),
                        description: description,
                        dietImage: dietImage,
                      );
                    }
                    showCoolSnackBar(
                        context, "Diet Created Successfully", true);
                    Navigator.pop(context);
                  }
                },
                child: provider.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Create Diet Plan'),
              ),
              if (provider.hasError)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    "Error creating diet plan",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
