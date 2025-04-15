//! mathi ko new

//? tala ko adjusted

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/models/exercise_model.dart'; // Import the Exercise model
import 'package:gymify/providers/exercise_provider/exercise_provider.dart';
import 'package:gymify/providers/workout_provider/workout_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:gymify/utils/custom_snackbar.dart';
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
  String searchQuery = "";
  File? workoutImage;
  DifficultyLevel difficulty = DifficultyLevel.Easy;
  GoalType goalType = GoalType.Weight_Loss;
  FitnessLevel fitnessLevel = FitnessLevel.Beginner;

  List<Map<String, dynamic>> exercises = [];
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
  Widget build(BuildContext context) {
    final exerciseProvider = Provider.of<ExerciseProvider>(context);
    final theme = Theme.of(context);
    final workoutProvider = Provider.of<WorkoutProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: "Create Workout",
        onBackPressed: () => context.pop(),
      ),
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
                      // Workout Name
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Workout Name'),
                        onSaved: (value) => workoutName = value,
                        validator: (value) => value!.isEmpty
                            ? 'Please enter a workout name'
                            : null,
                      ),
                      const SizedBox(height: 20),

                      // Description
                      TextFormField(
                        maxLines: 4,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        onSaved: (value) => description = value,
                      ),
                      const SizedBox(height: 20),

                      // Target Muscle Group Dropdown
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                            labelText: 'Target Muscle Group'),
                        value: targetMuscleGroup,
                        onChanged: (String? newValue) {
                          setState(() {
                            targetMuscleGroup = newValue;
                          });
                        },
                        items: muscleGroups
                            .where((group) => group != 'All')
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  // fontWeight: FontWeight.bold,
                                  ),
                            ),
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
                        decoration: const InputDecoration(
                            labelText: 'Difficulty Level'),
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
                            child: Text(
                              value.toString().split('.').last,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  // fontWeight: FontWeight.bold,
                                  ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),

                      // Goal Type Dropdown
                      DropdownButtonFormField<GoalType>(
                        decoration:
                            const InputDecoration(labelText: 'Goal Type'),
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
                              value
                                  .toString()
                                  .split('.')
                                  .last
                                  .replaceAll('_', ' '),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  // fontWeight: FontWeight.bold,
                                  ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),

                      // Fitness Level Dropdown
                      DropdownButtonFormField<FitnessLevel>(
                        decoration:
                            const InputDecoration(labelText: 'Fitness Level'),
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
                            child: Text(
                              value.toString().split('.').last,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  // fontWeight: FontWeight.bold,
                                  ),
                            ),
                          );
                        }).toList(),
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
                                // checkmarkColor: ,

                                selectedColor: Theme.of(context)
                                    .colorScheme
                                    .primary, // Primary color when selected
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .surface, // Surface color when not selected
                                labelStyle: TextStyle(
                                  color: selectedCategory == group
                                      ? Colors.white
                                      : theme.colorScheme.onSurface.withOpacity(
                                          0.6), // Text color based on selection
                                ),

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      12.0), // Optional: Customize the shape with rounded corners
                                ),
                                side: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest, // Border color, using surface variant for border
                                  width: 1.5, // Border width
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

                          final isAdded =
                              exercises.any((e) => e['exercise'] == exercise);

                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(exercise.imageUrl),
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
                      exercises.isEmpty
                          ? const Text(
                              'No exercises added yet.',
                              style: TextStyle(color: Colors.grey),
                            )
                          : ReorderableListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: exercises.length,
                              itemBuilder: (context, index) {
                                final exerciseData = exercises[index];
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
                                          exercises.removeAt(index);
                                        });
                                        showCoolSnackBar(
                                          context,
                                          "${exerciseData['exercise'].exerciseName} removed",
                                          true,
                                          actionLabel: "Undo",
                                          onActionPressed: () {
                                            setState(() {
                                              exercises.insert(
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
                                  final exercise = exercises.removeAt(oldIndex);
                                  exercises.insert(newIndex, exercise);
                                });
                              },
                            ),
                      const SizedBox(height: 20),

                      // Workout Image Upload
                      const Text('Workout Image'),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.blue, width: 2),
                                color: workoutImage == null
                                    ? Colors.grey[200]
                                    : null,
                              ),
                              child: workoutImage == null
                                  ? const Icon(Icons.image,
                                      size: 40, color: Colors.blue)
                                  : ClipOval(
                                      child: Image.file(workoutImage!,
                                          fit: BoxFit.cover)),
                            ),
                            if (workoutImage != null)
                              Positioned(
                                top: 5,
                                right: 5,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      workoutImage = null;
                                    });
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 12,
                                    child: Icon(Icons.close,
                                        color: Colors.white, size: 18),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      workoutProvider.isLoading
                          ? const Center(child: CustomLoadingAnimation())
                          : ElevatedButton.icon(
                              onPressed: _createWorkout,
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

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        workoutImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _createWorkout() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      try {
        final workoutId =
            await Provider.of<WorkoutProvider>(context, listen: false)
                .createWorkout(
          context: context,
          workoutName: workoutName!,
          description: description ?? '',
          targetMuscleGroup: targetMuscleGroup!,
          difficulty: difficulty.toString().split('.').last,
          goalType: goalType.toString().split('.').last,
          fitnessLevel: fitnessLevel.toString().split('.').last,
          workoutImage: workoutImage,
        );

        final exercisesPayload = exercises.map((exerciseData) {
          return {
            'exercise_id': exerciseData['exercise'].exerciseId,
            'sets': int.parse(exerciseData['sets']),
            'reps': int.parse(exerciseData['reps']),
            'duration': exerciseData['duration'],
          };
        }).toList();

        await Provider.of<WorkoutProvider>(context, listen: false)
            .addExercisesToWorkout(
          context,
          workoutId,
          exercisesPayload,
        );

        if (context.mounted) {
          showCoolSnackBar(context, "Workout created successfully", true);
          // Navigate back after successful creation
          context.pop();
        }
      } catch (e) {
        if (context.mounted) {
          // Check for specific duplicate name error
          if (e.toString().contains('already exists')) {
            showCoolSnackBar(
                context,
                "A workout with this name already exists. Please choose a different name.",
                false);
          } else {
            showCoolSnackBar(context,
                "Error: ${e.toString().replaceAll('Exception: ', '')}", false);
          }
        }
      }
    }
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
                  showCoolSnackBar(
                      context, "Please fill all the fields", false);
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
