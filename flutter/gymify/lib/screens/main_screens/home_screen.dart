import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/models/personal_best_model.dart';
import 'package:gymify/models/supported_exercise_model.dart';
import 'package:gymify/models/workout_log_models/workout_exercise_log_model.dart';
import 'package:gymify/models/workout_log_models/workout_log_model.dart';
import 'package:gymify/models/workout_model.dart';
import 'package:gymify/providers/attendance_provider/attendance_provider.dart';
import 'package:gymify/providers/auth_provider/auth_provider.dart';
import 'package:gymify/providers/chat_provider/chat_service.dart';
import 'package:gymify/providers/diet_provider/diet_provider.dart';
import 'package:gymify/providers/log_provider/log_provider.dart';
import 'package:gymify/providers/membership_provider/membership_provider.dart';
import 'package:gymify/providers/personal_best_provider/personal_best_provider.dart';
import 'package:gymify/providers/profile_provider/profile_provider.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:gymify/utils/workout_utils.dart/workout_list_item.dart';
import 'package:gymify/widget/attendance_date_picker_widget.dart';
import 'package:gymify/widget/attendance_stats_widget.dart';
import 'package:gymify/widget/fitnes_stats_widget.dart';
import 'package:gymify/widget/nutrition_stats_widget.dart';
import 'package:gymify/widget/workout_stats_widget.dart';
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
  late Future<void> _initialData;
  DateTime _selectedDate = DateTime.now(); // Define the selected date variable

  Future<void> _fetchAllData() async {
    // Fetch all providers data concurrently
    await Future.wait([
      context.read<WorkoutProvider>().fetchAllWorkouts(),
      context.read<ProfileProvider>().fetchProfile(),
      context.read<MembershipProvider>().fetchMembershipStatus(context),
      context.read<PersonalBestProvider>().fetchSupportedExercises(),
      context.read<PersonalBestProvider>().fetchCurrentPersonalBests(),
      context.read<MembershipProvider>().fetchMembershipPlans(),
      context.read<DietProvider>().fetchMealLogs(),
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
    if (profile != null && profile.userId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context
            .read<WorkoutLogProvider>()
            .fetchUserLogs(profile.userId.toString());

        context
            .read<AttendanceProvider>()
            .fetchAttendanceHistory(int.parse(profile.userId.toString()));
      });
    }
  }

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
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          IconButton(
            icon: Icon(
              size: 18,
              FontAwesomeIcons.fire,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              _fetchAllData();
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
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(
                          context,
                          user?.userName.toString() ?? "username",
                          user?.profileImage.toString() ??
                              "assets/images/profile/default_avatar.jpg"),

                      const SizedBox(height: 10),

                      _buildOfferBanner(context),

                      _buildAttendanceCalender(context, _selectedDate, (date) {
                        setState(() {
                          _selectedDate = date;
                        });
                      }),

                      // TextButton(
                      //     onPressed: () {
                      //       context.pushNamed('aiChatScreen');
                      //     },
                      //     child: const Text("AI chat")),
                      // TextButton(
                      //     onPressed: () {
                      //       context.pushNamed('manageWorkouts');
                      //     },
                      //     child: const Text("Manage Workout")),

                      // TextButton(
                      //   onPressed: () {
                      //     context.pushNamed('workoutHistory',
                      //         extra: context
                      //                 .read<ProfileProvider>()
                      //                 .user
                      //                 ?.userId
                      //                 .toString() ??
                      //             '0');
                      //   },
                      //   child: const Text("Workout Log History"),
                      // ),

                      const SizedBox(height: 10),
                      _buildAttendanceSection(context),
                      const SizedBox(height: 10),
                      _buildStepCountSection(context),

                      TextButton(
                          onPressed: () {
                            context.pushNamed('stepCount');
                          },
                          child: const Text("Step Count")),

                      _buildWeightSection(
                          context, user!.currentWeight.toString()),
                      const SizedBox(height: 10),

                      _buildNutritionSection(context),
                      const SizedBox(height: 10),

                      _buildWorkoutStatsSection(
                          context, user.userId.toString()),
                      const SizedBox(height: 10),

                      Text(
                        "Personal Bests",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 10),
                      _buildPersonalBestsGrid(context),

                      const SizedBox(height: 10),

                      _buildRecentWorkoutHistory(context),

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
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
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

// Widget _buildOfferBanner(BuildContext context) {
//   final membershipStatus =
//       context.watch<MembershipProvider>().membership?.status;

//   // Check for each membership status
//   final isMembershipActive = membershipStatus == 'Active';
//   final isMembershipPending = membershipStatus == 'Pending';
//   final isMembershipNotApplied = membershipStatus == 'Not Applied';

//   return Container(
//     padding: const EdgeInsets.all(20),
//     decoration: BoxDecoration(
//       gradient: isMembershipActive
//           ? const LinearGradient(
//               colors: [Color.fromARGB(255, 152, 115, 50), Color(0xFF2A1B4D)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             )
//           : isMembershipPending
//               ? const LinearGradient(
//                   colors: [
//                     Color(0xFFB02A2A),
//                     Color(0xFF6D1111)
//                   ], // Red Gradient
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 )
//               : const LinearGradient(
//                   colors: [
//                     Color.fromARGB(255, 152, 115, 50),
//                     Color.fromARGB(255, 77, 65, 1)
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
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
//                   Text(
//                     isMembershipActive
//                         ? 'Membership Active'
//                         : isMembershipPending
//                             ? 'Membership Pending'
//                             : 'Premium Membership',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       _showBottomSheet(context);
//                     },
//                     child: const Icon(
//                       LineAwesomeIcons.info_circle_solid,
//                       color: Colors.white,
//                       size: 24,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 isMembershipActive
//                     ? 'You are now a premium member.\nEnjoy all benefits!'
//                     : isMembershipPending
//                         ? 'Your membership is pending, waiting for approval.\nAfter approval, collect your membership card from the counter.'
//                         : 'Get your gym membership\nstarting at Rs 1500',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: isMembershipActive ? 22 : 14,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               // Show the appropriate button based on the membership status
//               if (isMembershipNotApplied)
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     foregroundColor: const Color.fromARGB(255, 152, 115, 50),
//                   ),
//                   onPressed: () => context.pushNamed('membershipPlans'),
//                   child: const Text('Apply Now 💪'),
//                 )
//               else
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     foregroundColor: const Color(0xFF4A3298),
//                   ),
//                   onPressed: () {
//                     // Show the membership details or redirect to the profile
//                     context.pushNamed('membershipPlans');
//                   },
//                   child: isMembershipPending
//                       ? const Text('Pending Approval')
//                       : const Text('View Membership Details'),
//                 ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

Widget _buildOfferBanner(BuildContext context) {
  final membershipStatus =
      context.watch<MembershipProvider>().membership?.status;

  // Check for each membership status
  final isMembershipActive = membershipStatus == 'Active';
  final isMembershipPending = membershipStatus == 'Pending';
  final isMembershipNotApplied = membershipStatus == 'Not Applied';

  // If the membership is active, return an empty widget
  if (isMembershipActive) {
    return const SizedBox
        .shrink(); // or return Container() if you prefer an empty container
  }

  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: isMembershipActive
          ? const LinearGradient(
              colors: [Color.fromARGB(255, 152, 115, 50), Color(0xFF2A1B4D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : isMembershipPending
              ? const LinearGradient(
                  colors: [
                    Color(0xFFB02A2A),
                    Color(0xFF6D1111)
                  ], // Red Gradient
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 152, 115, 50),
                    Color.fromARGB(255, 77, 65, 1)
                  ],
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
                  Text(
                    isMembershipActive
                        ? 'Membership Active'
                        : isMembershipPending
                            ? 'Membership Pending'
                            : 'Premium Membership',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showBottomSheet(context);
                    },
                    child: const Icon(
                      LineAwesomeIcons.info_circle_solid,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                isMembershipActive
                    ? 'You are now a premium member.\nEnjoy all benefits!'
                    : isMembershipPending
                        ? 'Your membership is pending, waiting for approval.\nAfter approval, collect your membership card from the counter.'
                        : 'Get your gym membership\nstarting at Rs 1500',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMembershipActive ? 22 : 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              // Show the appropriate button based on the membership status
              if (isMembershipNotApplied)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color.fromARGB(255, 152, 115, 50),
                  ),
                  onPressed: () => context.pushNamed('membershipPlans'),
                  child: const Text('Apply Now 💪'),
                )
              else
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF4A3298),
                  ),
                  onPressed: () {
                    // Show the membership details or redirect to the profile
                    context.pushNamed('membershipPlans');
                  },
                  child: isMembershipPending
                      ? const Text('Pending Approval')
                      : const Text('View Membership Details'),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildWorkoutStatsSection(BuildContext context, String userId) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Workout Stats",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          TextButton(
            onPressed: () {
              context.pushNamed('workoutHistory', extra: userId);
            },
            child: const Text("View All"),
          ),
        ],
      ),
      const SizedBox(height: 10),
      WorkoutStatsWidget(userId: userId),
    ],
  );
}

void _showBottomSheet(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
                        // decoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(16),
                        //   gradient: LinearGradient(
                        //     colors: [
                        //       colorScheme.primary.withOpacity(0.1),
                        //       colorScheme.surface,
                        //     ],
                        //     begin: Alignment.topLeft,
                        //     end: Alignment.bottomRight,
                        //   ),
                        //   border: Border.all(
                        //     color: colorScheme.outline.withOpacity(0.1),
                        //   ),
                        // ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),

                          gradient: isDarkMode
                              ? LinearGradient(
                                  colors: [
                                    colorScheme.onSurface.withOpacity(0.1),
                                    colorScheme.onSurface.withOpacity(0.05),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null, // For light mode, no gradient, just a white background
                          color: Theme.of(context).brightness ==
                                  Brightness.light
                              ? Colors.white // White background for light mode
                              : null, // Dark mode will apply the gradient above
                          border: Border.all(
                            color: colorScheme.onSurface.withOpacity(0.1),
                            width: 1.5,
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
                                  context.pushNamed(
                                    'membershipPlans',
                                  );
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
    // decoration: BoxDecoration(
    //   borderRadius: BorderRadius.circular(16),
    //   gradient: LinearGradient(
    //     colors: [
    //       Theme.of(context).colorScheme.secondary.withOpacity(0.1),
    //       Theme.of(context).colorScheme.secondary.withOpacity(0.05),
    //     ],
    //     begin: Alignment.topLeft,
    //     end: Alignment.bottomRight,
    //   ),
    //   border: Border.all(
    //     color: isDarkMode
    //         ? theme.colorScheme.onSurface.withOpacity(0.1)
    //         : theme.colorScheme.onSurface.withOpacity(0.1),
    //     width: 1.5,
    //   ),
    // ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),

      gradient: isDarkMode
          ? LinearGradient(
              colors: [
                theme.colorScheme.onSurface.withOpacity(0.1),
                theme.colorScheme.onSurface.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null, // For light mode, no gradient, just a white background
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.white // White background for light mode
          : null, // Dark mode will apply the gradient above
      border: Border.all(
        color: theme.colorScheme.onSurface.withOpacity(0.1),
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

// Add this function below _buildWeightSection in the HomeScreen file
Widget _buildNutritionSection(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Nutrition Stats",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          TextButton(
            onPressed: () {
              context.push('/mealLogs');
            },
            child: const Text("View All"),
          ),
        ],
      ),
      const SizedBox(height: 10),
      const NutritionStatsWidget(),
    ],
  );
}

Widget _buildAttendanceCalender(BuildContext context, DateTime selectedDate,
    Function(DateTime) onDateSelected) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   'Calendar',
        //   style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        //         fontWeight: FontWeight.bold,
        //       ),
        // ),
        // Custom Attendance Date Picker
        AttendanceDatePicker(
          initialDate: selectedDate,
          height: 110,
          onDateSelected: onDateSelected,
        ),
      ],
    ),
  );
}

// Add this function below _buildNutritionSection in the HomeScreen file
Widget _buildAttendanceSection(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Attendance Tracker",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          TextButton(
            onPressed: () {
              context.push('/attendance');
            },
            child: const Text("View All"),
          ),
        ],
      ),
      const SizedBox(height: 10),
      const AttendanceStatsWidget(),
    ],
  );
}

// Add this widget in your home screen file
Widget _buildRecentWorkoutHistory(BuildContext context) {
  return Consumer<WorkoutLogProvider>(
    builder: (context, workoutLogProvider, child) {
      if (workoutLogProvider.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (workoutLogProvider.userLogs.isEmpty) {
        return const Center(child: Text("No recent workout logs."));
      }
      // Show top 3 logs (sorted newest first)
      final recentLogs = workoutLogProvider.userLogs.take(2).toList();
      final dateFormat = DateFormat('MMM dd, yyyy - h:mm a');

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Recent Workout History",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
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
                child: const Text("View All"),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentLogs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final log = recentLogs[index];
              return _WorkoutLogCard(log: log, dateFormat: dateFormat);
            },
          ),
        ],
      );
    },
  );
}

//! with details
class _WorkoutLogCard extends StatelessWidget {
  final WorkoutLog log;
  final DateFormat dateFormat;

  const _WorkoutLogCard({
    required this.log,
    required this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Workout?>(
      future: Provider.of<WorkoutProvider>(context, listen: false)
          .getWorkoutDetailsById(log.workoutId),
      builder: (context, snapshot) {
        Widget headerContent;
        if (snapshot.connectionState != ConnectionState.done) {
          headerContent = const SizedBox(
            height: 60,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError || !snapshot.hasData) {
          headerContent = const ListTile(
            title: Text(
              'Workout details not available',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        } else {
          final workout = snapshot.data!;
          headerContent = ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: workout.workoutImage.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      workout.workoutImage,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[300],
                        child: const Icon(Icons.fitness_center),
                      ),
                    ),
                  )
                : Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[300],
                    child: const Icon(Icons.fitness_center),
                  ),
            title: Text(
              workout.workoutName,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              dateFormat.format(log.workoutDate),
              style: const TextStyle(color: Colors.grey),
            ),
            trailing: ElevatedButton(
              onPressed: () {
                // Navigate to workout details screen
                context.pushNamed(
                  'workoutDetail',
                  queryParameters: {'workoutId': workout.workoutId.toString()},
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('View'),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          child: ExpansionTile(
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            expandedAlignment: Alignment.topLeft,
            tilePadding: const EdgeInsets.all(0),
            title: headerContent,
            childrenPadding: const EdgeInsets.all(16),
            children: [
              if (log.performanceNotes.isNotEmpty) ...[
                const Text(
                  'Performance Notes:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(log.performanceNotes),
                const Divider(),
              ],
              const Text(
                'Exercises:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (log.workoutexerciseslogs.isNotEmpty)
                ...log.workoutexerciseslogs.map(
                  (exerciseLog) => _ExerciseLogItem(exerciseLog: exerciseLog),
                )
              else
                const Text('No exercise details available'),
            ],
          ),
        );
      },
    );
  }
}

// class _WorkoutLogCard extends StatelessWidget {
//   final WorkoutLog log;
//   final DateFormat dateFormat;

//   const _WorkoutLogCard({
//     required this.log,
//     required this.dateFormat,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.surface,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
//           width: 1.5,
//         ),
//       ),
//       child: ExpansionTile(
//         expandedCrossAxisAlignment: CrossAxisAlignment.start,
//         expandedAlignment: Alignment.topLeft,
//         tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         title: Text(
//           'Workout on ${dateFormat.format(log.workoutDate)}',
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Padding(
//           padding: const EdgeInsets.only(top: 4.0),
//           child: Text(
//             'Duration: ${double.parse(log.totalDuration).toStringAsFixed(2)} min  |  Exercises: ${log.workoutexerciseslogs.length}',
//             style: const TextStyle(color: Colors.grey),
//           ),
//         ),
//         childrenPadding: const EdgeInsets.all(16),
//         children: [
//           if (log.performanceNotes.isNotEmpty) ...[
//             const Text(
//               'Performance Notes:',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 4),
//             Text(log.performanceNotes),
//             const Divider(),
//           ],
//           const Text(
//             'Exercises:',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),
//           if (log.workoutexerciseslogs.isNotEmpty)
//             ...log.workoutexerciseslogs.map(
//               (exerciseLog) => _ExerciseLogItem(exerciseLog: exerciseLog),
//             )
//           else
//             const Text('No exercise details available'),
//         ],
//       ),
//     );
//   }
// }

class _ExerciseLogItem extends StatelessWidget {
  final Workoutexerciseslog exerciseLog;

  const _ExerciseLogItem({required this.exerciseLog});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to exercise details screen (if needed)
        context.pushNamed('exerciseDetails', extra: exerciseLog.exercises);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
            width: 1.5,
          ),
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: exerciseLog.exercises.imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    exerciseLog.exercises.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: const Icon(Icons.fitness_center),
                    ),
                  ),
                )
              : Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Icon(Icons.fitness_center),
                ),
          title: Text(
            exerciseLog.exercises.exerciseName ?? 'Unknown Exercise',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                'Target: ${exerciseLog.exercises.targetMuscleGroup ?? 'N/A'}',
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 4),
              Text(
                'Duration: ${double.parse(exerciseLog.exerciseDuration).toStringAsFixed(2)} min',
              ),
              if ((double.tryParse(exerciseLog.restDuration) ?? 0) > 0)
                Text(
                  'Rest: ${double.parse(exerciseLog.restDuration).toStringAsFixed(2)} min',
                ),
              if (exerciseLog.skipped)
                const Text(
                  'Skipped',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
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

Widget _buildStepCountSection(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Step Counter",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          TextButton(
            onPressed: () {
              context.pushNamed('stepCount');
            },
            child: const Text("Details"),
          ),
        ],
      ),
      const SizedBox(height: 10),
      // Add the FitnessStatsCard here
      FitnessStatsCard(
        onTap: () {
          context.pushNamed('stepCount');
        },
      ),
    ],
  );
}
