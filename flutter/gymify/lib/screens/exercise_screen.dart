// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:gymify/models/exercise_model.dart';
// import 'package:gymify/providers/exercise_provider/exercise_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:video_player/video_player.dart';

// class ExerciseScreen extends StatefulWidget {
//   const ExerciseScreen({super.key});

//   @override
//   State<ExerciseScreen> createState() => _ExerciseScreenState();
// }

// class _ExerciseScreenState extends State<ExerciseScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch all exercises when the screen is loaded
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // Fetch exercises from provider
//       context.read<ExerciseProvider>().fetchAllExercises();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Exercises',
//             style: TextStyle(fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.greenAccent,
//         leading: IconButton(
//           onPressed: () {
//             context.pop();
//           },
//           icon: const Icon(Icons.arrow_back),
//         ),
//       ),
//       body: Consumer<ExerciseProvider>(
//         builder: (context, exerciseProvider, child) {
//           // Check if exercises are still being loaded
//           if (exerciseProvider.exercises.isEmpty) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ListView.builder(
//               itemCount: exerciseProvider.exercises.length,
//               itemBuilder: (context, index) {
//                 final exercise = exerciseProvider.exercises[index];

//                 return ExerciseCard(exercise: exercise);
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// } // Add video player package for video support

// class ExerciseCard extends StatefulWidget {
//   final Exercise exercise;

//   const ExerciseCard({required this.exercise});

//   @override
//   _ExerciseCardState createState() => _ExerciseCardState();
// }

// class _ExerciseCardState extends State<ExerciseCard> {
//   VideoPlayerController? _videoController;

//   @override
//   void initState() {
//     super.initState();

//     // Initialize video player if video URL exists
//     if (widget.exercise.videoUrl.isNotEmpty) {
//       _videoController = VideoPlayerController.network(widget.exercise.videoUrl)
//         ..initialize().then((_) {
//           setState(() {});
//         });
//     }
//   }

//   @override
//   void dispose() {
//     // Dispose of the video controller when not needed
//     if (_videoController != null) {
//       _videoController!.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 5,
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Exercise Name
//             Text(
//               widget.exercise.exerciseName,
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 8),
//             // Exercise Description
//             Text(
//               widget.exercise.description,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[700],
//               ),
//             ),
//             const SizedBox(height: 10),
//             // Display Image if available
//             if (widget.exercise.imageUrl.isNotEmpty)
//               Image.network(
//                 widget.exercise.imageUrl,
//                 height: 200,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             const SizedBox(height: 10),
//             // Display Video if available
//             if (widget.exercise.videoUrl.isNotEmpty && _videoController != null)
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 color: Colors.black,
//                 child: Column(
//                   children: [
//                     _videoController!.value.isInitialized
//                         ? AspectRatio(
//                             aspectRatio: _videoController!.value.aspectRatio,
//                             child: VideoPlayer(_videoController!),
//                           )
//                         : const CircularProgressIndicator(),
//                     IconButton(
//                       icon: Icon(
//                         _videoController!.value.isPlaying
//                             ? Icons.pause
//                             : Icons.play_arrow,
//                         color: Colors.white,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           if (_videoController!.value.isPlaying) {
//                             _videoController!.pause();
//                           } else {
//                             _videoController!.play();
//                           }
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             const SizedBox(height: 10),
//             // Category (example: Strength)
//             const Row(
//               children: [
//                 Icon(
//                   Icons.fitness_center,
//                   color: Colors.greenAccent,
//                 ),
//                 SizedBox(width: 5),
//                 Text(
//                   'Strength', // You can use the exercise category here
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.greenAccent,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             // Action buttons (Add to favorites)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.favorite_border, color: Colors.redAccent),
//                   onPressed: () {
//                     // Implement add to favorites functionality
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymify/colors/custom_colors.dart';
import 'package:gymify/models/exercise_model.dart';
import 'package:gymify/providers/exercise_provider/exercise_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExerciseProvider>().fetchAllExercises();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'Exercises',
      //     style: GoogleFonts.poppins(
      //       fontSize: 20,
      //       fontWeight: FontWeight.bold,
      //       color: CustomColors.secondary,
      //     ),
      //   ),
      //   backgroundColor: CustomColors.backgroundColor,
      //   centerTitle: true,
      // ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Exercises",
          style: TextStyle(
            color: CustomColors.secondary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_sharp,
              color: Color(0xFFFF5E3A)),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop(); // Navigate back to the previous page
            } else {
              context
                  .pop(); // Navigate to the welcome page if there's nothing to pop
            }
          },
        ),
      ),
      body: Consumer<ExerciseProvider>(
        builder: (context, exerciseProvider, child) {
          if (exerciseProvider.exercises.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: exerciseProvider.exercises.length,
            itemBuilder: (context, index) {
              final exercise = exerciseProvider.exercises[index];
              return ExerciseTile(exercise: exercise);
            },
          );
        },
      ),
    );
  }
}

class ExerciseTile extends StatelessWidget {
  final Exercise exercise;

  const ExerciseTile({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseDetailScreen(exercise: exercise),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12.0),
          title: Text(
            exercise.exerciseName,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: CustomColors.primary,
            ),
          ),
          subtitle: Text(
            "Target: ${exercise.targetMuscleGroup}",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          trailing: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(exercise.imageUrl),
            backgroundColor: Colors.grey[200],
          ),
        ),
      ),
    );
  }
}

class ExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  VideoPlayerController? _videoController;
  bool _showVideo = false; // Toggle for video player visibility

  @override
  void initState() {
    super.initState();
    if (widget.exercise.videoUrl.isNotEmpty) {
      _videoController = VideoPlayerController.network(widget.exercise.videoUrl)
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.exercise.exerciseName,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: CustomColors.primary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.exercise.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Exercise Name
            Text(
              widget.exercise.exerciseName,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: CustomColors.primary,
              ),
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              widget.exercise.description,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),

            // Duration and Target Muscle
            Row(
              children: [
                Icon(Icons.timer, color: CustomColors.primaryCompliment),
                const SizedBox(width: 8),
                Text(
                  "Calories Burned: ${widget.exercise.caloriesBurnedPerMinute} kcal/min",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.fitness_center, color: CustomColors.accent),
                const SizedBox(width: 8),
                Text(
                  "Target Muscle: ${widget.exercise.targetMuscleGroup}",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Toggle Button for Tutorial/Video
            Text(
              "Tutorial Video",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: CustomColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            if (!_showVideo)
              Container(
                decoration: BoxDecoration(
                  color: CustomColors.primaryShade2.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: CustomColors.primary, width: 1),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Learn the correct form and technique for ${widget.exercise.exerciseName}. Watch the video tutorial for detailed guidance.",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showVideo = true; // Show video player
                        });
                      },
                      icon: const Icon(Icons.play_circle_fill, size: 24),
                      label: const Text("Play Video"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (_showVideo)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          VideoPlayer(_videoController!),
                          IconButton(
                            icon: Icon(
                              _videoController!.value.isPlaying
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_fill,
                              color: Colors.white.withOpacity(0.9),
                              size: 64,
                            ),
                            onPressed: () {
                              setState(() {
                                if (_videoController!.value.isPlaying) {
                                  _videoController!.pause();
                                } else {
                                  _videoController!.play();
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
