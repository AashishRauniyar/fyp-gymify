import 'package:flutter/material.dart';
import 'package:gymify/providers/custom_workout_provider/custom_workout_provider.dart';
import 'package:provider/provider.dart';

class CustomWorkoutDetailScreen extends StatelessWidget {
  final int customWorkoutId;

  const CustomWorkoutDetailScreen({super.key, required this.customWorkoutId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Workout Details'),
      ),
      body: ChangeNotifierProvider(
        create: (_) =>
            CustomWorkoutProvider()..getCustomWorkoutModelsById(customWorkoutId),
        child: Consumer<CustomWorkoutProvider>(
          builder: (context, customWorkoutProvider, child) {
            if (customWorkoutProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final exercises = customWorkoutProvider.customWorkouts
                .firstWhere((workout) =>
                    workout.customWorkoutId == customWorkoutId)
                .customworkoutexercises;

            if (exercises.isEmpty) {
              return const Center(child: Text('No exercises found.'));
            }

            return ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: ListTile(
                    title: Text(
                      exercise.exercises.exerciseName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                        'Sets: ${exercise.sets}, Reps: ${exercise.reps}, Duration: ${exercise.duration} mins'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        try {
                          await customWorkoutProvider
                              .removeExerciseFromCustomWorkout(
                                  exercise.customWorkoutExerciseId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Exercise removed successfully.'),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $e'),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
