// import 'package:flutter/material.dart';
// import 'package:gymify/providers/exercise_provider/exercise_provider.dart';
// import 'package:provider/provider.dart';

// class ExerciseScreen extends StatefulWidget {
//   const ExerciseScreen({super.key});

//   @override
//   State<ExerciseScreen> createState() => _ExerciseScreenState();
// }

// class _ExerciseScreenState extends State<ExerciseScreen> {

//   @override
//   void initState() {
//     super.initState();
//     // Fetch all exercises when the screen is loaded
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // Fetch exercises from provider
//       context.read<ExerciseProvider>().fetchAllExercises();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Exercises'),
//       ),
//       body: Center(
//         child: Consumer<ExerciseProvider>(
//           builder: (context, exerciseProvider, child) {
//             // Checking if exercises are loaded
//             if (exerciseProvider.exercises.isEmpty) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             return ListView.builder(
//               itemCount: exerciseProvider.exercises.length,
//               itemBuilder: (context, index) {
//                 final exercise = exerciseProvider.exercises[index];
//                 return ListTile(
//                   title: Text(exercise.exerciseName),
//                   subtitle: Text(exercise.description),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:gymify/providers/exercise_provider/exercise_provider.dart';
import 'package:provider/provider.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch all exercises when the screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch exercises from provider
      context.read<ExerciseProvider>().fetchAllExercises();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.greenAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality (future feature)
            },
          ),
        ],
      ),
      body: Consumer<ExerciseProvider>(
        builder: (context, exerciseProvider, child) {
          // Check if exercises are still being loaded
          if (exerciseProvider.exercises.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: exerciseProvider.exercises.length,
              itemBuilder: (context, index) {
                final exercise = exerciseProvider.exercises[index];

                return ExerciseCard(exercise: exercise);
              },
            ),
          );
        },
      ),
    );
  }
}

// Custom Card to Display Each Exercise
class ExerciseCard extends StatelessWidget {
  final exercise;

  const ExerciseCard({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise Name
            Text(
              exercise.exerciseName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            // Exercise Description
            Text(
              exercise.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 10),
            // Example of adding more details like a category (could be strength, flexibility, etc.)
            const Row(
              children: [
                Icon(
                  Icons.fitness_center,
                  color: Colors.greenAccent,
                ),
                SizedBox(width: 5),
                Text(
                  'Strength', // You can use the exercise category here
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // A simple action button or icon (e.g., Add to favorites)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.favorite_border, color: Colors.redAccent),
                  onPressed: () {
                    // Implement adding to favorites (optional)
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
