import 'package:flutter/material.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:gymify/providers/profile_provider/profile_provider.dart';
import 'package:gymify/models/weight_history_model.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class WeightLog extends StatefulWidget {
  const WeightLog({super.key});

  @override
  State<WeightLog> createState() => _WeightLogState();
}

class _WeightLogState extends State<WeightLog> {
  final _weightController = TextEditingController();
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // if (!_isInit) {
    //   _initData();
    //   _isInit = true;
    // }
    if (!_isInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _initData(); // Fetch data after the build phase
        _isInit = true; // Set to true once the data is initialized
      });
    }
  }

  Future<void> _initData() async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    await profileProvider.fetchProfile();
    await profileProvider.fetchWeightHistory();
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  // Helper method to safely parse weight strings to double
  double _parseWeight(String? weight) {
    if (weight == null || weight.isEmpty) return 0.0;
    try {
      return double.parse(weight);
    } catch (_) {
      return 0.0;
    }
  }

  void _showUpdateWeightDialog() {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    // Pre-fill with current weight if available
    if (profileProvider.user?.currentWeight != null) {
      _weightController.text = profileProvider.user!.currentWeight.toString();
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Update Weight'),
        content: TextField(
          controller: _weightController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Weight (kg)',
            hintText: 'Enter your current weight',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (_weightController.text.isNotEmpty) {
                try {
                  final newWeight = double.parse(_weightController.text);
                  await profileProvider.updateWeight(context, newWeight);

                  if (!profileProvider.hasError) {
                    // Refresh weight history after update
                    await profileProvider.fetchWeightHistory();
                    Navigator.of(ctx).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Weight updated successfully'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          profileProvider.errorMessage ??
                              'Error updating weight',
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid number'),
                    ),
                  );
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Gymify'),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.refresh),
      //       onPressed: _initData,
      //     ),
      //   ],
      // ),
      appBar: CustomAppBar(
        title: 'Weight Log',
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: theme.colorScheme.primary),
            onPressed: _initData,
          ),
        ],
      ),
      body: Consumer<ProfileProvider>(
        builder: (ctx, profileProvider, _) {
          if (profileProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (profileProvider.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    profileProvider.errorMessage ?? 'An error occurred',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      profileProvider.resetError();
                      _initData();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final user = profileProvider.user;
          final weightHistory = profileProvider.weightHistory;

          if (user == null) {
            return const Center(child: Text('No user data available'));
          }

          return RefreshIndicator(
            onRefresh: _initData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =====================
                  // User Profile Container
                  // =====================
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? theme.colorScheme.surface
                          : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDarkMode
                            ? theme.colorScheme.onSurface.withOpacity(0.1)
                            : theme.colorScheme.onSurface.withOpacity(0.1),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Row
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: user.profileImage != null
                                  ? NetworkImage(user.profileImage!)
                                  : null,
                              child: user.profileImage == null
                                  ? Text(
                                      user.userName
                                              ?.substring(0, 1)
                                              .toUpperCase() ??
                                          'U',
                                      style: const TextStyle(fontSize: 30),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.userName ?? 'User',
                                    style: theme.textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(user.email ?? ''),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Current Weight & Goal
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatCard(
                              'Current Weight',
                              user.currentWeight != null
                                  ? '${user.currentWeight} kg'
                                  : 'Not set',
                              Icons.monitor_weight_outlined,
                              theme,
                              isDarkMode,
                            ),
                            _buildStatCard(
                              'Goal Weight',
                              user.goalType != null
                                  ? '${user.goalType}'
                                  : 'Not set',
                              Icons.flag_outlined,
                              theme,
                              isDarkMode,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Update Weight Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _showUpdateWeightDialog,
                            icon: const Icon(Icons.add_circle_outline),
                            label: const Text('Update Weight'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ======================
                  // Weight History Section
                  // ======================
                  if (weightHistory != null && weightHistory.isNotEmpty) ...[
                    Text(
                      'Weight History',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),

                    // Chart Container
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? theme.colorScheme.surface
                            : theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDarkMode
                              ? theme.colorScheme.onSurface.withOpacity(0.1)
                              : theme.colorScheme.onSurface.withOpacity(0.1),
                          width: 1.5,
                        ),
                      ),
                      child: SizedBox(
                        height: 250,
                        child: _buildWeightChart(weightHistory),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'Recent Entries',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),

                    // Recent Entries List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: weightHistory.length,
                      itemBuilder: (ctx, index) {
                        final entry = weightHistory[index];
                        final date =
                            DateFormat('MMM d, yyyy').format(entry.loggedAt);

                        // Calculate weight change from previous entry
                        String changeText = '';
                        if (index < weightHistory.length - 1) {
                          final currentWeight = _parseWeight(entry.weight);
                          final prevWeight =
                              _parseWeight(weightHistory[index + 1].weight);
                          final change = currentWeight - prevWeight;
                          changeText = change > 0
                              ? '+${change.toStringAsFixed(1)} kg'
                              : '${change.toStringAsFixed(1)} kg';
                        }

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? theme.colorScheme.surface
                                : theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDarkMode
                                  ? theme.colorScheme.onSurface.withOpacity(0.1)
                                  : theme.colorScheme.onSurface
                                      .withOpacity(0.1),
                              width: 1.5,
                            ),
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            leading: const Icon(Icons.fitness_center),
                            title: Text('${entry.weight} kg'),
                            subtitle: Text(date),
                            trailing: changeText.isNotEmpty
                                ? Text(
                                    changeText,
                                    style: TextStyle(
                                      color: changeText.startsWith('+')
                                          ? Colors.red
                                          : Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                  ] else ...[
                    const SizedBox(height: 32),
                    Center(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.timeline_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No weight history available',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Update your weight to start tracking progress',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _showUpdateWeightDialog,
                            icon: const Icon(Icons.add),
                            label: const Text('Add First Entry'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    ThemeData theme,
    bool isDarkMode,
  ) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color:
            isDarkMode ? theme.colorScheme.surface : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode
              ? theme.colorScheme.onSurface.withOpacity(0.1)
              : theme.colorScheme.onSurface.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: theme.primaryColor),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightChart(List<WeightHistory> weightHistory) {
    // Sort by date (oldest to newest)
    final sortedHistory = List<WeightHistory>.from(weightHistory)
      ..sort((a, b) => a.loggedAt.compareTo(b.loggedAt));

    // If there's not enough data, show a message
    if (sortedHistory.length < 2) {
      return const Center(
        child: Text('Not enough data for chart visualization'),
      );
    }

    // Create spots for the line chart with safe parsing
    final spots = sortedHistory.asMap().entries.map((entry) {
      final weightValue = _parseWeight(entry.value.weight);
      return FlSpot(entry.key.toDouble(), weightValue);
    }).toList();

    // Find min and max values for better scaling
    final weightValues =
        sortedHistory.map((e) => _parseWeight(e.weight)).toList();
    final minWeight = weightValues.reduce((a, b) => a < b ? a : b);
    final maxWeight = weightValues.reduce((a, b) => a > b ? a : b);

    // Add some padding to the min/max values
    final minY = (minWeight - 2).clamp(0, double.infinity);
    final maxY = maxWeight + 2;

    return LineChart(
      LineChartData(
        gridData: const FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 5,
          verticalInterval: 1,
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 &&
                    value.toInt() < sortedHistory.length) {
                  // Show date for some points to avoid overcrowding
                  if (sortedHistory.length <= 5 ||
                      value.toInt() % (sortedHistory.length ~/ 5 + 1) == 0) {
                    final date = DateFormat('MM/dd')
                        .format(sortedHistory[value.toInt()].loggedAt);
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        date,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 5,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  "${value.toInt().toString()} kg",
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey.shade300),
        ),
        minX: 0,
        maxX: (sortedHistory.length - 1).toDouble(),
        minY: minY.toDouble(),
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Theme.of(context).primaryColor,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Theme.of(context).primaryColor,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).primaryColor.withOpacity(0.2),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final index = barSpot.x.toInt();
                if (index >= 0 && index < sortedHistory.length) {
                  final entry = sortedHistory[index];
                  final date = DateFormat('MMM d, yyyy').format(entry.loggedAt);
                  return LineTooltipItem(
                    '${entry.weight} kg\n$date',
                    const TextStyle(color: Colors.white),
                  );
                }
                return null;
              }).toList();
            },
          ),
          handleBuiltInTouches: true,
        ),
      ),
    );
  }
}
