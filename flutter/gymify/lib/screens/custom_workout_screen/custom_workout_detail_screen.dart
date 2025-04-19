import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymify/providers/custom_workout_provider/custom_workout_provider.dart';
import 'package:gymify/screens/custom_workout_screen/custom_workout_log_screen.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:gymify/utils/workout_utils.dart/exercise_list_item.dart';
import 'package:provider/provider.dart';

class CustomWorkoutDetailScreen extends StatelessWidget {
  final int customWorkoutId;

  const CustomWorkoutDetailScreen({super.key, required this.customWorkoutId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Set system UI overlay style for immersive experience
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: theme.scaffoldBackgroundColor,
    ));

    return Scaffold(
      body: ChangeNotifierProvider(
        create: (_) => CustomWorkoutProvider()
          ..getCustomWorkoutExercisesById(customWorkoutId),
        child: Consumer<CustomWorkoutProvider>(
          builder: (context, customWorkoutProvider, child) {
            if (customWorkoutProvider.selectedCustomWorkout == null &&
                !customWorkoutProvider.hasError) {
              return const Center(child: CustomLoadingAnimation());
            }

            if (customWorkoutProvider.hasError) {
              return SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 70,
                      color: theme.colorScheme.error.withOpacity(0.5),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Workout Not Found',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'We couldn\'t load this custom workout. It may have been deleted or is temporarily unavailable.',
                        style: theme.textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios),
                      label: const Text('Go Back'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                      ),
                    ),
                  ],
                ),
              );
            }

            final workout = customWorkoutProvider.selectedCustomWorkout!;
            // Get unique muscle groups from exercises for display
            final targetMuscleGroups =
                _getUniqueTargetMuscleGroups(workout.customworkoutexercises);

            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    // Header with gradient and title
                    SliverAppBar(
                      expandedHeight: 220,
                      pinned: true,
                      stretch: true,
                      backgroundColor: theme.colorScheme.primary,
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
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Gradient background
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    theme.colorScheme.primary,
                                    theme.colorScheme.primary.withBlue(
                                      (theme.colorScheme.primary.blue + 40)
                                          .clamp(0, 255),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Background pattern for visual interest
                            Opacity(
                              opacity: 0.1,
                              child: Image.network(
                                'https://www.transparenttextures.com/patterns/cubes.png',
                                repeat: ImageRepeat.repeat,
                              ),
                            ),

                            // Workout information overlay
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Workout type badge
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
                                    const SizedBox(height: 10),
                                    const Text("Custom : "),
                                    // Workout title
                                    Text(
                                      workout.customWorkoutName,
                                      style: GoogleFonts.poppins(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Target area and exercise count
                                    Row(
                                      children: [
                                        const Icon(
                                          FontAwesomeIcons.dumbbell,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          targetMuscleGroups,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        const Icon(
                                          FontAwesomeIcons.listCheck,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${workout.customworkoutexercises.length} exercises',
                                          style: const TextStyle(
                                            color: Colors.white,
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

                    // Workout content
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Quick info bar
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildInfoElement(
                                  'CREATED',
                                  _formatDate(workout.createdAt),
                                  FontAwesomeIcons.calendar,
                                  theme,
                                ),
                                _buildInfoElement(
                                  'FOCUS',
                                  _getWorkoutFocus(targetMuscleGroups),
                                  FontAwesomeIcons.crosshairs,
                                  theme,
                                ),
                                _buildInfoElement(
                                  'EXERCISES',
                                  workout.customworkoutexercises.length
                                      .toString(),
                                  FontAwesomeIcons.listCheck,
                                  theme,
                                ),
                              ],
                            ),
                          ),

                          // Divider
                          Divider(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.1)),

                          // Exercises section
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Exercises',
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
                                    '${workout.customworkoutexercises.length} total',
                                    style: TextStyle(
                                      color:
                                          theme.colorScheme.onPrimaryContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Exercise list with enhanced style
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 8),
                            itemCount: workout.customworkoutexercises.length,
                            itemBuilder: (context, index) {
                              final exerciseData =
                                  workout.customworkoutexercises[index];
                              return ExerciseTile(
                                  exercise: exerciseData.exercises);
                            },
                          ),

                          // Extra space for FAB
                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ],
                ),

                // START WORKOUT button positioned at the bottom
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomWorkoutLogScreen(
                                  customWorkoutId: workout.customWorkoutId,
                                  exercises: workout.customworkoutexercises,
                                  workoutName: workout.customWorkoutName,
                                ),
                              ),
                            );
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
                                  FontAwesomeIcons.play,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'START WORKOUT',
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

  Widget _buildInfoElement(
      String label, String value, IconData icon, ThemeData theme) {
    return Column(
      children: [
        Icon(
          icon,
          size: 22,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Removed _buildExerciseTile as we're now using the provided ExerciseTile component

  // Helper methods
  String _getUniqueTargetMuscleGroups(List<dynamic> exercises) {
    // Extract unique muscle groups from all exercises
    final Set<String> muscleGroups = {};
    for (final exercise in exercises) {
      if (exercise.exercises != null &&
          exercise.exercises.targetMuscleGroup != null) {
        muscleGroups.add(exercise.exercises.targetMuscleGroup);
      }
    }

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
