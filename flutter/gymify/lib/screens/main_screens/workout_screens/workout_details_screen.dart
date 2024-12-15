import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymify/colors/custom_colors.dart';
import 'package:gymify/screens/exercise_screen.dart';
import 'package:gymify/screens/main_screens/workout_screens/workout_log_screen.dart';
import 'package:provider/provider.dart';
import 'package:gymify/providers/workout_provider/workout_provider.dart';

class WorkoutDetailScreen extends StatelessWidget {
  final int workoutId;

  const WorkoutDetailScreen({super.key, required this.workoutId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Workout Details',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: CustomColors.primary,
        centerTitle: true,
      ),
      body: ChangeNotifierProvider(
        create: (_) => WorkoutProvider()..fetchWorkoutById(workoutId),
        child: Consumer<WorkoutProvider>(
          builder: (context, workoutProvider, child) {
            if (workoutProvider.selectedWorkout == null &&
                !workoutProvider.hasError) {
              return const Center(child: CircularProgressIndicator());
            }

            if (workoutProvider.hasError) {
              return const Center(
                child: Text(
                  'Error loading workout details.',
                  style: TextStyle(color: Colors.red, fontSize: 16),
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
                          height: 220,
                        ),
                      ),
                      Container(
                        height: 220,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent
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
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Chips Section
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildInfoChip(
                                "Muscle Group", workout.targetMuscleGroup),
                            _buildInfoChip("Difficulty", workout.difficulty),
                            _buildInfoChip("Goal", workout.goalType),
                            _buildInfoChip("Level", workout.fitnessLevel),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Exercises List Section
                        Text(
                          'Exercises:',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.primary,
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
                                // Navigate to ExerciseDetailScreen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ExerciseDetailScreen(
                                      exercise: exercise!.exercises!,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(12.0),
                                  leading: CircleAvatar(
                                    backgroundColor: CustomColors.primaryShade2,
                                    child: const Icon(Icons.fitness_center,
                                        color: Colors.white),
                                  ),
                                  title: Text(
                                    exercise?.exercises?.exerciseName ??
                                        'Unknown Exercise',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Sets: ${exercise?.sets}, Reps: ${exercise?.reps}, Duration: ${exercise?.duration}s',
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  trailing: const Icon(Icons.arrow_forward_ios,
                                      size: 18, color: Colors.grey),
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
                            icon: const Icon(Icons.play_circle_fill),
                            label: const Text(
                              'Start Workout',
                              style: TextStyle(fontSize: 18),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                              backgroundColor: CustomColors.primary,
                              foregroundColor: Colors.white,
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

  // Improved Chip Styling
  Widget _buildInfoChip(String label, String value) {
    return Chip(
      label: Text(
        "$label: $value",
        style: GoogleFonts.poppins(fontSize: 12),
      ),
      backgroundColor: CustomColors.primaryShade2.withOpacity(0.2),
      side: BorderSide(color: CustomColors.primaryShade2),
    );
  }
}
