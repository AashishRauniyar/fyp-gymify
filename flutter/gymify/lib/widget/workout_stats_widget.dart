import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:gymify/models/workout_log_models/workout_log_model.dart';
import 'package:gymify/providers/log_provider/log_provider.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class WorkoutStatsWidget extends StatelessWidget {
  final String userId;

  const WorkoutStatsWidget({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutLogProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return _buildLoadingState(context);
        }

        if (provider.hasError) {
          return _buildErrorState(context);
        }

        final logs = provider.userLogs;

        if (logs.isEmpty) {
          return _buildEmptyState(context);
        }

        // Calculate today's workouts
        final today = DateTime.now();
        final todayLogs = logs.where((log) {
          return _isSameDay(log.workoutDate, today);
        }).toList();

        // Calculate this week's workouts
        final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
        final weekLogs = logs.where((log) {
          return log.workoutDate
                  .isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
              log.workoutDate.isBefore(today.add(const Duration(days: 1)));
        }).toList();

        // Calculate stats
        int totalWorkoutsThisWeek = weekLogs.length;
        double totalDurationThisWeek = weekLogs.fold(
            0.0, (sum, log) => sum + double.parse(log.totalDuration));
        double totalCaloriesThisWeek = weekLogs.fold(
            0.0, (sum, log) => sum + double.parse(log.caloriesBurned));

        // Calculate streaks
        int currentStreak = _calculateCurrentStreak(logs);
        int longestStreak = _calculateLongestStreak(logs);

        // Calculate most trained muscle group
        String mostTrainedMuscleGroup = _calculateMostTrainedMuscleGroup(logs);

        return _buildWorkoutStatsCard(
          context,
          todayLogs.isNotEmpty,
          totalWorkoutsThisWeek,
          totalDurationThisWeek,
          totalCaloriesThisWeek,
          currentStreak,
          longestStreak,
          mostTrainedMuscleGroup,
        );
      },
    );
  }

  Widget _buildWorkoutStatsCard(
    BuildContext context,
    bool workoutTodayCompleted,
    int totalWorkoutsThisWeek,
    double totalDurationThisWeek,
    double totalCaloriesThisWeek,
    int currentStreak,
    int longestStreak,
    String mostTrainedMuscleGroup,
  ) {
    final theme = Theme.of(context);

    // Calculate weekly target progress (assuming target is 5 workouts per week)
    const targetWorkoutsPerWeek = 5;
    final weeklyProgress =
        (totalWorkoutsThisWeek / targetWorkoutsPerWeek).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16.0),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(16),
      //   gradient: LinearGradient(
      //     colors: [
      //       theme.colorScheme.onSurface.withOpacity(0.1),
      //       theme.colorScheme.onSurface.withOpacity(0.05),
      //     ],
      //     begin: Alignment.topLeft,
      //     end: Alignment.bottomRight,
      //   ),
      //   border: Border.all(
      //     color: theme.colorScheme.onSurface.withOpacity(0.1),
      //     width: 1.5,
      //   ),
      // ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),

        gradient: Theme.of(context).brightness == Brightness.dark
            ? LinearGradient(
                colors: [
                  theme.colorScheme.onSurface.withOpacity(0.1),
                  theme.colorScheme.onSurface.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null, // For light mode, no gradient, just a white background
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white // White background for light mode
            : null, // Dark mode will apply the gradient above
        border: Border.all(
          color: theme.colorScheme.onSurface.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workoutTodayCompleted
                          ? 'Workout completed today! 🎉'
                          : 'No workout today',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: workoutTodayCompleted
                            ? theme.colorScheme.primary
                            : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '$totalWorkoutsThisWeek/$targetWorkoutsPerWeek',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'workouts this week',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$currentStreak day streak',
                      style: TextStyle(
                        color: currentStreak > 0
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withOpacity(0.6),
                        fontWeight: currentStreak > 0
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              CircularPercentIndicator(
                radius: 40.0,
                lineWidth: 8.0,
                percent: weeklyProgress,
                center: Text(
                  '${(weeklyProgress * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                progressColor: theme.colorScheme.onSurface,
                backgroundColor: theme.colorScheme.onSurface.withOpacity(0.2),
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn(
                context,
                Icons.timer,
                totalDurationThisWeek.toStringAsFixed(0),
                'minutes',
                Colors.blue,
              ),
              _buildStatColumn(
                context,
                Icons.local_fire_department,
                totalCaloriesThisWeek.toStringAsFixed(0),
                'calories',
                Colors.red,
              ),
              _buildStatColumn(
                context,
                Icons.emoji_events,
                '$longestStreak',
                'best streak',
                Colors.amber,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.fitness_center,
                size: 16,
                color: theme.colorScheme.onSurface,
              ),
              const SizedBox(width: 8),
              Text(
                'Most trained: ',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              Text(
                mostTrainedMuscleGroup,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              context.pushNamed('workoutHistory', extra: userId);
            },
            // icon: const Icon(Icons.history),
            label: const Text('View Workout History'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: theme.colorScheme.primary,
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(
    BuildContext context,
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Could not load workout data',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Provider.of<WorkoutLogProvider>(context, listen: false)
                  .fetchUserLogs(userId);
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.onSurface.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.fitness_center,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
            size: 48,
          ),
          const SizedBox(height: 16), 
          Text(
            'No workout data available',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Start tracking your workouts to see statistics',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              context.pushNamed('workoutSearch'); // Navigate to workouts page
            },
            // icon: const Icon(Icons.play_arrow),
            label: const Text('Discover Workout'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: theme.colorScheme.primary,
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods for date calculations
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Calculate current streak
  int _calculateCurrentStreak(List<WorkoutLog> logs) {
    if (logs.isEmpty) return 0;

    // Sort logs by date (newest first)
    final sortedLogs = List<WorkoutLog>.from(logs)
      ..sort((a, b) => b.workoutDate.compareTo(a.workoutDate));

    // Check if there's a workout today
    final today = DateTime.now();
    bool hasWorkoutToday =
        sortedLogs.any((log) => _isSameDay(log.workoutDate, today));

    // If no workout today, check if there was one yesterday
    if (!hasWorkoutToday) {
      final yesterday = today.subtract(const Duration(days: 1));
      bool hasWorkoutYesterday =
          sortedLogs.any((log) => _isSameDay(log.workoutDate, yesterday));

      // If no workout yesterday, streak is 0
      if (!hasWorkoutYesterday) return 0;
    }

    // Count streak
    int streak = 0;
    DateTime currentDate =
        hasWorkoutToday ? today : today.subtract(const Duration(days: 1));

    while (true) {
      bool hasWorkout =
          sortedLogs.any((log) => _isSameDay(log.workoutDate, currentDate));
      if (!hasWorkout) break;

      streak++;
      currentDate = currentDate.subtract(const Duration(days: 1));
    }

    return streak;
  }

  // Calculate longest streak
  int _calculateLongestStreak(List<WorkoutLog> logs) {
    if (logs.isEmpty) return 0;

    // Group logs by date (to handle multiple workouts on same day)
    final Map<String, bool> workoutDays = {};
    for (var log in logs) {
      final dateStr = DateFormat('yyyy-MM-dd').format(log.workoutDate);
      workoutDays[dateStr] = true;
    }

    // Sort dates
    final sortedDates = workoutDays.keys.toList()..sort();
    if (sortedDates.isEmpty) return 0;

    int longestStreak = 1;
    int currentStreak = 1;

    for (int i = 1; i < sortedDates.length; i++) {
      final currentDate = DateTime.parse(sortedDates[i]);
      final prevDate = DateTime.parse(sortedDates[i - 1]);

      // Check if dates are consecutive
      if (currentDate.difference(prevDate).inDays == 1) {
        currentStreak++;
        if (currentStreak > longestStreak) {
          longestStreak = currentStreak;
        }
      } else {
        currentStreak = 1;
      }
    }

    return longestStreak;
  }

  // Calculate most trained muscle group
  String _calculateMostTrainedMuscleGroup(List<WorkoutLog> logs) {
    if (logs.isEmpty) return 'None';

    // Count muscle groups
    final Map<String, int> muscleGroups = {};

    for (var log in logs) {
      for (var exercise in log.workoutexerciseslogs) {
        final muscleGroup = exercise.exercises.targetMuscleGroup;
        muscleGroups[muscleGroup] = (muscleGroups[muscleGroup] ?? 0) + 1;
      }
    }

    // If no muscle groups, return none
    if (muscleGroups.isEmpty) return 'None';

    // Find most trained
    String mostTrained =
        muscleGroups.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    return mostTrained;
  }
}
