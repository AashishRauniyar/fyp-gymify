// import 'package:flutter/material.dart';
// import 'package:gymify/screens/main_screens/workout_screens/workout_details_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:gymify/providers/workout_provider/workout_provider.dart';

// class WorkoutListScreen extends StatelessWidget {
//   const WorkoutListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Workouts'),
//       ),
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
//                 return Card(
//                   margin:
//                       const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                   elevation: 5,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   child: InkWell(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               WorkoutDetailScreen(workoutId: workout.workoutId),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                           image: workout.workoutImage.isNotEmpty
//                               ? NetworkImage(workout.workoutImage)
//                               : const AssetImage(
//                                       'assets/images/workout_image/defaultWorkoutImage.jpg')
//                                   as ImageProvider,
//                           fit: BoxFit.cover,
//                           colorFilter: ColorFilter.mode(
//                             Colors.black.withOpacity(0.5),
//                             BlendMode.darken,
//                           ),
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: ListTile(
//                         contentPadding: const EdgeInsets.all(16),
//                         title: Text(
//                           workout.workoutName,
//                           style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         subtitle: Text(
//                           workout.targetMuscleGroup,
//                           style: const TextStyle(
//                               color: Colors.white, fontSize: 16),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

//! with search bar
import 'package:flutter/material.dart';
import 'package:gymify/screens/main_screens/workout_screens/workout_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:gymify/providers/workout_provider/workout_provider.dart';

class WorkoutListScreen extends StatefulWidget {
  const WorkoutListScreen({super.key});

  @override
  _WorkoutListScreenState createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
            if (workoutProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (workoutProvider.workouts.isEmpty) {
              return const Center(child: Text('No workouts found.'));
            }

            // Filter workouts based on the search query
            final filteredWorkouts = workoutProvider.workouts.where((workout) {
              final workoutName = workout.workoutName.toLowerCase();
              final targetMuscleGroup = workout.targetMuscleGroup.toLowerCase();
              return workoutName.contains(_searchQuery) ||
                  targetMuscleGroup.contains(_searchQuery);
            }).toList();

            return Column(
              children: [
                // Search Bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search Workouts...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),

                // Workout List
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredWorkouts.length,
                    itemBuilder: (context, index) {
                      final workout = filteredWorkouts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WorkoutDetailScreen(
                                    workoutId: workout.workoutId),
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
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
