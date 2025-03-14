import 'package:flutter/material.dart';
import 'package:gymify/models/personal_best_model.dart';
import 'package:gymify/models/supported_exercise_model.dart';
import 'package:gymify/providers/personal_best_provider/personal_best_provider.dart';
import 'package:gymify/screens/main_screens/membership_screen/membership_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class PersonalBestScreen extends StatefulWidget {
  const PersonalBestScreen({super.key});

  @override
  _PersonalBestScreenState createState() => _PersonalBestScreenState();
}

class _PersonalBestScreenState extends State<PersonalBestScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  SupportedExercise? _selectedExercise;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();

  // Define consistent spacing constants
  static const double kSpacingSmall = 8.0;
  static const double kSpacingMedium = 16.0;
  static const double kSpacingLarge = 24.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Fetch data when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<PersonalBestProvider>();
      provider.fetchSupportedExercises();
      provider.fetchCurrentPersonalBests();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  void _logPersonalBest() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedExercise == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an exercise')),
        );
        return;
      }

      final weight = double.tryParse(_weightController.text);
      final reps = int.tryParse(_repsController.text);

      if (weight != null && reps != null) {
        context
            .read<PersonalBestProvider>()
            .logPersonalBest(
              exerciseId: _selectedExercise!.supportedExerciseId,
              weight: weight,
              reps: reps,
            )
            .then((_) {
          // Clear form and refresh data
          _weightController.clear();
          _repsController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Personal best logged successfully!')),
          );

          // showCoolSnackBar(context, 'Personal best logged successfully!', true);

          // Refresh data
          context.read<PersonalBestProvider>().fetchCurrentPersonalBests();
          if (_selectedExercise != null) {
            context.read<PersonalBestProvider>().fetchPersonalBestHistory(
                _selectedExercise!.supportedExerciseId);
            context
                .read<PersonalBestProvider>()
                .fetchExerciseProgress(_selectedExercise!.supportedExerciseId);
          }
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${error.toString()}')),
          );
        });
      }
    }
  }

  void _viewExerciseHistory(SupportedExercise exercise) {
    setState(() {
      _selectedExercise = exercise;
    });
    context
        .read<PersonalBestProvider>()
        .fetchPersonalBestHistory(exercise.supportedExerciseId);
    context
        .read<PersonalBestProvider>()
        .fetchExerciseProgress(exercise.supportedExerciseId);
    _tabController.animateTo(1); // Switch to history tab
  }

  void _deleteRecord(int personalBestId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Record'),
        content: const Text('Are you sure you want to delete this record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context
                  .read<PersonalBestProvider>()
                  .deletePersonalBest(personalBestId)
                  .then((success) {
                if (success) {
                  if (context.mounted) {
                    showCoolSnackBar(
                        context, 'Record deleted successfully', true);
                  }
                  // Refresh data
                  if (_selectedExercise != null) {
                    context
                        .read<PersonalBestProvider>()
                        .fetchPersonalBestHistory(
                            _selectedExercise!.supportedExerciseId);
                    context.read<PersonalBestProvider>().fetchExerciseProgress(
                        _selectedExercise!.supportedExerciseId);
                  }
                  context
                      .read<PersonalBestProvider>()
                      .fetchCurrentPersonalBests();
                }
              });
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final personalBestProvider = context.watch<PersonalBestProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal Bests"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Current Bests"),
            Tab(text: "History"),
          ],
        ),
      ),
      body: personalBestProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : personalBestProvider.hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Error: ${personalBestProvider.errorMessage}"),
                      const SizedBox(height: kSpacingMedium),
                      ElevatedButton(
                        onPressed: () {
                          personalBestProvider.resetError();
                          personalBestProvider.fetchSupportedExercises();
                          personalBestProvider.fetchCurrentPersonalBests();
                        },
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildCurrentBestsTab(),
                    _buildHistoryTab(),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPersonalBestDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCurrentBestsTab() {
    final personalBestProvider = context.watch<PersonalBestProvider>();

    if (personalBestProvider.currentBests.isEmpty &&
        !personalBestProvider.isLoading) {
      return const Center(
        child: Text("No personal bests recorded yet"),
      );
    }

    return RefreshIndicator(
      onRefresh: () => personalBestProvider.fetchCurrentPersonalBests(),
      child: ListView.builder(
        padding: const EdgeInsets.all(kSpacingMedium),
        itemCount: personalBestProvider.currentBests.length,
        itemBuilder: (context, index) {
          final item = personalBestProvider.currentBests[index];
          final exercise = item['exercise'] as SupportedExercise;
          final personalBest = item['personalBest'] as PersonalBest?;

          final theme = Theme.of(context);

          return GestureDetector(
            onTap: () => _viewExerciseHistory(exercise),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.onSurface.withOpacity(0.1),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(kSpacingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title row with exercise name and history icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          exercise.exerciseName,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.history,
                            size: 16,
                          ),
                          onPressed: () => _viewExerciseHistory(exercise),
                          tooltip: 'View History',
                        ),
                      ],
                    ),
                    // const Divider(),
                    // Display personal best details if available
                    if (personalBest != null) ...[
                      const Text(
                        "Current Best:",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: kSpacingSmall),
                      Row(
                        children: [
                          _buildStatCard(
                            context,
                            "Weight",
                            "${personalBest.weight} kg",
                            Icons.fitness_center,
                          ),
                          const SizedBox(width: kSpacingMedium),
                          _buildStatCard(
                            context,
                            "Reps",
                            personalBest.reps.toString(),
                            Icons.repeat,
                          ),
                        ],
                      ),
                      const SizedBox(height: kSpacingSmall),
                      Text(
                        "Achieved on: ${DateFormat('MMM d, yyyy').format(personalBest.achievedAt)}",
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ] else ...[
                      const Text(
                        "No personal best recorded yet",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressChart() {
    final personalBestProvider = context.watch<PersonalBestProvider>();
    final progressData =
        personalBestProvider.exerciseProgress?.progressData ?? [];

    if (progressData.isEmpty) {
      return const Center(child: Text("No progress data available"));
    }

    // Sort data by date so the line moves left to right in chronological order.
    final sortedData = List.from(progressData)
      ..sort((a, b) => a.achievedAt.compareTo(b.achievedAt));

    // Convert each data record to a FlSpot with x = index, y = weight.
    final spots = sortedData.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final data = entry.value;
      return FlSpot(index, double.parse(data.weight));
    }).toList();

    // Compute min and max for Y-axis.
    final allYValues = spots.map((spot) => spot.y).toList();
    final rawMinY = allYValues.reduce((a, b) => a < b ? a : b);
    final rawMaxY = allYValues.reduce((a, b) => a > b ? a : b);

    // Add some padding so the top/bottom data points aren’t clipped.
    final minY = (rawMinY * 0.95).floorToDouble();
    final maxY = (rawMaxY * 1.05).ceilToDouble();

    // Handle the case where all data points might be the same weight
    // (avoid minY == maxY).
    final yRange = (maxY - minY).abs();
    final safeMinY = yRange == 0 ? minY - 1 : minY;
    final safeMaxY = yRange == 0 ? maxY + 1 : maxY;

    // Calculate an interval for Y-axis labels to avoid clutter (4-5 major steps).
    final yInterval = (safeMaxY - safeMinY) / 4;

    // For the X-axis, we simply label each index. If you have a lot of data,
    // you can label only some of them.
    final xCount = spots.length;
    final xInterval = (xCount / 5).floor().toDouble().clamp(1, double.infinity);

    // If you have fewer than 5 points, you might not need to skip any labels.
    // So we use clamp(1, double.infinity) to ensure xInterval is never 0.

    return Container(
      height: 300, // Slightly taller for better readability
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LineChart(
        LineChartData(
          // 1) No forced background color, so it blends with your Scaffold/theme.
          // backgroundColor: Colors.white,

          // 2) Show grid lines with a subtle style.
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
            ),
            getDrawingVerticalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
            ),
          ),

          // 3) Axis titles and labels.
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: xInterval.toDouble(),
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= sortedData.length) {
                    return const SizedBox.shrink();
                  }
                  final date = sortedData[index].achievedAt;
                  return SideTitleWidget(
                    meta: meta,
                    // axisSide: meta.axisSide,
                    space: 6,
                    child: Text(
                      DateFormat('MM/dd').format(date),
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                // Use the yInterval so the chart has about 4-5 horizontal lines.
                interval: yInterval,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    "${value.toStringAsFixed(0)} kg",
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),

          // 4) Give the chart a border for a neat look.
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: Colors.grey.withOpacity(0.3),
              width: 1,
            ),
          ),

          // 5) Set the axis min/max bounds.
          minX: 0,
          maxX: (spots.length - 1).toDouble(),
          minY: safeMinY,
          maxY: safeMaxY,

          // 6) Enable touch interactions + tooltips.
          lineTouchData: LineTouchData(
            enabled: true,
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((LineBarSpot spot) {
                  final index = spot.x.toInt();
                  final data = sortedData[index];
                  return LineTooltipItem(
                    "${data.weight} kg\n"
                    "${DateFormat('MMM d, yyyy').format(data.achievedAt)}",
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),

          // 7) Configure how the line and its area look.
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.3,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.6),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Theme.of(context).colorScheme.primary,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab() {
    final personalBestProvider = context.watch<PersonalBestProvider>();

    if (_selectedExercise == null) {
      return const Center(
        child: Text("Select an exercise to view history"),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(kSpacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(kSpacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedExercise!.exerciseName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: kSpacingSmall),
                  Text(
                    "History & Progress",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer
                          .withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: kSpacingLarge),

          // Progress Chart
          const Text(
            "Progress Chart",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: kSpacingSmall),
          _buildProgressChart(),

          const SizedBox(height: kSpacingLarge),

          const Text(
            "Log New Entry",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: kSpacingSmall),
          _buildLogForm(),

          const SizedBox(height: kSpacingLarge),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "History",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              if (personalBestProvider.personalBestHistory.isNotEmpty)
                TextButton.icon(
                  icon: const Icon(Icons.sort),
                  label: const Text("Sort"),
                  onPressed: () {
                    // Implement sorting options
                  },
                ),
            ],
          ),
          const SizedBox(height: kSpacingSmall),

          if (personalBestProvider.personalBestHistory.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(kSpacingMedium),
                child: Text("No history found for this exercise"),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: personalBestProvider.personalBestHistory.length,
              itemBuilder: (context, index) {
                final record = personalBestProvider.personalBestHistory[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: kSpacingSmall),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.2),
                      child: Icon(
                        Icons.fitness_center,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    title: Text(
                      "${record.weight} kg × ${record.reps} reps",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        DateFormat('MMM d, yyyy').format(record.achievedAt)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _deleteRecord(record.personalBestId),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildLogForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(
                    labelText: "Weight (kg)",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Invalid number';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: kSpacingMedium),
              Expanded(
                child: TextFormField(
                  controller: _repsController,
                  decoration: const InputDecoration(
                    labelText: "Reps",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Invalid number';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: kSpacingMedium),
          ElevatedButton(
            onPressed: _logPersonalBest,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text("Log New Entry"),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      BuildContext context, String label, String value, IconData icon) {
    // Use MediaQuery to adapt to screen size
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: isSmallScreen ? 16 : 20,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 10 : 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallScreen ? 14 : 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPersonalBestDialog() {
    final personalBestProvider = context.read<PersonalBestProvider>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Log New Personal Best",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<SupportedExercise>(
                    decoration: const InputDecoration(
                      labelText: "Select Exercise",
                      border: OutlineInputBorder(),
                    ),
                    items:
                        personalBestProvider.supportedExercises.map((exercise) {
                      return DropdownMenuItem(
                        value: exercise,
                        child: Text(exercise.exerciseName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedExercise = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildLogForm(),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
