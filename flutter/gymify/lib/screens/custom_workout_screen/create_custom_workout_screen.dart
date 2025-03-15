import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gymify/models/exercise_model.dart';
import 'package:gymify/providers/custom_workout_provider/custom_workout_provider.dart';
import 'package:gymify/providers/exercise_provider/exercise_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:gymify/utils/custom_input.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:provider/provider.dart';

class CreateCustomWorkoutScreen extends StatefulWidget {
  const CreateCustomWorkoutScreen({super.key});

  @override
  _CreateCustomWorkoutScreenState createState() =>
      _CreateCustomWorkoutScreenState();
}

class _CreateCustomWorkoutScreenState extends State<CreateCustomWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _workoutNameController = TextEditingController();
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
  void dispose() {
    _workoutNameController.dispose();
    repsController.dispose();
    setsController.dispose();
    durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exerciseProvider = Provider.of<ExerciseProvider>(context);
    final customWorkoutProvider = Provider.of<CustomWorkoutProvider>(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Create Custom Workout'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom workout name input using CustomInput widget.
              CustomInput(
                labelText: 'Custom Workout Name',
                controller: _workoutNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a custom workout name';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),

              // Exercise Selection Section.
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

              // Display Selected Exercises.
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

              // Image Picker Button (if needed).
              const SizedBox(height: 16),
              if (customWorkoutImage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.file(
                    customWorkoutImage!,
                    height: 100,
                    width: 100,
                  ),
                ),

              // Create Custom Workout Button.
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  // First validate the form.
                  if (_formKey.currentState?.validate() ?? false) {
                    // Check if at least one exercise is added.
                    if (selectedExercises.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please add at least one exercise.'),
                        ),
                      );
                      return;
                    }

                    // Save the workout name from the controller.
                    final customWorkoutName = _workoutNameController.text;
                    try {
                      // Create custom workout.
                      final customWorkoutId =
                          await customWorkoutProvider.createCustomWorkout(
                        customWorkoutName,
                      );

                      // Prepare exercises payload.
                      final exercisesPayload = selectedExercises.map((data) {
                        return {
                          'exercise_id': data['exercise'].exerciseId,
                          'sets': int.parse(data['sets']),
                          'reps': int.parse(data['reps']),
                          'duration': data['duration'],
                        };
                      }).toList();

                      // Add exercises to custom workout.
                      await customWorkoutProvider.addExercisesToCustomWorkout(
                          customWorkoutId, exercisesPayload);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Custom workout created and exercises added successfully!'),
                        ),
                      );

                      Navigator.pop(context); // Go back after creation.
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
              // Using CustomInput widgets for numeric fields.
              CustomInput(
                labelText: 'Reps',
                controller: repsController,
                keyboardType: TextInputType.number,
              ),
              CustomInput(
                labelText: 'Sets',
                controller: setsController,
                keyboardType: TextInputType.number,
              ),
              CustomInput(
                labelText: 'Duration (mins)',
                controller: durationController,
                keyboardType: TextInputType.number,
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
