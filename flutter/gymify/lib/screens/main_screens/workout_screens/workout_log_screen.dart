// // ! donot touch above code

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:gymify/colors/custom_colors.dart';
// import 'package:gymify/models/workout_model.dart';
// import 'package:gymify/providers/auth_provider/auth_provider.dart';
// import 'package:gymify/providers/log_provider/log_provider.dart';
// import 'package:provider/provider.dart';

// class ExerciseLogScreen extends StatefulWidget {
//   final int workoutId;
//   final List<Workoutexercise> exercises;

//   const ExerciseLogScreen({
//     super.key,
//     required this.workoutId,
//     required this.exercises,
//   });

//   @override
//   State<ExerciseLogScreen> createState() => _ExerciseLogScreenState();
// }

// class _ExerciseLogScreenState extends State<ExerciseLogScreen> {
//   int currentExerciseIndex = 0;
//   Timer? _timer;
//   Timer? _restTimer;
//   int _elapsedSeconds = 0;
//   int _restSeconds = 30; // Rest timer duration
//   bool _isResting = false; // Rest state
//   bool _exerciseLogged = false; // Prevent duplicate logging

//   @override
//   void initState() {
//     super.initState();
//     _startExerciseTimer();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _restTimer?.cancel();
//     super.dispose();
//   }

//   void _startExerciseTimer() {
//     _timer?.cancel(); // Cancel any previous timers
//     setState(() {
//       _elapsedSeconds = 0;
//       _isResting = false;
//       _exerciseLogged = false; // Reset logged state
//     });

//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       setState(() {
//         _elapsedSeconds++;
//       });
//     });
//   }

//   void _startRestTimer() {
//     _timer?.cancel(); // Cancel the exercise timer
//     setState(() {
//       _restSeconds = 30; // Reset rest timer
//       _isResting = true;
//       _exerciseLogged = true; // Ensure exercise is logged
//     });

//     _restTimer = Timer.periodic(const Duration(seconds: 1), (_) {
//       setState(() {
//         _restSeconds--;
//         if (_restSeconds == 0) {
//           _restTimer?.cancel();
//           _nextExercise();
//         }
//       });
//     });
//   }

//   void _logCurrentExercise({bool skipped = false}) {
//     if (_exerciseLogged) return; // Prevent duplicate logging

//     final logProvider = Provider.of<WorkoutLogProvider>(context, listen: false);
//     final currentExercise = widget.exercises[currentExerciseIndex];

//     double exerciseDuration =
//         skipped ? 0.0 : _elapsedSeconds / 60.0; // In minutes
//     double restDuration = _isResting ? _restSeconds / 60.0 : 0.0;

//     logProvider.addExerciseLog(
//       exerciseId: currentExercise.exerciseId,
//       exerciseDuration: exerciseDuration,
//       restDuration: restDuration,
//       skipped: skipped,
//     );

//     _exerciseLogged = true;

//     // Debugging to verify logs
//     debugPrint(
//         'Exercise Logged: ID: ${currentExercise.exerciseId}, Duration: $exerciseDuration mins, Rest: $restDuration mins, Skipped: $skipped');
//   }

//   void _nextExercise() {
//     if (currentExerciseIndex < widget.exercises.length - 1) {
//       setState(() {
//         currentExerciseIndex++;
//       });
//       _startExerciseTimer();
//     } else {
//       _completeWorkout();
//     }
//   }

//   void _skipExercise() {
//     _logCurrentExercise(skipped: true);
//     _startRestTimer();
//   }

//   void _skipRest() {
//     _restTimer?.cancel();
//     _nextExercise();
//   }

//   void _completeWorkout() {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) =>
//             PerformanceNotesScreen(workoutId: widget.workoutId),
//       ),
//     );
//   }

//   String _formattedTime(int seconds) {
//     final minutes = seconds ~/ 60;
//     final remainder = seconds % 60;
//     return "${minutes.toString().padLeft(2, '0')}:${remainder.toString().padLeft(2, '0')}";
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentExercise = widget.exercises[currentExerciseIndex];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           _isResting
//               ? "Rest Time"
//               : 'Exercise ${currentExerciseIndex + 1}/${widget.exercises.length}',
//           style: GoogleFonts.poppins(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         backgroundColor: CustomColors.primary,
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Timer Section
//             Container(
//               padding: const EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: CustomColors.primaryShade2.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Text(
//                 _isResting
//                     ? "Rest Timer: ${_formattedTime(_restSeconds)}"
//                     : "Time Elapsed: ${_formattedTime(_elapsedSeconds)}",
//                 style: GoogleFonts.poppins(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: CustomColors.primary,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Exercise Details
//             if (!_isResting)
//               Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Image
//                     ClipRRect(
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(12),
//                         topRight: Radius.circular(12),
//                       ),
//                       child: Image.network(
//                         currentExercise.exercises?.imageUrl ??
//                             'https://via.placeholder.com/400',
//                         height: 200,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             currentExercise.exercises?.exerciseName ??
//                                 'Unknown Exercise',
//                             style: GoogleFonts.poppins(
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black87,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             "Sets: ${currentExercise.sets} | Reps: ${currentExercise.reps} | Duration: ${currentExercise.duration}s",
//                             style: GoogleFonts.poppins(
//                               fontSize: 16,
//                               color: Colors.grey[700],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             const SizedBox(height: 16),

//             // Buttons
//             if (!_isResting)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: _skipExercise,
//                     icon: const Icon(Icons.skip_next),
//                     label: const Text("Skip"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.redAccent,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 12, horizontal: 24),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       _logCurrentExercise();
//                       _startRestTimer();
//                     },
//                     icon: const Icon(Icons.arrow_forward),
//                     label: const Text("Next"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: CustomColors.primary,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 12, horizontal: 24),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             if (_isResting)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: _skipRest,
//                     icon: const Icon(Icons.skip_next),
//                     label: const Text("Skip Rest"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: CustomColors.primary,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 12, horizontal: 24),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PerformanceNotesScreen extends StatelessWidget {
//   final int workoutId;

//   const PerformanceNotesScreen({super.key, required this.workoutId});

//   @override
//   Widget build(BuildContext context) {
//     final performanceNotesController = TextEditingController();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Performance Notes',
//           style: GoogleFonts.poppins(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: CustomColors.primary,
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Add notes about your workout performance:',
//               style: GoogleFonts.poppins(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: performanceNotesController,
//               maxLines: 5,
//               decoration: InputDecoration(
//                 labelText: 'Performance Notes',
//                 labelStyle: GoogleFonts.poppins(
//                   fontSize: 16,
//                   color: Colors.grey[600],
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 filled: true,
//                 fillColor: CustomColors.primaryShade2.withOpacity(0.1),
//               ),
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//               ),
//             ),
//             const SizedBox(height: 24),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () async {
//                   final logProvider =
//                       Provider.of<WorkoutLogProvider>(context, listen: false);

//                   // Save the notes in the provider
//                   logProvider.performanceNotes =
//                       performanceNotesController.text;

//                   // Finalize the workout (this includes logging exercises)
//                   int userId = int.parse(context
//                       .read<AuthProvider>()
//                       .userId!); // Replace with actual user ID retrieval
//                   await logProvider.finalizeWorkout(
//                     userId: userId,
//                     workoutId: workoutId,
//                   );

//                   // Clear state after successful logging
//                   logProvider.clearStates();

//                   // Navigate to the Workout Complete Screen
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const WorkoutCompleteScreen(),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: CustomColors.primary,
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 12,
//                     horizontal: 24,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: Text(
//                   'Finish Workout',
//                   style: GoogleFonts.poppins(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class WorkoutCompleteScreen extends StatelessWidget {
//   const WorkoutCompleteScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Workout Complete',
//           style: GoogleFonts.poppins(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: CustomColors.primary,
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(
//               Icons.check_circle_outline,
//               color: Colors.green,
//               size: 100,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Workout Logged Successfully!',
//               style: GoogleFonts.poppins(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: CustomColors.primary,
//               ),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () => Navigator.pop(context),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: CustomColors.primary,
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 12,
//                   horizontal: 24,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: Text(
//                 'Go Back',
//                 style: GoogleFonts.poppins(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:video_player/video_player.dart';
// import 'package:gymify/colors/custom_colors.dart';
// import 'package:gymify/models/workout_model.dart';
// import 'package:gymify/providers/log_provider/log_provider.dart';
// import 'package:provider/provider.dart';

// class ExerciseLogScreen extends StatefulWidget {
//   final int workoutId;
//   final List<Workoutexercise> exercises;

//   const ExerciseLogScreen({
//     super.key,
//     required this.workoutId,
//     required this.exercises,
//   });

//   @override
//   State<ExerciseLogScreen> createState() => _ExerciseLogScreenState();
// }

// class _ExerciseLogScreenState extends State<ExerciseLogScreen> {
//   late VideoPlayerController _videoController;
//   int currentExerciseIndex = 0;
//   Timer? _timer;
//   Timer? _restTimer;
//   int _elapsedSeconds = 0;
//   int _restSeconds = 30;
//   bool _isResting = false;
//   bool _exerciseLogged = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeVideo();
//     _startExerciseTimer();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _restTimer?.cancel();
//     _videoController.dispose();
//     super.dispose();
//   }

//   void _initializeVideo() {
//     final currentExercise = widget.exercises[currentExerciseIndex];
//     _videoController = VideoPlayerController.networkUrl(
//         Uri.parse(currentExercise.exercises?.videoUrl ?? ''))
//       ..initialize().then((_) {
//         setState(() {});
//         _videoController.play();
//       });
//   }

//   void _startExerciseTimer() {
//     _timer?.cancel();
//     _restTimer?.cancel();
//     setState(() {
//       _elapsedSeconds = 0;
//       _isResting = false;
//       _exerciseLogged = false;
//     });

//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       setState(() {
//         _elapsedSeconds++;
//       });
//     });
//   }

//   void _startRestTimer() {
//     _timer?.cancel();
//     setState(() {
//       _restSeconds = 30;
//       _isResting = true;
//       _exerciseLogged = true;
//     });

//     _restTimer = Timer.periodic(const Duration(seconds: 1), (_) {
//       setState(() {
//         _restSeconds--;
//         if (_restSeconds == 0) {
//           _restTimer?.cancel();
//           _nextExercise();
//         }
//       });
//     });
//   }

//   void _logCurrentExercise({bool skipped = false}) {
//     if (_exerciseLogged) return;

//     final logProvider = Provider.of<WorkoutLogProvider>(context, listen: false);
//     final currentExercise = widget.exercises[currentExerciseIndex];

//     double exerciseDuration = skipped ? 0.0 : _elapsedSeconds / 60.0;
//     double restDuration = _isResting ? _restSeconds / 60.0 : 0.0;

//     logProvider.addExerciseLog(
//       exerciseId: currentExercise.exerciseId,
//       exerciseDuration: exerciseDuration,
//       restDuration: restDuration,
//       skipped: skipped,
//     );

//     _exerciseLogged = true;
//   }

//   void _nextExercise() {
//     if (currentExerciseIndex < widget.exercises.length - 1) {
//       setState(() {
//         currentExerciseIndex++;
//       });
//       _initializeVideo();
//       _startExerciseTimer();
//     } else {
//       _completeWorkout();
//     }
//   }

//   void _skipExercise() {
//     _logCurrentExercise(skipped: true);
//     _startRestTimer();
//   }

//   void _skipRest() {
//     _restTimer?.cancel();
//     _nextExercise();
//   }

//   void _completeWorkout() {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const WorkoutCompleteScreen(),
//       ),
//     );
//   }

//   String _formattedTime(int seconds) {
//     final minutes = seconds ~/ 60;
//     final remainder = seconds % 60;
//     return "${minutes.toString().padLeft(2, '0')}:${remainder.toString().padLeft(2, '0')}";
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentExercise = widget.exercises[currentExerciseIndex];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           _isResting
//               ? "Rest Time"
//               : 'Exercise ${currentExerciseIndex + 1}/${widget.exercises.length}',
//           style: GoogleFonts.poppins(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         backgroundColor: CustomColors.primary,
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               if (_videoController.value.isInitialized)
//                 AspectRatio(
//                   aspectRatio: _videoController.value.aspectRatio,
//                   child: VideoPlayer(_videoController),
//                 ),
//               const SizedBox(height: 16),
//               Text(
//                 _isResting
//                     ? "Rest Timer: ${_formattedTime(_restSeconds)}"
//                     : "Time Elapsed: ${_formattedTime(_elapsedSeconds)}",
//                 style: GoogleFonts.poppins(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: CustomColors.primary,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               if (!_isResting)
//                 Column(
//                   children: [
//                     Text(
//                       currentExercise.exercises?.description ??
//                           'No Description',
//                       style: GoogleFonts.poppins(
//                         fontSize: 16,
//                         color: Colors.grey[700],
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       "Target Muscle Group: ${currentExercise.exercises?.targetMuscleGroup ?? 'N/A'}",
//                       style: GoogleFonts.poppins(
//                         fontSize: 16,
//                         color: CustomColors.primary,
//                       ),
//                     ),
//                   ],
//                 ),
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   if (!_isResting)
//                     ElevatedButton.icon(
//                       onPressed: _skipExercise,
//                       icon: const Icon(Icons.skip_next),
//                       label: const Text("Skip"),
//                     ),
//                   if (_isResting)
//                     ElevatedButton.icon(
//                       onPressed: _skipRest,
//                       icon: const Icon(Icons.skip_next),
//                       label: const Text("Skip Rest"),
//                     ),
//                   if (!_isResting)
//                     ElevatedButton.icon(
//                       onPressed: () {
//                         _logCurrentExercise();
//                         _startRestTimer();
//                       },
//                       icon: const Icon(Icons.check),
//                       label: const Text("Log & Rest"),
//                     ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class WorkoutCompleteScreen extends StatelessWidget {
//   const WorkoutCompleteScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Workout Complete',
//           style: GoogleFonts.poppins(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: CustomColors.primary,
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(
//               Icons.check_circle_outline,
//               color: Colors.green,
//               size: 100,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Workout Logged Successfully!',
//               style: GoogleFonts.poppins(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: CustomColors.primary,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:gymify/colors/custom_colors.dart';
import 'package:gymify/models/workout_model.dart';
import 'package:gymify/providers/log_provider/log_provider.dart';
import 'package:provider/provider.dart';

class ExerciseLogScreen extends StatefulWidget {
  final int workoutId;
  final List<Workoutexercise> exercises;

  const ExerciseLogScreen({
    super.key,
    required this.workoutId,
    required this.exercises,
  });

  @override
  State<ExerciseLogScreen> createState() => _ExerciseLogScreenState();
}

class _ExerciseLogScreenState extends State<ExerciseLogScreen> {
  late VideoPlayerController _videoController;
  int currentExerciseIndex = 0;
  Timer? _timer;
  Timer? _restTimer;
  int _elapsedSeconds = 0;
  int _restSeconds = 30;
  bool _isResting = false;
  bool _exerciseLogged = false;
  bool _isVideoPlaying = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _startExerciseTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _restTimer?.cancel();
    _videoController.dispose();
    super.dispose();
  }

  void _initializeVideo() {
    final currentExercise = widget.exercises[currentExerciseIndex];
    _videoController = VideoPlayerController.networkUrl(
        Uri.parse(currentExercise.exercises?.videoUrl ?? ''))
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
        _videoController.setLooping(true);
      });
  }

  void _toggleVideoPlayPause() {
    setState(() {
      if (_videoController.value.isPlaying) {
        _videoController.pause();
        _isVideoPlaying = false;
      } else {
        _videoController.play();
        _isVideoPlaying = true;
      }
    });
  }

  void _startExerciseTimer() {
    _timer?.cancel();
    _restTimer?.cancel();
    setState(() {
      _elapsedSeconds = 0;
      _isResting = false;
      _exerciseLogged = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  void _startRestTimer() {
    _timer?.cancel();
    setState(() {
      _restSeconds = 30;
      _isResting = true;
      _exerciseLogged = true;
    });

    _restTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _restSeconds--;
        if (_restSeconds == 0) {
          _restTimer?.cancel();
          _nextExercise();
        }
      });
    });
  }

  void _logCurrentExercise({bool skipped = false}) {
    if (_exerciseLogged) return;

    final logProvider = Provider.of<WorkoutLogProvider>(context, listen: false);
    final currentExercise = widget.exercises[currentExerciseIndex];

    double exerciseDuration = skipped ? 0.0 : _elapsedSeconds / 60.0;
    double restDuration = _isResting ? _restSeconds / 60.0 : 0.0;

    logProvider.addExerciseLog(
      exerciseId: currentExercise.exerciseId,
      exerciseDuration: exerciseDuration,
      restDuration: restDuration,
      skipped: skipped,
    );

    _exerciseLogged = true;
  }

  void _nextExercise() {
    if (currentExerciseIndex < widget.exercises.length - 1) {
      setState(() {
        currentExerciseIndex++;
      });
      _initializeVideo();
      _startExerciseTimer();
    } else {
      _completeWorkout();
    }
  }

  void _skipExercise() {
    _logCurrentExercise(skipped: true);
    _startRestTimer();
  }

  void _skipRest() {
    _restTimer?.cancel();
    _nextExercise();
  }

  void _completeWorkout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const WorkoutCompleteScreen(),
      ),
    );
  }

  String _formattedTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainder = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainder.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final currentExercise = widget.exercises[currentExerciseIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isResting
              ? "Rest Time"
              : 'Exercise ${currentExerciseIndex + 1}/${widget.exercises.length}',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: CustomColors.primary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (_videoController.value.isInitialized)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: VideoPlayer(_videoController),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        icon: Icon(
                          _isVideoPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 40,
                        ),
                        onPressed: _toggleVideoPlayPause,
                      ),
                    ),
                  ],
                ),
              if (_videoController.value.isInitialized)
                VideoProgressIndicator(
                  _videoController,
                  allowScrubbing: true,
                  colors: VideoProgressColors(
                    playedColor: CustomColors.primary,
                    bufferedColor: Colors.grey,
                    backgroundColor: Colors.grey[300]!,
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                _isResting
                    ? "Rest Timer: ${_formattedTime(_restSeconds)}"
                    : "Time Elapsed: ${_formattedTime(_elapsedSeconds)}",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              if (!_isResting)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          currentExercise.exercises?.description ??
                              'No Description',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Target Muscle Group: ${currentExercise.exercises?.targetMuscleGroup ?? 'N/A'}",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: CustomColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (!_isResting)
                    ElevatedButton.icon(
                      onPressed: _skipExercise,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.skip_next),
                      label: const Text("Skip"),
                    ),
                  if (_isResting)
                    ElevatedButton.icon(
                      onPressed: _skipRest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.skip_next),
                      label: const Text("Skip Rest"),
                    ),
                  if (!_isResting)
                    ElevatedButton.icon(
                      onPressed: () {
                        _logCurrentExercise();
                        _startRestTimer();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.check),
                      label: const Text("Log & Rest"),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WorkoutCompleteScreen extends StatelessWidget {
  const WorkoutCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Workout Complete',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: CustomColors.primary,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 16),
            Text(
              'Workout Logged Successfully!',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: CustomColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Back to Workouts',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
