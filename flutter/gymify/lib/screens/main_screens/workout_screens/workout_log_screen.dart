// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:gymify/providers/profile_provider/profile_provider.dart';
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
//   int _currentExerciseIndex = 0;
//   Timer? _exerciseTimer;
//   Timer? _restTimer;
//   int _elapsedSeconds = 0;
//   int _restSeconds = 30;
//   bool _isResting = false;
//   bool _isVideoPlaying = true;
//   double _totalDuration = 0.0;

//   // Pending exercise tracking (for logging after rest)
//   int _pendingExerciseIndex = 0;
//   double _pendingExerciseDuration = 0.0;
//   bool _pendingSkipped = false;
//   bool _isVideoLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _initializeWorkout();
//     _initializeVideo();
//     // Start timer for the first exercise
//     _startExerciseTimer();
//   }

//   void _initializeWorkout() {
//     final provider = Provider.of<WorkoutLogProvider>(context, listen: false);
//     provider.initializeWorkout();
//   }

//   void _initializeVideo() {
//     // Only initialize video if we're not in rest mode.
//     if (_isResting) return;
//     final currentExercise = widget.exercises[_currentExerciseIndex];
//     _videoController = VideoPlayerController.networkUrl(
//       Uri.parse(currentExercise.exercises?.videoUrl ?? ''),
//     )..initialize().then((_) {
//         setState(() {
//           _isVideoLoading = false;
//           _videoController.play();
//         });
//       }).catchError((_) {
//         setState(() => _isVideoLoading = false);
//       });
//   }

//   void _toggleVideoPlayPause() {
//     setState(() {
//       if (_videoController.value.isPlaying) {
//         _videoController.pause();
//         _isVideoPlaying = false;
//       } else {
//         _videoController.play();
//         _isVideoPlaying = true;
//       }
//     });
//   }

//   void _startRestTimer() {
//     // Mute the video during rest.
//     if (_videoController.value.isInitialized) {
//       _videoController.setVolume(0);
//     }
//     // Cancel any active timers and switch to rest mode.
//     _cancelTimers();
//     setState(() {
//       _restSeconds = 30;
//       _isResting = true;
//     });
//     _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         if (_restSeconds > 0) {
//           _restSeconds--;
//         } else {
//           _restTimer?.cancel();
//           _logPendingExercise();
//           _nextExercise();
//         }
//       });
//     });
//   }

//   void _startExerciseTimer() {
//     // Restore the volume for the exercise.
//     if (_videoController.value.isInitialized) {
//       _videoController.setVolume(1);
//     }
//     _cancelTimers();
//     setState(() {
//       _elapsedSeconds = 0;
//       _isResting = false;
//     });
//     _exerciseTimer = Timer.periodic(const Duration(seconds: 1), (_) {
//       setState(() => _elapsedSeconds++);
//     });
//   }

//   void _cancelTimers() {
//     _exerciseTimer?.cancel();
//     _restTimer?.cancel();
//   }

//   // Called when the user completes the current exercise.
//   void _completeExercise() {
//     _pendingExerciseIndex = _currentExerciseIndex;
//     _pendingExerciseDuration = _elapsedSeconds / 60.0;
//     _pendingSkipped = false;
//     _startRestTimer();
//   }

//   // Called when the user opts to skip the exercise.
//   void _skipExercise() {
//     _pendingExerciseIndex = _currentExerciseIndex;
//     _pendingExerciseDuration = 0.0;
//     _pendingSkipped = true;
//     _startRestTimer();
//   }

//   void _logPendingExercise() {
//     final restDuration = (30 - _restSeconds) / 60.0;
//     final provider = Provider.of<WorkoutLogProvider>(context, listen: false);
//     final currentExercise = widget.exercises[_pendingExerciseIndex];

//     provider.addExerciseLog(
//       exerciseId: currentExercise.exerciseId,
//       exerciseDuration: _pendingExerciseDuration,
//       restDuration: restDuration,
//       skipped: _pendingSkipped,
//     );

//     if (!_pendingSkipped) {
//       _totalDuration += _pendingExerciseDuration + restDuration;
//     }
//   }

//   void _nextExercise() {
//     if (_currentExerciseIndex < widget.exercises.length - 1) {
//       // Force reset rest mode and mark video as loading.
//       setState(() {
//         _currentExerciseIndex++;
//         _isVideoLoading = true;
//         _isResting = false;
//       });
//       // Dispose previous video controller before initializing a new one.
//       _videoController.dispose();
//       _initializeVideo();
//       _startExerciseTimer();
//     } else {
//       _completeWorkout();
//     }
//   }

//   void _skipRest() {
//     _restTimer?.cancel();
//     _logPendingExercise();
//     _nextExercise();
//   }

//   void _completeWorkout() async {
//     final provider = Provider.of<WorkoutLogProvider>(context, listen: false);
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => WorkoutSummaryScreen(
//           totalDuration: _totalDuration,
//           workoutId: widget.workoutId,
//         ),
//       ),
//     );
//   }

//   String _formattedTime(int seconds) {
//     final minutes = seconds ~/ 60;
//     final remainder = seconds % 60;
//     return "${minutes.toString().padLeft(2, '0')}:${remainder.toString().padLeft(2, '0')}";
//   }

//   @override
//   void dispose() {
//     _cancelTimers();
//     _videoController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentExercise = widget.exercises[_currentExerciseIndex];
//     final provider = Provider.of<WorkoutLogProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           _isResting
//               ? "Rest Time"
//               : 'Exercise ${_currentExerciseIndex + 1}/${widget.exercises.length}',
//           style: const TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Theme.of(context).primaryColor,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Column(
//         children: [
//           // Overall workout progress bar.
//           LinearProgressIndicator(
//             value: (_currentExerciseIndex + 1) / widget.exercises.length,
//             backgroundColor: Colors.grey[300],
//             valueColor: AlwaysStoppedAnimation<Color>(
//                 Theme.of(context).colorScheme.onSurface),
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   // Show video only when NOT in rest mode.
//                   if (!_isResting)
//                     _isVideoLoading
//                         ? const SizedBox(
//                             height: 250,
//                             child: Center(child: CircularProgressIndicator()),
//                           )
//                         : _videoController.value.isInitialized
//                             ? AspectRatio(
//                                 aspectRatio: _videoController.value.aspectRatio,
//                                 child: Stack(
//                                   alignment: Alignment.center,
//                                   children: [
//                                     VideoPlayer(_videoController),
//                                     IconButton(
//                                       icon: Icon(
//                                         _isVideoPlaying
//                                             ? Icons.pause
//                                             : Icons.play_arrow,
//                                         size: 48,
//                                         color: Colors.white.withOpacity(0.8),
//                                       ),
//                                       onPressed: _toggleVideoPlayPause,
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             : const SizedBox.shrink(),
//                   const SizedBox(height: 24),
//                   // Animated switcher to display exercise timer OR rest screen.
//                   AnimatedSwitcher(
//                     duration: const Duration(milliseconds: 300),
//                     child:
//                         _isResting ? _buildRestScreen() : _buildExerciseTimer(),
//                   ),
//                   const SizedBox(height: 24),
//                   // Card with exercise info styled with card borders inspired by weight log.
//                   _buildExerciseInfo(currentExercise),
//                 ],
//               ),
//             ),
//           ),
//           // Action buttons.
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 if (!_isResting)
//                   _buildActionButton(
//                     icon: Icons.skip_next,
//                     label: 'Skip Exercise',
//                     color: Colors.orange,
//                     onPressed: _skipExercise,
//                   ),
//                 if (_isResting)
//                   _buildActionButton(
//                     icon: Icons.fast_forward,
//                     label: 'Skip Rest',
//                     color: Colors.blue,
//                     onPressed: _skipRest,
//                   ),
//                 if (!_isResting)
//                   _buildActionButton(
//                     icon: Icons.check_circle,
//                     label: 'Complete',
//                     color: Colors.green,
//                     onPressed: _completeExercise,
//                   ),
//               ],
//             ),
//           ),
//           if (provider.isLoading)
//             const LinearProgressIndicator(
//               color: CustomColors.primary,
//               minHeight: 2,
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildExerciseTimer() {
//     return Column(
//       key: const ValueKey('exercise_timer'),
//       children: [
//         const Text(
//           'Exercise Time',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: CustomColors.primary,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           _formattedTime(_elapsedSeconds),
//           style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w600),
//         ),
//       ],
//     );
//   }

//   Widget _buildRestScreen() {
//     return Column(
//       key: const ValueKey('rest_screen'),
//       children: [
//         const Text(
//           'Rest Time Remaining',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: CustomColors.primary,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           _formattedTime(_restSeconds),
//           style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w600),
//         ),
//         const SizedBox(height: 16),
//         SizedBox(
//           width: 200,
//           height: 200,
//           child: CircularProgressIndicator(
//             value: _restSeconds / 30,
//             strokeWidth: 8,
//             backgroundColor: Colors.grey[200],
//             valueColor:
//                 const AlwaysStoppedAnimation<Color>(CustomColors.primary),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildExerciseInfo(Workoutexercise currentExercise) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//         side: BorderSide(
//           color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
//           width: 1.5,
//         ),
//       ),
//       margin: const EdgeInsets.symmetric(vertical: 12),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               currentExercise.exercises?.exerciseName ?? 'Exercise',
//               style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               currentExercise.exercises?.description ??
//                   'No description available',
//               style:
//                   TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.4),
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 const Icon(Icons.fitness_center, size: 18, color: Colors.grey),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Target: ${currentExercise.exercises?.targetMuscleGroup ?? 'N/A'}',
//                   style: const TextStyle(fontSize: 16, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButton({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required VoidCallback onPressed,
//   }) {
//     return ElevatedButton.icon(
//       icon: Icon(icon, size: 24, color: Colors.white),
//       label: Text(
//         label,
//         style: const TextStyle(
//             fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
//       ),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color,
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//       onPressed: onPressed,
//     );
//   }
// }

// //? working
// class WorkoutSummaryScreen extends StatefulWidget {
//   final double totalDuration;
//   final int workoutId;

//   const WorkoutSummaryScreen({
//     super.key,
//     required this.totalDuration,
//     required this.workoutId,
//   });

//   @override
//   State<WorkoutSummaryScreen> createState() => _WorkoutSummaryScreenState();
// }

// class _WorkoutSummaryScreenState extends State<WorkoutSummaryScreen> {
//   final _notesController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<WorkoutLogProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Workout Complete',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: CustomColors.primary,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView(
//                 children: [
//                   const SizedBox(height: 40),
//                   const Icon(Icons.check_circle_outline,
//                       size: 120, color: Colors.green),
//                   const SizedBox(height: 24),
//                   const Text(
//                     'Workout Completed!',
//                     style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: CustomColors.primary),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 40),
//                   _buildStatCard(
//                     icon: Icons.timer,
//                     title: 'Total Duration',
//                     value: '${widget.totalDuration.toStringAsFixed(1)} minutes',
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: _notesController,
//                     decoration: InputDecoration(
//                       labelText: 'Workout Notes',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       hintText: 'How did it go? Any important notes...',
//                       floatingLabelBehavior: FloatingLabelBehavior.always,
//                       contentPadding: const EdgeInsets.all(16),
//                     ),
//                     maxLines: 4,
//                     onChanged: (value) => provider.performanceNotes = value,
//                   ),
//                 ],
//               ),
//             ),
//             if (provider.hasError)
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 12),
//                 child: Text(
//                   'Error saving workout: ${provider.errorMessage}',
//                   style: const TextStyle(color: Colors.red),
//                 ),
//               ),
//             _buildSaveButton(provider),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatCard({
//     required IconData icon,
//     required String title,
//     required String value,
//   }) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Row(
//           children: [
//             Icon(icon, size: 34, color: CustomColors.primary),
//             const SizedBox(width: 20),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(fontSize: 16, color: Colors.grey),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   value,
//                   style: const TextStyle(
//                       fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSaveButton(WorkoutLogProvider provider) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: CustomColors.primary,
//           padding: const EdgeInsets.symmetric(vertical: 18),
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           elevation: 2,
//         ),
//         onPressed:
//             provider.isLoading ? null : () => _saveWorkout(context, provider),
//         child: provider.isLoading
//             ? const SizedBox(
//                 width: 24,
//                 height: 24,
//                 child: CircularProgressIndicator(
//                     color: Colors.white, strokeWidth: 3),
//               )
//             : const Text(
//                 'Save Workout',
//                 style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white),
//               ),
//       ),
//     );
//   }

//   Future<void> _saveWorkout(
//       BuildContext context, WorkoutLogProvider provider) async {
//     final userId =
//         context.read<ProfileProvider>().user?.userId.toString() ?? '0';

//     final success = await provider.finalizeWorkout(
//       userId: int.parse(userId),
//       workoutId: widget.workoutId,
//     );

//     if (success) {
//       Navigator.popUntil(context, (route) => route.isFirst);
//     }
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymify/providers/profile_provider/profile_provider.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:gymify/colors/custom_colors.dart';
import 'package:gymify/models/workout_model.dart';
import 'package:gymify/providers/log_provider/log_provider.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart'; // For audio cues

import 'package:confetti/confetti.dart';

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

class _ExerciseLogScreenState extends State<ExerciseLogScreen>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoController;
  late AnimationController _animationController;
  int _currentExerciseIndex = 0;
  Timer? _exerciseTimer;
  Timer? _restTimer;
  int _elapsedSeconds = 0;
  int _restSeconds = 30;
  bool _isResting = false;
  bool _isVideoPlaying = true;
  bool _isVideoLoading = true;
  bool _isFullscreen = false;
  bool _isPipActive = false;
  double _totalDuration = 0.0;
  double _videoAspectRatio = 16 / 9; // Default aspect ratio
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Animations
  late Animation<double> _progressAnimation;

  // Pending exercise tracking
  int _pendingExerciseIndex = 0;
  double _pendingExerciseDuration = 0.0;
  bool _pendingSkipped = false;

  // Scroll controller for handling the floating video
  late ScrollController _scrollController;
  bool _showFloatingVideo = false;

  @override
  void initState() {
    super.initState();

    // Set system UI for immersive experience
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Initialize scroll controller
    _scrollController = ScrollController()..addListener(_scrollListener);

    _initializeWorkout();
    _initializeVideo();
    _startExerciseTimer();

    // Preload audio files
    _preloadAudioFiles();
  }

  void _preloadAudioFiles() async {
    // Preload countdown beep sound
    await _audioPlayer.setSource(AssetSource('sounds/countdown_beep.mp3'));
    await _audioPlayer.setReleaseMode(ReleaseMode.stop);
  }

  void _playCountdownSound() {
    _audioPlayer.resume();
  }

  void _scrollListener() {
    // Show floating video when scrolling past the main video
    if (_scrollController.offset > 200 && !_isResting && !_showFloatingVideo) {
      setState(() {
        _showFloatingVideo = true;
      });
    } else if (_scrollController.offset <= 200 && _showFloatingVideo) {
      setState(() {
        _showFloatingVideo = false;
      });
    }
  }

  void _initializeWorkout() {
    // post frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<WorkoutLogProvider>(context, listen: false);
      provider.initializeWorkout();
    });
  }

  void _initializeVideo() {
    if (_isResting) return;

    setState(() => _isVideoLoading = true);

    final currentExercise = widget.exercises[_currentExerciseIndex];
    final videoUrl = currentExercise.exercises?.videoUrl ?? '';

    if (videoUrl.isEmpty) {
      setState(() => _isVideoLoading = false);
      return;
    }

    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(videoUrl),
    )..initialize().then((_) {
        if (mounted) {
          // Get video aspect ratio
          _videoAspectRatio = _videoController.value.aspectRatio;

          setState(() {
            _isVideoLoading = false;
            _videoController.play();
            _videoController.setLooping(true);
          });
        }
      }).catchError((error) {
        print("Video player error: $error");
        if (mounted) {
          setState(() => _isVideoLoading = false);
        }
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

    // Add haptic feedback
    HapticFeedback.selectionClick();
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });

    if (_isFullscreen) {
      // Enter fullscreen mode
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      // Exit fullscreen mode
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }

    // Add haptic feedback
    HapticFeedback.mediumImpact();
  }

  void _togglePictureInPicture() {
    setState(() {
      _isPipActive = !_isPipActive;
    });

    // Add haptic feedback
    HapticFeedback.selectionClick();
  }

  void _startRestTimer() {
    // Add haptic feedback
    HapticFeedback.mediumImpact();

    // Pause video during rest
    if (_videoController.value.isInitialized) {
      _videoController.pause();
    }

    // Cancel active timers and switch to rest mode
    _cancelTimers();
    setState(() {
      _restSeconds = 30;
      _isResting = true;
      _showFloatingVideo = false; // Hide floating video during rest
    });

    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_restSeconds > 0) {
          _restSeconds--;

          // Play countdown sound for the last 3 seconds
          if (_restSeconds <= 3 && _restSeconds > 0) {
            _playCountdownSound();
          }
        } else {
          _restTimer?.cancel();
          _logPendingExercise();
          _nextExercise();
        }
      });
    });

    // Run animation
    _animationController.reset();
    _animationController.forward();
  }

  void _startExerciseTimer() {
    // Add haptic feedback
    HapticFeedback.lightImpact();

    // Restore video playback if video is loaded
    if (_videoController.value.isInitialized) {
      _videoController.play();
      _isVideoPlaying = true;
    }

    _cancelTimers();
    setState(() {
      _elapsedSeconds = 0;
      _isResting = false;
    });

    _exerciseTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsedSeconds++);
    });

    // Run animation
    _animationController.reset();
    _animationController.forward();
  }

  void _cancelTimers() {
    _exerciseTimer?.cancel();
    _restTimer?.cancel();
  }

  void _completeExercise() {
    _pendingExerciseIndex = _currentExerciseIndex;
    _pendingExerciseDuration = _elapsedSeconds / 60.0;
    _pendingSkipped = false;
    _startRestTimer();
  }

  void _skipExercise() {
    _pendingExerciseIndex = _currentExerciseIndex;
    _pendingExerciseDuration = 0.0;
    _pendingSkipped = true;
    _startRestTimer();
  }

  void _logPendingExercise() {
    final restDuration = (30 - _restSeconds) / 60.0;
    final provider = Provider.of<WorkoutLogProvider>(context, listen: false);
    final currentExercise = widget.exercises[_pendingExerciseIndex];

    provider.addExerciseLog(
      exerciseId: currentExercise.exerciseId,
      exerciseDuration: _pendingExerciseDuration,
      restDuration: restDuration,
      skipped: _pendingSkipped,
    );

    if (!_pendingSkipped) {
      _totalDuration += _pendingExerciseDuration + restDuration;
    }
  }

  void _nextExercise() {
    if (_currentExerciseIndex < widget.exercises.length - 1) {
      // Force reset rest mode and mark video as loading
      setState(() {
        _currentExerciseIndex++;
        _isVideoLoading = true;
        _isResting = false;
      });

      // Dispose previous video controller before initializing a new one
      _videoController.dispose();
      _initializeVideo();
      _startExerciseTimer();
    } else {
      _completeWorkout();
    }
  }

  void _skipRest() {
    // Add haptic feedback
    HapticFeedback.lightImpact();

    _restTimer?.cancel();
    _logPendingExercise();
    _nextExercise();
  }

  void _completeWorkout() async {
    // Add haptic feedback for workout completion
    HapticFeedback.heavyImpact();

    final provider = Provider.of<WorkoutLogProvider>(context, listen: false);

    // Ensure we're back in portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutSummaryScreen(
          totalDuration: _totalDuration,
          workoutId: widget.workoutId,
        ),
      ),
    );
  }

  String _formattedTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainder = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainder.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    // Clean up resources
    _cancelTimers();
    _videoController.dispose();
    _animationController.dispose();
    _scrollController.dispose();
    _audioPlayer.dispose();

    // Reset device orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentExercise = widget.exercises[_currentExerciseIndex];
    final provider = Provider.of<WorkoutLogProvider>(context);
    final theme = Theme.of(context);

    // Handle fullscreen mode
    if (_isFullscreen) {
      return _buildFullscreenVideo(theme);
    }

    return WillPopScope(
      onWillPop: () async {
        if (_isFullscreen) {
          _toggleFullscreen();
          return false;
        }
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _isFullscreen
            ? null
            : AppBar(
                title: Text(
                  _isResting
                      ? "Rest Time"
                      : 'Exercise ${_currentExerciseIndex + 1}/${widget.exercises.length}',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                backgroundColor: _isResting
                    ? theme.colorScheme.primary.withOpacity(0.8)
                    : theme.primaryColor.withOpacity(0.8),
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.white),
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.arrow_back),
                  ),
                  onPressed: _showExitDialog,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: _buildProgressCircle(),
                  ),
                ],
              ),
        // Floating action button for quick exercise completion
        floatingActionButton: _isResting || _isFullscreen
            ? null
            : FloatingActionButton(
                onPressed: _completeExercise,
                backgroundColor: theme.colorScheme.primary,
                child: const Icon(Icons.check, color: Colors.white),
              ),
        body: Stack(
          children: [
            // Main content
            Column(
              children: [
                // Overall workout progress bar
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 4,
                  child: LinearProgressIndicator(
                    value: (_currentExerciseIndex) / widget.exercises.length,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary),
                  ),
                ),

                // Main content area
                Expanded(
                  child: _isResting
                      ? _buildRestScreen(theme)
                      : _buildExerciseScreen(currentExercise, theme),
                ),

                // Action buttons
                if (!_isFullscreen) _buildActionButtons(theme),

                // Loading indicator
                if (provider.isLoading)
                  const LinearProgressIndicator(
                    color: CustomColors.primary,
                    minHeight: 2,
                  ),
              ],
            ),

            // Floating video player (appears when scrolling)
            if (_showFloatingVideo && !_isResting && !_isFullscreen)
              _buildFloatingVideoPlayer(theme),

            // Picture-in-picture video
            if (_isPipActive &&
                !_isResting &&
                !_isFullscreen &&
                !_showFloatingVideo)
              Positioned(
                bottom: 100,
                right: 16,
                child: _buildPipVideoPlayer(),
              ),
          ],
        ),
      ),
    );
  }

  void _showExitDialog() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Workout?'),
        content:
            const Text('Your progress will not be saved if you leave now.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
            ),
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Exit screen
            },
            child: const Text('END WORKOUT'),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCircle() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 36,
          width: 36,
          child: CircularProgressIndicator(
            value: (_currentExerciseIndex + 1) / widget.exercises.length,
            strokeWidth: 3,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        Text(
          "${(_currentExerciseIndex + 1)}/${widget.exercises.length}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseScreen(
      Workoutexercise currentExercise, ThemeData theme) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          // Video player
          _buildMainVideoPlayer(theme),

          // Exercise timer
          _buildExerciseTimer(theme),

          // Exercise information card
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildExerciseInfo(currentExercise, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildMainVideoPlayer(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      constraints: const BoxConstraints(
        maxHeight: 300,
        minHeight: 200,
      ),
      color: Colors.black,
      child: _isVideoLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Loading exercise video...',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : !_videoController.value.isInitialized
              ? _buildNoVideoPlaceholder(theme)
              : _buildVideoPlayerWithControls(
                  aspectRatio: _videoAspectRatio,
                  showFullControls: true,
                ),
    );
  }

  Widget _buildNoVideoPlaceholder(ThemeData theme) {
    return Container(
      color: Colors.black87,
      height: 250,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.videocam_off,
              size: 48,
              color: Colors.white70,
            ),
            SizedBox(height: 16),
            Text(
              'No video available for this exercise',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayerWithControls({
    required double aspectRatio,
    bool showFullControls = true,
    double? width,
    double? height,
  }) {
    // Calculate container dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    double playerWidth = width ?? screenWidth;
    double playerHeight = height ?? playerWidth / aspectRatio;

    // Adjust for vertical videos
    if (aspectRatio < 1.0) {
      playerHeight = playerWidth * (3 / 4); // Limit height for vertical videos
    }

    return SizedBox(
      width: playerWidth,
      height: playerHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Video player
          AspectRatio(
            aspectRatio: aspectRatio,
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: playerWidth * aspectRatio,
                height: playerWidth,
                child: VideoPlayer(_videoController),
              ),
            ),
          ),

          // Tap handler for play/pause
          GestureDetector(
            onTap: _toggleVideoPlayPause,
            child: Container(
              color: Colors.transparent,
            ),
          ),

          // Play/Pause icon overlay
          AnimatedOpacity(
            opacity: _isVideoPlaying ? 0.0 : 0.8,
            duration: const Duration(milliseconds: 250),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                _isVideoPlaying ? Icons.pause : Icons.play_arrow,
                size: 48,
                color: Colors.white,
              ),
            ),
          ),

          // Show controls only if requested
          if (showFullControls) _buildVideoControls(),
        ],
      ),
    );
  }

  Widget _buildVideoControls() {
    final theme = Theme.of(context);

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Play/Pause button
            IconButton(
              icon: Icon(
                _isVideoPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
              onPressed: _toggleVideoPlayPause,
            ),

            // Replay button
            IconButton(
              icon: const Icon(
                Icons.replay_5,
                color: Colors.white,
              ),
              onPressed: () {
                final newPosition = _videoController.value.position -
                    const Duration(seconds: 5);
                _videoController.seekTo(
                    newPosition.isNegative ? Duration.zero : newPosition);
              },
            ),

            // Forward button
            IconButton(
              icon: const Icon(
                Icons.forward_10,
                color: Colors.white,
              ),
              onPressed: () {
                final newPosition = _videoController.value.position +
                    const Duration(seconds: 10);
                final duration = _videoController.value.duration;
                _videoController
                    .seekTo(newPosition > duration ? duration : newPosition);
              },
            ),

            // Spacer
            const Spacer(),

            // PiP button
            IconButton(
              icon: Icon(
                _isPipActive
                    ? Icons.picture_in_picture
                    : Icons.picture_in_picture_alt,
                color: Colors.white,
              ),
              onPressed: _togglePictureInPicture,
            ),

            // Fullscreen button
            IconButton(
              icon: const Icon(
                Icons.fullscreen,
                color: Colors.white,
              ),
              onPressed: _toggleFullscreen,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingVideoPlayer(ThemeData theme) {
    if (!_videoController.value.isInitialized) return const SizedBox.shrink();

    return Positioned(
      bottom: 100,
      right: 16,
      child: GestureDetector(
        onTap: () {
          // Scroll back up to the main video
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        child: Container(
          width: 160,
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildVideoPlayerWithControls(
              aspectRatio: _videoAspectRatio,
              showFullControls: false,
              width: 160,
              height: 90,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPipVideoPlayer() {
    if (!_videoController.value.isInitialized) return const SizedBox.shrink();

    return GestureDetector(
      onTap: _togglePictureInPicture,
      child: Container(
        width: 120,
        height: 68,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AspectRatio(
            aspectRatio: _videoAspectRatio,
            child: VideoPlayer(_videoController),
          ),
        ),
      ),
    );
  }

  Widget _buildFullscreenVideo(ThemeData theme) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Video centered on screen
            Center(
              child: _videoController.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _videoAspectRatio,
                      child: VideoPlayer(_videoController),
                    )
                  : _buildNoVideoPlaceholder(theme),
            ),

            // Back button
            Positioned(
              top: 8,
              left: 8,
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white),
                ),
                onPressed: _toggleFullscreen,
              ),
            ),

            // Video controls
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Replay 10 seconds
                    IconButton(
                      icon: const Icon(Icons.replay_10,
                          color: Colors.white, size: 32),
                      onPressed: () {
                        final newPosition = _videoController.value.position -
                            const Duration(seconds: 10);
                        _videoController.seekTo(newPosition.isNegative
                            ? Duration.zero
                            : newPosition);
                      },
                    ),

                    // Play/Pause
                    IconButton(
                      icon: Icon(
                        _isVideoPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 48,
                      ),
                      onPressed: _toggleVideoPlayPause,
                    ),

                    // Forward 10 seconds
                    IconButton(
                      icon: const Icon(Icons.forward_10,
                          color: Colors.white, size: 32),
                      onPressed: () {
                        final newPosition = _videoController.value.position +
                            const Duration(seconds: 10);
                        final duration = _videoController.value.duration;
                        _videoController.seekTo(
                            newPosition > duration ? duration : newPosition);
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Video progress bar
            Positioned(
              bottom: 80,
              left: 16,
              right: 16,
              child: VideoProgressIndicator(
                _videoController,
                allowScrubbing: true,
                colors: VideoProgressColors(
                  playedColor: theme.colorScheme.primary,
                  bufferedColor: Colors.white.withOpacity(0.3),
                  backgroundColor: Colors.white.withOpacity(0.1),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseTimer(ThemeData theme) {
    return Container(
      key: const ValueKey('exercise_timer'),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          Text(
            'Exercise Time',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer,
                  size: 28,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  _formattedTime(_elapsedSeconds),
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestScreen(ThemeData theme) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          children: [
            // Rest countdown timer
            _buildRestCountdown(theme),

            // Next exercise preview
            if (_currentExerciseIndex < widget.exercises.length - 1)
              _buildNextExercisePreview(theme),

            // Visual rest suggestion
            _buildRestSuggestions(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildRestCountdown(ThemeData theme) {
    return Column(
      children: [
        Text(
          'Rest Time Remaining',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 24),

        // Circular countdown timer
        Stack(
          alignment: Alignment.center,
          children: [
            // Background animation
            SizedBox(
              width: 200,
              height: 200,
              child: Lottie.asset(
                'assets/animations/rest_timer.json',
                repeat: true,
                animate: true,
              ),
            ),

            // Timer circle
            SizedBox(
              width: 180,
              height: 180,
              child: CircularProgressIndicator(
                value: _restSeconds / 30,
                strokeWidth: 12,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _restSeconds <= 5
                      ? Colors.redAccent
                      : theme.colorScheme.primary,
                ),
              ),
            ),

            // Timer text
            Column(
              children: [
                Text(
                  _formattedTime(_restSeconds),
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: _restSeconds <= 5
                        ? Colors.redAccent
                        : theme.colorScheme.primary,
                  ),
                ),
                Text(
                  'seconds',
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Get ready alert for last 5 seconds
        if (_restSeconds <= 10)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _restSeconds <= 5
                  ? Colors.redAccent.withOpacity(0.2)
                  : theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _restSeconds <= 5
                    ? Colors.redAccent.withOpacity(0.5)
                    : theme.colorScheme.primary.withOpacity(0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _restSeconds <= 5
                      ? Icons.warning_amber_rounded
                      : Icons.info_outline,
                  color: _restSeconds <= 5
                      ? Colors.redAccent
                      : theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  _restSeconds <= 5
                      ? 'Get ready for next exercise!'
                      : 'Prepare for the next exercise',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _restSeconds <= 5
                        ? Colors.redAccent
                        : theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildNextExercisePreview(ThemeData theme) {
    if (_currentExerciseIndex >= widget.exercises.length - 1) {
      return const SizedBox();
    }

    final nextExercise = widget.exercises[_currentExerciseIndex + 1];

    return Container(
      margin: const EdgeInsets.only(top: 32, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Row(
              children: [
                Icon(
                  Icons.next_plan,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Coming Up Next:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: theme.colorScheme.outline.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Exercise icon/image
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: nextExercise.exercises?.imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              nextExercise.exercises!.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.fitness_center,
                                size: 32,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.fitness_center,
                            size: 32,
                            color: theme.colorScheme.primary,
                          ),
                  ),

                  const SizedBox(width: 16),

                  // Exercise details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nextExercise.exercises?.exerciseName ??
                              'Next Exercise',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Target muscle
                        Row(
                          children: [
                            Icon(
                              Icons.accessibility_new,
                              size: 16,
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              nextExercise.exercises?.targetMuscleGroup ??
                                  'N/A',
                              style: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Sets and reps
                        Row(
                          children: [
                            Icon(
                              Icons.repeat,
                              size: 16,
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${nextExercise.sets ?? '0'} sets • ${nextExercise.reps ?? '0'} reps',
                              style: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestSuggestions(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Row(
              children: [
                Icon(
                  Icons.tips_and_updates,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'During Rest:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          // Rest suggestions cards
          _buildRestSuggestionCard(
            theme: theme,
            icon: Icons.water_drop,
            title: 'Stay Hydrated',
            description:
                'Take a sip of water to stay hydrated during your workout.',
          ),

          _buildRestSuggestionCard(
            theme: theme,
            icon: Icons.air,
            title: 'Deep Breathing',
            description:
                'Take deep breaths to help with recovery and prepare for the next exercise.',
          ),

          _buildRestSuggestionCard(
            theme: theme,
            icon: Icons.self_improvement,
            title: 'Stretch Lightly',
            description:
                'Perform light stretches to maintain flexibility and prevent stiffness.',
          ),
        ],
      ),
    );
  }

  Widget _buildRestSuggestionCard({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseInfo(Workoutexercise currentExercise, ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.fitness_center,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    currentExercise.exercises?.exerciseName ?? 'Exercise',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Target: ${currentExercise.exercises?.targetMuscleGroup ?? 'N/A'}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Exercise metrics cards
            _buildExerciseMetrics(currentExercise, theme),

            const SizedBox(height: 20),

            // Instructions section
            Text(
              'Instructions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),

            // Instruction steps
            _buildInstructionSteps(
                currentExercise.exercises?.description ??
                    'No description available',
                theme),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseMetrics(Workoutexercise exercise, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildMetricCard(
              label: 'Sets',
              value: '${exercise.sets ?? '0'}',
              icon: Icons.repeat,
              theme: theme,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildMetricCard(
              label: 'Reps',
              value: '${exercise.reps ?? '0'}',
              icon: Icons.fitness_center,
              theme: theme,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildMetricCard(
              label: 'Duration',
              value: '${exercise.duration ?? '0'}s',
              icon: Icons.timer,
              theme: theme,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String label,
    required String value,
    required IconData icon,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionSteps(String description, ThemeData theme) {
    // Split description into steps if possible
    final List<String> steps = description.split(RegExp(r'(?:\d+\.|\n|\r\n)'));

    if (steps.length <= 1) {
      // Just show as a paragraph if not splittable
      return Text(
        description,
        style: TextStyle(
          fontSize: 14,
          height: 1.5,
          color: theme.colorScheme.onSurface.withOpacity(0.8),
        ),
      );
    }

    // Show as numbered list
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: steps.where((s) => s.trim().isNotEmpty).length,
      itemBuilder: (context, index) {
        String step = steps[index].trim();
        if (step.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.only(right: 12, top: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  step,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: _isResting
          ? _buildRestActionButton(theme)
          : Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.skip_next,
                    label: 'Skip',
                    color: theme.colorScheme.errorContainer,
                    textColor: theme.colorScheme.onErrorContainer,
                    onPressed: _skipExercise,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: _buildActionButton(
                    icon: Icons.check_circle,
                    label: 'Complete',
                    color: theme.colorScheme.primary,
                    textColor: theme.colorScheme.onPrimary,
                    onPressed: _completeExercise,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildRestActionButton(ThemeData theme) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.fast_forward, color: Colors.white),
      label: const Text(
        'Skip Rest',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.secondary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      onPressed: _skipRest,
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: textColor),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      onPressed: onPressed,
    );
  }
}

class WorkoutSummaryScreen extends StatefulWidget {
  final double totalDuration;
  final int workoutId;

  const WorkoutSummaryScreen({
    super.key,
    required this.totalDuration,
    required this.workoutId,
  });

  @override
  State<WorkoutSummaryScreen> createState() => _WorkoutSummaryScreenState();
}

class _WorkoutSummaryScreenState extends State<WorkoutSummaryScreen>
    with SingleTickerProviderStateMixin {
  final _notesController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late ConfettiController _confettiController;
  bool _showConfetti = true;
  double _rating = 4.0; // Default rating
  int _caloriesBurned = 0;

  @override
  void initState() {
    super.initState();

    // Set system UI for immersive experience
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    // Initialize confetti controller
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));

    // Start animations
    _animationController.forward();
    _confettiController.play();

    // Calculate estimated calories burned (simplified)
    _calculateCaloriesBurned();

    // Hide confetti after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() => _showConfetti = false);
      }
    });
  }

  void _calculateCaloriesBurned() {
    // A simplified formula:
    // Average calorie burn is about 5-10 calories per minute for moderate exercise
    const caloriesPerMinute = 8.0;
    setState(() {
      _caloriesBurned = (widget.totalDuration * caloriesPerMinute).round();
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    _animationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WorkoutLogProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Workout Complete',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme.colorScheme.onSurface,
        actions: [
          // Share button
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share workout results
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sharing workout results')));
            },
          ),
          // Close button
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main content
          FadeTransition(
            opacity: _fadeInAnimation,
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Celebration header
                      _buildCelebrationHeader(theme),

                      // Workout date and time
                      _buildWorkoutTime(theme),

                      // Main stats section
                      _buildMainStats(theme),

                      // Divider
                      const Divider(height: 40),

                      // Workout experience rating
                      _buildRatingSection(theme),

                      const SizedBox(height: 24),

                      // Notes input
                      _buildNotesSection(theme, provider),

                      const SizedBox(height: 32),

                      // Error handling
                      if (provider.hasError)
                        _buildErrorMessage(provider, theme),

                      // Save button
                      _buildSaveButton(theme, provider),

                      // Extra space at bottom
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Confetti overlay
          if (_showConfetti)
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                particleDrag: 0.05,
                emissionFrequency: 0.05,
                numberOfParticles: 20,
                gravity: 0.1,
                colors: [
                  Colors.blue,
                  Colors.green,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                  theme.colorScheme.primary,
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCelebrationHeader(ThemeData theme) {
    return Column(
      children: [
        // Trophy icon with animation
        Stack(
          alignment: Alignment.center,
          children: [
            // Background glow
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withOpacity(0.1),
              ),
            ),

            // Trophy icon
            Container(
              width: 120,
              height: 120,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withOpacity(0.2),
              ),
              child: Lottie.asset(
                'assets/animations/trophy.json',
                repeat: false,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Congratulation text
        Text(
          'Workout Completed!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        Text(
          'Great job on your fitness journey today!',
          style: TextStyle(
            fontSize: 16,
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildWorkoutTime(ThemeData theme) {
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, MMMM d').format(now);
    final formattedTime = DateFormat('h:mm a').format(now);

    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 24),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            '$formattedDate at $formattedTime',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainStats(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main stats grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.3,
            padding: const EdgeInsets.all(16),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildStatCard(
                theme: theme,
                icon: Icons.timer,
                iconColor: Colors.blue,
                title: 'Duration',
                value: '${widget.totalDuration.toStringAsFixed(1)} min',
              ),
              _buildStatCard(
                theme: theme,
                icon: Icons.local_fire_department,
                iconColor: Colors.orange,
                title: 'Calories',
                value: '$_caloriesBurned kcal',
              ),
              _buildStatCard(
                theme: theme,
                icon: Icons.fitness_center,
                iconColor: Colors.green,
                title: 'Exercises',
                value: 'Completed',
              ),
              _buildStatCard(
                theme: theme,
                icon: Icons.emoji_events,
                iconColor: Colors.amber,
                title: 'Streak',
                value: '3 days',
              ),
            ],
          ),

          // Expanded stats (optional)
          ExpansionTile(
            title: Text(
              'More Details',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            tilePadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildDetailItem(
                      theme: theme,
                      icon: Icons.speed,
                      title: 'Avg. Rest',
                      value: '45 sec',
                    ),
                  ),
                  Expanded(
                    child: _buildDetailItem(
                      theme: theme,
                      icon: Icons.bolt,
                      title: 'Intensity',
                      value: 'Moderate',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildDetailItem(
                      theme: theme,
                      icon: Icons.timer_outlined,
                      title: 'Total Sets',
                      value: '12 sets',
                    ),
                  ),
                  Expanded(
                    child: _buildDetailItem(
                      theme: theme,
                      icon: Icons.insights,
                      title: 'Progress',
                      value: '+5% from last',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required ThemeData theme,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How was your workout?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),

        // Rating slider
        Row(
          children: [
            // Bad emoji
            Icon(
              Icons.sentiment_very_dissatisfied,
              color: _rating < 2
                  ? Colors.red
                  : theme.colorScheme.onSurface.withOpacity(0.3),
              size: 24,
            ),

            // Slider
            Expanded(
              child: Slider(
                value: _rating,
                min: 1,
                max: 5,
                divisions: 4,
                activeColor: _getColorForRating(_rating, theme),
                inactiveColor: theme.colorScheme.surfaceContainerHighest,
                onChanged: (value) {
                  setState(() {
                    _rating = value;
                  });

                  // Add haptic feedback
                  HapticFeedback.selectionClick();
                },
              ),
            ),

            // Good emoji
            Icon(
              Icons.sentiment_very_satisfied,
              color: _rating > 4
                  ? Colors.green
                  : theme.colorScheme.onSurface.withOpacity(0.3),
              size: 24,
            ),
          ],
        ),

        // Rating label
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: _getColorForRating(_rating, theme).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _getLabelForRating(_rating),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _getColorForRating(_rating, theme),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getColorForRating(double rating, ThemeData theme) {
    if (rating >= 4.5) return Colors.green;
    if (rating >= 3.5) return Colors.lightGreen;
    if (rating >= 2.5) return Colors.amber;
    if (rating >= 1.5) return Colors.orange;
    return Colors.red;
  }

  String _getLabelForRating(double rating) {
    if (rating >= 4.5) return 'Excellent! 💪';
    if (rating >= 3.5) return 'Great! 😀';
    if (rating >= 2.5) return 'Good 🙂';
    if (rating >= 1.5) return 'Okay 😐';
    return 'Difficult 😓';
  }

  Widget _buildNotesSection(ThemeData theme, WorkoutLogProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Workout Notes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),

        // Text input field with suggestions
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                hintText: 'How did it go? Any important notes...',
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                  ),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              maxLines: 4,
              onChanged: (value) => provider.performanceNotes = value,
            ),

            // Quick suggestion chips
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildSuggestionChip(
                    'Felt great!',
                    theme,
                    onTap: () => _addToNotes('Felt great during this workout!'),
                  ),
                  _buildSuggestionChip(
                    'Increase weights next time',
                    theme,
                    onTap: () =>
                        _addToNotes('Should increase weights next time.'),
                  ),
                  _buildSuggestionChip(
                    'Struggled with form',
                    theme,
                    onTap: () => _addToNotes(
                        'Struggled with proper form, need to focus on technique.'),
                  ),
                  _buildSuggestionChip(
                    'Need longer rest periods',
                    theme,
                    onTap: () =>
                        _addToNotes('Need longer rest periods between sets.'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSuggestionChip(String label, ThemeData theme,
      {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _addToNotes(String text) {
    final currentText = _notesController.text;

    setState(() {
      // Add text with proper spacing
      if (currentText.isEmpty) {
        _notesController.text = text;
      } else if (currentText.endsWith('.') ||
          currentText.endsWith('!') ||
          currentText.endsWith('?')) {
        _notesController.text = '$currentText $text';
      } else {
        _notesController.text = '$currentText. $text';
      }
    });

    // Update provider
    Provider.of<WorkoutLogProvider>(context, listen: false).performanceNotes =
        _notesController.text;

    // Add haptic feedback
    HapticFeedback.selectionClick();
  }

  Widget _buildErrorMessage(WorkoutLogProvider provider, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: theme.colorScheme.error,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Error Saving Workout',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.error,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  provider.errorMessage ?? 'An unknown error occurred',
                  style: TextStyle(
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(ThemeData theme, WorkoutLogProvider provider) {
    return Container(
      width: double.infinity,
      height: 56,
      margin: const EdgeInsets.only(bottom: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        onPressed:
            provider.isLoading ? null : () => _saveWorkout(context, provider),
        child: provider.isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.onPrimary,
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Saving...',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.save,
                    color: theme.colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Save & Finish',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _saveWorkout(
      BuildContext context, WorkoutLogProvider provider) async {
    final userId =
        context.read<ProfileProvider>().user?.userId.toString() ?? '0';

    // Add workout rating to provider

    // Add haptic feedback
    HapticFeedback.mediumImpact();

    final success = await provider.finalizeWorkout(
      userId: int.parse(userId),
      workoutId: widget.workoutId,
    );

    if (success) {
      // Show success animation
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/animations/success.json',
                width: 200,
                height: 200,
                repeat: false,
              ),
            ],
          ),
        ),
      );

      // Delay navigation to show animation
      Future.delayed(const Duration(milliseconds: 1500), () {
        Navigator.popUntil(context, (route) => route.isFirst);
      });
    }
  }
}
