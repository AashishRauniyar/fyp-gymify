import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gymify/screens/trainer_screens/trainer_members_screen.dart';
import 'package:gymify/services/trainer_analytics_service.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class TrainerAnalyticsDashboard extends StatefulWidget {
  const TrainerAnalyticsDashboard({super.key});

  @override
  _TrainerAnalyticsDashboardState createState() =>
      _TrainerAnalyticsDashboardState();
}

class _TrainerAnalyticsDashboardState extends State<TrainerAnalyticsDashboard> {
  final TrainerAnalyticsService _analyticsService = TrainerAnalyticsService();
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _analyticsData;

  @override
  void initState() {
    super.initState();
    _loadAnalyticsData();
  }

  Future<void> _loadAnalyticsData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await _analyticsService.fetchDashboardAnalytics();

    setState(() {
      _isLoading = false;
      if (result['status'] == 'success') {
        _analyticsData = result['data'];
      } else {
        _error = result['message'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: "Trainer Analytics"),
      body: _isLoading
          ? const Center(child: CustomLoadingAnimation())
          : _error != null
              ? _buildErrorState(theme)
              : _buildDashboardContent(theme),
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: theme.colorScheme.error.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          Text(
            "Failed to load analytics data",
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _error ?? "An unknown error occurred",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadAnalyticsData,
            icon: const Icon(Icons.refresh),
            label: const Text("Retry"),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(ThemeData theme) {
    // Extract data from the analytics response
    final memberCount = _analyticsData?['memberCount'] ?? 0;
    final workoutPlansCreated = _analyticsData?['workoutPlansCreated'] ?? 0;
    final dietPlansCreated = _analyticsData?['dietPlansCreated'] ?? 0;
    final attendanceMetrics = _analyticsData?['attendanceMetrics'] ?? {};
    final workoutMetrics = _analyticsData?['workoutMetrics'] ?? {};
    final weightProgressMetrics =
        _analyticsData?['weightProgressMetrics'] ?? {};
    final demographics = _analyticsData?['demographics'] ?? {};

    return RefreshIndicator(
      onRefresh: _loadAnalyticsData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top stats cards
            _buildTopMetricsSection(
                theme, memberCount, workoutPlansCreated, dietPlansCreated),

            const SizedBox(height: 24),

            // Member progress metrics
            _buildProgressMetricsSection(theme, attendanceMetrics,
                workoutMetrics, weightProgressMetrics),

            const SizedBox(height: 24),

            // Demographics charts
            _buildDemographicsSection(theme, demographics),

            const SizedBox(height: 16),

            // Action buttons
            _buildActionButtons(theme),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTopMetricsSection(ThemeData theme, int memberCount,
      int workoutPlansCreated, int dietPlansCreated) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Overview",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                theme,
                "Members",
                memberCount.toString(),
                Iconsax.profile_2user,
                theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                theme,
                "Workouts",
                workoutPlansCreated.toString(),
                Iconsax.weight,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                theme,
                "Diet Plans",
                dietPlansCreated.toString(),
                Iconsax.clipboard_text,
                Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressMetricsSection(
      ThemeData theme,
      Map<String, dynamic> attendanceMetrics,
      Map<String, dynamic> workoutMetrics,
      Map<String, dynamic> weightProgressMetrics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Member Progress",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Attendance card
        _buildProgressCard(
          theme,
          "Attendance",
          Iconsax.calendar,
          theme.colorScheme.primary,
          [
            ProgressItem(
              label: "Total Last Month",
              value: "${attendanceMetrics['totalLastMonth'] ?? 0}",
            ),
            ProgressItem(
              label: "Average per Member",
              value: "${attendanceMetrics['averagePerMember'] ?? '0.0'}",
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Workout completion card
        _buildProgressCard(
          theme,
          "Workout Completion",
          Iconsax.task_square,
          Colors.orange,
          [
            ProgressItem(
              label: "Completion Rate",
              value: "${workoutMetrics['completionRate'] ?? '0.0'}%",
            ),
            ProgressItem(
              label: "Total Workouts",
              value: "${workoutMetrics['totalWorkouts'] ?? 0}",
            ),
            ProgressItem(
              label: "Completed",
              value: "${workoutMetrics['completedWorkouts'] ?? 0}",
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Weight progress card
        _buildProgressCard(
          theme,
          "Weight Progress",
          Iconsax.weight_1,
          Colors.green,
          [
            ProgressItem(
              label: "Weight Loss",
              value:
                  "${weightProgressMetrics['membersWithWeightLoss'] ?? 0} members",
              iconData: Icons.trending_down,
              iconColor: Colors.green,
            ),
            ProgressItem(
              label: "Weight Gain",
              value:
                  "${weightProgressMetrics['membersWithWeightGain'] ?? 0} members",
              iconData: Icons.trending_up,
              iconColor: Colors.orange,
            ),
            ProgressItem(
              label: "No Change",
              value:
                  "${weightProgressMetrics['membersWithNoChange'] ?? 0} members",
              iconData: Icons.horizontal_rule,
              iconColor: Colors.grey,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDemographicsSection(
      ThemeData theme, Map<String, dynamic> demographics) {
    final genderDistribution =
        demographics['genderDistribution'] as List? ?? [];
    final fitnessLevelDistribution =
        demographics['fitnessLevelDistribution'] as List? ?? [];
    final goalTypeDistribution =
        demographics['goalTypeDistribution'] as List? ?? [];
    final ageDistribution = demographics['ageDistribution'] as List? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Member Demographics",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Gender Distribution
        _buildPieChartCard(
          theme,
          "Gender Distribution",
          _buildGenderPieChart(theme, genderDistribution),
          _buildGenderLegend(theme, genderDistribution),
        ),

        const SizedBox(height: 16),

        // Fitness Level Distribution
        _buildBarChartCard(
          theme,
          "Fitness Level Distribution",
          _buildFitnessLevelBarChart(theme, fitnessLevelDistribution),
        ),

        const SizedBox(height: 16),

        // Goal Type Distribution
        _buildBarChartCard(
          theme,
          "Fitness Goal Distribution",
          _buildGoalTypeBarChart(theme, goalTypeDistribution),
        ),

        const SizedBox(height: 16),

        // Age Distribution
        _buildBarChartCard(
          theme,
          "Age Distribution",
          _buildAgeBarChart(theme, ageDistribution),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    ThemeData theme,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
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
    );
  }

  Widget _buildProgressCard(
    ThemeData theme,
    String title,
    IconData icon,
    Color color,
    List<ProgressItem> items,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...items.map((item) => _buildProgressItemRow(theme, item)),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItemRow(ThemeData theme, ProgressItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          if (item.iconData != null) ...[
            Icon(
              item.iconData,
              color: item.iconColor ?? theme.colorScheme.primary,
              size: 16,
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              item.label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          Text(
            item.value,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChartCard(
    ThemeData theme,
    String title,
    Widget chart,
    Widget legend,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 180,
                    child: chart,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: legend,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChartCard(
    ThemeData theme,
    String title,
    Widget chart,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: chart,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderPieChart(ThemeData theme, List genderDistribution) {
    if (genderDistribution.isEmpty) {
      return _buildEmptyChartMessage(theme, "No gender data available");
    }

    final List<PieChartSectionData> sections = [];
    double totalCount = 0;

    // Calculate total for percentage
    for (final item in genderDistribution) {
      totalCount += (item['count'] as num).toDouble();
    }

    // Colors for different genders
    final colors = [
      theme.colorScheme.primary,
      Colors.pinkAccent,
      Colors.amber,
      Colors.teal,
    ];

    for (int i = 0; i < genderDistribution.length; i++) {
      final item = genderDistribution[i];
      final count = (item['count'] as num).toDouble();

      sections.add(
        PieChartSectionData(
          color: colors[i % colors.length],
          value: count,
          title: '',
          radius: 70,
          titleStyle: TextStyle(
            fontSize: 0,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
        ),
      );
    }

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 30,
        sections: sections,
      ),
    );
  }

  Widget _buildGenderLegend(ThemeData theme, List genderDistribution) {
    if (genderDistribution.isEmpty) {
      return Container();
    }

    // Colors for different genders
    final colors = [
      theme.colorScheme.primary,
      Colors.pinkAccent,
      Colors.amber,
      Colors.teal,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(genderDistribution.length, (index) {
        final item = genderDistribution[index];
        final gender = item['gender'] as String;
        final count = item['count'] as int;
        final percentage = item['percentage'] as String;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: colors[index % colors.length],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  gender,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              Text(
                "$count ($percentage%)",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildFitnessLevelBarChart(
      ThemeData theme, List fitnessLevelDistribution) {
    if (fitnessLevelDistribution.isEmpty) {
      return _buildEmptyChartMessage(theme, "No fitness level data available");
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: fitnessLevelDistribution
                .map<double>((item) => (item['count'] as num).toDouble())
                .reduce((a, b) => a > b ? a : b) *
            1.2,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final item = fitnessLevelDistribution[groupIndex];
              return BarTooltipItem(
                '${item['fitness_level']}\n${item['count']} (${item['percentage']}%)',
                TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value < 0 || value >= fitnessLevelDistribution.length)
                  return const Text('');
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _shortenText(fitnessLevelDistribution[value.toInt()]
                        ['fitness_level'] as String),
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const Text('');
                return Text(
                  value.toInt().toString(),
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
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
        barGroups: List.generate(fitnessLevelDistribution.length, (index) {
          final item = fitnessLevelDistribution[index];
          final count = (item['count'] as num).toDouble();

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: count,
                color: _getGradientColor(index),
                width: 20,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildGoalTypeBarChart(ThemeData theme, List goalTypeDistribution) {
    if (goalTypeDistribution.isEmpty) {
      return _buildEmptyChartMessage(theme, "No goal type data available");
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: goalTypeDistribution
                .map<double>((item) => (item['count'] as num).toDouble())
                .reduce((a, b) => a > b ? a : b) *
            1.2,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final item = goalTypeDistribution[groupIndex];
              final goalType =
                  (item['goal_type'] as String).replaceAll('_', ' ');
              return BarTooltipItem(
                '$goalType\n${item['count']} (${item['percentage']}%)',
                TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value < 0 || value >= goalTypeDistribution.length)
                  return const Text('');
                final goalType =
                    (goalTypeDistribution[value.toInt()]['goal_type'] as String)
                        .replaceAll('_', ' ');
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _shortenText(goalType),
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const Text('');
                return Text(
                  value.toInt().toString(),
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
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
        barGroups: List.generate(goalTypeDistribution.length, (index) {
          final item = goalTypeDistribution[index];
          final count = (item['count'] as num).toDouble();

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: count,
                color: _getGradientColor(
                    index + 2), // Offset to get different colors
                width: 20,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildAgeBarChart(ThemeData theme, List ageDistribution) {
    if (ageDistribution.isEmpty) {
      return _buildEmptyChartMessage(theme, "No age data available");
    }

    // Sort age groups to display in correct order
    final sortOrder = {
      'Under 18': 0,
      '18-24': 1,
      '25-34': 2,
      '35-44': 3,
      '45-54': 4,
      '55+': 5,
      'Unspecified': 6,
    };

    ageDistribution.sort((a, b) {
      final aOrder = sortOrder[a['age_group']] ?? 999;
      final bOrder = sortOrder[b['age_group']] ?? 999;
      return aOrder.compareTo(bOrder);
    });

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: ageDistribution
                .map<double>((item) => (item['count'] as num).toDouble())
                .reduce((a, b) => a > b ? a : b) *
            1.2,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final item = ageDistribution[groupIndex];
              return BarTooltipItem(
                '${item['age_group']}\n${item['count']} (${item['percentage']}%)',
                TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value < 0 || value >= ageDistribution.length)
                  return const Text('');
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    ageDistribution[value.toInt()]['age_group'] as String,
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const Text('');
                return Text(
                  value.toInt().toString(),
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
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
        barGroups: List.generate(ageDistribution.length, (index) {
          final item = ageDistribution[index];
          final count = (item['count'] as num).toDouble();

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: count,
                color:
                    _getGradientColor(index + 4), // Offset for different colors
                width: 20,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildEmptyChartMessage(ThemeData theme, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          message,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TrainerMembersScreen(),
                ),
              );
            },
            icon: const Icon(Iconsax.profile_2user),
            label: const Text("View All Members"),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper method to get gradient colors for charts
  Color _getGradientColor(int index) {
    final List<Color> colors = [
      Colors.blue,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.red,
      Colors.green,
      Colors.amber,
      Colors.indigo,
    ];

    return colors[index % colors.length];
  }

  // Helper method to shorten text for chart labels
  String _shortenText(String text) {
    if (text.length <= 8) return text;
    return '${text.substring(0, 7)}...';
  }
}

// Helper class for progress item
class ProgressItem {
  final String label;
  final String value;
  final IconData? iconData;
  final Color? iconColor;

  ProgressItem({
    required this.label,
    required this.value,
    this.iconData,
    this.iconColor,
  });
}
