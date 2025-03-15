import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gymify/providers/profile_provider/profile_provider.dart';
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
  int _currentExerciseIndex = 0;
  Timer? _exerciseTimer;
  Timer? _restTimer;
  int _elapsedSeconds = 0;
  int _restSeconds = 30;
  bool _isResting = false;
  bool _isVideoPlaying = true;
  double _totalDuration = 0.0;

  // Pending exercise tracking (for logging after rest)
  int _pendingExerciseIndex = 0;
  double _pendingExerciseDuration = 0.0;
  bool _pendingSkipped = false;
  bool _isVideoLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWorkout();
    _initializeVideo();
    // Start timer for the first exercise
    _startExerciseTimer();
  }

  void _initializeWorkout() {
    final provider = Provider.of<WorkoutLogProvider>(context, listen: false);
    provider.initializeWorkout();
  }

  void _initializeVideo() {
    // Only initialize video if we're not in rest mode.
    if (_isResting) return;
    final currentExercise = widget.exercises[_currentExerciseIndex];
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(currentExercise.exercises?.videoUrl ?? ''),
    )..initialize().then((_) {
        setState(() {
          _isVideoLoading = false;
          _videoController.play();
        });
      }).catchError((_) {
        setState(() => _isVideoLoading = false);
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

  void _startRestTimer() {
    // Mute the video during rest.
    if (_videoController.value.isInitialized) {
      _videoController.setVolume(0);
    }
    // Cancel any active timers and switch to rest mode.
    _cancelTimers();
    setState(() {
      _restSeconds = 30;
      _isResting = true;
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
  }

  void _startExerciseTimer() {
    // Restore the volume for the exercise.
    if (_videoController.value.isInitialized) {
      _videoController.setVolume(1);
    }
    _cancelTimers();
    setState(() {
      _elapsedSeconds = 0;
      _isResting = false;
    });
    _exerciseTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsedSeconds++);
    });
  }

  void _cancelTimers() {
    _exerciseTimer?.cancel();
    _restTimer?.cancel();
  }

  // Called when the user completes the current exercise.
  void _completeExercise() {
    _pendingExerciseIndex = _currentExerciseIndex;
    _pendingExerciseDuration = _elapsedSeconds / 60.0;
    _pendingSkipped = false;
    _startRestTimer();
  }

  // Called when the user opts to skip the exercise.
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
      // Force reset rest mode and mark video as loading.
      setState(() {
        _currentExerciseIndex++;
        _isVideoLoading = true;
        _isResting = false;
      });
      // Dispose previous video controller before initializing a new one.
      _videoController.dispose();
      _initializeVideo();
      _startExerciseTimer();
    } else {
      _completeWorkout();
    }
  }

  void _skipRest() {
    _restTimer?.cancel();
    _logPendingExercise();
    _nextExercise();
  }

  void _completeWorkout() async {
    final provider = Provider.of<WorkoutLogProvider>(context, listen: false);
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
    _cancelTimers();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentExercise = widget.exercises[_currentExerciseIndex];
    final provider = Provider.of<WorkoutLogProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isResting
              ? "Rest Time"
              : 'Exercise ${_currentExerciseIndex + 1}/${widget.exercises.length}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: CustomColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Overall workout progress bar.
          LinearProgressIndicator(
            value: (_currentExerciseIndex + 1) / widget.exercises.length,
            backgroundColor: Colors.grey[300],
            valueColor:
                const AlwaysStoppedAnimation<Color>(CustomColors.primary),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Show video only when NOT in rest mode.
                  if (!_isResting)
                    _isVideoLoading
                        ? const SizedBox(
                            height: 250,
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : _videoController.value.isInitialized
                            ? AspectRatio(
                                aspectRatio: _videoController.value.aspectRatio,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    VideoPlayer(_videoController),
                                    IconButton(
                                      icon: Icon(
                                        _isVideoPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        size: 48,
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                      onPressed: _toggleVideoPlayPause,
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                  const SizedBox(height: 24),
                  // Animated switcher to display exercise timer OR rest screen.
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child:
                        _isResting ? _buildRestScreen() : _buildExerciseTimer(),
                  ),
                  const SizedBox(height: 24),
                  // Card with exercise info styled with card borders inspired by weight log.
                  _buildExerciseInfo(currentExercise),
                ],
              ),
            ),
          ),
          // Action buttons.
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (!_isResting)
                  _buildActionButton(
                    icon: Icons.skip_next,
                    label: 'Skip Exercise',
                    color: Colors.orange,
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
          ),
          if (provider.isLoading)
            const LinearProgressIndicator(
              color: CustomColors.primary,
              minHeight: 2,
            ),
        ],
      ),
    );
  }

  Widget _buildExerciseTimer() {
    return Column(
      key: const ValueKey('exercise_timer'),
      children: [
        const Text(
          'Exercise Time',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: CustomColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _formattedTime(_elapsedSeconds),
          style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildRestScreen() {
    return Column(
      key: const ValueKey('rest_screen'),
      children: [
        const Text(
          'Rest Time Remaining',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: CustomColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _formattedTime(_restSeconds),
          style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 200,
          height: 200,
          child: CircularProgressIndicator(
            value: _restSeconds / 30,
            strokeWidth: 8,
            backgroundColor: Colors.grey[200],
            valueColor:
                const AlwaysStoppedAnimation<Color>(CustomColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseInfo(Workoutexercise currentExercise) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 12),
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

//? working
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

class _WorkoutSummaryScreenState extends State<WorkoutSummaryScreen> {
  final _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WorkoutLogProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Workout Complete',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: CustomColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
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
                        color: CustomColors.primary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  _buildStatCard(
                    icon: Icons.timer,
                    title: 'Total Duration',
                    value: '${widget.totalDuration.toStringAsFixed(1)} minutes',
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _notesController,
                    decoration: InputDecoration(
                      labelText: 'Workout Notes',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'How did it go? Any important notes...',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    maxLines: 4,
                    onChanged: (value) => provider.performanceNotes = value,
                  ),
                ],
              ),
            ),
            if (provider.hasError)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'Error saving workout: ${provider.errorMessage}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            _buildSaveButton(provider),
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
            Icon(icon, size: 34, color: CustomColors.primary),
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

  Widget _buildSaveButton(WorkoutLogProvider provider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
        ),
        onPressed:
            provider.isLoading ? null : () => _saveWorkout(context, provider),
        child: provider.isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 3),
              )
            : const Text(
                'Save Workout',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
      ),
    );
  }

  Future<void> _saveWorkout(
      BuildContext context, WorkoutLogProvider provider) async {
    final userId =
        context.read<ProfileProvider>().user?.userId.toString() ?? '0';

    final success = await provider.finalizeWorkout(
      userId: int.parse(userId),
      workoutId: widget.workoutId,
    );

    if (success) {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }
}
