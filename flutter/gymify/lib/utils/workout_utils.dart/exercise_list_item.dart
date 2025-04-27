import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymify/models/exercise_model.dart';

class ExerciseTile extends StatelessWidget {
  final Exercise exercise;

  const ExerciseTile({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        context.pushNamed(
          'exerciseDetails',
          extra: exercise,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
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
            // Exercise Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                exercise.imageUrl.isNotEmpty
                    ? exercise.imageUrl
                    : 'https://via.placeholder.com/150', // Placeholder for missing image
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),

            // Exercise Details (Title + Target Muscle Group)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.exerciseName,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Target: ${exercise.targetMuscleGroup}",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.6)
                          : Colors.black.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),

            // Icon for Visual Accent
            Icon(
              Icons.arrow_forward_ios, // Icon related to exercise
              color: theme
                  .colorScheme.primary, // Change to your custom primary color
              size: 22,
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
