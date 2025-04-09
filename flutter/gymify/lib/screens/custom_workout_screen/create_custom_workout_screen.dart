import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gymify/models/exercise_model.dart';
import 'package:gymify/providers/custom_workout_provider/custom_workout_provider.dart';
import 'package:gymify/providers/exercise_provider/exercise_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:gymify/utils/custom_input.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:gymify/utils/custom_snackbar.dart';
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
  String searchQuery = "";
  File? customWorkoutImage;

  List<Map<String, dynamic>> selectedExercises = [];
  final TextEditingController repsController = TextEditingController();
  final TextEditingController setsController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  final List<String> muscleGroups = [
    'All',
    'Chest',
    'Back',
    'Legs',
    'Shoulders',
    'Arms',
    'Core',
    'Lower Back',
    'Full Body'
  ];

  String selectedCategory = 'All';

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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: const CustomAppBar(title: 'Create Custom Workout'),
      body: exerciseProvider.isLoading
          ? const CustomLoadingAnimation()
          : SingleChildScrollView(
              child: Padding(
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
                      const SizedBox(height: 20),

                      // Search Bar
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Search Exercises',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                searchQuery = "";
                              });
                            },
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // Muscle Group Filters
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: muscleGroups.length,
                          itemBuilder: (context, index) {
                            final group = muscleGroups[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: ChoiceChip(
                                selectedColor:
                                    Theme.of(context).colorScheme.primary,
                                backgroundColor:
                                    Theme.of(context).colorScheme.surface,
                                labelStyle: TextStyle(
                                  color: selectedCategory == group
                                      ? Colors.white
                                      : theme.colorScheme.onSurface
                                          .withOpacity(0.6),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                side: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest,
                                  width: 1.5,
                                ),
                                label: Text(group),
                                selected: selectedCategory == group,
                                onSelected: (_) {
                                  setState(() {
                                    selectedCategory = group;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Exercise List with Search & Filter
                      const Text('Select Exercises'),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: exerciseProvider.exercises.length,
                        itemBuilder: (context, index) {
                          final exercise = exerciseProvider.exercises[index];

                          // Filter exercises
                          if (selectedCategory != 'All' &&
                              exercise.targetMuscleGroup != selectedCategory) {
                            return const SizedBox.shrink();
                          }
                          if (searchQuery.isNotEmpty &&
                              !exercise.exerciseName
                                  .toLowerCase()
                                  .contains(searchQuery.toLowerCase())) {
                            return const SizedBox.shrink();
                          }

                          final isAdded = selectedExercises
                              .any((e) => e['exercise'] == exercise);

                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    exercise.imageUrl),
                              ),
                              title: Text(exercise.exerciseName),
                              subtitle: Text(exercise.targetMuscleGroup),
                              trailing: isAdded
                                  ? const Icon(Icons.check, color: Colors.green)
                                  : IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        _showRepsSetsDialog(exercise);
                                      },
                                    ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      // Added Exercises List
                      const Text('Added Exercises:'),
                      selectedExercises.isEmpty
                          ? const Text(
                              'No exercises added yet.',
                              style: TextStyle(color: Colors.grey),
                            )
                          : ReorderableListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: selectedExercises.length,
                              itemBuilder: (context, index) {
                                final exerciseData = selectedExercises[index];
                                return Card(
                                  key: Key(exerciseData['exercise']
                                      .exerciseId
                                      .toString()),
                                  elevation: 2,
                                  child: ListTile(
                                    title: Text(
                                        exerciseData['exercise'].exerciseName),
                                    subtitle: Text(
                                      'Reps: ${exerciseData['reps']} | Sets: ${exerciseData['sets']} | Duration: ${exerciseData['duration']}',
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          selectedExercises.removeAt(index);
                                        });
                                        showCoolSnackBar(
                                          context,
                                          "${exerciseData['exercise'].exerciseName} removed",
                                          true,
                                          actionLabel: "Undo",
                                          onActionPressed: () {
                                            setState(() {
                                              selectedExercises.insert(
                                                  index, exerciseData);
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                              onReorder: (oldIndex, newIndex) {
                                setState(() {
                                  if (oldIndex < newIndex) {
                                    newIndex -= 1;
                                  }
                                  final exercise =
                                      selectedExercises.removeAt(oldIndex);
                                  selectedExercises.insert(newIndex, exercise);
                                });
                              },
                            ),
                      const SizedBox(height: 20),

                      // Create Custom Workout Button
                      ElevatedButton.icon(
                        onPressed: () async {
                          // First validate the form.
                          if (_formKey.currentState?.validate() ?? false) {
                            // Check if at least one exercise is added.
                            if (selectedExercises.isEmpty) {
                              showCoolSnackBar(
                                context,
                                'Please add at least one exercise.',
                                false,
                              );
                              return;
                            }

                            // Save the workout name from the controller.
                            final customWorkoutName =
                                _workoutNameController.text;
                            try {
                              // Create custom workout.
                              final customWorkoutId =
                                  await customWorkoutProvider
                                      .createCustomWorkout(
                                customWorkoutName,
                              );

                              // Prepare exercises payload.
                              final exercisesPayload =
                                  selectedExercises.map((data) {
                                return {
                                  'exercise_id': data['exercise'].exerciseId,
                                  'sets': int.parse(data['sets']),
                                  'reps': int.parse(data['reps']),
                                  'duration': data['duration'],
                                };
                              }).toList();

                              // Add exercises to custom workout.
                              await customWorkoutProvider
                                  .addExercisesToCustomWorkout(
                                      customWorkoutId, exercisesPayload);

                              // Refresh the workouts list before popping
                              await customWorkoutProvider.fetchCustomWorkouts();

                              showCoolSnackBar(
                                context,
                                'Custom workout created and exercises added successfully!',
                                true,
                              );

                              Navigator.pop(context,
                                  true); // Return true to indicate success
                            } catch (e) {
                              showCoolSnackBar(
                                context,
                                'Error: $e',
                                false,
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
                controller: setsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Sets'),
              ),
              TextField(
                controller: repsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Reps'),
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
                  showCoolSnackBar(
                    context,
                    "Please fill all the fields",
                    false,
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
