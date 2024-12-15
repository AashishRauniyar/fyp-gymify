import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gymify/models/workout_model.dart';
import 'package:gymify/providers/log_provider/log_provider.dart';
import 'package:provider/provider.dart';
import 'package:gymify/providers/workout_provider/workout_provider.dart';

class WorkoutListScreen extends StatelessWidget {
  const WorkoutListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
      ),
      body: ChangeNotifierProvider(
        create: (_) => WorkoutProvider()..fetchAllWorkouts(),
        child: Consumer<WorkoutProvider>(
          builder: (context, workoutProvider, child) {
            if (workoutProvider.workouts.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              itemCount: workoutProvider.workouts.length,
              itemBuilder: (context, index) {
                final workout = workoutProvider.workouts[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              WorkoutDetailScreen(workoutId: workout.workoutId),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: workout.workoutImage.isNotEmpty
                              ? NetworkImage(workout.workoutImage)
                              : const AssetImage(
                                      'assets/images/workout_image/defaultWorkoutImage.jpg')
                                  as ImageProvider,
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5),
                            BlendMode.darken,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          workout.workoutName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          workout.targetMuscleGroup,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class WorkoutDetailScreen extends StatelessWidget {
  final int workoutId;

  const WorkoutDetailScreen({super.key, required this.workoutId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Details'),
      ),
      body: ChangeNotifierProvider(
        create: (_) => WorkoutProvider()..fetchWorkoutById(workoutId),
        child: Consumer<WorkoutProvider>(
          builder: (context, workoutProvider, child) {
            if (workoutProvider.selectedWorkout == null &&
                !workoutProvider.hasError) {
              return const Center(child: CircularProgressIndicator());
            }

            if (workoutProvider.hasError) {
              return const Center(
                child: Text(
                  'Error loading workout details.',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            }

            final workout = workoutProvider.selectedWorkout!;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Workout Image
                    if (workout.workoutImage.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          workout.workoutImage,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        ),
                      ),
                    const SizedBox(height: 16),
                    // Workout Info
                    Text(
                      workout.workoutName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      workout.description,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoChip(
                              "Muscle Group", workout.targetMuscleGroup),
                          _buildInfoChip("Difficulty", workout.difficulty),
                          _buildInfoChip("Goal", workout.goalType),
                          _buildInfoChip("Level", workout.fitnessLevel),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Exercises List
                    const Text(
                      'Exercises:',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: workout.workoutexercises?.length,
                      itemBuilder: (context, index) {
                        final exercise = workout.workoutexercises?[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            title: Text(
                              exercise?.exercises?.exerciseName ??
                                  'Unknown Exercise',
                            ),
                            subtitle: Text(
                              'Sets: ${exercise?.sets}, Reps: ${exercise?.reps}, Duration: ${exercise?.duration}s',
                            ),
                            trailing: const Icon(Icons.fitness_center),
                          ),
                        );
                      },
                    ),

                    ElevatedButton(
                      onPressed: () {
                        // get current time and pass it as start time
                        

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExerciseLogScreen(
                              workoutId: workout.workoutId,
                              exercises: workout.workoutexercises ?? [],
                            ),
                          ),
                        );
                      },
                      child: const Text('Start Workout'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Chip(
      label: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}

// // Placeholder FinalScreen for confirmation
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

//!------------------------------------------------------------------------------------------------------------
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
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  void _resetTimer() {
    setState(() {
      _elapsedSeconds = 0;
    });
  }

  void _logCurrentExercise(bool skipped) {
    final logProvider = Provider.of<WorkoutLogProvider>(context, listen: false);
    final currentExercise = widget.exercises[currentExerciseIndex];

    logProvider.addExerciseLog(
      exerciseId: currentExercise.exerciseId,
      startTime: skipped
          ? null
          : DateTime.now().subtract(Duration(seconds: _elapsedSeconds)),
      endTime: skipped ? null : DateTime.now(),
      duration: skipped ? 0.0 : _elapsedSeconds / 60,
      restDuration: 0.0,
      skipped: skipped,
    );

    _resetTimer();
    if (currentExerciseIndex < widget.exercises.length - 1) {
      setState(() {
        currentExerciseIndex++;
      });
    } else {
      _timer?.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PerformanceNotesScreen(workoutId: widget.workoutId),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentExercise = widget.exercises[currentExerciseIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Exercise ${currentExerciseIndex + 1}/${widget.exercises.length}'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Time Elapsed: $_elapsedSeconds seconds'),
          const SizedBox(height: 16),
          Card(
            margin: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(currentExercise.exercises?.exerciseName ??
                    'Unknown Exercise'),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => _logCurrentExercise(false),
                      child: const Text('Log'),
                    ),
                    ElevatedButton(
                      onPressed: () => _logCurrentExercise(true),
                      child: const Text('Skip'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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

                await logProvider.finalizeWorkout(
                    userId: 1, workoutId: workoutId);

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
