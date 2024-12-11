// import 'package:flutter/material.dart';
// import 'package:gymify/models/workout_model.dart';
// import 'package:provider/provider.dart';

// import 'package:gymify/providers/workout_provider/workout_provider.dart';

// class WorkoutListScreen extends StatelessWidget {
//   const WorkoutListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ChangeNotifierProvider(
//         create: (_) => WorkoutProvider()..fetchAllWorkouts(),
//         child: Consumer<WorkoutProvider>(
//           builder: (context, workoutProvider, child) {
//             if (workoutProvider.workouts.isEmpty) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             return ListView.builder(
//               itemCount: workoutProvider.workouts.length,
//               itemBuilder: (context, index) {
//                 final workout = workoutProvider.workouts[index];
//                 return ListTile(
//                   title: Text(workout.workoutName),
//                   subtitle: Text(workout.targetMuscleGroup),
//                   onTap: () {
//                     // Navigate to a detailed screen showing exercises
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             WorkoutDetailScreen(workout: workout),
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class WorkoutDetailScreen extends StatelessWidget {
//   final Workout workout;

//   const WorkoutDetailScreen({super.key, required this.workout});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(workout.workoutName)),
//       body: ListView.builder(
//         itemCount: workout.workoutexercises.length,
//         itemBuilder: (context, index) {
//           final exercise = workout.workoutexercises[index];
//           return ListTile(
//             title: Text('Exercise ID: ${exercise.exerciseId}'),

//             subtitle: Text(
//                 'Sets: ${exercise.sets} | Reps: ${exercise.reps} | Duration: ${exercise.duration}s'),
//           );
//         },
//       ),
//     );
//   }
// }

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
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Container(
                    decoration: BoxDecoration(
  image: DecorationImage(
    image: workout.workoutImage.isNotEmpty
        ? NetworkImage(workout.workoutImage) // Use network image if URL is available
        : const AssetImage('assets/images/workout_image/defaultWorkoutImage.jpg') as ImageProvider, // Fallback to the asset image if URL is empty
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
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      onTap: () {
                        // Navigate to the detailed screen showing exercises
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                WorkoutDetailScreen(workout: workout),
                          ),
                        );
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

class WorkoutDetailScreen extends StatelessWidget {
  final Workout workout;

  const WorkoutDetailScreen({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workout.workoutName),
        backgroundColor:
            Colors.transparent, // AppBar with transparent background
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.network(
                workout.workoutImage.isNotEmpty
                    ? workout
                        .workoutImage // If the workout image exists, use it
                    : 'assets/images/workout_image/defaultWorkoutImage.png', // Fallback to the local asset image if empty
                fit: BoxFit.cover,
              ),
            ),

            // Overlay content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Workout Name and Description
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors
                          .black54, // Semi-transparent background for text readability
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workout.workoutName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          workout.description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Workout details: target muscle group, difficulty, etc.
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Target Muscle Group: ${workout.targetMuscleGroup}",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "Difficulty: ${workout.difficulty}",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "Fitness Level: ${workout.fitnessLevel}",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "Goal Type: ${workout.goalType}",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Exercises List
                  Text(
                    'Exercises Included:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap:
                        true, // Ensures the list doesn't take up extra space
                    physics:
                        NeverScrollableScrollPhysics(), // Disable scrolling on the list
                    itemCount: workout.workoutexercises.length,
                    itemBuilder: (context, index) {
                      final exercise = workout.workoutexercises[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text('Exercise: ${exercise.exerciseId}'),
                          subtitle: Text(
                            'Sets: ${exercise.sets} | Reps: ${exercise.reps} | Duration: ${exercise.duration}s',
                          ),
                          trailing: const Icon(Icons.fitness_center),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
