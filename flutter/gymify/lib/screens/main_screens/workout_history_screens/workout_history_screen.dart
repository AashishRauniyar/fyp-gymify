// lib/screens/workout_logs_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/models/workout_log_models/workout_exercise_log_model.dart';
import 'package:gymify/models/workout_log_models/workout_log_model.dart';
import 'package:gymify/providers/log_provider/log_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  final String userId;

  const WorkoutHistoryScreen({super.key, required this.userId});

  @override
  State<WorkoutHistoryScreen> createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch workout logs after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WorkoutLogProvider>(context, listen: false)
          .fetchUserLogs(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy - h:mm a');

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Workout History',
        actions: [
          IconButton(
            icon: Icon(Icons.refresh,
                color: Theme.of(context).colorScheme.onSurface),
            onPressed: () {
              Provider.of<WorkoutLogProvider>(context, listen: false)
                  .fetchUserLogs(widget.userId);
            },
          ),
        ],
      ),
      body: Consumer<WorkoutLogProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    provider.errorMessage ?? 'Failed to load workout logs',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.fetchUserLogs(widget.userId);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (provider.userLogs.isEmpty) {
            return const Center(
              child: Text('No workout logs found. Start working out!'),
            );
          }
          return RefreshIndicator(
            onRefresh: () => provider.fetchUserLogs(widget.userId),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: provider.userLogs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final log = provider.userLogs[index];
                return _WorkoutLogCard(log: log, dateFormat: dateFormat);
              },
            ),
          );
        },
      ),
    );
  }
}

class _ExerciseLogItem extends StatelessWidget {
  final Workoutexerciseslog exerciseLog;

  const _ExerciseLogItem({required this.exerciseLog});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Add navigation to exercise details screen
        context.pushNamed('exerciseDetails', extra: exerciseLog.exercises);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
            width: 1.5,
          ),
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: exerciseLog.exercises.imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    exerciseLog.exercises.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: const Icon(Icons.fitness_center),
                    ),
                  ),
                )
              : Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Icon(Icons.fitness_center),
                ),
          title: Text(
            exerciseLog.exercises.exerciseName ?? 'Unknown Exercise',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                'Target: ${exerciseLog.exercises.targetMuscleGroup ?? 'N/A'}',
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 4),
              Text(
                'Duration: ${double.parse(exerciseLog.exerciseDuration).toStringAsFixed(2)} min',
              ),
              if ((double.tryParse(exerciseLog.restDuration) ?? 0) > 0)
                Text(
                  'Rest: ${double.parse(exerciseLog.restDuration).toStringAsFixed(2)} min',
                ),
              if (exerciseLog.skipped)
                const Text(
                  'Skipped',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkoutLogCard extends StatelessWidget {
  final WorkoutLog log;
  final DateFormat dateFormat;

  const _WorkoutLogCard({
    required this.log,
    required this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: ExpansionTile(
        // Align expanded content to the top-left
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        expandedAlignment: Alignment.topLeft,

        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          'Workout on ${dateFormat.format(log.workoutDate)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            'Duration: ${double.parse(log.totalDuration).toStringAsFixed(2)} min  |  Exercises: ${log.workoutexerciseslogs.length}',
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        childrenPadding: const EdgeInsets.all(16),
        children: [
          if (log.performanceNotes.isNotEmpty) ...[
            const Text(
              'Performance Notes:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(log.performanceNotes),
            const Divider(),
          ],
          const Text(
            'Exercises:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (log.workoutexerciseslogs.isNotEmpty)
            ...log.workoutexerciseslogs.map(
              (exerciseLog) => _ExerciseLogItem(exerciseLog: exerciseLog),
            )
          else
            const Text('No exercise details available'),
        ],
      ),
    );
  }
}
