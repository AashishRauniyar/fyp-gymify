import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymify/utils/custom_appbar.dart';
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

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Workout Details',
        showBackButton: true,
      ),
      body: ChangeNotifierProvider(
        create: (_) => WorkoutProvider()..fetchWorkoutById(workoutId),
        child: Consumer<WorkoutProvider>(
          builder: (context, workoutProvider, child) {
            if (workoutProvider.selectedWorkout == null &&
                !workoutProvider.hasError) {
              return const Center(child: CustomLoadingAnimation());
            }

            if (workoutProvider.hasError) {
              return Center(
                child: Text(
                  'Error loading workout details.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              );
            }

            final workout = workoutProvider.selectedWorkout!;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Workout Image with Gradient Overlay
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                        child: Image.network(
                          workout.workoutImage,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 250,
                        ),
                      ),
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Text(
                          workout.workoutName,
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Description
                        Text(
                          workout.description,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Chips Section
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildInfoChip(
                              FontAwesomeIcons.dumbbell,
                              "Muscle Group",
                              workout.targetMuscleGroup,
                              theme,
                            ),
                            _buildInfoChip(
                              FontAwesomeIcons.solidStar,
                              "Difficulty",
                              workout.difficulty,
                              theme,
                            ),
                            _buildInfoChip(
                              FontAwesomeIcons.bullseye,
                              "Goal",
                              workout.goalType,
                              theme,
                            ),
                            _buildInfoChip(
                              FontAwesomeIcons.user,
                              "Level",
                              workout.fitnessLevel,
                              theme,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Exercises List Section
                        Text(
                          'Exercises',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: workout.workoutexercises?.length ?? 0,
                          itemBuilder: (context, index) {
                            final exercise = workout.workoutexercises?[index];
                            return GestureDetector(
                              onTap: () {
                                context.pushNamed('exerciseDetails',
                                    extra: exercise!.exercises!);
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                            exercise?.exercises?.exerciseName ??
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
                                              color: theme.colorScheme.onSurface
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

                        const SizedBox(height: 24),

                        // Start Workout Button
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
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
                            icon: const Icon(FontAwesomeIcons.play),
                            label: const Text(
                              'Start Workout',
                              style: TextStyle(fontSize: 18),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 24,
                              ),
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoChip(
      IconData icon, String label, String value, ThemeData theme) {
    return Chip(
      avatar: Icon(icon, size: 16, color: theme.colorScheme.primary),
      label: Text(
        "$label: $value",
        style: theme.textTheme.bodyMedium,
      ),
      backgroundColor: theme.colorScheme.surface,
      side: BorderSide(color: theme.colorScheme.primary),
    );
  }
}
