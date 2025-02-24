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
//               return const Center(child: CustomLoadingAnimation());
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

// //! with search bar
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:gymify/colors/custom_colors.dart';
// import 'package:gymify/routes/route_config.dart';
// import 'package:gymify/screens/main_screens/workout_screens/workout_details_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:gymify/providers/workout_provider/workout_provider.dart';

// class WorkoutListScreen extends StatefulWidget {
//   const WorkoutListScreen({super.key});

//   @override
//   _WorkoutListScreenState createState() => _WorkoutListScreenState();
// }

// class _WorkoutListScreenState extends State<WorkoutListScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: CustomColors.backgroundColor,
//       appBar: AppBar(
//         title: const Text(
//           'Workouts',
//           style: TextStyle(
//             color: CustomColors.primary,
//           ),
//         ),
//         backgroundColor: CustomColors.backgroundColor,
//       ),
//       body: ChangeNotifierProvider(
//         create: (_) => WorkoutProvider()..fetchAllWorkouts(),
//         child: Consumer<WorkoutProvider>(
//           builder: (context, workoutProvider, child) {
//             if (workoutProvider.isLoading) {
//               return const Center(child: CustomLoadingAnimation());
//             }

//             if (workoutProvider.workouts.isEmpty) {
//               return const Center(child: Text('No workouts found.'));
//             }

//             // Filter workouts based on the search query
//             final filteredWorkouts = workoutProvider.workouts.where((workout) {
//               final workoutName = workout.workoutName.toLowerCase();
//               final targetMuscleGroup = workout.targetMuscleGroup.toLowerCase();
//               return workoutName.contains(_searchQuery) ||
//                   targetMuscleGroup.contains(_searchQuery);
//             }).toList();

//             return Column(
//               children: [
//                 // Search Bar
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                   child: TextField(
//                     controller: _searchController,
//                     onChanged: (value) {
//                       setState(() {
//                         _searchQuery = value.toLowerCase();
//                       });
//                     },
//                     decoration: InputDecoration(
//                       hintText: 'Search Workouts...',
//                       prefixIcon: const Icon(Icons.search),
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide.none,
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(vertical: 10),
//                     ),
//                   ),
//                 ),

//                 // Workout List
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: filteredWorkouts.length,
//                     itemBuilder: (context, index) {
//                       final workout = filteredWorkouts[index];
//                       return Card(
//                         margin: const EdgeInsets.symmetric(
//                             vertical: 10, horizontal: 15),
//                         elevation: 5,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: InkWell(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => WorkoutDetailScreen(
//                                     workoutId: workout.workoutId),
//                               ),
//                             );
//                           },
//                           child: Container(
//                             decoration: BoxDecoration(
//                               image: DecorationImage(
//                                 image: workout.workoutImage.isNotEmpty
//                                     ? NetworkImage(workout.workoutImage)
//                                     : const AssetImage(
//                                             'assets/images/workout_image/defaultWorkoutImage.jpg')
//                                         as ImageProvider,
//                                 fit: BoxFit.cover,
//                                 colorFilter: ColorFilter.mode(
//                                   Colors.black.withOpacity(0.5),
//                                   BlendMode.darken,
//                                 ),
//                               ),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: ListTile(
//                               contentPadding: const EdgeInsets.all(16),
//                               title: Text(
//                                 workout.workoutName,
//                                 style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 22,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               subtitle: Text(
//                                 workout.targetMuscleGroup,
//                                 style: const TextStyle(
//                                     color: Colors.white, fontSize: 16),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),

//                 SizedBox(
//                   child: Divider(
//                     color: Colors.black,
//                     thickness: 2,
//                     indent: 10,
//                     endIndent: 10,
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     context.pushNamed('customWorkout');
//                   },
//                   child: Text('Create Your own workout plan'),
//                 )
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

//! v2
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:gymify/colors/custom_colors.dart';
// import 'package:gymify/providers/custom_workout_provider/custom_workout_provider.dart';
// import 'package:gymify/providers/workout_provider/workout_provider.dart';
// import 'package:gymify/screens/main_screens/workout_screens/workout_details_screen.dart';
// import 'package:provider/provider.dart';

// class WorkoutListScreen extends StatefulWidget {
//   const WorkoutListScreen({super.key});

//   @override
//   _WorkoutListScreenState createState() => _WorkoutListScreenState();
// }

// class _WorkoutListScreenState extends State<WorkoutListScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Workouts',
//           style: TextStyle(
//             color: CustomColors.primary,
//           ),
//         ),
//         backgroundColor: CustomColors.backgroundColor,
//       ),
//       body: MultiProvider(
//         providers: [
//           ChangeNotifierProvider(
//               create: (_) => WorkoutProvider()..fetchAllWorkouts()),
//           ChangeNotifierProvider(
//               create: (_) => CustomWorkoutProvider()..fetchCustomWorkouts()),
//         ],
//         child: Consumer2<WorkoutProvider, CustomWorkoutProvider>(
//           builder: (context, workoutProvider, customWorkoutProvider, child) {
//             if (workoutProvider.isLoading || customWorkoutProvider.isLoading) {
//               return const Center(child: CustomLoadingAnimation());
//             }

//             if (workoutProvider.workouts.isEmpty &&
//                 customWorkoutProvider.customWorkouts.isEmpty) {
//               return const Center(child: Text('No workouts found.'));
//             }

//             // Filter default workouts based on the search query
//             final filteredDefaultWorkouts =
//                 workoutProvider.workouts.where((workout) {
//               final workoutName = workout.workoutName.toLowerCase();
//               final targetMuscleGroup = workout.targetMuscleGroup.toLowerCase();
//               return workoutName.contains(_searchQuery) ||
//                   targetMuscleGroup.contains(_searchQuery);
//             }).toList();

//             // Filter custom workouts based on the search query
//             final filteredCustomWorkouts =
//                 customWorkoutProvider.customWorkouts.where((workout) {
//               return workout.customWorkoutName
//                   .toLowerCase()
//                   .contains(_searchQuery);
//             }).toList();

//             return Column(
//               children: [
//                 // Search Bar
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                   child: TextField(
//                     controller: _searchController,
//                     onChanged: (value) {
//                       setState(() {
//                         _searchQuery = value.toLowerCase();
//                       });
//                     },
//                     decoration: InputDecoration(
//                       hintText: 'Search Workouts...',
//                       prefixIcon: const Icon(Icons.search),
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide.none,
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(vertical: 10),
//                     ),
//                   ),
//                 ),

//                 // Default Workouts Section
//                 if (filteredDefaultWorkouts.isNotEmpty)
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Padding(
//                           padding: EdgeInsets.all(16.0),
//                           child: Text(
//                             'Default Workouts',
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Expanded(
//                           child: ListView.builder(
//                             itemCount: filteredDefaultWorkouts.length,
//                             itemBuilder: (context, index) {
//                               final workout = filteredDefaultWorkouts[index];
//                               return Card(
//                                 margin: const EdgeInsets.symmetric(
//                                     vertical: 10, horizontal: 15),
//                                 elevation: 5,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: InkWell(
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             WorkoutDetailScreen(
//                                                 workoutId: workout.workoutId),
//                                       ),
//                                     );
//                                   },
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       image: DecorationImage(
//                                         image: workout.workoutImage.isNotEmpty
//                                             ? NetworkImage(workout.workoutImage)
//                                             : const AssetImage(
//                                                     'assets/images/workout_image/defaultWorkoutImage.jpg')
//                                                 as ImageProvider,
//                                         fit: BoxFit.cover,
//                                         colorFilter: ColorFilter.mode(
//                                           Colors.black.withOpacity(0.5),
//                                           BlendMode.darken,
//                                         ),
//                                       ),
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     child: ListTile(
//                                       contentPadding: const EdgeInsets.all(16),
//                                       title: Text(
//                                         workout.workoutName,
//                                         style: const TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 22,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       subtitle: Text(
//                                         workout.targetMuscleGroup,
//                                         style: const TextStyle(
//                                             color: Colors.white, fontSize: 16),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                 // Custom Workouts Section
//                 if (filteredCustomWorkouts.isNotEmpty)
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Padding(
//                           padding: EdgeInsets.all(16.0),
//                           child: Text(
//                             'Custom Workouts',
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Expanded(
//                           child: ListView.builder(
//                             itemCount: filteredCustomWorkouts.length,
//                             itemBuilder: (context, index) {
//                               final customWorkout =
//                                   filteredCustomWorkouts[index];
//                               return Card(
//                                 margin: const EdgeInsets.symmetric(
//                                     vertical: 10, horizontal: 15),
//                                 elevation: 5,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: InkWell(
//                                   onTap: () {
//                                     context.pushNamed(
//                                       'customWorkoutDetail',
//                                       queryParameters: {
//                                         'id': customWorkout.customWorkoutId
//                                             .toString()
//                                       },
//                                     );
//                                   },
//                                   child: ListTile(
//                                     title: Text(
//                                       customWorkout.customWorkoutName,
//                                       style: const TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     subtitle: Text(
//                                       'Created on: ${customWorkout.createdAt.toLocal()}',
//                                       style: const TextStyle(fontSize: 14),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                 // Button to create custom workout
//                 TextButton(
//                   onPressed: () {
//                     context.pushNamed('createCustomWorkout');
//                   },
//                   child: const Text('Create Your Own Workout Plan'),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

//! v3 try
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:gymify/colors/custom_colors.dart';
// import 'package:gymify/providers/custom_workout_provider/custom_workout_provider.dart';
// import 'package:gymify/providers/workout_provider/workout_provider.dart';
// import 'package:gymify/screens/main_screens/workout_screens/workout_details_screen.dart';
// import 'package:provider/provider.dart';

// class WorkoutListScreen extends StatefulWidget {
//   const WorkoutListScreen({super.key});

//   @override
//   _WorkoutListScreenState createState() => _WorkoutListScreenState();
// }

// class _WorkoutListScreenState extends State<WorkoutListScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: CustomColors.backgroundColor,
//       appBar: AppBar(
//         actions: [
//           // Text('Create Custom Workout plan'),
//           IconButton(
//             icon: const Icon(Icons.add, color: CustomColors.primary),
//             onPressed: () {
//               context.pushNamed('createCustomWorkout');
//             },
//           ),
//         ],
//         title: const Text(
//           'Workouts',
//           style: TextStyle(
//             color: CustomColors.primary,
//           ),
//         ),
//         backgroundColor: CustomColors.backgroundColor,
//       ),
//       body: MultiProvider(
//         providers: [
//           ChangeNotifierProvider(
//               create: (_) => WorkoutProvider()..fetchAllWorkouts()),
//           ChangeNotifierProvider(
//               create: (_) => CustomWorkoutProvider()..fetchCustomWorkouts()),
//         ],
//         child: Consumer2<WorkoutProvider, CustomWorkoutProvider>(
//           builder: (context, workoutProvider, customWorkoutProvider, child) {
//             if (workoutProvider.isLoading || customWorkoutProvider.isLoading) {
//               return const Center(child: CustomLoadingAnimation());
//             }

//             if (workoutProvider.workouts.isEmpty &&
//                 customWorkoutProvider.customWorkouts.isEmpty) {
//               return const Center(child: Text('No workouts found.'));
//             }

//             // Filter default workouts based on the search query
//             final filteredDefaultWorkouts =
//                 workoutProvider.workouts.where((workout) {
//               final workoutName = workout.workoutName.toLowerCase();
//               final targetMuscleGroup = workout.targetMuscleGroup.toLowerCase();
//               return workoutName.contains(_searchQuery) ||
//                   targetMuscleGroup.contains(_searchQuery);
//             }).toList();

//             // Filter custom workouts based on the search query
//             final filteredCustomWorkouts =
//                 customWorkoutProvider.customWorkouts.where((workout) {
//               return workout.customWorkoutName
//                   .toLowerCase()
//                   .contains(_searchQuery);
//             }).toList();

//             return SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Search Bar
//                     Padding(
//                       padding: const EdgeInsets.only(top: 16, bottom: 10),
//                       child: TextField(
//                         controller: _searchController,
//                         onChanged: (value) {
//                           setState(() {
//                             _searchQuery = value.toLowerCase();
//                           });
//                         },
//                         decoration: InputDecoration(
//                           hintText: 'Search Workouts...',
//                           prefixIcon: const Icon(Icons.search),
//                           filled: true,
//                           fillColor: Colors.grey[200],
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide.none,
//                           ),
//                           contentPadding:
//                               const EdgeInsets.symmetric(vertical: 10),
//                         ),
//                       ),
//                     ),

//                     // Default Workouts Section
//                     if (filteredDefaultWorkouts.isNotEmpty)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text(
//                                 'Default Workouts',
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                               TextButton(
//                                 onPressed: () {
//                                   context.pushNamed(
//                                       'allWorkouts'); // Navigate to all workouts
//                                 },
//                                 child: const Text('See All'),
//                               ),
//                             ],
//                           ),
//                           LimitedBox(
//                             maxHeight: 200,
//                             child: ListView.builder(
//                               shrinkWrap: true,
//                               scrollDirection: Axis.horizontal,
//                               itemCount:
//                                   filteredDefaultWorkouts.length.clamp(0, 5),
//                               itemBuilder: (context, index) {
//                                 final workout = filteredDefaultWorkouts[index];
//                                 return SizedBox(
//                                   width: 150,
//                                   child: Card(
//                                     margin: const EdgeInsets.symmetric(
//                                         vertical: 10, horizontal: 8),
//                                     elevation: 5,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     child: InkWell(
//                                       onTap: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 WorkoutDetailScreen(
//                                                     workoutId:
//                                                         workout.workoutId),
//                                           ),
//                                         );
//                                       },
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           image: DecorationImage(
//                                             image: workout
//                                                     .workoutImage.isNotEmpty
//                                                 ? NetworkImage(
//                                                     workout.workoutImage)
//                                                 : const AssetImage(
//                                                         'assets/images/workout_image/defaultWorkoutImage.jpg')
//                                                     as ImageProvider,
//                                             fit: BoxFit.cover,
//                                             colorFilter: ColorFilter.mode(
//                                               Colors.black.withOpacity(0.5),
//                                               BlendMode.darken,
//                                             ),
//                                           ),
//                                           borderRadius:
//                                               BorderRadius.circular(12),
//                                         ),
//                                         alignment: Alignment.bottomCenter,
//                                         padding: const EdgeInsets.all(8),
//                                         child: Text(
//                                           workout.workoutName,
//                                           style: const TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     if (filteredCustomWorkouts.isNotEmpty)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text(
//                                 'Your Custom Workouts',
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                               TextButton(
//                                 onPressed: () {
//                                   context.pushNamed(
//                                       'customWorkout'); // Navigate to all custom workouts
//                                 },
//                                 child: const Text('See All'),
//                               ),
//                             ],
//                           ),
//                           ListView.builder(
//                             shrinkWrap: true, // Prevents infinite height issues
//                             physics:
//                                 const NeverScrollableScrollPhysics(), // Disables inner scrolling
//                             itemCount:
//                                 filteredCustomWorkouts.length.clamp(0, 5),
//                             itemBuilder: (context, index) {
//                               final customWorkout =
//                                   filteredCustomWorkouts[index];
//                               return Card(

//                                 margin: const EdgeInsets.symmetric(
//                                     vertical: 6, horizontal: 8),
//                                 elevation: 0,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: ListTile(
//                                   onTap: () {
//                                     context.pushNamed(
//                                       'customWorkoutDetail',
//                                       queryParameters: {
//                                         'id': customWorkout.customWorkoutId
//                                             .toString(),
//                                       },
//                                     );
//                                   },
//                                   title: Text(
//                                     customWorkout.customWorkoutName,
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   trailing: const Icon(Icons.arrow_forward_ios),
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       ),

//                     // Create Custom Workout Button
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:provider/provider.dart';
import 'package:gymify/providers/custom_workout_provider/custom_workout_provider.dart';
import 'package:gymify/providers/workout_provider/workout_provider.dart';
import 'package:gymify/screens/main_screens/workout_screens/workout_details_screen.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: theme.colorScheme.primary),
            onPressed: () {
              context.pushNamed('createCustomWorkout');
            },
          ),
        ],
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        toolbarHeight: 60,
        title: Text(
          'Workouts',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => WorkoutProvider()..fetchAllWorkouts()),
          ChangeNotifierProvider(
              create: (_) => CustomWorkoutProvider()..fetchCustomWorkouts()),
        ],
        child: Consumer2<WorkoutProvider, CustomWorkoutProvider>(
          builder: (context, workoutProvider, customWorkoutProvider, child) {
            if (workoutProvider.isLoading || customWorkoutProvider.isLoading) {
              return const Center(child: CustomLoadingAnimation());
            }

            if (workoutProvider.workouts.isEmpty &&
                customWorkoutProvider.customWorkouts.isEmpty) {
              return const Center(child: Text('No workouts found.'));
            }

            final filteredDefaultWorkouts =
                workoutProvider.workouts.where((workout) {
              final workoutName = workout.workoutName.toLowerCase();
              final targetMuscleGroup = workout.targetMuscleGroup.toLowerCase();
              return workoutName.contains(_searchQuery) ||
                  targetMuscleGroup.contains(_searchQuery);
            }).toList();

            final filteredCustomWorkouts =
                customWorkoutProvider.customWorkouts.where((workout) {
              return workout.customWorkoutName
                  .toLowerCase()
                  .contains(_searchQuery);
            }).toList();

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 10),
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
                          fillColor: theme.colorScheme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    if (filteredDefaultWorkouts.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Our Workouts',
                                style: theme.textTheme.headlineSmall,
                              ),
                              TextButton(
                                onPressed: () {
                                  context.pushNamed('allWorkouts');
                                },
                                child: Text('See All',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.primary,
                                    )),
                              ),
                            ],
                          ),
                          LimitedBox(
                            maxHeight: 200,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  filteredDefaultWorkouts.length.clamp(0, 5),
                              itemBuilder: (context, index) {
                                final workout = filteredDefaultWorkouts[index];
                                return SizedBox(
                                  width: 150,
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 8),
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                WorkoutDetailScreen(
                                                    workoutId:
                                                        workout.workoutId),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: workout
                                                    .workoutImage.isNotEmpty
                                                ? NetworkImage(
                                                    workout.workoutImage)
                                                : const AssetImage(
                                                        'assets/images/workout_image/defaultWorkoutImage.jpg')
                                                    as ImageProvider,
                                            fit: BoxFit.cover,
                                            colorFilter: ColorFilter.mode(
                                              Colors.black.withOpacity(0.5),
                                              BlendMode.darken,
                                            ),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        alignment: Alignment.bottomCenter,
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          workout.workoutName,
                                          style: theme.textTheme.bodyLarge
                                              ?.copyWith(
                                            color: theme.colorScheme.onPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Explore Exercises',
                          style: theme.textTheme.headlineSmall,
                        ),
                        // TextButton(
                        //   onPressed: () {
                        //     context.pushNamed('exercises');
                        //   },
                        //   child: Text(
                        //     'See Exercises',
                        //     style: theme.textTheme.bodyMedium?.copyWith(
                        //       color: theme.colorScheme.primary,
                        //     ),
                        //   ),
                        // ),
                        GestureDetector(
                          onTap: () {
                            context.pushNamed('exercises');
                          },
                          child: Card(
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: const DecorationImage(
                                  image:
                                      AssetImage('assets/images/exercise.jpeg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'View All Exercises',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Workout Plans',
                          style: theme.textTheme.headlineSmall,
                        ),
                        // TextButton(
                        //   onPressed: () {
                        //     context.pushNamed('workoutPlans');
                        //   },
                        //   child: Text(
                        //     'See All',
                        //     style: TextStyle(
                        //       color: theme.colorScheme.primary,
                        //     ),
                        //   ),
                        // ),
                        GestureDetector(
                          onTap: () {
                            context.pushNamed('customWorkout');
                          },
                          child: Card(
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.black.withOpacity(0.7),
                                image: const DecorationImage(
                                  image: AssetImage(
                                      'assets/images/bannercustomworkout.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Create Your own Workout Plans💪',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    // if (filteredCustomWorkouts.isNotEmpty)
                    // Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    // children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(
                    //       'Your Custom Workouts',
                    //       style: theme.textTheme.headlineSmall,
                    //     ),
                    //     // TextButton(
                    //     //   onPressed: () {
                    //     //     context.pushNamed('customWorkout');
                    //     //   },
                    //     //   child: Text('See All',
                    //     //       style: theme.textTheme.bodyMedium?.copyWith(
                    //     //         color: theme.colorScheme.primary,
                    //     //       )),
                    //     // ),
                    //   ],
                    // ),
                    // ListView.builder(
                    //   shrinkWrap: true,
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   itemCount:
                    //       filteredCustomWorkouts.length.clamp(0, 5),
                    //   itemBuilder: (context, index) {
                    //     final customWorkout =
                    //         filteredCustomWorkouts[index];
                    //     return Card(
                    //       margin: const EdgeInsets.symmetric(
                    //           vertical: 6, horizontal: 8),
                    //       elevation: 0,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(8),
                    //       ),
                    //       child: ListTile(
                    //         onTap: () {
                    //           context.pushNamed(
                    //             'customWorkoutDetail',
                    //             queryParameters: {
                    //               'id': customWorkout.customWorkoutId
                    //                   .toString(),
                    //             },
                    //           );
                    //         },
                    //         title: Text(
                    //           customWorkout.customWorkoutName,
                    //           style: theme.textTheme.bodyLarge?.copyWith(
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //         ),
                    //         trailing: const Icon(Icons.arrow_forward_ios),
                    //       ),
                    //     );
                    //   },
                    // ),
                    // ],
                    // ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
