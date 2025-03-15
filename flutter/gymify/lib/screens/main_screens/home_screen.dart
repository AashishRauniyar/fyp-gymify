// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:gymify/models/personal_best_model.dart';
// import 'package:gymify/models/supported_exercise_model.dart';
// import 'package:gymify/models/workout_model.dart';
// import 'package:gymify/providers/auth_provider/auth_provider.dart';
// import 'package:gymify/providers/chat_provider/chat_service.dart';
// import 'package:gymify/providers/log_provider/log_provider.dart';
// import 'package:gymify/providers/membership_provider/membership_provider.dart';
// import 'package:gymify/providers/personal_best_provider/personal_best_provider.dart';
// import 'package:gymify/providers/profile_provider/profile_provider.dart';
// import 'package:gymify/utils/custom_loader.dart';
// import 'package:gymify/utils/workout_utils.dart/workout_list_item.dart';
// import 'package:intl/intl.dart';
// import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:gymify/providers/workout_provider/workout_provider.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // Fetch workouts and profile information
//       if (mounted) {
//         context.read<WorkoutProvider>().fetchAllWorkouts();
//         context.read<ProfileProvider>().fetchProfile();
//         context.read<MembershipProvider>().fetchMembershipStatus(context);
//         context.read<PersonalBestProvider>().fetchSupportedExercises();
//         context.read<PersonalBestProvider>().fetchCurrentPersonalBests();
//         context.read<MembershipProvider>().fetchMembershipPlans();
//         final authProvider = context.read<AuthProvider>();
//         final chatProvider = context.read<ChatProvider>();
//         if (authProvider.isLoggedIn && authProvider.userId != null) {
//           if (!chatProvider.isInitialized) {
//             chatProvider.initializeSocket(authProvider.userId!);
//           }
//         }
//         // After fetching profile data, fetch the user logs:
//         final profile = context.read<ProfileProvider>().user;
//         if (profile != null && profile.userId != null) {
//           context
//               .read<WorkoutLogProvider>()
//               .fetchUserLogs(profile.userId.toString());
//         }
//       }
//     });
//   }

//   // Method to format the current date
//   String getFormattedDate() {
//     final DateFormat dateFormat = DateFormat('MMMM dd, yyyy');
//     return dateFormat.format(DateTime.now());
//   }

//   // get current year, month and day as integer values
//   final year = DateTime.now().year;
//   final month = DateTime.now().month;
//   final day = DateTime.now().day;

//   final TextEditingController _searchController = TextEditingController();

//   final String _searchQuery = '';

//   @override
//   Widget build(BuildContext context) {
//     // Fetch user data from ProfileProvider
//     final user = context.watch<ProfileProvider>().user;
//     final currentDate = getFormattedDate();
//     final personalBestProvider = context.watch<PersonalBestProvider>();

//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

//     // If the user hasn't been loaded yet, show a loading indicator.
//     if (user == null) {
//       return const Scaffold(
//         body: Center(child: CustomLoadingAnimation()),
//       );
//     }

//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       //TODO: Uncomment here
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         scrolledUnderElevation: 0,
//         toolbarHeight: 60,
//         title: Text(
//           // 'Gymify',
//           currentDate,
//           style: Theme.of(context).textTheme.titleMedium,
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(
//               size: 18,
//               FontAwesomeIcons.user,
//               color: Theme.of(context).iconTheme.color,
//             ),
//             onPressed: () {
//               // Navigate to Settings Screen
//               //TODO: open bottom model sheet and show attendance and more
//               context.pushNamed('profile');
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
//         // Make the body scrollable
//         child: Consumer<WorkoutProvider>(
//           builder: (context, workoutProvider, child) {
//             if (workoutProvider.isLoading) {
//               return const Center(child: CustomLoadingAnimation());
//             }

//             if (workoutProvider.hasError) {
//               return const Center(child: Text('Error fetching workouts.'));
//             }

//             final filteredWorkouts = workoutProvider.workouts.where((workout) {
//               final workoutName = workout.workoutName.toLowerCase();
//               final targetMuscleGroup = workout.targetMuscleGroup.toLowerCase();
//               return workoutName.contains(_searchQuery) ||
//                   targetMuscleGroup.contains(_searchQuery);
//             }).toList();

//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildHeader(
//                       context,
//                       user.userName.toString() ?? "username",
//                       user.profileImage.toString() ??
//                           "assets/images/profile/default_avatar.jpg"),

//                   // Display Current Date
//                   const SizedBox(
//                     height: 16,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 24.0),
//                     child: Text(
//                       'Today is $currentDate',
//                       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                             color: Colors.grey,
//                           ),
//                     ),
//                   ),

//                   _buildOfferBanner(context),
//                   TextButton(
//                       onPressed: () {
//                         context.pushNamed('test');
//                       },
//                       child: const Text("Test Page")),
//                   TextButton(
//                       onPressed: () {
//                         context.pushNamed('personalBest');
//                       },
//                       child: const Text("Personal Best Page")),
//                   TextButton(
//                       onPressed: () {
//                         context.pushNamed('weightLog');
//                       },
//                       child: const Text("Weight History")),
//                   Text(
//                     "Workout Log History",
//                     style: Theme.of(context).textTheme.headlineMedium,
//                   ),
//                   const SizedBox(height: 10),
//                   Consumer<WorkoutLogProvider>(
//                     builder: (context, workoutLogProvider, child) {
//                       if (workoutLogProvider.isLoading) {
//                         return const Center(child: CircularProgressIndicator());
//                       }
//                       if (workoutLogProvider.hasError) {
//                         return const Center(
//                             child: Text('Error fetching workout logs.'));
//                       }
//                       if (workoutLogProvider.userLogs.isEmpty) {
//                         return const Center(
//                             child: Text('No workout logs available.'));
//                       }
//                       return ListView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: workoutLogProvider.userLogs.length,
//                         itemBuilder: (context, index) {
//                           final log = workoutLogProvider.userLogs[index];
//                           return Card(
//                             margin: const EdgeInsets.symmetric(vertical: 6),
//                             child: ListTile(
//                               leading: const Icon(Icons.history),
//                               title: Text("Workout ID: ${log['workout_id']}"),
//                               subtitle: Text(
//                                 "Total Duration: ${log['total_duration']} min\nCalories Burned: ${log['calories_burned'] ?? 'N/A'}",
//                               ),
//                               isThreeLine: true,
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 20),

//                   // _buildPBItem(context, exercise, data),
//                   _buildWeightSection(context, user.currentWeight.toString()),

//                   const SizedBox(height: 16),
//                   Text(
//                     "Personal Bests",
//                     style: Theme.of(context).textTheme.headlineMedium,
//                   ),
//                   const SizedBox(height: 10),
//                   _buildPersonalBestsGrid(context),

//                   Text(
//                     "Supported Exercises",
//                     style: Theme.of(context).textTheme.headlineMedium,
//                   ),
//                   const SizedBox(height: 10),

//                   Row(
//                     children: [
//                       // Card to display the user's profile, inside an Expanded widget to handle overflow
//                       const SizedBox(
//                           width:
//                               8), // Add spacing between HeatMap and profile card
//                       Expanded(
//                         child: Card(
//                           color: Theme.of(context).cardColor,
//                           elevation: 2,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     ClipOval(
//                                       child: CachedNetworkImage(
//                                         imageUrl: user.profileImage ?? '',
//                                         width: 50,
//                                         height: 50,
//                                         fit: BoxFit.cover,
//                                         errorWidget: (context, url, error) =>
//                                             Image.asset(
//                                           'assets/images/profile/default_avatar.jpg',
//                                           width: 50,
//                                           height: 50,
//                                           fit: BoxFit.cover,
//                                         ),
//                                         placeholder: (context, url) =>
//                                             const CustomLoadingAnimation(),
//                                       ),
//                                     ),
//                                     const SizedBox(width: 8),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           user.userName ?? 'User Name',
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .headlineMedium,
//                                         ),
//                                         const SizedBox(height: 4),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 16),
//                                 Text(
//                                   'Membership: ${context.watch<MembershipProvider>().membershipStatus?['status'] ?? "Not Applied"} ',
//                                   style:
//                                       Theme.of(context).textTheme.headlineSmall,
//                                 ),
//                                 TextButton(
//                                     onPressed: () {
//                                       context.pushNamed('membershipPlans');
//                                     },
//                                     child: const Text('Manage')),

//                                 const SizedBox(height: 8),
//                                 // Height and Weight data
//                                 Text(
//                                   'Height: ${user.height ?? '0'} cm',
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .bodyMedium
//                                       ?.copyWith(
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onSurface,
//                                       ),
//                                 ),
//                                 Text(
//                                   'Weight: ${user.currentWeight ?? '0'} kg',
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .bodyMedium
//                                       ?.copyWith(
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onSurface,
//                                       ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 16),
//                   // Workout Plans Section
//                   Text(
//                     "Workouts",
//                     style: Theme.of(context).textTheme.headlineMedium,
//                   ),
//                   const SizedBox(height: 10),
//                   // Horizontal List of Workouts
//                   SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children: filteredWorkouts.map((workout) {
//                         return WorkoutCard(
//                           workout: workout,
//                           onTap: () {
//                             context.pushNamed(
//                               'workoutDetail',
//                               queryParameters: {
//                                 'workoutId': workout.workoutId.toString(),
//                               },
//                             );
//                           },
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   // All Workouts Section
//                   Text(
//                     "All Workouts",
//                     style: Theme.of(context).textTheme.headlineMedium,
//                   ),

//                   // Vertical ListView of Workouts
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics:
//                         const NeverScrollableScrollPhysics(), // Disable internal scrolling
//                     itemCount: workoutProvider.workouts.length,
//                     itemBuilder: (context, index) {
//                       final workout = workoutProvider.workouts[index];
//                       return WorkoutListItem(workout: workout);
//                     },
//                   )
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// // have to give user name and profile image
// Widget _buildHeader(
//     BuildContext context, String username, String profileImage) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Welcome Back',
//               style: TextStyle(
//                   color: Theme.of(context)
//                       .colorScheme
//                       .onSurface
//                       .withOpacity(0.6))),
//           const SizedBox(height: 4),
//           // make first letter capitalize
//           Text(username[0].toUpperCase() + username.substring(1),
//               style:
//                   const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//         ],
//       ),
//       Container(
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.surface,
//           borderRadius: BorderRadius.circular(50),
//           border: Border.all(
//             color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
//             width: 1.5,
//           ),
//         ),
//         child: ClipOval(
//           child: CachedNetworkImage(
//             imageUrl: profileImage,
//             width: 60,
//             height: 60,
//             fit: BoxFit.cover,
//             errorWidget: (context, url, error) => Image.asset(
//               'assets/images/profile/default_avatar.jpg',
//               width: 50,
//               height: 50,
//               fit: BoxFit.cover,
//             ),
//             placeholder: (context, url) => const CustomLoadingAnimation(),
//           ),
//         ),
//       ),
//     ],
//   );
// }

// Widget _buildOfferBanner(BuildContext context) {
//   return Container(
//     padding: const EdgeInsets.all(20),
//     decoration: BoxDecoration(
//       gradient: const LinearGradient(
//         colors: [Color(0xFF4A3298), Color(0xFF2A1B4D)],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       ),
//       borderRadius: BorderRadius.circular(16),
//     ),
//     child: Row(
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text('Premium Membership',
//                       style: TextStyle(color: Colors.white, fontSize: 18)),
//                   GestureDetector(
//                     onTap: () {
//                       _showBottomSheet(context);
//                     },
//                     child: const Icon(LineAwesomeIcons.info_circle_solid,
//                         color: Colors.white, size: 24),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               const Text('Get you gym membership\ntarting at Rs 1500',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold)),
//               const SizedBox(height: 12),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.white,
//                   foregroundColor: const Color(0xFF4A3298),
//                 ),
//                 onPressed: () => context.pushNamed('membershipPlans'),
//                 child: const Text('Apply Now 💪'),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

// void _showBottomSheet(BuildContext context) {
//   final colorScheme = Theme.of(context).colorScheme;

//   showModalBottomSheet(
//     builder: (context) {
//       return SizedBox(
//         height: MediaQuery.of(context).size.height * 0.7,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Container(
//                   width: 48,
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: colorScheme.outline.withOpacity(0.4),
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               Text('Choose Your Plan',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: colorScheme.onSurface,
//                   )),
//               const SizedBox(height: 16),
//               Text('Get full access to GYMIFY facilities',
//                   style: TextStyle(
//                     color: colorScheme.onSurface.withOpacity(0.6),
//                     fontSize: 16,
//                   )),
//               const SizedBox(height: 32),

//               // Using Consumer to access MembershipProvider and display plans dynamically
//               Consumer<MembershipProvider>(
//                 builder: (context, membershipProvider, child) {
//                   // Check if the plans are still loading
//                   if (membershipProvider.isLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   // Check if plans are empty
//                   if (membershipProvider.plans.isEmpty) {
//                     return const Center(child: Text('No plans available.'));
//                   }

//                   return ListView.separated(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: membershipProvider.plans.length,
//                     separatorBuilder: (context, index) =>
//                         const SizedBox(height: 16),
//                     itemBuilder: (context, index) {
//                       final plan = membershipProvider.plans[index];

//                       return Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(16),
//                           gradient: LinearGradient(
//                             colors: [
//                               colorScheme.primary.withOpacity(0.1),
//                               colorScheme.surface,
//                             ],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                           border: Border.all(
//                             color: colorScheme.outline.withOpacity(0.1),
//                           ),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(plan['plan_type'] as String,
//                                     style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                       color: colorScheme.primary,
//                                     )),
//                                 Icon(Icons.fitness_center,
//                                     color: colorScheme.primary),
//                               ],
//                             ),
//                             const SizedBox(height: 12),
//                             Text(plan['price'] as String,
//                                 style: TextStyle(
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.bold,
//                                   color: colorScheme.onSurface,
//                                 )),

//                             const SizedBox(height: 16),
//                             Text("${plan['duration'].toString()} months",
//                                 style: TextStyle(
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.bold,
//                                   color: colorScheme.onSurface,
//                                 )),
//                             const SizedBox(height: 16),
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Icon(Icons.check_circle_outline,
//                                     size: 16, color: colorScheme.primary),
//                                 const SizedBox(width: 8),
//                                 Expanded(
//                                   child: Text(plan['description'] as String,
//                                       style: TextStyle(
//                                         color: colorScheme.onSurface
//                                             .withOpacity(0.8),
//                                       )),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 16),
//                             // Select Plan Button
//                             SizedBox(
//                               width: double.infinity,
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: const Color(0xFF4A3298),
//                                   foregroundColor: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                 ),
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                   // When the user selects a plan, navigate to membership screen
//                                   context.pushNamed('membership', extra: plan);
//                                 },
//                                 child: const Text('Select Plan'),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//               const SizedBox(height: 24),
//               Center(
//                 child: TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text('Close'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: colorScheme.surface,
//     shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
//   );
// }

// Widget _buildPersonalBestsGrid(BuildContext context) {
//   return Consumer<PersonalBestProvider>(
//     builder: (context, personalBestProvider, child) {
//       if (personalBestProvider.isLoading) {
//         return const Center(child: CustomLoadingAnimation());
//       }

//       if (personalBestProvider.currentBests.isEmpty) {
//         return Center(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               "No personal bests recorded yet",
//               style: TextStyle(
//                 color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
//               ),
//             ),
//           ),
//         );
//       }

//       return GridView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2, // Changed from 3 to 2 columns
//           childAspectRatio: 1.4, // Adjust the ratio as needed
//           crossAxisSpacing: 10,
//           mainAxisSpacing: 10,
//         ),
//         itemCount: personalBestProvider.currentBests.length,
//         itemBuilder: (context, index) {
//           final item = personalBestProvider.currentBests[index];
//           final exercise = item['exercise'] as SupportedExercise;
//           final personalBest = item['personalBest'] as PersonalBest?;
//           return GestureDetector(
//             onTap: () {
//               context.pushNamed(
//                 'personalBest',
//                 extra: {
//                   'initialExercise': exercise,
//                   'initialTab': 1,
//                 },
//               );
//             },
//             child: _buildPBItem(
//               context,
//               exercise.exerciseName,
//               personalBest != null
//                   ? {
//                       'weight': personalBest.weight,
//                       'reps': personalBest.reps,
//                     }
//                   : {'weight': '-', 'reps': '-'},
//             ),
//           );
//         },
//       );
//     },
//   );
// }

// Widget _buildPBItem(
//   BuildContext context,
//   String exercise,
//   Map<String, dynamic> data,
// ) {
//   final theme = Theme.of(context);
//   final isDarkMode = theme.brightness == Brightness.dark;

//   return Container(
//     margin: const EdgeInsets.symmetric(vertical: 6),
//     decoration: BoxDecoration(
//       color: theme.colorScheme.surface,
//       borderRadius: BorderRadius.circular(16),
//       border: Border.all(
//         color: theme.colorScheme.onSurface.withOpacity(0.1),
//         width: 1.5,
//       ),
//     ),
//     child: Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Top row: Exercise name with arrow icon
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Text(
//                   exercise,
//                   style: theme.textTheme.headlineSmall?.copyWith(
//                     color: isDarkMode ? Colors.white : Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               const Icon(
//                 Icons.arrow_forward_ios,
//                 size: 16,
//                 color: Colors.grey,
//               ),
//             ],
//           ),
//           const SizedBox(height: 6),
//           // Middle line: Weight
//           Text(
//             '${data['weight']} kg',
//             style: theme.textTheme.bodyLarge?.copyWith(
//               fontWeight: FontWeight.bold,
//               color: theme.colorScheme.onSurface,
//             ),
//           ),
//           // Bottom line: Reps
//           Text(
//             '${data['reps']} reps',
//             style: theme.textTheme.bodyMedium?.copyWith(
//               color: theme.colorScheme.onSurface.withOpacity(0.6),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// Widget _buildWeightSection(BuildContext context, String weight) {
//   final theme = Theme.of(context);
//   final isDarkMode = theme.brightness == Brightness.dark;
//   return Container(
//     margin: const EdgeInsets.symmetric(vertical: 6),
//     padding: const EdgeInsets.all(16.0),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(16),
//       gradient: LinearGradient(
//         colors: [
//           Theme.of(context).colorScheme.secondary.withOpacity(0.1),
//           Theme.of(context).colorScheme.secondary.withOpacity(0.05),
//         ],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       ),
//       border: Border.all(
//         color: isDarkMode
//             ? theme.colorScheme.onSurface.withOpacity(0.1)
//             : theme.colorScheme.onSurface.withOpacity(0.1),
//         width: 1.5,
//       ),
//     ),

//     // padding: const EdgeInsets.all(16),
//     // decoration: BoxDecoration(
//     //   gradient: LinearGradient(
//     //     colors: [
//     //       Theme.of(context).colorScheme.secondary.withOpacity(0.1),
//     //       Theme.of(context).colorScheme.secondary.withOpacity(0.05),
//     //     ],
//     //     begin: Alignment.topLeft,
//     //     end: Alignment.bottomRight,
//     //   ),
//     //   borderRadius: BorderRadius.circular(16),
//     // ),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Current Weight',
//                 style: TextStyle(
//                     color: Theme.of(context)
//                         .colorScheme
//                         .onSurface
//                         .withOpacity(0.6))),
//             const SizedBox(height: 8),
//             Text('$weight kg',
//                 style:
//                     const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//           ],
//         ),
//         ElevatedButton.icon(
//           icon: const Icon(LineAwesomeIcons.play_circle),
//           label: const Text('Log Weight'),
//           onPressed: () => context.pushNamed('weightLog'),
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildProgressCard(BuildContext context, String value, String label) {
//   return Expanded(
//     child: Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.surfaceContainerHighest,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         children: [
//           Text(value,
//               style:
//                   const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 4),
//           Text(label,
//               style: TextStyle(
//                   color: Theme.of(context)
//                       .colorScheme
//                       .onSurface
//                       .withOpacity(0.6))),
//         ],
//       ),
//     ),
//   );
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
import 'package:gymify/providers/log_provider/log_provider.dart';
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
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     // Fetch workouts and profile information
  //     if (mounted) {
  //       context.read<WorkoutProvider>().fetchAllWorkouts();
  //       context.read<ProfileProvider>().fetchProfile();
  //       context.read<MembershipProvider>().fetchMembershipStatus(context);
  //       context.read<PersonalBestProvider>().fetchSupportedExercises();
  //       context.read<PersonalBestProvider>().fetchCurrentPersonalBests();
  //       context.read<MembershipProvider>().fetchMembershipPlans();
  //       final authProvider = context.read<AuthProvider>();
  //       final chatProvider = context.read<ChatProvider>();
  //       if (authProvider.isLoggedIn && authProvider.userId != null) {
  //         if (!chatProvider.isInitialized) {
  //           chatProvider.initializeSocket(authProvider.userId!);
  //         }
  //       }
  //       // After fetching profile data, fetch the user logs:
  //       final profile = context.read<ProfileProvider>().user;
  //       if (profile != null && profile.userId != null) {
  //         context
  //             .read<WorkoutLogProvider>()
  //             .fetchUserLogs(profile.userId.toString());
  //       }
  //     }
  //   });
  // }
  late Future<void> _initialData;

  Future<void> _fetchAllData() async {
    // Fetch all providers data concurrently
    await Future.wait([
      context.read<WorkoutProvider>().fetchAllWorkouts(),
      context.read<ProfileProvider>().fetchProfile(),
      context.read<MembershipProvider>().fetchMembershipStatus(context),
      context.read<PersonalBestProvider>().fetchSupportedExercises(),
      context.read<PersonalBestProvider>().fetchCurrentPersonalBests(),
      context.read<MembershipProvider>().fetchMembershipPlans(),
    ]);

    final authProvider = context.read<AuthProvider>();
    final chatProvider = context.read<ChatProvider>();
    if (authProvider.isLoggedIn && authProvider.userId != null) {
      if (!chatProvider.isInitialized) {
        chatProvider.initializeSocket(authProvider.userId!);
      }
    }

    // After profile is fetched, get logs
    final profile = context.read<ProfileProvider>().user;
    // if (profile != null && profile.userId != null) {
    //   await context
    //       .read<WorkoutLogProvider>()
    //       .fetchUserLogs(profile.userId.toString());
    // }
    if (profile != null && profile.userId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context
            .read<WorkoutLogProvider>()
            .fetchUserLogs(profile.userId.toString());
      });
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   // Start fetching data

  //   _initialData = _fetchAllData();
  // }

  @override
  void initState() {
    super.initState();
    _initialData = Future.delayed(Duration.zero, () async {
      await _fetchAllData();
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

  final String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Fetch user data from ProfileProvider

    final currentDate = getFormattedDate();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      //TODO: Uncomment here
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        toolbarHeight: 60,
        title: Text(
          // 'Gymify',
          currentDate,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          IconButton(
            icon: Icon(
              size: 18,
              FontAwesomeIcons.user,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              // Navigate to Settings Screen
              //TODO: open bottom model sheet and show attendance and more
              context.pushNamed('profile');
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _initialData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            // Show loading indicator until all data is fetched
            return const Center(child: CustomLoadingAnimation());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading data.'));
          }
          // Data is fetched; now build your page.
          final user = context.watch<ProfileProvider>().user;

          return SingleChildScrollView(
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

                final filteredWorkouts =
                    workoutProvider.workouts.where((workout) {
                  final workoutName = workout.workoutName.toLowerCase();
                  final targetMuscleGroup =
                      workout.targetMuscleGroup.toLowerCase();
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

                      // Display Current Date
                      const SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: Text(
                          'Today is $currentDate',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                      TextButton(
                          onPressed: () {
                            context.pushNamed('weightLog');
                          },
                          child: const Text("Weight History")),
                      Text(
                        "Workout Log History",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 10),

                      TextButton(
                        onPressed: () {
                          context.pushNamed('workoutHistory',
                              extra: context
                                      .read<ProfileProvider>()
                                      .user
                                      ?.userId
                                      .toString() ??
                                  '0');
                        },
                        child: const Text("Workout Log History"),
                      ),
                      const SizedBox(height: 20),

                      // _buildPBItem(context, exercise, data),
                      _buildWeightSection(
                          context, user!.currentWeight.toString()),

                      const SizedBox(height: 16),
                      Text(
                        "Personal Bests",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 10),
                      _buildPersonalBestsGrid(context),

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
                                            imageUrl: user.profileImage ?? '',
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                            errorWidget:
                                                (context, url, error) =>
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
                                              user.userName ?? 'User Name',
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          context.pushNamed('membershipPlans');
                                        },
                                        child: const Text('Manage')),

                                    const SizedBox(height: 8),
                                    // Height and Weight data
                                    Text(
                                      'Height: ${user.height ?? '0'} cm',
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
                                      'Weight: ${user.currentWeight ?? '0'} kg',
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
          );
        },
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
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
            width: 1.5,
          ),
        ),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: profileImage,
            width: 60,
            height: 60,
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

Widget _buildPersonalBestsGrid(BuildContext context) {
  return Consumer<PersonalBestProvider>(
    builder: (context, personalBestProvider, child) {
      if (personalBestProvider.isLoading) {
        return const Center(child: CustomLoadingAnimation());
      }

      if (personalBestProvider.currentBests.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "No personal bests recorded yet",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
        );
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Changed from 3 to 2 columns
          childAspectRatio: 1.4, // Adjust the ratio as needed
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: personalBestProvider.currentBests.length,
        itemBuilder: (context, index) {
          final item = personalBestProvider.currentBests[index];
          final exercise = item['exercise'] as SupportedExercise;
          final personalBest = item['personalBest'] as PersonalBest?;
          return GestureDetector(
            onTap: () {
              context.pushNamed(
                'personalBest',
                extra: {
                  'initialExercise': exercise,
                  'initialTab': 1,
                },
              );
            },
            child: _buildPBItem(
              context,
              exercise.exerciseName,
              personalBest != null
                  ? {
                      'weight': personalBest.weight,
                      'reps': personalBest.reps,
                    }
                  : {'weight': '-', 'reps': '-'},
            ),
          );
        },
      );
    },
  );
}

Widget _buildPBItem(
  BuildContext context,
  String exercise,
  Map<String, dynamic> data,
) {
  final theme = Theme.of(context);
  final isDarkMode = theme.brightness == Brightness.dark;

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 6),
    decoration: BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: theme.colorScheme.onSurface.withOpacity(0.1),
        width: 1.5,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Exercise name with arrow icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  exercise,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Middle line: Weight
          Text(
            '${data['weight']} kg',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          // Bottom line: Reps
          Text(
            '${data['reps']} reps',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildWeightSection(BuildContext context, String weight) {
  final theme = Theme.of(context);
  final isDarkMode = theme.brightness == Brightness.dark;
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 6),
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: LinearGradient(
        colors: [
          Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          Theme.of(context).colorScheme.secondary.withOpacity(0.05),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(
        color: isDarkMode
            ? theme.colorScheme.onSurface.withOpacity(0.1)
            : theme.colorScheme.onSurface.withOpacity(0.1),
        width: 1.5,
      ),
    ),

    // padding: const EdgeInsets.all(16),
    // decoration: BoxDecoration(
    //   gradient: LinearGradient(
    //     colors: [
    //       Theme.of(context).colorScheme.secondary.withOpacity(0.1),
    //       Theme.of(context).colorScheme.secondary.withOpacity(0.05),
    //     ],
    //     begin: Alignment.topLeft,
    //     end: Alignment.bottomRight,
    //   ),
    //   borderRadius: BorderRadius.circular(16),
    // ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Weight',
                style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6))),
            const SizedBox(height: 8),
            Text('$weight kg',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
        ElevatedButton.icon(
          icon: const Icon(LineAwesomeIcons.play_circle),
          label: const Text('Log Weight'),
          onPressed: () => context.pushNamed('weightLog'),
        ),
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
