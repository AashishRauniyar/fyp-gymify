// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:gymify/models/workout_model.dart';
// import 'package:go_router/go_router.dart';

// class WorkoutListItem extends StatelessWidget {
//   final Workout workout;

//   const WorkoutListItem({super.key, required this.workout});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         context.pushNamed(
//           'workoutDetail',
//           queryParameters: {
//             'workoutId': workout.workoutId.toString(),
//           },
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 6),
//         decoration: BoxDecoration(
//           color: const Color(0xFF1A1A1A), // Dark background for card
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: Colors.white.withOpacity(0.1), // Subtle border
//             width: 1.5,
//           ),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Workout Image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(16),
//               child: Image.network(
//                 workout.workoutImage.isNotEmpty
//                     ? workout.workoutImage
//                     : 'https://via.placeholder.com/150', // Placeholder for missing image
//                 width: 90,
//                 height: 90,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(width: 12),

//             // Workout Details (Title + Exercises + Target Areas)
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     workout.workoutName,
//                     style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     '${workout.workoutexercises?.length} exercises',
//                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                           color: Colors.white.withOpacity(0.6),
//                         ),
//                   ),
//                   Text(
//                     workout.targetMuscleGroup,
//                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                           color: Colors.white.withOpacity(0.4),
//                         ),
//                   ),
//                 ],
//               ),
//             ),

//             // Blue Icon for Visual Accent
//             const Icon(
//               FontAwesomeIcons.clone, // Mimics the icon in the image
//               color: Colors.blue,
//               size: 22,
//             ),
//             const SizedBox(width: 10),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gymify/models/workout_model.dart';
import 'package:go_router/go_router.dart';

class WorkoutListItem extends StatelessWidget {
  final Workout workout;

  const WorkoutListItem({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        context.pushNamed(
          'workoutDetail',
          queryParameters: {
            'workoutId': workout.workoutId.toString(),
          },
        );
      },
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
              child: Image.network(
                workout.workoutImage.isNotEmpty
                    ? workout.workoutImage
                    : 'https://via.placeholder.com/150', // Placeholder for missing image
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),

            // Workout Details (Title + Exercises + Target Areas)
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
                  Text(
                    workout.targetMuscleGroup,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.4)
                          : Colors.black.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),

            // Blue Icon for Visual Accent
            const Icon(
              FontAwesomeIcons.clone, // Mimics the icon in the image
              color: Colors.blue,
              size: 22,
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
