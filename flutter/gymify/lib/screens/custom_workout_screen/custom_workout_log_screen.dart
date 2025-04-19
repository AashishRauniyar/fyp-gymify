import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymify/colors/app_colors.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:video_player/video_player.dart';


class CustomWorkoutLogScreen extends StatefulWidget {
  final int customWorkoutId;
  final List<dynamic> exercises;
  final String workoutName;

  const CustomWorkoutLogScreen({
    super.key,
    required this.customWorkoutId,
    required this.exercises,
    required this.workoutName,
  });

  @override
  State<CustomWorkoutLogScreen> createState() => _CustomWorkoutLogScreenState();
}

class _CustomWorkoutLogScreenState extends State<CustomWorkoutLogScreen>
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
  double _totalDuration = 0.0;
  bool _isPipActive = false;
  late ScrollController _scrollController;
  bool _showFloatingVideo = false;

  // Pending exercise tracking
  int _pendingExerciseIndex = 0;
  double _pendingExerciseDuration = 0.0;
  bool _pendingSkipped = false;

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

    // Initialize scroll controller
    _scrollController = ScrollController()..addListener(_scrollListener);

    _initializeVideo();
    _startExerciseTimer();
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
          setState(() {
            _isVideoLoading = false;
            _videoController.play();
            _videoController.setLooping(true);
            _isVideoPlaying = true;
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

    // Simply tracking the time without saving to database
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

    // Ensure we're back in portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutCompletedScreen(
          totalDuration: _totalDuration,
          workoutName: widget.workoutName,
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
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        return _showExitDialog();
      },
      child: Scaffold(
        appBar: AppBar(
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
            onPressed: () => _showExitDialog(),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: _buildProgressCircle(),
            ),
          ],
        ),
        // Floating action button for quick exercise completion
        floatingActionButton: _isResting
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
                _buildActionButtons(theme),
              ],
            ),

            // Floating video player (appears when scrolling)
            if (_showFloatingVideo && !_isResting)
              _buildFloatingVideoPlayer(theme),

            // Picture-in-picture video
            if (_isPipActive && !_isResting && !_showFloatingVideo)
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

  Future<bool> _showExitDialog() async {
    final theme = Theme.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Workout?'),
        content:
            const Text('Your progress will not be saved if you leave now.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('END WORKOUT'),
          ),
        ],
      ),
    );

    if (result == true) {
      Navigator.pop(context);
    }
    return false;
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

  Widget _buildExerciseScreen(dynamic currentExercise, ThemeData theme) {
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
              : _buildVideoPlayerWithControls(),
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

  Widget _buildVideoPlayerWithControls() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Video player
        AspectRatio(
          aspectRatio: _videoController.value.aspectRatio,
          child: VideoPlayer(_videoController),
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

        // Video controls
        Positioned(
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
                    _videoController.seekTo(
                        newPosition > duration ? duration : newPosition);
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
              ],
            ),
          ),
        ),
      ],
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
            child: AspectRatio(
              aspectRatio: _videoController.value.aspectRatio,
              child: VideoPlayer(_videoController),
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
            aspectRatio: _videoController.value.aspectRatio,
            child: VideoPlayer(_videoController),
          ),
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

            // Rest suggestions
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
            // SizedBox(
            //   width: 200,
            //   height: 200,
            //   child: Lottie.asset(
            //     'assets/animations/rest_timer.json',
            //     repeat: true,
            //     animate: true,
            //   ),
            // ),

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

        // Get ready alert for last few seconds
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

  Widget _buildExerciseInfo(dynamic currentExercise, ThemeData theme) {
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
            Text(
              currentExercise.exercises?.exerciseName ?? 'Exercise',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              currentExercise.exercises?.description ??
                  'No description available',
              style:
                  TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.4),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.fitness_center, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Target: ${currentExercise.exercises?.targetMuscleGroup ?? 'N/A'}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (!_isResting)
            _buildActionButton(
              icon: Icons.skip_next,
              label: 'Skip Exercise',
              color: Colors.red,
              onPressed: _skipExercise,
            ),
          if (_isResting)
            _buildActionButton(
              icon: Icons.fast_forward,
              label: 'Skip Rest',
              color: Colors.blue,
              onPressed: _skipRest,
            ),
          if (!_isResting)
            _buildActionButton(
              icon: Icons.check_circle,
              label: 'Complete',
              color: Colors.green,
              onPressed: _completeExercise,
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 24, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
    );
  }
}

class WorkoutCompletedScreen extends StatefulWidget {
  final double totalDuration;
  final String workoutName;

  const WorkoutCompletedScreen({
    super.key,
    required this.totalDuration,
    required this.workoutName,
  });

  @override
  State<WorkoutCompletedScreen> createState() => _WorkoutCompletedScreenState();
}

class _WorkoutCompletedScreenState extends State<WorkoutCompletedScreen> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     'Workout Complete',
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   backgroundColor: CustomColors.primary,
      //   iconTheme: const IconThemeData(color: Colors.white),
      // ),
      appBar: const CustomAppBar(
        title: 'Workout Complete',
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(height: 40),
                  const Icon(Icons.check_circle_outline,
                      size: 120, color: Colors.green),
                  const SizedBox(height: 24),
                  const Text(
                    'Workout Completed!',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightPrimary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.workoutName,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface.withOpacity(0.7)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  _buildStatCard(
                    icon: Icons.timer,
                    title: 'Total Duration',
                    value: '${widget.totalDuration.toStringAsFixed(1)} minutes',
                  ),
                ],
              ),
            ),
            _buildDoneButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              icon,
              size: 34,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoneButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
        ),
        onPressed: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        child: const Text(
          'Done',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
    );
  }
}
