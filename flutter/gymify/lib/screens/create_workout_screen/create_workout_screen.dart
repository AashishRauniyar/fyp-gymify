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
                        validator: (value) => value!.isEmpty
                            ? 'Please enter a workout description'
                            : null,
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

      // Check if workout image is selected
      if (workoutImage == null) {
        showCoolSnackBar(context, "Please select a workout image", false);
        return;
      }

      // Check if at least one exercise is added
      if (exercises.isEmpty) {
        showCoolSnackBar(
            context, "Please add at least one exercise to your workout", false);
        return;
      }

      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(child: CustomLoadingAnimation());
          },
        );

        // Step 1: Create the workout first and wait for its completion
        final workoutId =
            await Provider.of<WorkoutProvider>(context, listen: false)
                .createWorkout(
          context: context,
          workoutName: workoutName!,
          description: description!,
          targetMuscleGroup: targetMuscleGroup!,
          difficulty: difficulty.toString().split('.').last,
          goalType: goalType.toString().split('.').last,
          fitnessLevel: fitnessLevel.toString().split('.').last,
          workoutImage: workoutImage,
        );

        // Add a small delay to ensure the server has processed the workout creation
        await Future.delayed(const Duration(milliseconds: 500));

        // If we're here, workout creation was successful
        // Now prepare the exercises payload
        final exercisesPayload = exercises.map((exerciseData) {
          return {
            'exercise_id': exerciseData['exercise'].exerciseId,
            'sets': exerciseData['sets'], // Already stored as int
            'reps': exerciseData['reps'], // Already stored as int
            'duration': exerciseData['duration'], // Already stored as double
          };
        }).toList();

        // Step 2: Add exercises to the workout
        await Provider.of<WorkoutProvider>(context, listen: false)
            .addExercisesToWorkout(
          context,
          workoutId,
          exercisesPayload,
        );

        // Close the loading dialog
        if (context.mounted) {
          Navigator.of(context).pop();
        }

        if (context.mounted) {
          showCoolSnackBar(context, "Workout created successfully", true);
          // Navigate back after successful creation
          context.pop();
        }
      } catch (error) {
        // Close the loading dialog if it's showing
        if (context.mounted && Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }

        if (context.mounted) {
          // Check for specific duplicate name error
          if (error.toString().contains('already exists')) {
            showCoolSnackBar(
                context,
                "A workout with this name already exists. Please choose a different name.",
                false);
          } else {
            showCoolSnackBar(
                context, "Error creating workout: ${error.toString()}", false);
          }
        }
      }
    } else {
      // Form validation failed - scrolls to show errors
      showCoolSnackBar(context, "Please fill in all required fields", false);
    }
  }

  void _showRepsSetsDialog(Exercise exercise) {
    // Reset controllers before showing dialog
    repsController.clear();
    setsController.clear();
    durationController.clear();

    // Define validation limits based on exercise properties
    const int maxSets = 10; // Standard max sets for most exercises
    int minReps = 1;
    int maxReps = 30;
    double minDuration = 0.5; // 30 seconds
    double maxDuration = 10.0; // 10 minutes

    // Adjust limits based on target muscle group or exercise type
    if (exercise.targetMuscleGroup.toLowerCase().contains('cardio') ||
        exercise.exerciseName.toLowerCase().contains('run') ||
        exercise.exerciseName.toLowerCase().contains('jog') ||
        exercise.exerciseName.toLowerCase().contains('cycle')) {
      // For cardio exercises
      minReps = 1;
      maxReps = 1; // Often cardio is just 1 set
      minDuration = 5.0; // Minimum 5 minutes
      maxDuration = 60.0; // Up to an hour
    } else if (exercise.targetMuscleGroup.toLowerCase() == 'core') {
      // For core exercises
      minReps = 8;
      maxReps = 50; // Core can have higher reps
      minDuration = 0.25; // 15 seconds
      maxDuration = 5.0; // 5 minutes
    } else if (exercise.exerciseName.toLowerCase().contains('plank') ||
        exercise.exerciseName.toLowerCase().contains('hold')) {
      // For isometric/holding exercises
      minReps = 1;
      maxReps = 5; // Fewer reps for holds
      minDuration = 0.25; // 15 seconds
      maxDuration = 5.0; // 5 minutes
    }

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
                decoration: const InputDecoration(
                  labelText: 'Sets',
                  hintText: 'Between 1 and $maxSets',
                ),
              ),
              TextField(
                controller: repsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Reps',
                  hintText: 'Between $minReps and $maxReps',
                ),
              ),
              TextField(
                controller: durationController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Duration (minutes)',
                  hintText: 'Between $minDuration and $maxDuration minutes',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Validate inputs are not empty
                if (repsController.text.isEmpty ||
                    setsController.text.isEmpty ||
                    durationController.text.isEmpty) {
                  showCoolSnackBar(context, "Please fill all fields", false);
                  return;
                }

                // Parse inputs
                int? sets;
                int? reps;
                double? duration;

                try {
                  sets = int.parse(setsController.text);
                  reps = int.parse(repsController.text);
                  duration = double.parse(durationController.text);
                } catch (e) {
                  showCoolSnackBar(
                      context, "Please enter valid numbers", false);
                  return;
                }

                // Validate ranges
                if (sets < 1 || sets > maxSets) {
                  showCoolSnackBar(
                      context, "Sets should be between 1 and $maxSets", false);
                  return;
                }

                if (reps < minReps || reps > maxReps) {
                  showCoolSnackBar(
                      context,
                      "Reps should be between $minReps and $maxReps for this exercise",
                      false);
                  return;
                }

                if (duration < minDuration || duration > maxDuration) {
                  showCoolSnackBar(
                      context,
                      "Duration should be between $minDuration and $maxDuration minutes for this exercise",
                      false);
                  return;
                }

                // Add exercise to the list
                setState(() {
                  exercises.add({
                    'exercise': exercise,
                    'reps': reps, // Store as int instead of string
                    'sets': sets, // Store as int instead of string
                    'duration': duration, // Store as double instead of string
                  });
                });

                Navigator.pop(context);
                showCoolSnackBar(
                    context, "${exercise.exerciseName} added to workout", true);
              },
              child: const Text('Add Exercise'),
            ),
          ],
        );
      },
    );
  }
}
