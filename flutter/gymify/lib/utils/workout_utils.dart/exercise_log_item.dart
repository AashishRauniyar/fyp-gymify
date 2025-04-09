import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/models/workout_log_models/workout_exercise_log_model.dart';

class ExerciseLogItem extends StatelessWidget {
  final Workoutexerciseslog exerciseLog;

  const ExerciseLogItem({super.key, required this.exerciseLog});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to exercise details screen (if needed)
        context.pushNamed('exerciseDetails', extra: exerciseLog.exercises);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
            width: 1.5,
          ),
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: exerciseLog.exercises.imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    exerciseLog.exercises.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: const Icon(Icons.fitness_center),
                    ),
                  ),
                )
              : Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Icon(Icons.fitness_center),
                ),
          title: Text(
            exerciseLog.exercises.exerciseName ?? 'Unknown Exercise',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                'Target: ${exerciseLog.exercises.targetMuscleGroup ?? 'N/A'}',
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 4),
              Text(
                'Duration: ${double.parse(exerciseLog.exerciseDuration).toStringAsFixed(2)} min',
              ),
              if ((double.tryParse(exerciseLog.restDuration) ?? 0) > 0)
                Text(
                  'Rest: ${double.parse(exerciseLog.restDuration).toStringAsFixed(2)} min',
                ),
              if (exerciseLog.skipped)
                const Text(
                  'Skipped',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
