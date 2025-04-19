import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/models/workout_log_models/workout_exercise_log_model.dart';
import 'package:gymify/models/workout_log_models/workout_log_model.dart';
import 'package:gymify/models/workout_model.dart';
import 'package:gymify/providers/log_provider/log_provider.dart';
import 'package:gymify/providers/workout_provider/workout_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  final String userId;

  const WorkoutHistoryScreen({super.key, required this.userId});

  @override
  State<WorkoutHistoryScreen> createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedFilter = 'All';
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  String? targetMuscleFilter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Fetch workout logs after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WorkoutLogProvider>(context, listen: false)
          .fetchUserLogs(widget.userId);
    });

    // Initialize date range to last 30 days
    selectedEndDate = DateTime.now();
    selectedStartDate = selectedEndDate!.subtract(const Duration(days: 30));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy - h:mm a');
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Workout History',
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: theme.colorScheme.onSurface),
            onPressed: () => _showFilterOptions(context),
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: theme.colorScheme.onSurface),
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.fitness_center,
                    size: 64,
                    color: theme.colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No workout logs found',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Start working out to track your progress!',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Start a Workout'),
                    onPressed: () {
                      context.go('/'); // Navigate to workouts page
                    },
                  ),
                ],
              ),
            );
          }

          final List<WorkoutLog> filteredLogs = _filterLogs(provider.userLogs);

          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: theme.colorScheme.primary,
                  unselectedLabelColor:
                      theme.colorScheme.onSurface.withOpacity(0.6),
                  indicatorColor: theme.colorScheme.primary,
                  tabs: const [
                    Tab(text: 'LOGS'),
                    Tab(text: 'STATS'),
                    Tab(text: 'TRENDS'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // LOGS TAB
                    _buildLogsTab(filteredLogs, dateFormat, provider),

                    // STATS TAB
                    _buildStatsTab(filteredLogs, provider),

                    // TRENDS TAB
                    _buildTrendsTab(filteredLogs, provider),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // TABS IMPLEMENTATION

  Widget _buildLogsTab(List<WorkoutLog> logs, DateFormat dateFormat,
      WorkoutLogProvider provider) {
    if (logs.isEmpty) {
      return _buildEmptyFilterState();
    }

    return RefreshIndicator(
      onRefresh: () => provider.fetchUserLogs(widget.userId),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: logs.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final log = logs[index];
          return _WorkoutLogCard(log: log, dateFormat: dateFormat);
        },
      ),
    );
  }

  Widget _buildStatsTab(List<WorkoutLog> logs, WorkoutLogProvider provider) {
    if (logs.isEmpty) {
      return _buildEmptyFilterState();
    }

    final theme = Theme.of(context);

    // Calculate statistics
    int totalWorkouts = logs.length;
    double totalDuration =
        logs.fold(0.0, (sum, log) => sum + double.parse(log.totalDuration));
    double avgDuration = totalWorkouts > 0 ? totalDuration / totalWorkouts : 0;
    double totalCalories =
        logs.fold(0.0, (sum, log) => sum + double.parse(log.caloriesBurned));

    // Calculate most trained muscle groups
    final muscleGroupFrequency = <String, int>{};
    for (var log in logs) {
      for (var exercise in log.workoutexerciseslogs) {
        final muscleGroup = exercise.exercises.targetMuscleGroup;
        muscleGroupFrequency[muscleGroup] =
            (muscleGroupFrequency[muscleGroup] ?? 0) + 1;
      }
    }

    final sortedMuscleGroups = muscleGroupFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date range indicator
          if (selectedStartDate != null && selectedEndDate != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Stats for: ${DateFormat('MMM d').format(selectedStartDate!)} - ${DateFormat('MMM d, yyyy').format(selectedEndDate!)}',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          const SizedBox(height: 24),

          // Workout summary stats
          Text(
            'Workout Summary',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatCard(
                context,
                '$totalWorkouts',
                'Total Workouts',
                Icons.fitness_center,
                theme.colorScheme.primary,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                context,
                '${totalDuration.toStringAsFixed(1)} min',
                'Total Time',
                Icons.timer,
                theme.colorScheme.secondary,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatCard(
                context,
                '${avgDuration.toStringAsFixed(1)} min',
                'Avg Duration',
                Icons.schedule,
                Colors.orange,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                context,
                '${totalCalories.toStringAsFixed(0)} kcal',
                'Calories Burned',
                Icons.local_fire_department,
                Colors.red,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Most trained muscle groups
          Text(
            'Most Trained Muscle Groups',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          if (sortedMuscleGroups.isNotEmpty)
            ...sortedMuscleGroups.take(5).map((entry) => _buildMuscleGroupItem(
                context, entry.key, entry.value, totalWorkouts))
          else
            Text(
              'No muscle group data available',
              style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.6)),
            ),

          const SizedBox(height: 24),

          // Exercise completion rate
          Text(
            'Exercise Completion Rate',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          _buildCompletionRateChart(logs),
        ],
      ),
    );
  }

  Widget _buildTrendsTab(List<WorkoutLog> logs, WorkoutLogProvider provider) {
    if (logs.isEmpty) {
      return _buildEmptyFilterState();
    }

    final theme = Theme.of(context);

    // Group logs by week for weekly trend analysis
    final weeklyWorkouts = _groupWorkoutsByWeek(logs);
    final weeklyDurations = _calculateWeeklyDurations(logs);
    final weeklyCalories = _calculateWeeklyCalories(logs);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Workout Frequency',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: _buildWeeklyWorkoutChart(weeklyWorkouts),
          ),
          const SizedBox(height: 24),
          Text(
            'Weekly Workout Duration (minutes)',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: _buildWeeklyDurationChart(weeklyDurations),
          ),
          const SizedBox(height: 24),
          Text(
            'Weekly Calories Burned',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: _buildWeeklyCaloriesChart(weeklyCalories),
          ),
          const SizedBox(height: 24),
          Text(
            'Workout Time Distribution',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: _buildWorkoutTimeDistributionChart(logs),
          ),
        ],
      ),
    );
  }

  // FILTER HELPERS

  List<WorkoutLog> _filterLogs(List<WorkoutLog> logs) {
    // Filter by date range if selected
    List<WorkoutLog> filtered = logs;

    if (selectedStartDate != null && selectedEndDate != null) {
      filtered = filtered.where((log) {
        return log.workoutDate.isAfter(selectedStartDate!) &&
            log.workoutDate
                .isBefore(selectedEndDate!.add(const Duration(days: 1)));
      }).toList();
    }

    // Filter by target muscle group if selected
    if (targetMuscleFilter != null && targetMuscleFilter!.isNotEmpty) {
      filtered = filtered.where((log) {
        return log.workoutexerciseslogs.any((exerciseLog) =>
            exerciseLog.exercises.targetMuscleGroup == targetMuscleFilter);
      }).toList();
    }

    return filtered;
  }

  void _showFilterOptions(BuildContext context) {
    final theme = Theme.of(context);

    // Get unique muscle groups from all logs
    final provider = Provider.of<WorkoutLogProvider>(context, listen: false);
    final allMuscleGroups = <String>{};

    for (var log in provider.userLogs) {
      for (var exerciseLog in log.workoutexerciseslogs) {
        allMuscleGroups.add(exerciseLog.exercises.targetMuscleGroup);
      }
    }

    final muscleGroups = allMuscleGroups.toList()..sort();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter Workouts',
                        style: theme.textTheme.headlineSmall,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Date Range Filter
                  Text(
                    'Date Range',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: selectedStartDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              setState(() {
                                selectedStartDate = date;
                              });
                            }
                          },
                          child: Text(
                            selectedStartDate != null
                                ? DateFormat('MMM d, yyyy')
                                    .format(selectedStartDate!)
                                : 'Start Date',
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: selectedEndDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              setState(() {
                                selectedEndDate = date;
                              });
                            }
                          },
                          child: Text(
                            selectedEndDate != null
                                ? DateFormat('MMM d, yyyy')
                                    .format(selectedEndDate!)
                                : 'End Date',
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Quick date range buttons
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildQuickDateButton('Last 7 days', 7, setState),
                      _buildQuickDateButton('Last 30 days', 30, setState),
                      _buildQuickDateButton('Last 3 months', 90, setState),
                      _buildQuickDateButton('This year', 365, setState),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Muscle Group Filter
                  Text(
                    'Target Muscle Group',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: targetMuscleFilter == null,
                        onSelected: (selected) {
                          setState(() {
                            targetMuscleFilter = null;
                          });
                        },
                      ),
                      ...muscleGroups.map(
                        (muscle) => FilterChip(
                          label: Text(muscle),
                          selected: targetMuscleFilter == muscle,
                          onSelected: (selected) {
                            setState(() {
                              targetMuscleFilter = selected ? muscle : null;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Apply and Reset buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              selectedStartDate = null;
                              selectedEndDate = null;
                              targetMuscleFilter = null;
                            });
                          },
                          child: const Text('Reset Filters'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Apply filters and update state
                            this.setState(() {});
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Apply Filters'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildQuickDateButton(String label, int days, StateSetter setState) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedEndDate = DateTime.now();
          selectedStartDate = selectedEndDate!.subtract(Duration(days: days));
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Text(label),
    );
  }

  // CHART AND STAT WIDGETS

  Widget _buildStatCard(BuildContext context, String value, String label,
      IconData icon, Color color) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.primary.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const Spacer(),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMuscleGroupItem(
      BuildContext context, String muscleGroup, int count, int total) {
    final theme = Theme.of(context);
    final percentage = total > 0 ? count / total : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                muscleGroup,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              Text(
                '$count times',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percentage,
            minHeight: 8,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            valueColor:
                AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionRateChart(List<WorkoutLog> logs) {
    // Calculate completion rate
    int totalExercises = 0;
    int completedExercises = 0;

    for (var log in logs) {
      for (var exercise in log.workoutexerciseslogs) {
        totalExercises++;
        if (!exercise.skipped) {
          completedExercises++;
        }
      }
    }

    final completionRate =
        totalExercises > 0 ? completedExercises / totalExercises : 0.0;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 60.0,
            lineWidth: 12.0,
            percent: completionRate,
            center: Text(
              '${(completionRate * 100).toStringAsFixed(1)}%',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            progressColor: theme.colorScheme.primary,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            circularStrokeCap: CircularStrokeCap.round,
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Exercise Completion',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$completedExercises of $totalExercises exercises completed',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${totalExercises - completedExercises} exercises skipped',
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

  Map<String, int> _groupWorkoutsByWeek(List<WorkoutLog> logs) {
    final Map<String, int> weeklyData = {};
    final now = DateTime.now();

    // Initialize the weeks (up to 8 weeks back)
    for (int i = 7; i >= 0; i--) {
      final weekStart = now.subtract(Duration(days: now.weekday + 7 * i - 1));
      final weekLabel = 'Week ${8 - i}';
      weeklyData[weekLabel] = 0;
    }

    // Count workouts per week
    for (var log in logs) {
      final logDate = log.workoutDate;
      final weeksDifference = (now.difference(logDate).inDays / 7).floor();

      if (weeksDifference >= 0 && weeksDifference < 8) {
        final weekLabel = 'Week ${8 - weeksDifference}';
        weeklyData[weekLabel] = (weeklyData[weekLabel] ?? 0) + 1;
      }
    }

    return weeklyData;
  }

  Map<String, double> _calculateWeeklyDurations(List<WorkoutLog> logs) {
    final Map<String, double> weeklyData = {};
    final now = DateTime.now();

    // Initialize the weeks (up to 8 weeks back)
    for (int i = 7; i >= 0; i--) {
      final weekStart = now.subtract(Duration(days: now.weekday + 7 * i - 1));
      final weekLabel = 'Week ${8 - i}';
      weeklyData[weekLabel] = 0;
    }

    // Sum durations per week
    for (var log in logs) {
      final logDate = log.workoutDate;
      final weeksDifference = (now.difference(logDate).inDays / 7).floor();

      if (weeksDifference >= 0 && weeksDifference < 8) {
        final weekLabel = 'Week ${8 - weeksDifference}';
        weeklyData[weekLabel] =
            (weeklyData[weekLabel] ?? 0) + double.parse(log.totalDuration);
      }
    }

    return weeklyData;
  }

  Map<String, double> _calculateWeeklyCalories(List<WorkoutLog> logs) {
    final Map<String, double> weeklyData = {};
    final now = DateTime.now();

    // Initialize the weeks (up to 8 weeks back)
    for (int i = 7; i >= 0; i--) {
      final weekStart = now.subtract(Duration(days: now.weekday + 7 * i - 1));
      final weekLabel = 'Week ${8 - i}';
      weeklyData[weekLabel] = 0;
    }

    // Sum calories per week
    for (var log in logs) {
      final logDate = log.workoutDate;
      final weeksDifference = (now.difference(logDate).inDays / 7).floor();

      if (weeksDifference >= 0 && weeksDifference < 8) {
        final weekLabel = 'Week ${8 - weeksDifference}';
        weeklyData[weekLabel] =
            (weeklyData[weekLabel] ?? 0) + double.parse(log.caloriesBurned);
      }
    }

    return weeklyData;
  }

  Widget _buildWeeklyWorkoutChart(Map<String, int> weeklyWorkouts) {
    final List<String> weeks = weeklyWorkouts.keys.toList();
    final theme = Theme.of(context);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (weeklyWorkouts.values.isEmpty
                ? 5
                : weeklyWorkouts.values.reduce((a, b) => a > b ? a : b) + 2)
            .toDouble(),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < weeks.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      weeks[value.toInt()],
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value == value.roundToDouble() && value >= 0) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 10,
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(
          weeklyWorkouts.length,
          (index) {
            final entry = weeklyWorkouts.entries.elementAt(index);
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: entry.value.toDouble(),
                  color: theme.colorScheme.primary,
                  width: 16,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildWeeklyDurationChart(Map<String, double> weeklyDurations) {
    final List<String> weeks = weeklyDurations.keys.toList();
    final theme = Theme.of(context);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (weeklyDurations.values.isEmpty
            ? 60
            : weeklyDurations.values.reduce((a, b) => a > b ? a : b) * 1.2),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < weeks.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      weeks[value.toInt()],
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 30,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(
          weeklyDurations.length,
          (index) {
            final entry = weeklyDurations.entries.elementAt(index);
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: entry.value,
                  color: Colors.orange,
                  width: 16,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildWeeklyCaloriesChart(Map<String, double> weeklyCalories) {
    final List<String> weeks = weeklyCalories.keys.toList();
    final theme = Theme.of(context);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (weeklyCalories.values.isEmpty
            ? 500
            : weeklyCalories.values.reduce((a, b) => a > b ? a : b) * 1.2),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < weeks.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      weeks[value.toInt()],
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 250,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(
          weeklyCalories.length,
          (index) {
            final entry = weeklyCalories.entries.elementAt(index);
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: entry.value,
                  color: Colors.red,
                  width: 16,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildWorkoutTimeDistributionChart(List<WorkoutLog> logs) {
    // Count workouts by hour of day
    final Map<int, int> workoutsByHour = {};

    for (var log in logs) {
      final hour = log.workoutDate.hour;
      workoutsByHour[hour] = (workoutsByHour[hour] ?? 0) + 1;
    }

    // Create spots for the chart
    final List<FlSpot> spots = [];
    for (int hour = 0; hour < 24; hour++) {
      spots
          .add(FlSpot(hour.toDouble(), (workoutsByHour[hour] ?? 0).toDouble()));
    }

    final theme = Theme.of(context);

    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                final hour = spot.x.toInt();
                final formattedHour = hour < 12
                    ? (hour == 0 ? '12 AM' : '$hour AM')
                    : (hour == 12 ? '12 PM' : '${hour - 12} PM');
                return LineTooltipItem(
                  '$formattedHour: ${spot.y.toInt()} workouts',
                  TextStyle(color: theme.colorScheme.onSurface),
                );
              }).toList();
            },
          ),
          handleBuiltInTouches: true,
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: theme.colorScheme.onSurface.withOpacity(0.1),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 4,
              getTitlesWidget: (double value, TitleMeta meta) {
                final hour = value.toInt();
                return Text(
                  hour < 12
                      ? (hour == 0 ? '12 AM' : '$hour AM')
                      : (hour == 12 ? '12 PM' : '${hour - 12} PM'),
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value == value.toInt() && value >= 0) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 10,
                    ),
                  );
                }
                return const SizedBox();
              },
              reservedSize: 28,
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
              color: theme.colorScheme.onSurface.withOpacity(0.1), width: 1),
        ),
        minX: 0,
        maxX: 23,
        minY: 0,
        maxY: workoutsByHour.isEmpty
            ? 5
            : (workoutsByHour.values.reduce((a, b) => a > b ? a : b) + 1)
                .toDouble(),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: theme.colorScheme.secondary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: theme.colorScheme.secondary.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFilterState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.filter_list,
            size: 48,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          const Text(
            'No workouts match your filters',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filter criteria',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Reset Filters'),
            onPressed: () {
              setState(() {
                selectedStartDate = null;
                selectedEndDate = null;
                targetMuscleFilter = null;
              });
            },
          ),
        ],
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
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.onSurface.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ExpansionTile(
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          expandedAlignment: Alignment.topLeft,
          collapsedBackgroundColor: theme.colorScheme.surface,
          backgroundColor: theme.colorScheme.surface,
          shape: const Border(),
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: FutureBuilder<Workout?>(
            future: Provider.of<WorkoutProvider>(context, listen: false)
                .getWorkoutDetailsById(log.workoutId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                );
              }

              final workout = snapshot.data;
              final hasImage =
                  workout != null && workout.workoutImage.isNotEmpty;

              return Row(
                children: [
                  // Circular workout image
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primaryContainer,
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.shadow.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: hasImage
                          ? Image.network(
                              workout.workoutImage,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                Icons.fitness_center,
                                color: theme.colorScheme.primary,
                                size: 28,
                              ),
                            )
                          : Icon(
                              Icons.fitness_center,
                              color: theme.colorScheme.primary,
                              size: 28,
                            ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Workout info column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date row
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('MMM d, yyyy').format(log.workoutDate),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Workout name
                        Text(
                          workout?.workoutName ?? 'Workout',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 4),

                        // Time and target muscles
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: theme.colorScheme.secondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('h:mm a').format(log.workoutDate),
                              style: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.fitness_center,
                              size: 14,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                workout != null
                                    ? _formatTargetMuscleGroups(workout)
                                    : 'Unknown muscle groups',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(
                top: 12,
                left: 76), // Align with the content after the circular image
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.1),
                ),
              ),
              child: Row(
                children: [
                  _buildStatColumn(
                    context,
                    Icons.timer,
                    theme.colorScheme.primary,
                    '${double.parse(log.totalDuration).toStringAsFixed(0)} min',
                    'Duration',
                  ),
                  const SizedBox(width: 16),
                  _buildStatColumn(
                    context,
                    Icons.local_fire_department,
                    Colors.orange,
                    double.parse(log.caloriesBurned).toStringAsFixed(0),
                    'Calories',
                  ),
                  const SizedBox(width: 16),
                  _buildStatColumn(
                    context,
                    Icons.fitness_center,
                    theme.colorScheme.secondary,
                    '${log.workoutexerciseslogs.length}',
                    'Exercises',
                  ),
                ],
              ),
            ),
          ),
          childrenPadding: const EdgeInsets.all(16),
          children: [
            if (log.performanceNotes.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.note_alt,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Performance Notes',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      log.performanceNotes,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Exercises Section
            Row(
              children: [
                Icon(
                  Icons.fitness_center,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Exercises Completed',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (log.workoutexerciseslogs.isNotEmpty)
              ...log.workoutexerciseslogs.map(
                (exerciseLog) => _ExerciseLogItem(exerciseLog: exerciseLog),
              )
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.1),
                  ),
                ),
                child: Center(
                  child: Text(
                    'No exercise details available',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper method to format target muscle groups from workout
  String _formatTargetMuscleGroups(Workout workout) {
    final Set<String> muscleGroups = {};
    if (workout.workoutexercises != null) {
      for (var exercise in workout.workoutexercises!) {
        if (exercise.exercises != null &&
            exercise.exercises!.targetMuscleGroup.isNotEmpty) {
          muscleGroups.add(exercise.exercises!.targetMuscleGroup);
        }
      }
    }

    if (muscleGroups.isEmpty) return workout.targetMuscleGroup;
    if (muscleGroups.length <= 3) return muscleGroups.join(' • ');
    return 'Full Body';
  }
}

Widget _buildStatColumn(
  BuildContext context,
  IconData icon,
  Color color,
  String value,
  String label,
) {
  return Expanded(
    child: Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
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
    ),
  );
}

class _ExerciseLogItem extends StatelessWidget {
  final Workoutexerciseslog exerciseLog;

  const _ExerciseLogItem({required this.exerciseLog});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        // Navigate to exercise details screen
        context.pushNamed('exerciseDetails', extra: exerciseLog.exercises);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.onSurface.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Exercise Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: exerciseLog.exercises.imageUrl.isNotEmpty
                    ? Image.network(
                        exerciseLog.exercises.imageUrl,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 70,
                          height: 70,
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          child: Icon(
                            Icons.fitness_center,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      )
                    : Container(
                        width: 70,
                        height: 70,
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        child: Icon(
                          Icons.fitness_center,
                          color: theme.colorScheme.primary,
                        ),
                      ),
              ),
              const SizedBox(width: 16),
              // Exercise Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exerciseLog.exercises.exerciseName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.fitness_center,
                          size: 14,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          exerciseLog.exercises.targetMuscleGroup,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Duration and Rest
                    Row(
                      children: [
                        Icon(
                          Icons.timer,
                          size: 14,
                          color: theme.colorScheme.secondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${double.parse(exerciseLog.exerciseDuration).toStringAsFixed(1)} min',
                          style: TextStyle(
                            fontSize: 14,
                            color: exerciseLog.skipped
                                ? theme.colorScheme.error
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.hourglass_bottom,
                          size: 14,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Rest: ${double.parse(exerciseLog.restDuration).toStringAsFixed(1)} min',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    // Skipped indicator
                    if (exerciseLog.skipped)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Skipped',
                          style: TextStyle(
                            color: theme.colorScheme.error,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Arrow Icon
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.colorScheme.onSurface.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
