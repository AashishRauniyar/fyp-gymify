// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:gymify/providers/workout_provider/workout_provider.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';

// class CreateWorkoutScreen extends StatefulWidget {
//   const CreateWorkoutScreen({super.key});

//   @override
//   _CreateWorkoutScreenState createState() => _CreateWorkoutScreenState();
// }

// class _CreateWorkoutScreenState extends State<CreateWorkoutScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late String workoutName;
//   late String description;
//   late String targetMuscleGroup;
//   late String difficulty;
//   late String goalType;
//   late String fitnessLevel;
//   File? workoutImage;

//   @override
//   Widget build(BuildContext context) {
//     final workoutProvider = Provider.of<WorkoutProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create Workout'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Workout Name'),
//                 onSaved: (value) => workoutName = value ?? '',
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a workout name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Description'),
//                 onSaved: (value) => description = value ?? '',
//               ),
//               TextFormField(
//                 decoration:
//                     const InputDecoration(labelText: 'Target Muscle Group'),
//                 onSaved: (value) => targetMuscleGroup = value ?? '',
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Difficulty'),
//                 onSaved: (value) => difficulty = value ?? '',
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Goal Type'),
//                 onSaved: (value) => goalType = value ?? '',
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Fitness Level'),
//                 onSaved: (value) => fitnessLevel = value ?? '',
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () async {
//                   // Pick an image
//                   final ImagePicker picker = ImagePicker();
//                   final pickedFile =
//                       await picker.pickImage(source: ImageSource.gallery);

//                   if (pickedFile != null) {
//                     setState(() {
//                       workoutImage = File(pickedFile.path);
//                     });
//                   }
//                 },
//                 child: const Text('Pick Workout Image'),
//               ),
//               if (workoutImage != null)
//                 Image.file(workoutImage!, height: 100, width: 100),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () async {
//                   // Save form and create workout
//                   if (_formKey.currentState?.validate() ?? false) {
//                     _formKey.currentState?.save();
//                     try {
//                       await workoutProvider.createWorkout(
//                         context: context,
//                         workoutName: workoutName,
//                         description: description,
//                         targetMuscleGroup: targetMuscleGroup,
//                         difficulty: difficulty,
//                         goalType: goalType,
//                         fitnessLevel: fitnessLevel,
//                         workoutImage: workoutImage,
//                       );

//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                             content: Text('Workout created successfully')
//                             ),
//                             // go to workout screeen

//                       );

//                       context.go('/workout');
//                     } catch (e) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Error creating workout: $e')),
//                       );
//                     }
//                   }
//                 },
//                 child: const Text('Create Workout'),
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
import 'package:gymify/providers/workout_provider/workout_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

enum DifficultyLevel { Easy, Intermediate, Hard }

enum FitnessLevel { Beginner, Intermediate, Advanced, Athlete }

enum GoalType { Weight_Loss, Muscle_Gain, Endurance, Maintenance, Flexibility }

class CreateWorkoutScreen extends StatefulWidget {
  const CreateWorkoutScreen({super.key});

  @override
  _CreateWorkoutScreenState createState() => _CreateWorkoutScreenState();
}

class _CreateWorkoutScreenState extends State<CreateWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  late String workoutName;
  late String description;
  String targetMuscleGroup =
      ''; // Initialize with an empty string or default muscle group

  // Initialize enum fields with default values
  DifficultyLevel difficulty = DifficultyLevel.Easy; // Default value
  GoalType goalType = GoalType.Weight_Loss; // Default value
  FitnessLevel fitnessLevel = FitnessLevel.Beginner; // Default value

  File? workoutImage;

  // List for muscle groups
  final List<String> muscleGroups = [
    'Chest',
    'Upper Back',
    'Lower Back',
    'Middle Back',
    'Biceps',
    'Shoulders',
    'Legs',
    'Glutes',
    'Calves',
    'Hamstrings',
    'Hips',
    'Core (Abs)',
    'Traps',
    'Neck',
  ];

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Workout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Workout Name'),
                onSaved: (value) => workoutName = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a workout name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) => description = value ?? '',
              ),
              // Target Muscle Group Dropdown
              DropdownButtonFormField<String>(
                decoration:
                    const InputDecoration(labelText: 'Target Muscle Group'),
                value: targetMuscleGroup.isNotEmpty ? targetMuscleGroup : null,
                onChanged: (String? newValue) {
                  setState(() {
                    targetMuscleGroup = newValue!;
                  });
                },
                items:
                    muscleGroups.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a target muscle group';
                  }
                  return null;
                },
              ),
              // Difficulty Level Dropdown
              DropdownButtonFormField<DifficultyLevel>(
                decoration:
                    const InputDecoration(labelText: 'Difficulty Level'),
                value: difficulty,
                onChanged: (DifficultyLevel? newValue) {
                  setState(() {
                    difficulty = newValue!;
                  });
                },
                items: DifficultyLevel.values
                    .map<DropdownMenuItem<DifficultyLevel>>(
                        (DifficultyLevel value) {
                  return DropdownMenuItem<DifficultyLevel>(
                    value: value,
                    child: Text(value.toString().split('.').last),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a difficulty level';
                  }
                  return null;
                },
              ),
              // Goal Type Dropdown
              DropdownButtonFormField<GoalType>(
                decoration: const InputDecoration(labelText: 'Goal Type'),
                value: goalType,
                onChanged: (GoalType? newValue) {
                  setState(() {
                    goalType = newValue!;
                  });
                },
                items: GoalType.values
                    .map<DropdownMenuItem<GoalType>>((GoalType value) {
                  return DropdownMenuItem<GoalType>(
                    value: value,
                    child: Text(
                        value.toString().split('.').last.replaceAll('_', ' ')),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a goal type';
                  }
                  return null;
                },
              ),
              // Fitness Level Dropdown
              DropdownButtonFormField<FitnessLevel>(
                decoration: const InputDecoration(labelText: 'Fitness Level'),
                value: fitnessLevel,
                onChanged: (FitnessLevel? newValue) {
                  setState(() {
                    fitnessLevel = newValue!;
                  });
                },
                items: FitnessLevel.values
                    .map<DropdownMenuItem<FitnessLevel>>((FitnessLevel value) {
                  return DropdownMenuItem<FitnessLevel>(
                    value: value,
                    child: Text(value.toString().split('.').last),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a fitness level';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Pick an image
                  final ImagePicker picker = ImagePicker();
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);

                  if (pickedFile != null) {
                    setState(() {
                      workoutImage = File(pickedFile.path);
                    });
                  }
                },
                child: const Text('Pick Workout Image'),
              ),
              if (workoutImage != null)
                Image.file(workoutImage!, height: 100, width: 100),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Save form and create workout
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    try {
                      await workoutProvider.createWorkout(
                        context: context,
                        workoutName: workoutName,
                        description: description,
                        targetMuscleGroup: targetMuscleGroup,
                        difficulty: difficulty.toString().split('.').last,
                        goalType: goalType.toString().split('.').last,
                        fitnessLevel: fitnessLevel.toString().split('.').last,
                        workoutImage: workoutImage,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Workout created successfully')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error creating workout: $e')),
                      );
                    }
                  }
                },
                child: const Text('Create Workout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
