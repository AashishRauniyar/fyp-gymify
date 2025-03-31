import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/models/workout_model.dart';
import 'package:gymify/providers/workout_provider/workout_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditWorkoutScreen extends StatefulWidget {
  final Workout workout;

  const EditWorkoutScreen({
    super.key,
    required this.workout,
  });

  @override
  State<EditWorkoutScreen> createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late String _selectedMuscleGroup;
  late String _selectedDifficulty;
  late String _selectedGoalType;
  late String _selectedFitnessLevel;

  File? _workoutImage;
  bool _isLoading = false;
  bool _hasChanges = false;

  // Dropdown options
  final List<String> _muscleGroups = [
    'Chest',
    'Back',
    'Legs',
    'Shoulders',
    'Arms',
    'Core',
    'Full Body',
    'Cardio'
  ];

  final List<String> _difficultyLevels = ['Easy', 'Intermediate', 'Hard'];

  final List<String> _goalTypes = [
    'Weight_Loss',
    'Muscle_Gain',
    'Endurance',
    'Maintenance',
    'Flexibility'
  ];

  final List<String> _fitnessLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Athlete'
  ];

  @override
  void initState() {
    super.initState();
    _initFormValues();
  }

  void _initFormValues() {
    _nameController = TextEditingController(text: widget.workout.workoutName);
    _descriptionController =
        TextEditingController(text: widget.workout.description);
    _selectedMuscleGroup = widget.workout.targetMuscleGroup;
    _selectedDifficulty = widget.workout.difficulty;
    _selectedGoalType = widget.workout.goalType;
    _selectedFitnessLevel = widget.workout.fitnessLevel;

    // Listen for changes to track if form has been modified
    _nameController.addListener(_onFormChanged);
    _descriptionController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _workoutImage = File(pickedFile.path);
        _hasChanges = true;
      });
    }
  }

  Future<void> _saveWorkout() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final workoutProvider =
          Provider.of<WorkoutProvider>(context, listen: false);
      await workoutProvider.updateWorkout(
        workoutId: widget.workout.workoutId,
        workoutName: _nameController.text,
        description: _descriptionController.text,
        targetMuscleGroup: _selectedMuscleGroup,
        difficulty: _selectedDifficulty,
        goalType: _selectedGoalType,
        fitnessLevel: _selectedFitnessLevel,
        workoutImage: _workoutImage,
      );

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Workout updated successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Return to manage workouts screen
      context.pop();
    } catch (e) {
      // Show error message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating workout: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) {
      return true;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text(
            'You have unsaved changes. Are you sure you want to discard them?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  void _navigateToManageExercises() {
    context.pushNamed(
      'manageWorkoutExercises',
      extra: widget.workout,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Edit Workout",
          showBackButton: true,
          actions: [
            TextButton.icon(
              onPressed: _navigateToManageExercises,
              icon: const Icon(Icons.fitness_center),
              label: const Text('Exercises'),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CustomLoadingAnimation())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Workout Image
                      Center(
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    theme.colorScheme.primary.withOpacity(0.3),
                              ),
                            ),
                            child: _workoutImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      _workoutImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : widget.workout.workoutImage.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          widget.workout.workoutImage,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return _buildImagePlaceholder();
                                          },
                                        ),
                                      )
                                    : _buildImagePlaceholder(),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),
                      Center(
                        child: TextButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Change Image'),
                          style: TextButton.styleFrom(
                            foregroundColor: theme.colorScheme.primary,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      // Workout Name
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Workout Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.fitness_center),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter workout name';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),
                      // Description
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.description),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter workout description';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),
                      // Target Muscle Group
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Target Muscle Group',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.accessibility_new),
                        ),
                        value: _selectedMuscleGroup,
                        items: _muscleGroups.map((String muscleGroup) {
                          return DropdownMenuItem<String>(
                            value: muscleGroup,
                            child: Text(muscleGroup),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedMuscleGroup = newValue;
                              _hasChanges = true;
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select target muscle group';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),
                      // Difficulty
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Difficulty',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.trending_up),
                        ),
                        value: _selectedDifficulty,
                        items: _difficultyLevels.map((String difficulty) {
                          return DropdownMenuItem<String>(
                            value: difficulty,
                            child: Text(difficulty),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedDifficulty = newValue;
                              _hasChanges = true;
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select difficulty level';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),
                      // Goal Type
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Goal Type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.flag),
                        ),
                        value: _selectedGoalType,
                        items: _goalTypes.map((String goalType) {
                          return DropdownMenuItem<String>(
                            value: goalType,
                            child: Text(goalType.replaceAll('_', ' ')),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedGoalType = newValue;
                              _hasChanges = true;
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select goal type';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),
                      // Fitness Level
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Fitness Level',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.fitness_center),
                        ),
                        value: _selectedFitnessLevel,
                        items: _fitnessLevels.map((String fitnessLevel) {
                          return DropdownMenuItem<String>(
                            value: fitnessLevel,
                            child: Text(fitnessLevel),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedFitnessLevel = newValue;
                              _hasChanges = true;
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select fitness level';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _hasChanges ? _saveWorkout : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('SAVE CHANGES'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.fitness_center,
          size: 50,
          color: Colors.grey,
        ),
        SizedBox(height: 8),
        Text(
          'Tap to add image',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
