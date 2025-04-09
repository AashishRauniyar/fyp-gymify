import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymify/providers/custom_workout_provider/custom_workout_provider.dart';
import 'package:gymify/screens/custom_workout_screen/custom_workout_detail_screen.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:provider/provider.dart';

class CustomWorkoutListScreen extends StatefulWidget {
  const CustomWorkoutListScreen({super.key});

  @override
  _CustomWorkoutListScreenState createState() =>
      _CustomWorkoutListScreenState();
}

class _CustomWorkoutListScreenState extends State<CustomWorkoutListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late ThemeData theme;
  late CustomWorkoutProvider customWorkoutProvider;

  @override
  void initState() {
    super.initState();
    // Set system UI overlay style for immersive experience
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          'Custom Workouts',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withBlue(
                    (theme.colorScheme.primary.blue + 40).clamp(0, 255)),
              ],
            ),
          ),
        ),
      ),
      body: ChangeNotifierProvider(
        create: (_) {
          customWorkoutProvider = CustomWorkoutProvider()
            ..fetchCustomWorkouts();
          return customWorkoutProvider;
        },
        child: Consumer<CustomWorkoutProvider>(
          builder: (context, customWorkoutProvider, child) {
            if (customWorkoutProvider.isLoading) {
              return const Center(child: CustomLoadingAnimation());
            }

            if (customWorkoutProvider.customWorkouts.isEmpty) {
              return _buildEmptyState();
            }

            // Filter workouts based on the search query
            final filteredWorkouts =
                customWorkoutProvider.customWorkouts.where((workout) {
              return workout.customWorkoutName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase());
            }).toList();

            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    // Search bar
                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search custom workouts...',
                            prefixIcon: Icon(Icons.search,
                                color: Theme.of(context).colorScheme.primary),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear,
                                        color: Colors.grey),
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                        _searchQuery = '';
                                      });
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor: theme.colorScheme.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 0),
                          ),
                        ),
                      ),
                    ),

                    // Workouts section header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Your Workouts',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${filteredWorkouts.length} total',
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Custom workout list
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final workout = filteredWorkouts[index];
                            return _buildWorkoutCard(workout);
                          },
                          childCount: filteredWorkouts.length,
                        ),
                      ),
                    ),

                    // Extra space for FAB
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 100),
                    ),
                  ],
                ),

                // Create Workout button positioned at the bottom
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  child: SafeArea(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.primary.withBlue(
                              (theme.colorScheme.primary.blue + 40)
                                  .clamp(0, 255),
                            ),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () async {
                            final result =
                                await context.pushNamed('createCustomWorkout');
                            if (result == true) {
                              // Refresh workouts if we get a positive result back
                              await customWorkoutProvider.fetchCustomWorkouts();
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  FontAwesomeIcons.plus,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'CREATE OWN WORKOUT',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SafeArea(
      child: Stack(
        children: [
          // Empty state content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.dumbbell,
                size: 70,
                color: theme.colorScheme.primary.withOpacity(0.5),
              ),
              const SizedBox(height: 24),
              Text(
                'No Custom Workouts',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Create your first custom workout to start building your personalized fitness routine.',
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () async {
                  final result =
                      await Navigator.pushNamed(context, 'createCustomWorkout');
                  if (result == true) {
                    // Refresh workouts if we get a positive result back
                    await customWorkoutProvider.fetchCustomWorkouts();
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('Create Workout'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
            ],
          ),

          // Create Workout button positioned at the bottom
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: SafeArea(
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withBlue(
                        (theme.colorScheme.primary.blue + 40).clamp(0, 255),
                      ),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () async {
                      final result = await Navigator.pushNamed(
                          context, 'createCustomWorkout');
                      if (result == true) {
                        // Refresh workouts if we get a positive result back
                        await customWorkoutProvider.fetchCustomWorkouts();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            FontAwesomeIcons.plus,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'CREATE OWN WORKOUT',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildWorkoutCard(dynamic workout) {
  //   // Get actual data from the workout model
  //   final String workoutName = workout.customWorkoutName;
  //   final DateTime createdAt = workout.createdAt;
  //   final int exerciseCount = workout.customworkoutexercises.length;

  //   // Extract unique target muscle groups from exercises
  //   final Set<String> muscleGroups = {};
  //   for (final exercise in workout.customworkoutexercises) {
  //     if (exercise.exercises != null &&
  //         exercise.exercises.targetMuscleGroup != null) {
  //       muscleGroups.add(exercise.exercises.targetMuscleGroup);
  //     }
  //   }

  //   // Create a display string for muscle groups
  //   final String muscleGroupsDisplay = _formatMuscleGroups(muscleGroups);

  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 16),
  //     decoration: BoxDecoration(
  //       color: theme.colorScheme.surface,
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.05),
  //           blurRadius: 10,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: InkWell(
  //       borderRadius: BorderRadius.circular(16),
  //       onTap: () async {
  //         final result = await Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => CustomWorkoutDetailScreen(
  //               customWorkoutId: workout.customWorkoutId,
  //             ),
  //           ),
  //         );

  //         // If returned with a result, refresh the workouts list
  //         if (result == true) {
  //           await customWorkoutProvider.fetchCustomWorkouts();
  //         }
  //       },
  //       child: Column(
  //         children: [
  //           // Workout header with title
  //           Container(
  //             decoration: BoxDecoration(
  //               color: theme.colorScheme.primary,
  //               borderRadius: const BorderRadius.only(
  //                 topLeft: Radius.circular(16),
  //                 topRight: Radius.circular(16),
  //               ),
  //               gradient: LinearGradient(
  //                 begin: Alignment.topLeft,
  //                 end: Alignment.bottomRight,
  //                 colors: [
  //                   theme.colorScheme.primary,
  //                   theme.colorScheme.primary.withBlue(
  //                       (theme.colorScheme.primary.blue + 40).clamp(0, 255)),
  //                 ],
  //               ),
  //             ),
  //             padding: const EdgeInsets.all(16),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 // Custom badge
  //                 Container(
  //                   padding:
  //                       const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  //                   decoration: BoxDecoration(
  //                     color: theme.colorScheme.secondary,
  //                     borderRadius: BorderRadius.circular(20),
  //                   ),
  //                   child: Text(
  //                     'CUSTOM',
  //                     style: GoogleFonts.roboto(
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 12,
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 10),
  //                 // Workout title
  //                 Text(
  //                   workoutName,
  //                   style: GoogleFonts.poppins(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.white,
  //                   ),
  //                   maxLines: 1,
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //                 const SizedBox(height: 8),
  //                 // Workout info
  //                 Row(
  //                   children: [
  //                     const Icon(
  //                       FontAwesomeIcons.dumbbell,
  //                       size: 12,
  //                       color: Colors.white,
  //                     ),
  //                     const SizedBox(width: 6),
  //                     Text(
  //                       muscleGroupsDisplay,
  //                       style: const TextStyle(
  //                         fontSize: 12,
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                     const SizedBox(width: 12),
  //                     const Icon(
  //                       FontAwesomeIcons.listCheck,
  //                       size: 12,
  //                       color: Colors.white,
  //                     ),
  //                     const SizedBox(width: 6),
  //                     Text(
  //                       "$exerciseCount exercises",
  //                       style: const TextStyle(
  //                         fontSize: 12,
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),

  //           // Quick info bar
  //           Padding(
  //             padding: const EdgeInsets.all(12),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceAround,
  //               children: [
  //                 _buildInfoElement(
  //                   'CREATED',
  //                   _formatDate(createdAt),
  //                   FontAwesomeIcons.calendar,
  //                 ),
  //                 _buildInfoElement(
  //                   'EXERCISES',
  //                   exerciseCount.toString(),
  //                   FontAwesomeIcons.listCheck,
  //                 ),
  //                 _buildInfoElement(
  //                   'FOCUS',
  //                   _getWorkoutFocus(muscleGroupsDisplay),
  //                   FontAwesomeIcons.crosshairs,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildWorkoutCard(dynamic workout) {
    // Get actual data from the workout model
    final String workoutName = workout.customWorkoutName;
    final DateTime createdAt = workout.createdAt;
    final int exerciseCount = workout.customworkoutexercises.length;
    final int workoutId = workout.customWorkoutId;

    // Extract unique target muscle groups from exercises
    final Set<String> muscleGroups = {};
    for (final exercise in workout.customworkoutexercises) {
      if (exercise.exercises != null &&
          exercise.exercises.targetMuscleGroup != null) {
        muscleGroups.add(exercise.exercises.targetMuscleGroup);
      }
    }

    // Create a display string for muscle groups
    final String muscleGroupsDisplay = _formatMuscleGroups(muscleGroups);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CustomWorkoutDetailScreen(
                customWorkoutId: workout.customWorkoutId,
              ),
            ),
          );

          // If returned with a result, refresh the workouts list
          if (result == true) {
            await customWorkoutProvider.fetchCustomWorkouts();
          }
        },
        child: Column(
          children: [
            // Workout header with title and delete button
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withBlue(
                        (theme.colorScheme.primary.blue + 40).clamp(0, 255)),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge and Delete button row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Custom badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'CUSTOM',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      // Delete button
                      InkWell(
                        onTap: () {
                          _showDeleteConfirmation(workoutId, workoutName);
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            FontAwesomeIcons.trash,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Workout title
                  Text(
                    workoutName,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Workout info
                  Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.dumbbell,
                        size: 12,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        muscleGroupsDisplay,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        FontAwesomeIcons.listCheck,
                        size: 12,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "$exerciseCount exercises",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Quick info bar
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoElement(
                    'CREATED',
                    _formatDate(createdAt),
                    FontAwesomeIcons.calendar,
                  ),
                  _buildInfoElement(
                    'EXERCISES',
                    exerciseCount.toString(),
                    FontAwesomeIcons.listCheck,
                  ),
                  _buildInfoElement(
                    'FOCUS',
                    _getWorkoutFocus(muscleGroupsDisplay),
                    FontAwesomeIcons.crosshairs,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(int workoutId, String workoutName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Workout'),
        content: Text(
            'Are you sure you want to delete "$workoutName"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () async {
              Navigator.pop(context); // Close dialog

              try {
                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );

                // Delete the workout
                await customWorkoutProvider.deleteCustomWorkout(workoutId);

                // Close loading indicator
                Navigator.pop(context);

                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('Workout "$workoutName" deleted successfully'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );

                // Refresh the list
                await customWorkoutProvider.fetchCustomWorkouts();
              } catch (e) {
                // Close loading indicator if open
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }

                // Show error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error deleting workout: ${e.toString()}'),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoElement(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Helper methods that work with actual data
  String _formatMuscleGroups(Set<String> muscleGroups) {
    if (muscleGroups.isEmpty) {
      return "Various";
    } else if (muscleGroups.length == 1) {
      return muscleGroups.first;
    } else if (muscleGroups.length <= 2) {
      return muscleGroups.join(' & ');
    } else {
      return 'Full Body';
    }
  }

  String _formatDate(DateTime date) {
    final today = DateTime.now();
    final difference = today.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      final month = date.month.toString().padLeft(2, '0');
      final day = date.day.toString().padLeft(2, '0');
      return '${date.year}-$month-$day';
    }
  }

  String _getWorkoutFocus(String muscleGroups) {
    final lowercaseMuscle = muscleGroups.toLowerCase();

    if (lowercaseMuscle.contains('chest') || lowercaseMuscle.contains('pecs')) {
      return 'Upper Body';
    } else if (lowercaseMuscle.contains('leg') ||
        lowercaseMuscle.contains('quad') ||
        lowercaseMuscle.contains('hamstring') ||
        lowercaseMuscle.contains('glute')) {
      return 'Lower Body';
    } else if (lowercaseMuscle.contains('back') ||
        lowercaseMuscle.contains('lat')) {
      return 'Back';
    } else if (lowercaseMuscle.contains('arm') ||
        lowercaseMuscle.contains('bicep') ||
        lowercaseMuscle.contains('tricep')) {
      return 'Arms';
    } else if (lowercaseMuscle.contains('core') ||
        lowercaseMuscle.contains('abs')) {
      return 'Core';
    } else if (lowercaseMuscle.contains('shoulder') ||
        lowercaseMuscle.contains('delt')) {
      return 'Shoulders';
    } else if (lowercaseMuscle.contains('full') ||
        lowercaseMuscle.contains('total') ||
        muscleGroups == 'Various') {
      return 'Full Body';
    } else {
      return 'Mixed';
    }
  }
}
