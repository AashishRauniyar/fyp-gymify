import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/colors/custom_colors.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:provider/provider.dart';
import 'package:gymify/providers/custom_workout_provider/custom_workout_provider.dart';
import 'package:gymify/providers/workout_provider/workout_provider.dart';

class WorkoutListScreen extends StatefulWidget {
  const WorkoutListScreen({super.key});

  @override
  _WorkoutListScreenState createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Workouts',
        showBackButton: false,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: theme.colorScheme.primary),
            onPressed: () {
              context.pushNamed('createCustomWorkout');
            },
          ),
        ],
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
                    _buildSearchBar(theme),
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
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) =>
                                        //         WorkoutDetailScreen(
                                        //             workoutId:
                                        //                 workout.workoutId),
                                        //   ),
                                        // );
                                        context.pushNamed(
                                          'workoutDetail',
                                          queryParameters: {
                                            'workoutId':
                                                workout.workoutId.toString(),
                                          },
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
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Hero(
      tag: 'searchBar',
      child: Material(
        color: Colors.transparent,
        child: TextField(
          readOnly: true, // Prevent keyboard from appearing
          onTap: () {
            // When tapped, navigate to the search screen with a smooth Hero animation.
            context.pushNamed('workoutSearch');
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
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
    );
  }
}
