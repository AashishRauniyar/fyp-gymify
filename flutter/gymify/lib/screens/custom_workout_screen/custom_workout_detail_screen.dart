// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:gymify/colors/custom_colors.dart';
// import 'package:gymify/providers/custom_workout_provider/custom_workout_provider.dart';
// import 'package:gymify/utils/custom_loader.dart';
// import 'package:provider/provider.dart';

// class CustomWorkoutDetailScreen extends StatelessWidget {
//   final int customWorkoutId;

//   const CustomWorkoutDetailScreen({super.key, required this.customWorkoutId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new_sharp,
//               color: Color(0xFFFF5E3A)),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: ChangeNotifierProvider(
//         create: (_) => CustomWorkoutProvider()
//           ..getCustomWorkoutExercisesById(customWorkoutId),
//         child: Consumer<CustomWorkoutProvider>(
//           builder: (context, customWorkoutProvider, child) {
//             if (customWorkoutProvider.selectedCustomWorkout == null &&
//                 !customWorkoutProvider.hasError) {
//               return const Center(child: CustomLoadingAnimation());
//             }

//             if (customWorkoutProvider.hasError) {
//               return const Center(
//                 child: Text(
//                   'Error loading custom workout details.',
//                   style: TextStyle(color: Colors.red, fontSize: 16),
//                 ),
//               );
//             }

//             final workout = customWorkoutProvider.selectedCustomWorkout!;

//             return SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Custom Workout Name Header
//                     Stack(
//                       children: [
//                         Container(
//                           height: 220,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             color: CustomColors.primaryShade2,
//                             borderRadius:
//                                 const BorderRadius.all(Radius.circular(24)),
//                           ),
//                           alignment: Alignment.center,
//                           child: Text(
//                             workout.customWorkoutName,
//                             style: GoogleFonts.poppins(
//                               fontSize: 28,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ],
//                     ),

//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Description Section
//                           Text(
//                             'Description: No description available.', // Add description field if available
//                             style: GoogleFonts.poppins(
//                               fontSize: 16,
//                               color: Colors.grey[700],
//                             ),
//                           ),
//                           const SizedBox(height: 16),

//                           // Exercises List Section
//                           Text(
//                             'Exercises:',
//                             style: GoogleFonts.poppins(
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                               color: CustomColors.primary,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           ListView.builder(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             itemCount: workout.customworkoutexercises.length,
//                             itemBuilder: (context, index) {
//                               final exercise =
//                                   workout.customworkoutexercises[index];
//                               return GestureDetector(
//                                 onTap: () {
//                                   //TODO: Implement action (if needed)
//                                   context.pushNamed('exerciseDetails',
//                                       extra: exercise.exercises);
//                                 },
//                                 child: Card(
//                                   margin:
//                                       const EdgeInsets.symmetric(vertical: 8.0),
//                                   elevation: 4,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: ListTile(
//                                     contentPadding: const EdgeInsets.all(12.0),
//                                     leading: CircleAvatar(
//                                       backgroundColor:
//                                           CustomColors.primaryShade2,
//                                       backgroundImage: NetworkImage(
//                                         exercise.exercises.imageUrl,
//                                       ),
//                                     ),
//                                     title: Text(
//                                       exercise.exercises.exerciseName,
//                                       style: GoogleFonts.poppins(
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     subtitle: Text(
//                                       'Sets: ${exercise.sets}, Reps: ${exercise.reps}, Duration: ${exercise.duration} mins',
//                                       style: GoogleFonts.poppins(
//                                         color: Colors.grey[600],
//                                       ),
//                                     ),
//                                     trailing: const Icon(
//                                         Icons.arrow_forward_ios,
//                                         size: 18,
//                                         color: Colors.grey),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),

//                           const SizedBox(height: 24),

//                           // Start Workout Button (Optional)
//                           Center(
//                             child: ElevatedButton.icon(
//                               onPressed: () {

//                               },
//                               icon: const Icon(Icons.play_circle_fill),
//                               label: const Text(
//                                 'Start Custom Workout',
//                                 style: TextStyle(fontSize: 18),
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: 12, horizontal: 24),
//                                 backgroundColor: CustomColors.primary,
//                                 foregroundColor: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymify/providers/custom_workout_provider/custom_workout_provider.dart';
import 'package:gymify/utils/custom_button.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:provider/provider.dart';

class CustomWorkoutDetailScreen extends StatelessWidget {
  final int customWorkoutId;

  const CustomWorkoutDetailScreen({super.key, required this.customWorkoutId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
              return Center(
                child: Text(
                  'Error loading custom workout details.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              );
            }

            final workout = customWorkoutProvider.selectedCustomWorkout!;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Custom Workout Header with Gradient Overlay
                  Stack(
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/exercise.jpeg'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            workout.customWorkoutName,
                            style: theme.textTheme.headlineLarge?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
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
                        const SizedBox(height: 16),

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
                          itemCount: workout.customworkoutexercises.length,
                          itemBuilder: (context, index) {
                            final exercise =
                                workout.customworkoutexercises[index];
                            return GestureDetector(
                              onTap: () {
                                context.pushNamed('exerciseDetails',
                                    extra: exercise.exercises);
                              },
                              child: Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(12.0),
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        theme.colorScheme.primaryContainer,
                                    backgroundImage: NetworkImage(
                                      exercise.exercises.imageUrl,
                                    ),
                                  ),
                                  title: Text(
                                    exercise.exercises.exerciseName,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Sets: ${exercise.sets}, Reps: ${exercise.reps}, Duration: ${exercise.duration} mins',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: CustomButton(
            text: "Start Custom Workout",
            onPressed: () {
              final workoutProvider =
                  Provider.of<CustomWorkoutProvider>(context, listen: false);
              final workout = workoutProvider.selectedCustomWorkout;

              // Navigator.push(
              //                       context,
              //                       MaterialPageRoute(
              //                         builder: (context) => ExerciseLogScreen(
              //                           workoutId:  workout!.customWorkoutId ,
              //                           exercises: workout.customworkoutexercises,
              //                         ),
              //                       ),
              //                     );
            }),
      ),
    );
  }
}
