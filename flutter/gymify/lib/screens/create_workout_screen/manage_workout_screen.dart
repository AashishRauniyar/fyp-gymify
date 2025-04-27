// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:go_router/go_router.dart';
// import 'package:gymify/models/workout_model.dart';
// import 'package:gymify/providers/workout_provider/workout_provider.dart';
// import 'package:gymify/utils/custom_appbar.dart';
// import 'package:gymify/utils/custom_loader.dart';
// import 'package:provider/provider.dart';

// class ManageWorkoutScreen extends StatefulWidget {
//   const ManageWorkoutScreen({super.key});

//   @override
//   State<ManageWorkoutScreen> createState() => _ManageWorkoutScreenState();
// }

// class _ManageWorkoutScreenState extends State<ManageWorkoutScreen> {
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     // Fetch workouts when screen loads
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
//       workoutProvider.fetchAllWorkouts();
//     });
//   }

//   Future<void> _deleteWorkout(BuildContext context, Workout workout) async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
//       await workoutProvider.deleteWorkout(workout.workoutId);

//       // Show success message
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Workout deleted successfully'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       // Show error message
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error deleting workout: ${e.toString()}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   void _showDeleteConfirmationDialog(BuildContext context, Workout workout) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Workout'),
//         content: Text('Are you sure you want to delete "${workout.workoutName}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _deleteWorkout(context, workout);
//             },
//             style: TextButton.styleFrom(
//               foregroundColor: Colors.red,
//             ),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _navigateToEditWorkout(BuildContext context, Workout workout) {
//     context.pushNamed(
//       'editWorkout',
//       extra: workout,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: const CustomAppBar(
//         title: "Manage Workouts",
//         showBackButton: true,
//       ),
//       body: _isLoading
//           ? const Center(child: CustomLoadingAnimation())
//           : Consumer<WorkoutProvider>(
//               builder: (context, workoutProvider, child) {
//                 if (workoutProvider.isLoading) {
//                   return const Center(child: CustomLoadingAnimation());
//                 }

//                 if (workoutProvider.hasError) {
//                   return Center(
//                     child: Text(
//                       "Error loading workouts.",
//                       style: theme.textTheme.headlineSmall?.copyWith(
//                         color: theme.colorScheme.error,
//                       ),
//                     ),
//                   );
//                 }

//                 if (workoutProvider.workouts.isEmpty) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.fitness_center,
//                           size: 80,
//                           color: Colors.grey.shade400,
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           "No workouts found",
//                           style: theme.textTheme.headlineSmall,
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           "Create a workout to get started",
//                           style: theme.textTheme.bodyMedium?.copyWith(
//                             color: Colors.grey,
//                           ),
//                         ),
//                         const SizedBox(height: 24),
//                         ElevatedButton.icon(
//                           onPressed: () => context.pushNamed('createWorkout'),
//                           icon: const Icon(Icons.add),
//                           label: const Text('Create Workout'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: theme.colorScheme.primary,
//                             foregroundColor: theme.colorScheme.onPrimary,
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 24,
//                               vertical: 12,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 return ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: workoutProvider.workouts.length,
//                   itemBuilder: (context, index) {
//                     final workout = workoutProvider.workouts[index];
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 12),
//                       child: Slidable(
//                         key: ValueKey(workout.workoutId),
//                         endActionPane: ActionPane(
//                           motion: const ScrollMotion(),
//                           dismissible: DismissiblePane(
//                             onDismissed: () => _showDeleteConfirmationDialog(context, workout),
//                           ),
//                           children: [
//                             SlidableAction(
//                               onPressed: (context) => _navigateToEditWorkout(context, workout),
//                               backgroundColor: Colors.blue,
//                               foregroundColor: Colors.white,
//                               icon: Icons.edit,
//                               label: 'Edit',
//                             ),
//                             SlidableAction(
//                               onPressed: (context) => _showDeleteConfirmationDialog(context, workout),
//                               backgroundColor: Colors.red,
//                               foregroundColor: Colors.white,
//                               icon: Icons.delete,
//                               label: 'Delete',
//                             ),
//                           ],
//                         ),
//                         child: _buildWorkoutCard(context, workout),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => context.pushNamed('createWorkout'),
//         backgroundColor: theme.colorScheme.primary,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   Widget _buildWorkoutCard(BuildContext context, Workout workout) {
//     final theme = Theme.of(context);
//     final exerciseCount = workout.workoutexercises?.length ?? 0;

//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: InkWell(
//         onTap: () => _navigateToEditWorkout(context, workout),
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Workout image or placeholder
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: workout.workoutImage.isNotEmpty
//                     ? Image.network(
//                         workout.workoutImage,
//                         width: 80,
//                         height: 80,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return Container(
//                             width: 80,
//                             height: 80,
//                             color: Colors.grey.shade300,
//                             child: const Icon(
//                               Icons.fitness_center,
//                               color: Colors.grey,
//                               size: 40,
//                             ),
//                           );
//                         },
//                       )
//                     : Container(
//                         width: 80,
//                         height: 80,
//                         color: Colors.grey.shade300,
//                         child: const Icon(
//                           Icons.fitness_center,
//                           color: Colors.grey,
//                           size: 40,
//                         ),
//                       ),
//               ),
//               const SizedBox(width: 16),
//               // Workout details
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       workout.workoutName,
//                       style: theme.textTheme.titleMedium?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       workout.description,
//                       style: theme.textTheme.bodyMedium,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         Chip(
//                           label: Text(
//                             workout.difficulty,
//                             style: TextStyle(
//                               color: _getDifficultyColor(workout.difficulty),
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12,
//                             ),
//                           ),
//                           backgroundColor: _getDifficultyColor(workout.difficulty).withOpacity(0.1),
//                           padding: EdgeInsets.zero,
//                           visualDensity: VisualDensity.compact,
//                         ),
//                         const SizedBox(width: 8),
//                         Icon(
//                           Icons.fitness_center,
//                           size: 16,
//                           color: theme.colorScheme.primary,
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           "$exerciseCount exercises",
//                           style: theme.textTheme.bodySmall,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               // Edit icon
//               IconButton(
//                 icon: Icon(
//                   Icons.arrow_forward_ios,
//                   size: 16,
//                   color: theme.colorScheme.primary,
//                 ),
//                 onPressed: () => _navigateToEditWorkout(context, workout),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Color _getDifficultyColor(String difficulty) {
//     switch (difficulty) {
//       case 'Easy':
//         return Colors.green;
//       case 'Intermediate':
//         return Colors.orange;
//       case 'Hard':
//         return Colors.red;
//       default:
//         return Colors.blue;
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/models/workout_model.dart';
import 'package:gymify/providers/workout_provider/workout_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:gymify/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ManageWorkoutScreen extends StatefulWidget {
  const ManageWorkoutScreen({super.key});

  @override
  State<ManageWorkoutScreen> createState() => _ManageWorkoutScreenState();
}

class _ManageWorkoutScreenState extends State<ManageWorkoutScreen> {
  bool _isLoading = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch workouts when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final workoutProvider =
          Provider.of<WorkoutProvider>(context, listen: false);
      workoutProvider.fetchAllWorkouts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _deleteWorkout(BuildContext context, Workout workout) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final workoutProvider =
          Provider.of<WorkoutProvider>(context, listen: false);
      await workoutProvider.deleteWorkout(workout.workoutId);

      // Show success message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Text('${workout.workoutName} deleted successfully'),
            ],
          ),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(12),
        ),
      );
    } catch (e) {
      // Show error message
      if (!mounted) return;
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Row(
      //       children: [
      //         const Icon(Icons.error_outline, color: Colors.white),
      //         const SizedBox(width: 12),
      //         Expanded(
      //             child: Text('Failed to delete workout: ${e.toString()}')),
      //       ],
      //     ),
      //     backgroundColor: Colors.red.shade700,
      //     behavior: SnackBarBehavior.floating,
      //     shape:
      //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      //     margin: const EdgeInsets.all(12),
      //   ),
      // );
      showCoolSnackBar(
        context,
        'Failed to delete workout: ${e.toString()}',
        false,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, Workout workout) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.delete_outline, color: theme.colorScheme.error),
            const SizedBox(width: 12),
            const Text('Delete Workout'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to delete this workout?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: workout.workoutImage.isNotEmpty
                        ? Image.network(
                            workout.workoutImage,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 40,
                                height: 40,
                                color: Colors.grey.shade300,
                                child: const Icon(
                                  Icons.fitness_center,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              );
                            },
                          )
                        : Container(
                            width: 40,
                            height: 40,
                            color: Colors.grey.shade300,
                            child: const Icon(
                              Icons.fitness_center,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      workout.workoutName,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This action cannot be undone.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _deleteWorkout(context, workout);
            },
            icon: const Icon(Icons.delete_outline, size: 18),
            label: const Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  List<Workout> _filterWorkouts(List<Workout> workouts) {
    if (_searchQuery.isEmpty) return workouts;

    return workouts
        .where((workout) =>
            workout.workoutName
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            workout.description
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            workout.difficulty
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Manange Workouts",
        showBackButton: true,
      ),
      body: _isLoading
          ? const Center(child: CustomLoadingAnimation())
          : Consumer<WorkoutProvider>(
              builder: (context, workoutProvider, child) {
                if (workoutProvider.isLoading) {
                  return const Center(child: CustomLoadingAnimation());
                }

                if (workoutProvider.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.circleExclamation,
                          size: 60,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Failed to load workouts",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Please try again later",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => workoutProvider.fetchAllWorkouts(),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (workoutProvider.workouts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(70),
                          ),
                          child: FaIcon(
                            FontAwesomeIcons.dumbbell,
                            size: 60,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "No workouts available",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            "Create your first workout to start helping your clients with their fitness goals",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton.icon(
                          onPressed: () => context.pushNamed('createWorkout'),
                          icon: const Icon(Icons.add),
                          label: const Text('Create New Workout'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final filteredWorkouts =
                    _filterWorkouts(workoutProvider.workouts);

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search workouts...',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {
                                        _searchQuery = '';
                                      });
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                        ),
                      ),
                    ),

                    // Stats panel
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.primary.withBlue(
                                theme.colorScheme.primary.blue + 30,
                              ),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Workout Summary',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Trainer View',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatCard(
                                  context,
                                  Icons.fitness_center,
                                  workoutProvider.workouts.length.toString(),
                                  'Total Workouts',
                                ),
                                _buildStatCard(
                                  context,
                                  Icons.speed,
                                  _getDifficultyCount(
                                          workoutProvider.workouts, 'Easy')
                                      .toString(),
                                  'Easy',
                                ),
                                _buildStatCard(
                                  context,
                                  Icons.trending_up,
                                  _getDifficultyCount(workoutProvider.workouts,
                                          'Intermediate')
                                      .toString(),
                                  'Intermediate',
                                ),
                                _buildStatCard(
                                  context,
                                  Icons.local_fire_department,
                                  _getDifficultyCount(
                                          workoutProvider.workouts, 'Hard')
                                      .toString(),
                                  'Hard',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Workouts list header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            filteredWorkouts.length ==
                                    workoutProvider.workouts.length
                                ? 'All Workouts (${filteredWorkouts.length})'
                                : 'Results (${filteredWorkouts.length})',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => context.pushNamed('createWorkout'),
                            icon: const Icon(
                              Icons.add,
                              size: 18,
                              color: Colors.white,
                            ),
                            label: const Text('New'),
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  theme.colorScheme.primaryContainer,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Workouts list
                    Expanded(
                      child: filteredWorkouts.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.magnifyingGlass,
                                    size: 50,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No matching workouts',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Try a different search',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                              itemCount: filteredWorkouts.length,
                              itemBuilder: (context, index) {
                                final workout = filteredWorkouts[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Slidable(
                                    key: ValueKey(workout.workoutId),
                                    endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      extentRatio: 0.25,
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) =>
                                              _showDeleteConfirmationDialog(
                                                  context, workout),
                                          backgroundColor:
                                              theme.colorScheme.error,
                                          foregroundColor: Colors.white,
                                          icon: Icons.delete,
                                          label: 'Delete',
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(12),
                                            bottomRight: Radius.circular(12),
                                          ),
                                        ),
                                      ],
                                    ),
                                    child: _buildWorkoutCard(context, workout),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed('createWorkout'),
        backgroundColor: theme.colorScheme.primary,
        icon: const Icon(Icons.add),
        label: const Text('New Workout'),
      ),
    );
  }

  Widget _buildStatCard(
      BuildContext context, IconData icon, String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  int _getDifficultyCount(List<Workout> workouts, String difficulty) {
    return workouts.where((workout) => workout.difficulty == difficulty).length;
  }

  Widget _buildWorkoutCard(BuildContext context, Workout workout) {
    final theme = Theme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final exerciseCount = workout.workoutexercises?.length ?? 0;

    return Stack(
      children: [
        // Use the WorkoutListItem for UI consistency
        GestureDetector(
          onTap: () {
            context.pushNamed(
              'workoutDetail',
              queryParameters: {
                'workoutId': workout.workoutId.toString(),
              },
            );
          },
          child: Container(
            margin: const EdgeInsets.only(
                right: 8), // Add margin for delete button to show when sliding
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? theme.colorScheme.surface
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDarkMode
                      ? theme.colorScheme.onSurface.withOpacity(0.1)
                      : theme.colorScheme.onSurface.withOpacity(0.1),
                  width: 1.5,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Workout Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: workout.workoutImage.isNotEmpty
                          ? workout.workoutImage
                          : 'https://via.placeholder.com/150', // Placeholder for missing image
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 90,
                        height: 90,
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.dumbbell,
                            color: theme.colorScheme.primary.withOpacity(0.5),
                            size: 24,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 90,
                        height: 90,
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.dumbbell,
                            color: theme.colorScheme.primary.withOpacity(0.5),
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Workout Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workout.workoutName,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${workout.workoutexercises?.length} exercises',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDarkMode
                                ? Colors.white.withOpacity(0.6)
                                : Colors.black.withOpacity(0.6),
                          ),
                        ),
                        Row(
                          children: [
                            // Difficulty badge
                            Container(
                              margin: const EdgeInsets.only(top: 4, right: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getDifficultyColor(workout.difficulty)
                                    .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                workout.difficulty,
                                style: TextStyle(
                                  color:
                                      _getDifficultyColor(workout.difficulty),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            // Target muscle group
                            Expanded(
                              child: Text(
                                workout.targetMuscleGroup ?? "Full Body",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isDarkMode
                                      ? Colors.white.withOpacity(0.4)
                                      : Colors.black.withOpacity(0.4),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Right side actions
                  Row(
                    children: [
                      // Delete button (small version)
                      IconButton(
                        onPressed: () =>
                            _showDeleteConfirmationDialog(context, workout),
                        icon: Icon(
                          Icons.delete_outline,
                          color: theme.colorScheme.error,
                          size: 20,
                        ),
                      ),
                      // Arrow icon for visual accent
                      Icon(
                        Icons.arrow_forward_ios,
                        color: theme.primaryColor,
                        size: 16,
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildInfoChip(
  //   BuildContext context,
  //   IconData icon,
  //   String label,
  //   Color backgroundColor,
  //   Color iconColor,
  // ) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //     decoration: BoxDecoration(
  //       color: backgroundColor,
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Icon(
  //           icon,
  //           size: 14,
  //           color: iconColor,
  //         ),
  //         const SizedBox(width: 4),
  //         Text(
  //           label,
  //           style: TextStyle(
  //             fontSize: 12,
  //             fontWeight: FontWeight.w500,
  //             color: iconColor,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return Colors.green.shade600;
      case 'Intermediate':
        return Colors.orange.shade600;
      case 'Hard':
        return Colors.red.shade600;
      default:
        return Colors.blue.shade600;
    }
  }
}
