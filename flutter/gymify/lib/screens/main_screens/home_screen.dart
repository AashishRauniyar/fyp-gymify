// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:gymify/providers/workout_provider/workout_provider.dart';
// import 'package:gymify/colors/custom_colors.dart';
// import 'package:gymify/screens/main_screens/workout_screens/workout_details_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: CustomColors.backgroundColor,
//       appBar: AppBar(
//         toolbarHeight: 80,
//         backgroundColor: CustomColors.backgroundColor,
//         title: const Text(
//           'Gymify',
//           style: TextStyle(
//               fontSize: 32,
//               fontWeight: FontWeight.bold,
//               color: CustomColors.secondary),
//         ),
//         actions: [
//           IconButton(
//             color: CustomColors.secondary,
//             icon: const Icon(Icons.settings),
//             onPressed: () {
//               print('Settings clicked');
//             },
//           ),
//         ],
//       ),
//       body: Consumer<WorkoutProvider>(
//         builder: (context, workoutProvider, child) {
//           if (workoutProvider.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (workoutProvider.hasError) {
//             return const Center(child: Text('Error fetching workouts.'));
//           }

//           final filteredWorkouts = workoutProvider.workouts.where((workout) {
//             final workoutName = workout.workoutName.toLowerCase();
//             final targetMuscleGroup = workout.targetMuscleGroup.toLowerCase();
//             return workoutName.contains(_searchQuery) ||
//                 targetMuscleGroup.contains(_searchQuery);
//           }).toList();

//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Search Bar
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: TextField(
//                       controller: _searchController,
//                       onChanged: (value) {
//                         setState(() {
//                           _searchQuery = value.toLowerCase();
//                         });
//                       },
//                       decoration: InputDecoration(
//                         hintText: 'Search Workouts...',
//                         prefixIcon: const Icon(Icons.search),
//                         filled: true,
//                         fillColor: Colors.grey[200],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding:
//                             const EdgeInsets.symmetric(vertical: 10),
//                       ),
//                     ),
//                   ),
//                   // Workout Plans Section
//                   const Text(
//                     "Workout Plans",
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: CustomColors.black,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   // Display filtered workout plans
//                   for (var workout in filteredWorkouts)
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => WorkoutDetailScreen(
//                                 workoutId: workout.workoutId),
//                           ),
//                         );
//                       },
//                       child: Card(
//                         margin: const EdgeInsets.symmetric(vertical: 10),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: 5,
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: Stack(
//                             children: [
//                               Image.network(
//                                 workout.workoutImage.isNotEmpty
//                                     ? workout.workoutImage
//                                     : 'https://via.placeholder.com/150',
//                                 fit: BoxFit.cover,
//                                 height: 200,
//                                 width: double.infinity,
//                               ),
//                               Positioned(
//                                 bottom: 0,
//                                 left: 0,
//                                 right: 0,
//                                 child: Container(
//                                   padding: const EdgeInsets.all(10),
//                                   color: Colors.black.withOpacity(0.5),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         workout.workoutName,
//                                         style: const TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 8),
//                                       Text(
//                                         workout.targetMuscleGroup,
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           color: Colors.white.withOpacity(0.8),
//                                         ),
//                                       ),
//                                       const SizedBox(height: 12),
//                                       ElevatedButton(
//                                         onPressed: () {
//                                           print('Start ${workout.workoutName}');
//                                         },
//                                         style: ElevatedButton.styleFrom(
//                                           padding: const EdgeInsets.symmetric(
//                                               vertical: 12, horizontal: 20),
//                                         ),
//                                         child: const Text(
//                                           'Start',
//                                           style: TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   // Footer Text
//                   Center(
//                     child: Text(
//                       "Let's build a stronger you 💪",
//                       style: GoogleFonts.poppins(
//                         fontSize: 16,
//                         color: CustomColors.lightText,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymify/models/workout_model.dart';
import 'package:gymify/routes/route_config.dart';
import 'package:provider/provider.dart';
import 'package:gymify/providers/workout_provider/workout_provider.dart';
import 'package:gymify/colors/custom_colors.dart';
import 'package:gymify/screens/main_screens/workout_screens/workout_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: CustomColors.backgroundColor,
        title: const Text(
          'Gymify',
          style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: CustomColors.secondary),
        ),
        actions: [
          IconButton(
            color: CustomColors.secondary,
            icon: const Icon(Icons.settings),
            onPressed: () {
              print('Settings clicked');
            },
          ),
        ],
      ),
      body: Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, child) {
          if (workoutProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (workoutProvider.hasError) {
            return const Center(child: Text('Error fetching workouts.'));
          }

          final filteredWorkouts = workoutProvider.workouts.where((workout) {
            final workoutName = workout.workoutName.toLowerCase();
            final targetMuscleGroup = workout.targetMuscleGroup.toLowerCase();
            return workoutName.contains(_searchQuery) ||
                targetMuscleGroup.contains(_searchQuery);
          }).toList();

          final workouts = workoutProvider.workouts;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
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
                // Workout Plans Section
                const Text(
                  "Workout Plans",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.black,
                  ),
                ),
                // Display filtered workout plans horizontally
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: filteredWorkouts.map((workout) {
                      return WorkoutCard(
                        workout: workout,
                        onTap: () {
                          // Get the workoutId from the workout model
                          context.pushNamed(
                            'workoutDetail', // Named route
                            queryParameters: {
                              'workoutId': workout.workoutId.toString()
                            }, // Pass workoutId as a query parameter
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                // Image List Section
                const Text(
                  "All Workouts",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.black,
                  ),
                ),
                const SizedBox(height: 10),
                // ListView for workouts
                Expanded(
                  child: ListView.builder(
                    itemCount: workouts.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        elevation: 1,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              workouts[index].workoutImage,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            workouts[index].workoutName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            '${workouts[index].fitnessLevel} • ${workouts[index].goalType}',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: CustomColors.secondary),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            print('Tapped on ${workouts[index].workoutName}');

                            final workoutId = workouts[index]
                                .workoutId; // Get the workoutId from the workout model
                            context.pushNamed(
                              'workoutDetail', // Named route
                              queryParameters: {
                                'workoutId': workoutId.toString()
                              }, // Pass workoutId as a query parameter
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                // Footer Text
                Center(
                  child: Text(
                    "Let's build a stronger you 💪",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: CustomColors.lightText,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class WorkoutCard extends StatelessWidget {
  final Workout workout;
  final VoidCallback onTap;

  const WorkoutCard({
    super.key,
    required this.workout,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Image.network(
                workout.workoutImage.isNotEmpty
                    ? workout.workoutImage
                    : 'https://via.placeholder.com/150',
                fit: BoxFit.cover,
                height: 200,
                width: 340, // Control width
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.black.withOpacity(0.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Level of the workout (Beginner, Intermediate)
                      Text(
                        workout.fitnessLevel,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Workout Title
                      Text(
                        workout.workoutName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Workout Description
                      Text(
                        workout.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Start Button
                      ElevatedButton(
                        onPressed: () {
                          // Trigger the workout start action
                          print('Start ${workout.workoutName}');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                        ),
                        child: const Text(
                          'Start',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
