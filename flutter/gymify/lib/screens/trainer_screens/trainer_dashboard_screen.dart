import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/models/trainer_models/user_list_trainer.dart';
import 'package:gymify/providers/trainer_provider/trainer_analytics_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class TrainerDashboardScreen extends StatefulWidget {
  const TrainerDashboardScreen({super.key});

  @override
  _TrainerDashboardScreenState createState() => _TrainerDashboardScreenState();
}

class _TrainerDashboardScreenState extends State<TrainerDashboardScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserStatsProvider>().fetchStatsSummary();
    });
  }

  Future<void> _refreshData() async {
    await context.read<UserStatsProvider>().fetchStatsSummary();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Trainer Dashboard',
        showBackButton: true,
        actions: [
          IconButton(
            icon: Icon(Icons.people, color: theme.colorScheme.primary),
            onPressed: () {
              context.push('/userList');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Consumer<UserStatsProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CustomLoadingAnimation());
            }

            if (provider.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 60,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading dashboard',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.errorMessage,
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _refreshData,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh'),
                    ),
                  ],
                ),
              );
            }

            final summary = provider.statsSummary;
            if (summary == null) {
              return const Center(
                child: Text('No data available'),
              );
            }

            return SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOverviewStats(summary, theme),
                  const SizedBox(height: 24),
                  _buildGoalTypeDistribution(summary, theme),
                  const SizedBox(height: 24),
                  _buildFitnessLevelDistribution(summary, theme),
                  const SizedBox(height: 24),
                  _buildActionButtons(theme),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20), // Rounded corners for a modern look
          side: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        onPressed: () {
          context.push('/userList');
        },
        label: Row(
          mainAxisSize: MainAxisSize
              .min, // Ensures the label fits tightly around the text
          children: [
            Icon(Icons.group,
                color:
                    theme.colorScheme.onPrimary), // Adds an icon for better UX
            const SizedBox(width: 8), // Adds spacing between icon and text
            Text(
              'View All Members',
              style: TextStyle(
                  color: theme.colorScheme.onPrimary), // Improved text style
            ),
          ],
        ),
        backgroundColor: theme.colorScheme.primary,
        elevation: 6, // Adds shadow for depth
        hoverColor: theme.colorScheme.primary
            .withOpacity(0.1), // Adds hover effect for web
        focusColor: theme.colorScheme.primary
            .withOpacity(0.1), // Adds focus effect for accessibility
        splashColor:
            theme.colorScheme.secondary.withOpacity(0.3), // Adds splash effect
      ),
    );
  }

  Widget _buildOverviewStats(StatsSummary summary, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildStatCard(
              icon: Icons.people,
              title: 'Total Members',
              value: summary.totalMembers.toString(),
              color: Colors.blue,
              theme: theme,
            ),
            _buildStatCard(
              icon: Icons.fitness_center,
              title: 'Workouts Completed',
              value: summary.totalWorkoutsCompleted.toString(),
              color: Colors.green,
              theme: theme,
            ),
            _buildStatCard(
              icon: Icons.restaurant_menu,
              title: 'Diet Plans',
              value: summary.totalDietPlans.toString(),
              color: Colors.orange,
              theme: theme,
            ),
            _buildStatCard(
              icon: Icons.calendar_today,
              title: 'Recent Attendance',
              value: '${summary.recentAttendance} (30 days)',
              color: Colors.purple,
              theme: theme,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required ThemeData theme,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Add specific actions for each card if needed
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                const Spacer(),
                Text(
                  value,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoalTypeDistribution(StatsSummary summary, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Member Goals Distribution',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Adjust layout based on available width
              final isNarrow = constraints.maxWidth < 400;

              return isNarrow
                  ? Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 40,
                              sections:
                                  _getPieChartSections(summary.usersByGoalType),
                              pieTouchData: PieTouchData(
                                touchCallback:
                                    (FlTouchEvent event, pieTouchResponse) {
                                  // Interactive touch response could be added here
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildEnhancedLegend(summary.usersByGoalType, theme),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 40,
                              sections:
                                  _getPieChartSections(summary.usersByGoalType),
                              pieTouchData: PieTouchData(
                                touchCallback:
                                    (FlTouchEvent event, pieTouchResponse) {
                                  // Interactive touch response could be added here
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 2,
                          child: _buildEnhancedLegend(
                              summary.usersByGoalType, theme),
                        ),
                      ],
                    );
            },
          ),
        ),
      ],
    );
  }

  // Enhanced legend with better readability and percentage display
  Widget _buildEnhancedLegend(List<GoalTypeCount> data, ThemeData theme) {
    final totalCount = data.fold<int>(0, (sum, item) => sum + item.count);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: data.map((item) {
        final goalTypeKey = item.goalType.toLowerCase();
        final color = _getGoalTypeColor(goalTypeKey);
        final percentage = totalCount > 0 ? (item.count / totalCount) * 100 : 0;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _formatGoalType(item.goalType),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${item.count})',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(width: 8),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getGoalTypeColor(String goalType) {
    final colorMap = {
      'weight_loss': const Color(0xFF4CAF50), // Green
      'muscle_gain': const Color(0xFFFFC107), // Amber/Yellow
      'endurance': const Color(0xFF2196F3), // Blue
      'flexibility': const Color(0xFFFF5722), // Red-Orange
    };

    return colorMap[goalType] ?? Colors.grey;
  }

  // Fixed Bar Chart for Fitness Level Distribution
  Widget _buildFitnessLevelDistribution(StatsSummary summary, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fitness Level Distribution',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 400;

              return Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceEvenly,
                        maxY: _getMaxFitnessLevelCount(
                            summary.usersByFitnessLevel),
                        gridData: FlGridData(
                          show: true,
                          drawHorizontalLine: true,
                          horizontalInterval: 5,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.1),
                              strokeWidth: 1,
                            );
                          },
                          drawVerticalLine: false,
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 5,
                              getTitlesWidget: (value, meta) {
                                if (value == 0) return const SizedBox.shrink();
                                return SideTitleWidget(
                                  meta: meta,
                                  child: Text(
                                    value.toInt().toString(),
                                    style: theme.textTheme.bodySmall,
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
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value >=
                                        summary.usersByFitnessLevel.length ||
                                    value < 0) {
                                  return const SizedBox.shrink();
                                }
                                return SideTitleWidget(
                                  meta: meta,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      _shortenFitnessLevel(summary
                                          .usersByFitnessLevel[value.toInt()]
                                          .fitnessLevel),
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: List.generate(
                          summary.usersByFitnessLevel.length,
                          (index) {
                            final item = summary.usersByFitnessLevel[index];
                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: item.count.toDouble(),
                                  color:
                                      _getFitnessLevelColor(item.fitnessLevel),
                                  width: isNarrow
                                      ? 18
                                      : 22, // Adjust width based on screen size
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(6),
                                  ),
                                  backDrawRodData: BackgroundBarChartRodData(
                                    show: true,
                                    toY: _getMaxFitnessLevelCount(
                                        summary.usersByFitnessLevel),
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.05),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            // tooltipBgColor:
                            //     theme.colorScheme.surface.withOpacity(0.8),

                            tooltipPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            tooltipMargin: 8,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              final item = summary.usersByFitnessLevel[group.x];
                              return BarTooltipItem(
                                '${item.fitnessLevel}\n',
                                theme.textTheme.bodySmall!
                                    .copyWith(fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: '${item.count} members',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Enhanced detailed stats display
                  _buildFitnessLevelLegend(summary.usersByFitnessLevel, theme),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFitnessLevelLegend(
      List<FitnessLevelCount> data, ThemeData theme) {
    // Calculate total for percentages
    final totalCount = data.fold<int>(0, (sum, item) => sum + item.count);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Distribution Details:',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Grid layout for fitness level stats
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: data.map((level) {
            final color = _getFitnessLevelColor(level.fitnessLevel);
            final percentage =
                totalCount > 0 ? (level.count / totalCount) * 100 : 0;

            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withOpacity(0.4), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        level.fitnessLevel,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${level.count} members (${percentage.toStringAsFixed(1)}%)',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _shortenFitnessLevel(String level) {
    // For bottom labels, use abbreviated names if needed
    if (level.length > 12) {
      return level.substring(0, 3); // Use first 3 chars
    }
    return level;
  }

  String _formatGoalType(String goalType) {
    // Convert 'Weight_Loss' to 'Weight Loss'
    return goalType.replaceAll('_', ' ');
  }

  double _getMaxFitnessLevelCount(List<FitnessLevelCount> data) {
    if (data.isEmpty) return 10;
    final maxCount = data.fold<int>(
      0,
      (max, item) => item.count > max ? item.count : max,
    );
    // Add some padding to the max value
    return (maxCount + 2).toDouble();
  }

  Color _getFitnessLevelColor(String fitnessLevel) {
    switch (fitnessLevel.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      case 'athlete':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  List<PieChartSectionData> _getPieChartSections(List<GoalTypeCount> data) {
    final totalCount = data.fold<int>(0, (sum, item) => sum + item.count);

    return data.map((item) {
      final goalTypeKey = item.goalType.toLowerCase();
      final color = _getGoalTypeColor(goalTypeKey);
      final percentage = totalCount > 0 ? (item.count / totalCount) * 100 : 0;

      return PieChartSectionData(
        value: item.count.toDouble(),
        title: '${percentage.toStringAsFixed(1)}%',
        color: color,
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 2.5,
          children: [
            _buildActionButton(
              icon: Icons.fitness_center,
              title: 'Manage Workout',
              color: Colors.blue,
              onTap: () => context.pushNamed('manageWorkouts'),
              theme: theme,
            ),
            _buildActionButton(
              icon: Icons.restaurant_menu,
              title: 'Manage Diet Plan',
              color: Colors.green,
              onTap: () => context.pushNamed('manageDietPlans'),
              theme: theme,
            ),
            _buildActionButton(
              icon: Icons.fitness_center,
              title: 'Manage Exercise',
              color: Colors.orange,
              onTap: () => context.pushNamed('manageExercise'),
              theme: theme,
            ),
            _buildActionButton(
              icon: Icons.health_and_safety,
              title: 'Supported Exercises',
              color: Colors.red,
              onTap: () => context.pushNamed('createSupportedExercise'),
              theme: theme,
            ),
          ],
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required Color color,
    required Function() onTap,
    required ThemeData theme,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
