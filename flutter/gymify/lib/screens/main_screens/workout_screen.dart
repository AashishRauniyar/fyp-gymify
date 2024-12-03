import 'package:flutter/material.dart';
import 'package:gymify/models/workout_model.dart';
import 'package:provider/provider.dart';

import 'package:gymify/providers/workout_provider/workout_provider.dart';

class WorkoutListScreen extends StatelessWidget {
  const WorkoutListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (_) => WorkoutProvider()..fetchAllWorkouts(),
        child: Consumer<WorkoutProvider>(
          builder: (context, workoutProvider, child) {
            if (workoutProvider.workouts.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              itemCount: workoutProvider.workouts.length,
              itemBuilder: (context, index) {
                final workout = workoutProvider.workouts[index];
                return ListTile(
                  title: Text(workout.workoutName),
                  subtitle: Text(workout.targetMuscleGroup),
                  onTap: () {
                    // Navigate to a detailed screen showing exercises
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            WorkoutDetailScreen(workout: workout),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class WorkoutDetailScreen extends StatelessWidget {
  final Workout workout;

  const WorkoutDetailScreen({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(workout.workoutName)),
      body: ListView.builder(
        itemCount: workout.workoutexercises.length,
        itemBuilder: (context, index) {
          final exercise = workout.workoutexercises[index];
          return ListTile(
            title: Text('Exercise ID: ${exercise.exerciseId}'),
            subtitle: Text(
                'Sets: ${exercise.sets} | Reps: ${exercise.reps} | Duration: ${exercise.duration}s'),
          );
        },
      ),
    );
  }
}
