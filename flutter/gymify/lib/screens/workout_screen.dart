// import 'package:flutter/material.dart';
// import 'package:gymify/providers/workout_provider/workout_provider.dart';
// import 'package:provider/provider.dart';

// class WorkoutScreen extends StatefulWidget {
//   const WorkoutScreen({super.key});

//   @override
//   _WorkoutScreenState createState() => _WorkoutScreenState();
// }

// class _WorkoutScreenState extends State<WorkoutScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch all workouts when the screen is loaded
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // Fetch workouts from provider
//       context.read<WorkoutProvider>().fetchAllWorkouts();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Workouts'),
//       ),
//       body: Consumer<WorkoutProvider>(
//         builder: (context, workoutProvider, child) {
//           // Display loading indicator while fetching data
//           if (workoutProvider.workouts.isEmpty) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           return ListView.builder(
//             itemCount: workoutProvider.workouts.length,
//             itemBuilder: (context, index) {
//               final workout = workoutProvider.workouts[index];
//               return ListTile(
//                 title: Text(workout.workoutName),
//                 subtitle: Text(workout.difficulty),
//                 onTap: () => _showWorkoutDetails(context, workout.workoutId),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   void _showWorkoutDetails(BuildContext context, int workoutId) {
//     final workoutProvider =
//         Provider.of<WorkoutProvider>(context, listen: false);
//     workoutProvider.fetchWorkoutById(workoutId).then((workout) {
//       if (workout != null) {
//         // Navigate to workout details screen with workout data
//         // For now, we'll just print the workout details as an example
//         print('Workout details: ${workout.workoutName}');
//       }
//     });
//   }
// }

