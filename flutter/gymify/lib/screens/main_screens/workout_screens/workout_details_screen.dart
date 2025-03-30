import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:provider/provider.dart';
import 'package:gymify/screens/main_screens/workout_screens/workout_log_screen.dart';
import 'package:gymify/providers/workout_provider/workout_provider.dart';

class WorkoutDetailScreen extends StatelessWidget {
  final int workoutId;

  const WorkoutDetailScreen({super.key, required this.workoutId});

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
        create: (_) => WorkoutProvider()..fetchWorkoutById(workoutId),
        child: Consumer<WorkoutProvider>(
          builder: (context, workoutProvider, child) {
            if (workoutProvider.selectedWorkout == null &&
                !workoutProvider.hasError) {
              return const Center(child: CustomLoadingAnimation());
            }

            if (workoutProvider.hasError) {
              return SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
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
                        'We couldn\'t load this workout. It may have been deleted or is temporarily unavailable.',
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

            final workout = workoutProvider.selectedWorkout!;

            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    // Header with image and title
                    SliverAppBar(
                      expandedHeight: 300,
                      pinned: true,
                      stretch: true,
                      backgroundColor: theme.colorScheme.primary,
                      leading: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
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
                            // Workout image
                            CachedNetworkImage(
                              imageUrl: workout.workoutImage,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color:
                                    theme.colorScheme.primary.withOpacity(0.2),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color:
                                    theme.colorScheme.primary.withOpacity(0.2),
                                child: const Icon(Icons.image_not_supported,
                                    size: 50),
                              ),
                            ),
                            // Gradient overlay for better text visibility
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.7),
                                  ],
                                  stops: const [0.5, 1.0],
                                ),
                              ),
                            ),
                            // Workout information overlay
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Level badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _getDifficultyColor(
                                            workout.difficulty),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        workout.difficulty.toUpperCase(),
                                        style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // Workout title
                                    Text(
                                      workout.workoutName,
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
                                          workout.targetMuscleGroup,
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
                                          "${workout.workoutexercises?.length ?? 0} exercises",
                                          style: const TextStyle(
                                            fontSize: 14,
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
                                  'GOAL',
                                  workout.goalType,
                                  FontAwesomeIcons.bullseye,
                                  theme,
                                ),
                                _buildInfoElement(
                                  'LEVEL',
                                  workout.fitnessLevel,
                                  FontAwesomeIcons.userGroup,
                                  theme,
                                ),
                                _buildInfoElement(
                                  'FOCUS',
                                  _getWorkoutFocus(workout.targetMuscleGroup),
                                  FontAwesomeIcons.crosshairs,
                                  theme,
                                ),
                              ],
                            ),
                          ),

                          // Workout description
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'About This Workout',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  workout.description,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    height: 1.6,
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.8),
                                  ),
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
                                    '${workout.workoutexercises?.length ?? 0} total',
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

                          // Exercise list (with the original design as requested)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            itemCount: workout.workoutexercises?.length ?? 0,
                            itemBuilder: (context, index) {
                              final exercise = workout.workoutexercises?[index];
                              return GestureDetector(
                                onTap: () {
                                  context.pushNamed('exerciseDetails',
                                      extra: exercise!.exercises!);
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.1),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Exercise Image
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: CachedNetworkImage(
                                          imageUrl: exercise
                                                  ?.exercises?.imageUrl ??
                                              'https://via.placeholder.com/150',
                                          width: 90,
                                          height: 90,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // Exercise Details (Title + Sets/Reps/Duration)
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              exercise?.exercises
                                                      ?.exerciseName ??
                                                  'Unknown Exercise',
                                              style: theme.textTheme.bodyLarge
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Sets: ${exercise?.sets}, Reps: ${exercise?.reps}, Duration: ${exercise?.duration}s',
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                color: theme
                                                    .colorScheme.onSurface
                                                    .withOpacity(0.6),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Blue Icon for Visual Accent
                                      const Icon(
                                        FontAwesomeIcons.chevronRight,
                                        size: 16,
                                        color: Colors.blue,
                                      ),
                                      const SizedBox(width: 12),
                                    ],
                                  ),
                                ),
                              );
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
                                builder: (context) => ExerciseLogScreen(
                                  workoutId: workout.workoutId,
                                  exercises: workout.workoutexercises ?? [],
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

  // Get appropriate color based on difficulty
  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      case 'expert':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  // Get simplified focus area
  String _getWorkoutFocus(String muscleGroup) {
    final lowercaseMuscle = muscleGroup.toLowerCase();

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
        lowercaseMuscle.contains('total')) {
      return 'Full Body';
    } else {
      return 'Specialized';
    }
  }
}
