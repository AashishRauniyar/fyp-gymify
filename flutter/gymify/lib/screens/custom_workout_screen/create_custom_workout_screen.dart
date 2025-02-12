import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gymify/models/exercise_model.dart';
import 'package:gymify/providers/custom_workout_provider/custom_workout_provider.dart';
import 'package:gymify/providers/exercise_provider/exercise_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateCustomWorkoutScreen extends StatefulWidget {
  const CreateCustomWorkoutScreen({super.key});

  @override
  _CreateCustomWorkoutScreenState createState() =>
      _CreateCustomWorkoutScreenState();
}

class _CreateCustomWorkoutScreenState extends State<CreateCustomWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  String? customWorkoutName;
  File? customWorkoutImage;

  List<Map<String, dynamic>> selectedExercises = [];
  final TextEditingController repsController = TextEditingController();
  final TextEditingController setsController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExerciseProvider>(context, listen: false).fetchAllExercises();
    });
  }

  @override
  Widget build(BuildContext context) {
    final exerciseProvider = Provider.of<ExerciseProvider>(context);
    final customWorkoutProvider = Provider.of<CustomWorkoutProvider>(context);

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Create Custom Workout'),
      // ),
      appBar: const CustomAppBar(title: 'Create Custom Workout'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Workout Name Input
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Custom Workout Name',
                ),
                onSaved: (value) => customWorkoutName = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a custom workout name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Exercise Selection
              const Text('Select Exercises'),
              const SizedBox(height: 8),
              exerciseProvider.exercises.isEmpty
                  ? const Center(child: CustomLoadingAnimation())
                  : Expanded(
                      child: ListView.builder(
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
                    ),

              // Display Selected Exercises
              const SizedBox(height: 16),
              const Text(
                'Selected Exercises:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: selectedExercises.length,
                  itemBuilder: (context, index) {
                    final exercise = selectedExercises[index];
                    return Card(
                      child: ListTile(
                        title: Text(exercise['exercise'].exerciseName),
                        subtitle: Text(
                          'Sets: ${exercise['sets']}, Reps: ${exercise['reps']}, Duration: ${exercise['duration']} mins',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              selectedExercises.removeAt(index);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Image Picker Button
              const SizedBox(height: 16),
              // ElevatedButton.icon(
              //   onPressed: () async {
              //     final ImagePicker picker = ImagePicker();
              //     final pickedFile =
              //         await picker.pickImage(source: ImageSource.gallery);
              //     if (pickedFile != null) {
              //       setState(() {
              //         customWorkoutImage = File(pickedFile.path);
              //       });
              //     }
              //   },
              //   icon: const Icon(Icons.image),
              //   label: const Text('Pick Custom Workout Image'),
              // ),

              // Display Selected Image
              if (customWorkoutImage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.file(
                    customWorkoutImage!,
                    height: 100,
                    width: 100,
                  ),
                ),

              // Create Custom Workout Button
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    try {
                      // Create custom workout
                      final customWorkoutId =
                          await customWorkoutProvider.createCustomWorkout(
                        customWorkoutName!,
                      );

                      // Prepare exercises payload
                      final exercisesPayload = selectedExercises.map((data) {
                        return {
                          'exercise_id': data['exercise'].exerciseId,
                          'sets': int.parse(data['sets']),
                          'reps': int.parse(data['reps']),
                          'duration': data['duration'],
                        };
                      }).toList();

                      // Add exercises to custom workout
                      await customWorkoutProvider.addExercisesToCustomWorkout(
                          customWorkoutId, exercisesPayload);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Custom workout created and exercises added successfully!')),
                      );

                      Navigator.pop(context); // Go back after creation
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.save),
                label: const Text('Create Custom Workout'),
              ),
            ],
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
          title: Text('Add Details for ${exercise.exerciseName}'),
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
                decoration: const InputDecoration(labelText: 'Duration (mins)'),
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
                    selectedExercises.add({
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
                        content: Text('Please enter valid details.')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
