// import 'package:flutter/material.dart';
// import 'package:gymify/providers/exercise_provider/exercise_provider.dart';
// import 'package:provider/provider.dart';

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
//         actions: [
//           IconButton(
//             icon: Icon(Icons.search),
//             onPressed: () {
//               // Implement search functionality (future feature)
//             },
//           ),
//         ],
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
// }

// // Custom Card to Display Each Exercise
// class ExerciseCard extends StatelessWidget {
//   final exercise;

//   const ExerciseCard({required this.exercise});

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
//               exercise.exerciseName,
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 8),
//             // Exercise Description
//             Text(
//               exercise.description,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[700],
//               ),
//             ),
//             const SizedBox(height: 10),
//             // Example of adding more details like a category (could be strength, flexibility, etc.)
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
//             // A simple action button or icon (e.g., Add to favorites)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.favorite_border, color: Colors.redAccent),
//                   onPressed: () {
//                     // Implement adding to favorites (optional)
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
import 'package:gymify/models/exercise_model.dart';
import 'package:gymify/providers/exercise_provider/exercise_provider.dart';
import 'package:gymify/routes/route_config.dart';
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
    // Fetch all exercises when the screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch exercises from provider
      context.read<ExerciseProvider>().fetchAllExercises();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.greenAccent,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Consumer<ExerciseProvider>(
        builder: (context, exerciseProvider, child) {
          // Check if exercises are still being loaded
          if (exerciseProvider.exercises.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: exerciseProvider.exercises.length,
              itemBuilder: (context, index) {
                final exercise = exerciseProvider.exercises[index];

                return ExerciseCard(exercise: exercise);
              },
            ),
          );
        },
      ),
    );
  }
} // Add video player package for video support

class ExerciseCard extends StatefulWidget {
  final Exercise exercise;

  const ExerciseCard({required this.exercise});

  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();

    // Initialize video player if video URL exists
    if (widget.exercise.videoUrl.isNotEmpty) {
      _videoController = VideoPlayerController.network(widget.exercise.videoUrl)
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    // Dispose of the video controller when not needed
    if (_videoController != null) {
      _videoController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise Name
            Text(
              widget.exercise.exerciseName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            // Exercise Description
            Text(
              widget.exercise.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 10),
            // Display Image if available
            if (widget.exercise.imageUrl.isNotEmpty)
              Image.network(
                widget.exercise.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 10),
            // Display Video if available
            if (widget.exercise.videoUrl.isNotEmpty && _videoController != null)
              Container(
                padding: EdgeInsets.all(10),
                color: Colors.black,
                child: Column(
                  children: [
                    _videoController!.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: _videoController!.value.aspectRatio,
                            child: VideoPlayer(_videoController!),
                          )
                        : CircularProgressIndicator(),
                    IconButton(
                      icon: Icon(
                        _videoController!.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.white,
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
            const SizedBox(height: 10),
            // Category (example: Strength)
            const Row(
              children: [
                Icon(
                  Icons.fitness_center,
                  color: Colors.greenAccent,
                ),
                SizedBox(width: 5),
                Text(
                  'Strength', // You can use the exercise category here
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Action buttons (Add to favorites)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.favorite_border, color: Colors.redAccent),
                  onPressed: () {
                    // Implement add to favorites functionality
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
