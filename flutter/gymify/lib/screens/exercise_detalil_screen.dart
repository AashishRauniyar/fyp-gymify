// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// class ExerciseDetailScreen extends StatelessWidget {
//   final exercise;

//   const ExerciseDetailScreen({required this.exercise});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(exercise.exerciseName),
//         backgroundColor: Colors.greenAccent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             // Exercise Name
//             Text(
//               exercise.exerciseName,
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             // Exercise Description
//             Text(
//               exercise.description,
//               style: TextStyle(fontSize: 18, color: Colors.grey[700]),
//             ),
//             const SizedBox(height: 20),
//             // Exercise Image
//             if (exercise.exerciseImage != null)
//               Image.file(
//                 File(exercise.exerciseImage.path),
//                 height: 200,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             const SizedBox(height: 20),
//             // Exercise Video (If any)
//             if (exercise.exerciseVideo != null)
//               Container(
//                 padding: EdgeInsets.all(10),
//                 color: Colors.black,
//                 child: Center(
//                   child: Text(
//                     'Video URL: ${exercise.exerciseVideo.path}',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//             const SizedBox(height: 20),
//             // Additional details (like target muscle group, category, etc.)
//             Row(
//               children: [
//                 Icon(Icons.fitness_center, color: Colors.greenAccent),
//                 SizedBox(width: 5),
//                 Text(
//                   'Strength', // Customize based on the category
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.greenAccent,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             // Additional buttons for actions like adding to favorites can go here
//             ElevatedButton(
//               onPressed: () {
//                 // Implement favorite functionality here
//               },
//               child: const Text('Add to Favorites'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart'; // Import video player package

class ExerciseDetailScreen extends StatefulWidget {
  final exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  _ExerciseDetailScreenState createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();

    // If exercise has a video, initialize the video controller
    if (widget.exercise.exerciseVideo != null) {
      _videoController =
          VideoPlayerController.file(File(widget.exercise.exerciseVideo.path))
            ..initialize().then((_) {
              setState(() {});
            });
    }
  }

  @override
  void dispose() {
    // Dispose of video controller when the screen is disposed
    if (_videoController != null) {
      _videoController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise.exerciseName),
        backgroundColor: Colors.greenAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Exercise Name
            Text(
              widget.exercise.exerciseName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Exercise Description
            Text(
              widget.exercise.description,
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            // Exercise Image
            if (widget.exercise.exerciseImage != null)
              Image.file(
                File(widget.exercise.exerciseImage.path),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 20),
            // Exercise Video (If any)
            if (widget.exercise.exerciseVideo != null &&
                _videoController != null)
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
            const SizedBox(height: 20),
            // Additional details (like target muscle group, category, etc.)
            Row(
              children: [
                Icon(Icons.fitness_center, color: Colors.greenAccent),
                SizedBox(width: 5),
                Text(
                  'Strength', // Customize based on the category
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Additional buttons for actions like adding to favorites can go here
            ElevatedButton(
              onPressed: () {
                // Implement favorite functionality here
              },
              child: const Text('Add to Favorites'),
            ),
          ],
        ),
      ),
    );
  }
}
