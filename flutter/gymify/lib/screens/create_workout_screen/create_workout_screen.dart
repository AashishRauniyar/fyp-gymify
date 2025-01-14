import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gymify/models/exercise_model.dart';
import 'package:gymify/providers/exercise_provider/exercise_provider.dart';
import 'package:gymify/providers/workout_provider/workout_provider.dart';
import 'package:gymify/utils/custom_loader.dart';
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
  String? workoutName;
  String? description;
  String? targetMuscleGroup;
  DifficultyLevel difficulty = DifficultyLevel.Easy;
  GoalType goalType = GoalType.Weight_Loss;
  FitnessLevel fitnessLevel = FitnessLevel.Beginner;
  File? workoutImage;

  List<Map<String, dynamic>> exercises = [];
  final TextEditingController repsController = TextEditingController();
  final TextEditingController setsController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<ExerciseProvider>(context, listen: false).fetchAllExercises();
  }

  @override
  // Widget build(BuildContext context) {
  //   final exerciseProvider = Provider.of<ExerciseProvider>(context);
  //   final workoutProvider = Provider.of<WorkoutProvider>(context);

  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Create Workout'),
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Form(
  //         key: _formKey,
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             // Workout Name Input
  //             TextFormField(
  //               decoration: const InputDecoration(labelText: 'Workout Name'),
  //               onSaved: (value) => workoutName = value,
  //               validator: (value) {
  //                 if (value == null || value.isEmpty) {
  //                   return 'Please enter a workout name';
  //                 }
  //                 return null;
  //               },
  //             ),
  //             const SizedBox(height: 20),
  //             // Description Input
  //             TextFormField(
  //               decoration: const InputDecoration(labelText: 'Description'),
  //               onSaved: (value) => description = value,
  //             ),
  //             const SizedBox(height: 20),
  //             // Target Muscle Group Dropdown
  //             DropdownButtonFormField<String>(
  //               decoration:
  //                   const InputDecoration(labelText: 'Target Muscle Group'),
  //               value: targetMuscleGroup,
  //               onChanged: (String? newValue) {
  //                 setState(() {
  //                   targetMuscleGroup = newValue;
  //                 });
  //               },
  //               items: [
  //                 'Chest',
  //                 'Back',
  //                 'Legs',
  //                 'Shoulders',
  //                 'Arms',
  //                 'Core',
  //                 'Lower Back'
  //               ].map<DropdownMenuItem<String>>((String value) {
  //                 return DropdownMenuItem<String>(
  //                   value: value,
  //                   child: Text(value),
  //                 );
  //               }).toList(),
  //               validator: (value) {
  //                 if (value == null || value.isEmpty) {
  //                   return 'Please select a target muscle group';
  //                 }
  //                 return null;
  //               },
  //             ),
  //             const SizedBox(height: 20),
  //             // Difficulty Level Dropdown
  //             DropdownButtonFormField<DifficultyLevel>(
  //               decoration:
  //                   const InputDecoration(labelText: 'Difficulty Level'),
  //               value: difficulty,
  //               onChanged: (DifficultyLevel? newValue) {
  //                 setState(() {
  //                   difficulty = newValue!;
  //                 });
  //               },
  //               items: DifficultyLevel.values
  //                   .map<DropdownMenuItem<DifficultyLevel>>(
  //                       (DifficultyLevel value) {
  //                 return DropdownMenuItem<DifficultyLevel>(
  //                   value: value,
  //                   child: Text(value.toString().split('.').last),
  //                 );
  //               }).toList(),
  //             ),
  //             const SizedBox(height: 20),
  //             // Goal Type Dropdown
  //             DropdownButtonFormField<GoalType>(
  //               decoration: const InputDecoration(labelText: 'Goal Type'),
  //               value: goalType,
  //               onChanged: (GoalType? newValue) {
  //                 setState(() {
  //                   goalType = newValue!;
  //                 });
  //               },
  //               items: GoalType.values
  //                   .map<DropdownMenuItem<GoalType>>((GoalType value) {
  //                 return DropdownMenuItem<GoalType>(
  //                   value: value,
  //                   child: Text(
  //                       value.toString().split('.').last.replaceAll('_', ' ')),
  //                 );
  //               }).toList(),
  //             ),
  //             const SizedBox(height: 20),
  //             // Fitness Level Dropdown
  //             DropdownButtonFormField<FitnessLevel>(
  //               decoration: const InputDecoration(labelText: 'Fitness Level'),
  //               value: fitnessLevel,
  //               onChanged: (FitnessLevel? newValue) {
  //                 setState(() {
  //                   fitnessLevel = newValue!;
  //                 });
  //               },
  //               items: FitnessLevel.values
  //                   .map<DropdownMenuItem<FitnessLevel>>((FitnessLevel value) {
  //                 return DropdownMenuItem<FitnessLevel>(
  //                   value: value,
  //                   child: Text(value.toString().split('.').last),
  //                 );
  //               }).toList(),
  //             ),
  //             const SizedBox(height: 20),
  //             // Exercise Selection

  //             const Text('Select Exercises'),
  //             if (exerciseProvider.exercises.isEmpty)
  //               const Center(child: CustomLoadingAnimation())
  //             else
  //               Expanded(
  //                 child: ListView.builder(
  //                   itemCount: exerciseProvider.exercises.length,
  //                   itemBuilder: (context, index) {
  //                     final exercise = exerciseProvider.exercises[index];
  //                     return ListTile(
  //                       title: Text(exercise.exerciseName),
  //                       subtitle: Text(exercise.targetMuscleGroup),
  //                       trailing: IconButton(
  //                         icon: const Icon(Icons.add),
  //                         onPressed: () {
  //                           _showRepsSetsDialog(exercise);
  //                         },
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ),

  //             // Display Added Exercises
  //             const SizedBox(height: 20),
  //             const Text('Added Exercises:'),
  //             Expanded(
  //               child: ListView.builder(
  //                 itemCount: exercises.length,
  //                 itemBuilder: (context, index) {
  //                   return ListTile(
  //                     title: Text(exercises[index]['exercise'].exerciseName),
  //                     subtitle: Text(
  //                       'Reps: ${exercises[index]['reps']} | Sets: ${exercises[index]['sets']} | Duration: ${exercises[index]['duration']}',
  //                     ),
  //                     trailing: IconButton(
  //                       icon: const Icon(Icons.delete),
  //                       onPressed: () {
  //                         setState(() {
  //                           exercises.removeAt(index);
  //                         });
  //                       },
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ),

  //             // Image Picker Button
  //             const SizedBox(height: 20),
  //             ElevatedButton.icon(
  //               onPressed: () async {
  //                 final ImagePicker picker = ImagePicker();
  //                 final pickedFile =
  //                     await picker.pickImage(source: ImageSource.gallery);
  //                 if (pickedFile != null) {
  //                   setState(() {
  //                     workoutImage = File(pickedFile.path);
  //                   });
  //                 }
  //               },
  //               icon: const Icon(Icons.image),
  //               label: const Text('Pick Workout Image'),
  //             ),

  //             // Display selected workout image
  //             if (workoutImage != null)
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Image.file(workoutImage!, height: 100, width: 100),
  //               ),

  //             // Create Workout Button
  //             const SizedBox(height: 20),
  //             ElevatedButton.icon(
  //               onPressed: () async {
  //                 if (_formKey.currentState?.validate() ?? false) {
  //                   _formKey.currentState?.save();
  //                   try {
  //                     // Create workout
  //                     final workoutId = await workoutProvider.createWorkout(
  //                       context: context,
  //                       workoutName: workoutName!,
  //                       description: description ?? '',
  //                       targetMuscleGroup: targetMuscleGroup!,
  //                       difficulty: difficulty.toString().split('.').last,
  //                       goalType: goalType.toString().split('.').last,
  //                       fitnessLevel: fitnessLevel.toString().split('.').last,
  //                       workoutImage: workoutImage,
  //                     );

  //                     // Prepare exercises payload
  //                     final exercisesPayload = exercises.map((exerciseData) {
  //                       return {
  //                         'exercise_id': exerciseData['exercise'].exerciseId,
  //                         'sets': int.parse(exerciseData['sets']),
  //                         'reps': int.parse(exerciseData['reps']),
  //                         'duration': exerciseData['duration'],
  //                       };
  //                     }).toList();

  //                     // Add exercises to the workout
  //                     await workoutProvider.addExercisesToWorkout(
  //                         context, workoutId, exercisesPayload);

  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       const SnackBar(
  //                           content: Text(
  //                               'Workout created and exercises added successfully')),
  //                     );
  //                   } catch (e) {
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       SnackBar(content: Text('Error creating workout: $e')),
  //                     );
  //                   }
  //                 }
  //               },
  //               icon: const Icon(Icons.save),
  //               label: const Text('Create Workout'),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    final exerciseProvider = Provider.of<ExerciseProvider>(context);
    final workoutProvider = Provider.of<WorkoutProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Workout'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Workout Name Input
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Workout Name'),
                  onSaved: (value) => workoutName = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a workout name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Description Input
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  onSaved: (value) => description = value,
                ),
                const SizedBox(height: 20),
                // Target Muscle Group Dropdown
                DropdownButtonFormField<String>(
                  decoration:
                      const InputDecoration(labelText: 'Target Muscle Group'),
                  value: targetMuscleGroup,
                  onChanged: (String? newValue) {
                    setState(() {
                      targetMuscleGroup = newValue;
                    });
                  },
                  items: [
                    'Chest',
                    'Back',
                    'Legs',
                    'Shoulders',
                    'Arms',
                    'Core',
                    'Lower Back'
                  ].map<DropdownMenuItem<String>>((String value) {
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
                const SizedBox(height: 20),
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
                ),
                const SizedBox(height: 20),
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
                      child: Text(value
                          .toString()
                          .split('.')
                          .last
                          .replaceAll('_', ' ')),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
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
                      .map<DropdownMenuItem<FitnessLevel>>(
                          (FitnessLevel value) {
                    return DropdownMenuItem<FitnessLevel>(
                      value: value,
                      child: Text(value.toString().split('.').last),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                // Exercise Selection
                const Text('Select Exercises'),
                if (exerciseProvider.exercises.isEmpty)
                  const Center(child: CustomLoadingAnimation())
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: exerciseProvider.exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = exerciseProvider.exercises[index];
                      return ListTile(
                        title: Text(exercise.exerciseName),
                        subtitle: Text(exercise.targetMuscleGroup),
                        trailing: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            _showRepsSetsDialog(exercise);
                          },
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 20),
                const Text('Added Exercises:'),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(exercises[index]['exercise'].exerciseName),
                      subtitle: Text(
                        'Reps: ${exercises[index]['reps']} | Sets: ${exercises[index]['sets']} | Duration: ${exercises[index]['duration']}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            exercises.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Image Picker Button
                ElevatedButton.icon(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      setState(() {
                        workoutImage = File(pickedFile.path);
                      });
                    }
                  },
                  icon: const Icon(Icons.image),
                  label: const Text('Pick Workout Image'),
                ),
                // Display selected workout image
                if (workoutImage != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(workoutImage!, height: 100, width: 100),
                  ),
                const SizedBox(height: 20),
                // Create Workout Button
                ElevatedButton.icon(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      try {
                        final workoutId = await workoutProvider.createWorkout(
                          context: context,
                          workoutName: workoutName!,
                          description: description ?? '',
                          targetMuscleGroup: targetMuscleGroup!,
                          difficulty: difficulty.toString().split('.').last,
                          goalType: goalType.toString().split('.').last,
                          fitnessLevel: fitnessLevel.toString().split('.').last,
                          workoutImage: workoutImage,
                        );

                        // Prepare exercises payload
                        final exercisesPayload = exercises.map((exerciseData) {
                          return {
                            'exercise_id': exerciseData['exercise'].exerciseId,
                            'sets': int.parse(exerciseData['sets']),
                            'reps': int.parse(exerciseData['reps']),
                            'duration': exerciseData['duration'],
                          };
                        }).toList();

                        // Add exercises to the workout
                        await workoutProvider.addExercisesToWorkout(
                            context, workoutId, exercisesPayload);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Workout created and exercises added successfully')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Create Workout'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showRepsSetsDialog(Exercise exercise) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              Text('Add Reps, Sets, and Duration for ${exercise.exerciseName}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: repsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Reps'),
              ),
              TextField(
                controller: setsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Sets'),
              ),
              TextField(
                controller: durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Duration'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (repsController.text.isNotEmpty &&
                    setsController.text.isNotEmpty &&
                    durationController.text.isNotEmpty) {
                  setState(() {
                    exercises.add({
                      'exercise': exercise,
                      'reps': repsController.text,
                      'sets': setsController.text,
                      'duration': durationController.text,
                    });
                  });
                  Navigator.pop(context);
                  repsController.clear();
                  setsController.clear();
                  durationController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter reps, sets, and duration')),
                  );
                }
              },
              child: const Text('Add Exercise'),
            ),
          ],
        );
      },
    );
  }
}
