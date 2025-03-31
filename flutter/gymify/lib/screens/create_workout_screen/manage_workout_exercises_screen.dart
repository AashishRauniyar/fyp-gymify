import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/models/workout_model.dart';
import 'package:gymify/providers/exercise_provider/exercise_provider.dart';
import 'package:gymify/providers/workout_provider/workout_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:provider/provider.dart';

class ManageWorkoutExercisesScreen extends StatefulWidget {
  final Workout workout;

  const ManageWorkoutExercisesScreen({
    super.key,
    required this.workout,
  });

  @override
  State<ManageWorkoutExercisesScreen> createState() =>
      _ManageWorkoutExercisesScreenState();
}

class _ManageWorkoutExercisesScreenState
    extends State<ManageWorkoutExercisesScreen> {
  bool _isLoading = false;
  late Workout _currentWorkout;

  @override
  void initState() {
    super.initState();
    _currentWorkout = widget.workout;
    _refreshWorkoutDetails();
  }

  Future<void> _refreshWorkoutDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final workoutProvider =
          Provider.of<WorkoutProvider>(context, listen: false);
      await workoutProvider.fetchWorkoutById(_currentWorkout.workoutId);

      if (workoutProvider.selectedWorkout != null) {
        setState(() {
          _currentWorkout = workoutProvider.selectedWorkout!;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading workout details: ${e.toString()}'),
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

  Future<void> _removeExercise(int workoutExerciseId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final workoutProvider =
          Provider.of<WorkoutProvider>(context, listen: false);
      await workoutProvider.removeExerciseFromWorkout(
        _currentWorkout.workoutId,
        workoutExerciseId,
      );

      // Refresh workout details to get updated exercise list
      await _refreshWorkoutDetails();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Exercise removed successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error removing exercise: ${e.toString()}'),
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

  void _showRemoveConfirmationDialog(Workoutexercise exercise) {
    final exerciseName = exercise.exercises?.exerciseName ?? 'this exercise';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Exercise'),
        content: Text(
            'Are you sure you want to remove $exerciseName from this workout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _removeExercise(exercise.workoutExerciseId);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _navigateToAddExercises() {
    context
        .pushNamed(
          'addExercisesToWorkout',
          extra: _currentWorkout,
        )
        .then((_) => _refreshWorkoutDetails());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final exercises = _currentWorkout.workoutexercises ?? [];

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Manage Exercises",
        showBackButton: true,
      ),
      body: _isLoading
          ? const Center(child: CustomLoadingAnimation())
          : exercises.isEmpty
              ? _buildEmptyState(theme)
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = exercises[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Slidable(
                        key: ValueKey(exercise.workoutExerciseId),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dismissible: DismissiblePane(
                            onDismissed: () =>
                                _showRemoveConfirmationDialog(exercise),
                          ),
                          children: [
                            SlidableAction(
                              onPressed: (context) =>
                                  _showRemoveConfirmationDialog(exercise),
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Remove',
                            ),
                          ],
                        ),
                        child: _buildExerciseCard(context, exercise),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddExercises,
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            "No exercises in this workout",
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            "Add exercises to complete your workout",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _navigateToAddExercises,
            icon: const Icon(Icons.add),
            label: const Text('Add Exercises'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(BuildContext context, Workoutexercise exercise) {
    final theme = Theme.of(context);
    final exerciseName = exercise.exercises?.exerciseName ?? 'Unknown Exercise';

    final muscleGroup =
        exercise.exercises?.targetMuscleGroup ?? 'Unknown Muscle Group';
    final sets = exercise.sets;
    final reps = exercise.reps;
    final duration = exercise.duration;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise icon or image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 16),
            // Exercise details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exerciseName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    muscleGroup,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildInfoChip(theme, 'Sets: $sets'),
                      const SizedBox(width: 8),
                      _buildInfoChip(theme, 'Reps: $reps'),
                      if (duration != '0') ...[
                        const SizedBox(width: 8),
                        _buildInfoChip(theme, 'Duration: ${duration}s'),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Handle or action icon
            Icon(
              Icons.drag_handle,
              size: 20,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(ThemeData theme, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  IconData _getExerciseIcon(String exerciseType) {
    switch (exerciseType.toLowerCase()) {
      case 'strength':
        return Icons.fitness_center;
      case 'cardio':
        return Icons.directions_run;
      case 'flexibility':
        return Icons.accessibility_new;
      case 'balance':
        return Icons.sync_alt;
      default:
        return Icons.fitness_center;
    }
  }
}
