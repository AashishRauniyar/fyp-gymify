// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:gymify/models/workout_model.dart';
// import 'package:provider/provider.dart';
// import 'package:gymify/providers/workout_provider/workout_provider.dart';
// import 'package:gymify/colors/custom_colors.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch workouts
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<WorkoutProvider>().fetchAllWorkouts();
//     });
//   }

//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: CustomColors.backgroundColor,
//       appBar: AppBar(
//         scrolledUnderElevation: 0,
//         toolbarHeight: 60,
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
//             return const Center(child: CustomLoadingAnimation());
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

//           final workouts = workoutProvider.workouts;

//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Search Bar
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 10),
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
//                 // Workout Plans Section
//                 const Text(
//                   "Workout Plans",
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: CustomColors.black,
//                   ),
//                 ),
//                 // Display filtered workout plans horizontally
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: filteredWorkouts.map((workout) {
//                       return WorkoutCard(
//                         workout: workout,
//                         onTap: () {
//                           // Get the workoutId from the workout model
//                           context.pushNamed(
//                             'workoutDetail', // Named route
//                             queryParameters: {
//                               'workoutId': workout.workoutId.toString()
//                             }, // Pass workoutId as a query parameter
//                           );
//                         },
//                       );
//                     }).toList(),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 // Image List Section
//                 const Text(
//                   "All Workouts",
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: CustomColors.black,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 // ListView for workouts
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: workouts.length,
//                     itemBuilder: (context, index) {
//                       return Card(
//                         margin: const EdgeInsets.symmetric(vertical: 10),
//                         elevation: 1,
//                         child: ListTile(
//                           contentPadding: const EdgeInsets.all(8),
//                           leading: ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: Image.network(
//                               workouts[index].workoutImage,
//                               width: 70,
//                               height: 70,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           title: Text(
//                             workouts[index].workoutName,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18,
//                             ),
//                           ),
//                           subtitle: Text(
//                             '${workouts[index].fitnessLevel} • ${workouts[index].goalType}',
//                             style: const TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                                 color: CustomColors.secondary),
//                           ),
//                           trailing: const Icon(Icons.arrow_forward_ios),
//                           onTap: () {
//                             print('Tapped on ${workouts[index].workoutName}');

//                             final workoutId = workouts[index]
//                                 .workoutId; // Get the workoutId from the workout model
//                             context.pushNamed(
//                               'workoutDetail', // Named route
//                               queryParameters: {
//                                 'workoutId': workoutId.toString()
//                               }, // Pass workoutId as a query parameter
//                             );
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 // Footer Text
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class WorkoutCard extends StatelessWidget {
//   final Workout workout;
//   final VoidCallback onTap;

//   const WorkoutCard({
//     super.key,
//     required this.workout,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         elevation: 5,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(12),
//           child: Stack(
//             children: [
//               Image.network(
//                 workout.workoutImage.isNotEmpty
//                     ? workout.workoutImage
//                     : 'https://via.placeholder.com/150',
//                 fit: BoxFit.cover,
//                 height: 200,
//                 width: 340, // Control width
//               ),
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: Container(
//                   padding: const EdgeInsets.all(10),
//                   color: Colors.black.withOpacity(0.5),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Level of the workout (Beginner, Intermediate)
//                       Text(
//                         workout.fitnessLevel,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       // Workout Title
//                       Text(
//                         workout.workoutName,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       // Workout Description
//                       Text(
//                         workout.description,
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.white.withOpacity(0.8),
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       // Start Button
//                       ElevatedButton(
//                         onPressed: () {
//                           // Trigger the workout start action
//                           print('Start ${workout.workoutName}');
//                         },
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 12, horizontal: 20),
//                         ),
//                         child: const Text(
//                           'Start',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:gymify/models/workout_model.dart';
// import 'package:gymify/providers/auth_provider/auth_provider.dart';
// import 'package:gymify/providers/chat_provider/chat_service.dart';
// import 'package:gymify/providers/profile_provider/profile_provider.dart';
// import 'package:gymify/utils/custom_loader.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:gymify/providers/workout_provider/workout_provider.dart';
// // Import the theme

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // context.read<WorkoutProvider>().fetchAllWorkouts();
//       if (mounted) {
//         context.read<WorkoutProvider>().fetchAllWorkouts();
//         context.read<ProfileProvider>().fetchProfile();
//       }

//       final authProvider = context.read<AuthProvider>();
//       final chatProvider = context.read<ChatProvider>();
//       if (authProvider.isLoggedIn && authProvider.userId != null) {
//         if (!chatProvider.isInitialized) {
//           chatProvider.initializeSocket(authProvider.userId!);
//         }
//       }
//     });
//   }

//   // Method to format the current date
//   String getFormattedDate() {
//     final DateFormat dateFormat = DateFormat('MMMM dd, yyyy');
//     return dateFormat.format(DateTime.now());
//   }

//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         scrolledUnderElevation: 0,
//         toolbarHeight: 60,
//         title: Text(
//           'Gymify',
//           style: Theme.of(context).textTheme.headlineMedium,
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.settings,
//               color: Theme.of(context).iconTheme.color,
//             ),
//             onPressed: () {
//               // Navigate to Settings Screen
//               context.pushNamed('profile');

//             },
//           ),
//         ],
//       ),
//       body: Consumer<WorkoutProvider>(
//         builder: (context, workoutProvider, child) {
//           if (workoutProvider.isLoading) {
//             return const Center(child: CustomLoadingAnimation());
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

//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Search Bar
//                 if (user != null)
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 16.0),
//                     child: Text(
//                       'Welcome, ${user.firstName}!',
//                       style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                             fontWeight: FontWeight.bold,
//                           ),
//                     ),
//                   ),
//                 // Display Current Date
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 24.0),
//                   child: Text(
//                     'Today is $currentDate',
//                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                           color: Colors.grey,
//                         ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 10),
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
//                       fillColor: Theme.of(context).colorScheme.surface,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 // Workout Plans Section
//                 Text(
//                   "Workout Plans",
//                   style: Theme.of(context).textTheme.headlineMedium,
//                 ),
//                 const SizedBox(height: 10),
//                 // Horizontal List of Workouts
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: filteredWorkouts.map((workout) {
//                       return WorkoutCard(
//                         workout: workout,
//                         onTap: () {
//                           context.pushNamed(
//                             'workoutDetail',
//                             queryParameters: {
//                               'workoutId': workout.workoutId.toString(),
//                             },
//                           );
//                         },
//                       );
//                     }).toList(),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 // All Workouts Section
//                 Text(
//                   "All Workouts",
//                   style: Theme.of(context).textTheme.headlineMedium,
//                 ),
//                 const SizedBox(height: 10),
//                 // Vertical ListView of Workouts
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: workoutProvider.workouts.length,
//                     itemBuilder: (context, index) {
//                       final workout = workoutProvider.workouts[index];
//                       return Card(
//                         margin: const EdgeInsets.symmetric(vertical: 4),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: 0.5,
//                         child: ListTile(
//                           contentPadding: const EdgeInsets.all(8),
//                           leading: ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: Image.network(
//                               workout.workoutImage.isNotEmpty
//                                   ? workout.workoutImage
//                                   : 'https://via.placeholder.com/150',
//                               width: 70,
//                               height: 70,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           title: Text(
//                             workout.workoutName,
//                             style: Theme.of(context).textTheme.headlineSmall,
//                           ),
//                           subtitle: Text(
//                             '${workout.fitnessLevel} • ${workout.goalType}',
//                             style: Theme.of(context).textTheme.bodyMedium,
//                           ),
//                           trailing: const Icon(Icons.arrow_forward_ios),
//                           onTap: () {
//                             context.pushNamed(
//                               'workoutDetail',
//                               queryParameters: {
//                                 'workoutId': workout.workoutId.toString(),
//                               },
//                             );
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class WorkoutCard extends StatelessWidget {
//   final Workout workout;
//   final VoidCallback onTap;

//   const WorkoutCard({
//     super.key,
//     required this.workout,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         elevation: 5,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(12),
//           child: Stack(
//             children: [
//               Image.network(
//                 workout.workoutImage.isNotEmpty
//                     ? workout.workoutImage
//                     : 'https://via.placeholder.com/150',
//                 fit: BoxFit.cover,
//                 height: 200,
//                 width: 320,
//               ),
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: Container(
//                   padding: const EdgeInsets.all(10),
//                   color: Colors.black.withOpacity(0.6),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         workout.fitnessLevel,
//                         style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                               color: Colors.white,
//                             ),
//                       ),
//                       Text(
//                         workout.workoutName,
//                         style:
//                             Theme.of(context).textTheme.headlineSmall?.copyWith(
//                                   color: Colors.white,
//                                 ),
//                       ),
//                       const SizedBox(height: 8),
//                       ElevatedButton(
//                         onPressed: onTap,
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(
//                             vertical: 10,
//                             horizontal: 16,
//                           ),
//                         ),
//                         child: const Text('Start'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/models/workout_model.dart';
import 'package:gymify/providers/auth_provider/auth_provider.dart';
import 'package:gymify/providers/chat_provider/chat_service.dart';
import 'package:gymify/providers/membership_provider/membership_provider.dart';
import 'package:gymify/providers/profile_provider/profile_provider.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:gymify/providers/workout_provider/workout_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch workouts and profile information
      if (mounted) {
        context.read<WorkoutProvider>().fetchAllWorkouts();
        context.read<ProfileProvider>().fetchProfile();
        context.read<MembershipProvider>().fetchMembershipStatus(context);
      }

      final authProvider = context.read<AuthProvider>();
      final chatProvider = context.read<ChatProvider>();
      if (authProvider.isLoggedIn && authProvider.userId != null) {
        if (!chatProvider.isInitialized) {
          chatProvider.initializeSocket(authProvider.userId!);
        }
      }
    });
  }

  // Method to format the current date
  String getFormattedDate() {
    final DateFormat dateFormat = DateFormat('MMMM dd, yyyy');
    return dateFormat.format(DateTime.now());
  }

  // get current year, month and day as integer values
  final year = DateTime.now().year;
  final month = DateTime.now().month;
  final day = DateTime.now().day;

  final TextEditingController _searchController = TextEditingController();

  final String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Fetch user data from ProfileProvider
    final user = context.watch<ProfileProvider>().user;
    final currentDate = getFormattedDate();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        toolbarHeight: 60,
        title: Text(
          'Gymify',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              // Navigate to Settings Screen
              context.pushNamed('profile');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Make the body scrollable
        child: Consumer<WorkoutProvider>(
          builder: (context, workoutProvider, child) {
            if (workoutProvider.isLoading) {
              return const Center(child: CustomLoadingAnimation());
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

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Message with User's Name
                  if (user != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        'Welcome, ${user.userName ?? "User"}!',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                  // Display Current Date
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      'Today is $currentDate',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ),
                  // // Search Bar
                  Row(
                    children: [
                      // Card to display the user's profile, inside an Expanded widget to handle overflow
                      const SizedBox(
                          width:
                              8), // Add spacing between HeatMap and profile card
                      Expanded(
                        child: Card(
                          color: Theme.of(context).cardColor,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: user?.profileImage ?? '',
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          'assets/images/profile/default_avatar.jpg',
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                        placeholder: (context, url) =>
                                            const CustomLoadingAnimation(),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user?.userName ?? 'User Name',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                        ),
                                        const SizedBox(height: 4),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Membership: ${context.watch<MembershipProvider>().membershipStatus?['status'] ?? "Not Applied"} ',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                TextButton(
                                    onPressed: () {
                                      context.pushNamed('membershipPlans');
                                    },
                                    child: const Text('Manage')),

                                const SizedBox(height: 8),
                                // Height and Weight data
                                Text(
                                  'Height: ${user?.height ?? '0'} cm',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                ),
                                Text(
                                  'Weight: ${user?.currentWeight ?? '0'} kg',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 10),
                  //   child: TextField(
                  //     controller: _searchController,
                  //     onChanged: (value) {
                  //       setState(() {
                  //         _searchQuery = value.toLowerCase();
                  //       });
                  //     },
                  //     decoration: InputDecoration(
                  //       hintText: 'Search Workouts...',
                  //       prefixIcon: const Icon(Icons.search),
                  //       filled: true,
                  //       fillColor: Theme.of(context).colorScheme.surface,
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(12),
                  //         borderSide: BorderSide.none,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 16),
                  // Workout Plans Section
                  Text(
                    "Workouts",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  // Horizontal List of Workouts
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: filteredWorkouts.map((workout) {
                        return WorkoutCard(
                          workout: workout,
                          onTap: () {
                            context.pushNamed(
                              'workoutDetail',
                              queryParameters: {
                                'workoutId': workout.workoutId.toString(),
                              },
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // All Workouts Section
                  Text(
                    "All Workouts",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  // Vertical ListView of Workouts
                  ListView.builder(
                    shrinkWrap:
                        true, // Ensure the list doesn't take up all space
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable internal scrolling
                    itemCount: workoutProvider.workouts.length,
                    itemBuilder: (context, index) {
                      final workout = workoutProvider.workouts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0.5,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              workout.workoutImage.isNotEmpty
                                  ? workout.workoutImage
                                  : 'https://via.placeholder.com/150',
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            workout.workoutName,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          subtitle: Text(
                            '${workout.fitnessLevel} • ${workout.goalType}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            context.pushNamed(
                              'workoutDetail',
                              queryParameters: {
                                'workoutId': workout.workoutId.toString(),
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
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
                width: 320,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.black.withOpacity(0.6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workout.fitnessLevel,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                      Text(
                        workout.workoutName,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                        ),
                        child: const Text('Start'),
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
