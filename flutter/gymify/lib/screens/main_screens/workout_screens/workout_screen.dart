import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/models/custom_workout_model.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:provider/provider.dart';
import 'package:gymify/providers/custom_workout_provider/custom_workout_provider.dart';
import 'package:gymify/providers/workout_provider/workout_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WorkoutListScreen extends StatefulWidget {
  const WorkoutListScreen({super.key});

  @override
  _WorkoutListScreenState createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> {
  final String _searchQuery = '';
  bool _isRefreshing = false;

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    try {
      await Future.wait([
        context.read<WorkoutProvider>().fetchAllWorkouts(),
        context.read<CustomWorkoutProvider>().fetchCustomWorkouts(),
      ]);
    } finally {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Workouts',
        showBackButton: false,
        actions: [
          // IconButton(
          //   icon: Icon(Icons.refresh, color: theme.colorScheme.onSurface),
          //   onPressed: _refreshData,
          // ),
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
            if ((workoutProvider.isLoading ||
                    customWorkoutProvider.isLoading) &&
                !_isRefreshing) {
              return const Center(child: CustomLoadingAnimation());
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

            if (filteredDefaultWorkouts.isEmpty &&
                filteredCustomWorkouts.isEmpty &&
                !_isRefreshing) {
              return _buildEmptyState(context);
            }

            return RefreshIndicator(
              onRefresh: _refreshData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildSearchBar(theme),
                      const SizedBox(height: 24),
                      if (filteredDefaultWorkouts.isNotEmpty)
                        _buildDefaultWorkoutsSection(
                            filteredDefaultWorkouts, theme),
                      if (filteredCustomWorkouts.isNotEmpty)
                        _buildCustomWorkoutsSection(
                            filteredCustomWorkouts, theme),
                      const SizedBox(height: 24),
                      _buildExploreExercisesSection(theme),
                      const SizedBox(height: 24),
                      _buildCreateWorkoutPlanSection(theme),
                      const SizedBox(height: 24),
                      _buildWorkoutCategoriesSection(theme, workoutProvider),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        onPressed: () {
          context.pushNamed('createCustomWorkout');
        },
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
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
            fillColor:
                theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            hintStyle:
                TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center,
            size: 64,
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'No workouts available',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Pull down to refresh or create your own workout',
            style:
                TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              context.pushNamed('createCustomWorkout');
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Workout'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomWorkoutsSection(
      List<dynamic> customWorkouts, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Workouts',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                context.pushNamed('customWorkout');
              },
              // icon: const Icon(Icons.visibility),
              label: const Text('See All'),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: customWorkouts.length.clamp(0, 5),
            itemBuilder: (context, index) {
              final workout = customWorkouts[index];
              return _buildCustomWorkoutCard(workout, theme);
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCustomWorkoutCard(dynamic workout, ThemeData theme) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: () {
          context.pushNamed(
            'customWorkoutDetail',
            queryParameters: {
              'id': workout.customWorkoutId.toString(),
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Creator badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'CUSTOM',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              // Workout name
              Text(
                workout.customWorkoutName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              // Stats
              Row(
                children: [
                  const Icon(Icons.fitness_center,
                      size: 14, color: Colors.white70),
                  const SizedBox(width: 4),
                  Text(
                    '${workout.customworkoutexercises.length} exercises', // Fixed property name here
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.access_time,
                      size: 14, color: Colors.white70),
                  const SizedBox(width: 4),
                  Text(
                    '~${_calculateEstimatedDuration(workout)} min', // Added a function to calculate duration
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Add this helper method to calculate the estimated duration
  String _calculateEstimatedDuration(CustomWorkoutModel workout) {
    // This assumes you have a duration property in your customworkoutexercises
    // If not, you can use a default value or calculate based on exercises count
    double totalDuration = 0;

    for (var exercise in workout.customworkoutexercises) {
      // Parse the duration string, assuming it's in minutes
      final exerciseDuration = double.tryParse(exercise.duration) ?? 0;
      // Add the duration for this exercise
      totalDuration += exerciseDuration * exercise.sets;
    }

    // If no exercises or duration is 0, return a default value
    if (totalDuration == 0) {
      return workout.customworkoutexercises.isNotEmpty
          ? '${workout.customworkoutexercises.length * 5}' // Rough estimate: 5 min per exercise
          : '0';
    }

    return totalDuration.toStringAsFixed(0);
  }

  Widget _buildDefaultWorkoutsSection(
      List<dynamic> defaultWorkouts, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // Add this to prevent expansion
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Workouts',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  context.pushNamed('allWorkouts');
                },
                // icon: const Icon(Icons.visibility, size: 16),
                label: const Text('See All', style: TextStyle(fontSize: 13)),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 0), // Reduced vertical padding
                  minimumSize: Size.zero,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6), // Reduced from 8
        SizedBox(
          height: 198, // Reduced from 200
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: defaultWorkouts.length.clamp(0, 5),
            padding: const EdgeInsets.only(bottom: 2), // Reduced padding
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final workout = defaultWorkouts[index];
              return _buildDefaultWorkoutCard(workout, theme);
            },
          ),
        ),
        const SizedBox(height: 10), // Reduced from 12
      ],
    );
  }

  Widget _buildDefaultWorkoutCard(dynamic workout, ThemeData theme) {
    return Container(
      width: 190,
      height: 194, // Reduced from 196
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        margin: EdgeInsets.zero, // Remove built-in Card margin
        elevation: 4,
        shadowColor: theme.colorScheme.shadow.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            context.pushNamed(
              'workoutDetail',
              queryParameters: {
                'workoutId': workout.workoutId.toString(),
              },
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Workout image
              SizedBox(
                height: 108, // Reduced from 110
                width: double.infinity,
                child: workout.workoutImage.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: workout.workoutImage,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          child: const Icon(Icons.image, size: 40),
                        ),
                      )
                    : Image.asset(
                        'assets/images/workout_image/defaultWorkoutImage.jpg',
                        fit: BoxFit.cover,
                      ),
              ),
              // Workout details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Fitness level badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1), // Further reduced
                        decoration: BoxDecoration(
                          color: _getLevelColor(workout.fitnessLevel)
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          workout.fitnessLevel.toUpperCase(),
                          style: TextStyle(
                            color: _getLevelColor(workout.fitnessLevel),
                            fontSize: 8, // Reduced from 9
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3), // Reduced from 4
                      // Workout name
                      Text(
                        workout.workoutName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      // Target muscle group
                      Row(
                        children: [
                          Icon(
                            Icons.fitness_center,
                            size: 12,
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              workout.targetMuscleGroup,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.6),
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
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

  Color _getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  Widget _buildExploreExercisesSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Explore Exercises',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            context.pushNamed('exercises');
          },
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: const AssetImage('assets/images/exercise.jpeg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5),
                  BlendMode.darken,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Browse Exercise Library',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Find new exercises for your workouts',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
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
      ],
    );
  }

  Widget _buildCreateWorkoutPlanSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create Your Own',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            context.pushNamed('customWorkout');
          },
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Choose font size based on available width
                        final titleFontSize =
                            constraints.maxWidth < 300 ? 16.0 : 20.0;
                        final subtitleFontSize =
                            constraints.maxWidth < 300 ? 12.0 : 14.0;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Design Your Workout Plan',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: titleFontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Build custom routines tailored to your goals',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: subtitleFontSize,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWorkoutCategoriesSection(
      ThemeData theme, WorkoutProvider provider) {
    // Extract unique muscle groups
    final muscleGroups = <String>{};
    for (var workout in provider.workouts) {
      muscleGroups.add(workout.targetMuscleGroup);
    }

    // Featured categories
    final featuredCategories = [
      {
        'name': 'Full Body',
        'icon': Icons.accessibility_new,
        'color': Colors.purple
      },
      {'name': 'Chest', 'icon': Icons.fitness_center, 'color': Colors.red},
      {'name': 'Back', 'icon': Icons.fitness_center, 'color': Colors.blue},
      {'name': 'Legs', 'icon': Icons.fitness_center, 'color': Colors.green},
      {'name': 'Arms', 'icon': Icons.fitness_center, 'color': Colors.orange},
      {'name': 'Core', 'icon': Icons.fitness_center, 'color': Colors.amber},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.5,
          ),
          itemCount: featuredCategories.length,
          itemBuilder: (context, index) {
            final category = featuredCategories[index];
            return _buildCategoryCard(
              name: category['name'] as String,
              icon: category['icon'] as IconData,
              color: category['color'] as Color,
              theme: theme,
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoryCard({
    required String name,
    required IconData icon,
    required Color color,
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: () {
        // Navigate to filtered search results
        // context.pushNamed(
        //   'workoutSearch',
        //   queryParameters: {'filter': name},
        // );
        context.pushNamed(
          'exercises',
          queryParameters: {'filter': name},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color.withOpacity(0.1),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.2),
              ),
              padding: const EdgeInsets.all(6),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
