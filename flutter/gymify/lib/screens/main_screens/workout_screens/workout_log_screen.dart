import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymify/colors/custom_colors.dart';
import 'package:gymify/models/workout_model.dart';
import 'package:gymify/providers/auth_provider/auth_provider.dart';
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
  int currentExerciseIndex = 0;
  Timer? _timer;
  Timer? _restTimer;
  int _elapsedSeconds = 0;
  int _restSeconds = 30; // Rest timer duration
  bool _isResting = false; // Rest state
  bool _exerciseLogged = false; // Prevent duplicate logging

  @override
  void initState() {
    super.initState();
    _startExerciseTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _restTimer?.cancel();
    super.dispose();
  }

  void _startExerciseTimer() {
    _timer?.cancel(); // Cancel previous timer
    _elapsedSeconds = 0;
    _isResting = false;
    _exerciseLogged = false; // Reset logged state
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  void _startRestTimer() {
    _timer?.cancel(); // Cancel exercise timer
    setState(() {
      _restSeconds = 30; // Reset rest timer
      _isResting = true;
      _exerciseLogged = true; // Ensure exercise is logged
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
    if (_exerciseLogged) return; // Prevent duplicate logging

    final logProvider = Provider.of<WorkoutLogProvider>(context, listen: false);
    final currentExercise = widget.exercises[currentExerciseIndex];

    logProvider.addExerciseLog(
      exerciseId: currentExercise.exerciseId,
      exerciseDuration:
          skipped ? 0.0 : _elapsedSeconds / 60, // Convert seconds to minutes
      restDuration: _isResting
          ? _restSeconds / 60
          : 0.0, // Include rest only if applicable
      skipped: skipped,
    );

    _exerciseLogged = true; // Mark as logged
  }

  void _nextExercise() {
    if (currentExerciseIndex < widget.exercises.length - 1) {
      setState(() {
        currentExerciseIndex++;
      });
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
        builder: (context) =>
            PerformanceNotesScreen(workoutId: widget.workoutId),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Timer Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: CustomColors.primaryShade2.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _isResting
                    ? "Rest Timer: ${_formattedTime(_restSeconds)}"
                    : "Time Elapsed: ${_formattedTime(_elapsedSeconds)}",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Exercise Details
            if (!_isResting)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.network(
                        currentExercise.exercises?.imageUrl ??
                            'https://via.placeholder.com/400',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentExercise.exercises?.exerciseName ??
                                'Unknown Exercise',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Sets: ${currentExercise.sets} | Reps: ${currentExercise.reps} | Duration: ${currentExercise.duration}s",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // Buttons
            if (!_isResting)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _skipExercise,
                    icon: const Icon(Icons.skip_next),
                    label: const Text("Skip"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _logCurrentExercise();
                      _startRestTimer();
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text("Next"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            if (_isResting)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _skipRest,
                    icon: const Icon(Icons.skip_next),
                    label: const Text("Skip Rest"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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

class PerformanceNotesScreen extends StatelessWidget {
  final int workoutId;

  const PerformanceNotesScreen({super.key, required this.workoutId});

  @override
  Widget build(BuildContext context) {
    final performanceNotesController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Performance Notes')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: performanceNotesController,
              decoration: const InputDecoration(
                labelText: 'Performance Notes',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final logProvider =
                    Provider.of<WorkoutLogProvider>(context, listen: false);
                logProvider.performanceNotes = performanceNotesController.text;
                // get current user id from auth provider

                int userId = int.parse(context.read<AuthProvider>().userId!);

                await logProvider.finalizeWorkout(
                    userId: userId, workoutId: workoutId);

                // Clear states and navigate to confirmation
                logProvider.clearStates();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WorkoutCompleteScreen(),
                  ),
                );
              },
              child: const Text('End Workout'),
            ),
          ],
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
      appBar: AppBar(title: const Text('Workout Complete')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Workout and exercises logged successfully!'),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}

class FinalScreen extends StatelessWidget {
  const FinalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Complete')),
      body: const Center(
        child: Text('Workout and exercises logged successfully!'),
      ),
    );
  }
}
