import 'package:flutter/material.dart';
import 'package:gymify/screens/main_screens/workout_screens/workout_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:gymify/providers/workout_provider/workout_provider.dart';

class WorkoutListScreen extends StatelessWidget {
  const WorkoutListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
      ),
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
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              WorkoutDetailScreen(workoutId: workout.workoutId),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: workout.workoutImage.isNotEmpty
                              ? NetworkImage(workout.workoutImage)
                              : const AssetImage(
                                      'assets/images/workout_image/defaultWorkoutImage.jpg')
                                  as ImageProvider,
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5),
                            BlendMode.darken,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          workout.workoutName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          workout.targetMuscleGroup,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
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

