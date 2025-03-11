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
import 'package:gymify/models/personal_best_model.dart';
import 'package:gymify/models/supported_exercise_model.dart';
import 'package:gymify/models/workout_model.dart';
import 'package:gymify/providers/auth_provider/auth_provider.dart';
import 'package:gymify/providers/chat_provider/chat_service.dart';
import 'package:gymify/providers/membership_provider/membership_provider.dart';
import 'package:gymify/providers/personal_best_provider/personal_best_provider.dart';
import 'package:gymify/providers/profile_provider/profile_provider.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:gymify/utils/workout_utils.dart/workout_list_item.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:gymify/providers/workout_provider/workout_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        context.read<PersonalBestProvider>().fetchSupportedExercises();
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
    final personalBestProvider = context.watch<PersonalBestProvider>();

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      //TODO: Uncomment here
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   scrolledUnderElevation: 0,
      //   toolbarHeight: 60,
      //   title: Text(
      //     // 'Gymify',
      //     currentDate,
      //     style: Theme.of(context).textTheme.titleMedium,
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: Icon(
      //         size: 18,
      //         FontAwesomeIcons.user,
      //         color: Theme.of(context).iconTheme.color,
      //       ),
      //       onPressed: () {
      //         // Navigate to Settings Screen
      //         //TODO: open bottom model sheet and show attendance and more
      //         context.pushNamed('profile');
      //       },
      //     ),
      //   ],
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
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
                  _buildHeader(
                      context,
                      user?.userName.toString() ?? "username",
                      user?.profileImage.toString() ??
                          "assets/images/profile/default_avatar.jpg"),
                  // Welcome Message with User's Name
                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 16.0),
                  //   child: Text(
                  //     'Welcome, ${user.userName ?? "User"}!',
                  //     style:
                  //         Theme.of(context).textTheme.headlineSmall?.copyWith(
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //   ),
                  // ),
                  // Display Current Date
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      'Today is $currentDate',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ),

                  _buildOfferBanner(context),
                  TextButton(
                      onPressed: () {
                        context.pushNamed('test');
                      },
                      child: const Text("Test Page")),
                  TextButton(
                      onPressed: () {
                        context.pushNamed('personalBest');
                      },
                      child: const Text("Personal Best Page")),

                  // _buildPBItem(context, exercise, data),
                  Text(
                    "Supported Exercises",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),

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
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable internal scrolling
                    itemCount: workoutProvider.workouts.length,
                    itemBuilder: (context, index) {
                      final workout = workoutProvider.workouts[index];
                      return WorkoutListItem(workout: workout);
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// have to give user name and profile image
Widget _buildHeader(
    BuildContext context, String username, String profileImage) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome Back',
              style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.6))),
          const SizedBox(height: 4),
          // make first letter capitalize
          Text(username[0].toUpperCase() + username.substring(1),
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
      ClipOval(
        child: CachedNetworkImage(
          imageUrl: profileImage,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => Image.asset(
            'assets/images/profile/default_avatar.jpg',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          placeholder: (context, url) => const CustomLoadingAnimation(),
        ),
      ),
    ],
  );
}

Widget _buildOfferBanner(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF4A3298), Color(0xFF2A1B4D)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Premium Membership',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  GestureDetector(
                    onTap: () {
                      _showBottomSheet(context);
                    },
                    child: const Icon(LineAwesomeIcons.info_circle_solid,
                        color: Colors.white, size: 24),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text('Get you gym membership\ntarting at Rs 1500',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF4A3298),
                ),
                onPressed: () => context.pushNamed('membershipPlans'),
                child: const Text('Apply Now 💪'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

void _showBottomSheet(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  showModalBottomSheet(
    builder: (context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.outline.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Choose Your Plan',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  )),
              const SizedBox(height: 16),
              Text('Get full access to GYMIFY facilities',
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 16,
                  )),
              const SizedBox(height: 32),

              // Using Consumer to access MembershipProvider and display plans dynamically
              Consumer<MembershipProvider>(
                builder: (context, membershipProvider, child) {
                  // Check if the plans are still loading
                  if (membershipProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Check if plans are empty
                  if (membershipProvider.plans.isEmpty) {
                    return const Center(child: Text('No plans available.'));
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: membershipProvider.plans.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final plan = membershipProvider.plans[index];

                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.primary.withOpacity(0.1),
                              colorScheme.surface,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: colorScheme.outline.withOpacity(0.1),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(plan['plan_type'] as String,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.primary,
                                    )),
                                Icon(Icons.fitness_center,
                                    color: colorScheme.primary),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(plan['price'] as String,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                )),

                            const SizedBox(height: 16),
                            Text("${plan['duration'].toString()} months",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                )),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.check_circle_outline,
                                    size: 16, color: colorScheme.primary),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(plan['description'] as String,
                                      style: TextStyle(
                                        color: colorScheme.onSurface
                                            .withOpacity(0.8),
                                      )),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Select Plan Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4A3298),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  // When the user selects a plan, navigate to membership screen
                                  context.pushNamed('membership', extra: plan);
                                },
                                child: const Text('Select Plan'),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      );
    },
    context: context,
    isScrollControlled: true,
    backgroundColor: colorScheme.surface,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
  );
}

// Widget _buildPBItem(BuildContext context ,String exercise, Map<String, dynamic> data) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Theme.of(context).colorScheme.primary.withOpacity(0.2),
//             Theme.of(context).colorScheme.primary.withOpacity(0.1),
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(exercise,
//               style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).colorScheme.onSurface)),
//           const SizedBox(height: 4),
//           Text('${data['weight']} kg',
//               style:
//                   const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           Text('${data['reps']} reps',
//               style: TextStyle(
//                   fontSize: 12,
//                   color: Theme.of(context)
//                       .colorScheme
//                       .onSurface
//                       .withOpacity(0.6))),
//         ],
//       ),
//     );
//   }
Widget _buildPBItem(
    BuildContext context, SupportedExercise exercise, PersonalBest data) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Theme.of(context).colorScheme.primary.withOpacity(0.2),
          Theme.of(context).colorScheme.primary.withOpacity(0.1),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(exercise.exerciseName,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 4),
        Text('${data.weight} kg',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text('${data.reps} reps',
            style: TextStyle(
                fontSize: 12,
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
      ],
    ),
  );
}

Widget _buildProgressCard(BuildContext context, String value, String label) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.6))),
        ],
      ),
    ),
  );
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
