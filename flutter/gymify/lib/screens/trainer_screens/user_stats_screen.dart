import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/models/deit_plan_models/diet_plan_model.dart';
import 'package:gymify/models/trainer_models/user_list_trainer.dart';
import 'package:gymify/providers/trainer_provider/trainer_analytics_provider.dart';

import 'package:gymify/utils/custom_appbar.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class UserStatsScreen extends StatefulWidget {
  final int userId;

  const UserStatsScreen({super.key, required this.userId});

  @override
  _UserStatsScreenState createState() => _UserStatsScreenState();
}

class _UserStatsScreenState extends State<UserStatsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserStatsProvider>().fetchUserStats(widget.userId);
    });
  }

  Future<void> _refreshData() async {
    await context.read<UserStatsProvider>().fetchUserStats(widget.userId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: const CustomAppBar(
        title: 'Member Statistics',
        showBackButton: true,
      ),
      body: Consumer<UserStatsProvider>(
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
                    'Error loading member statistics',
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

          final userStats = provider.userStats;
          if (userStats == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 60,
                    color: theme.colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No statistics available',
                    style: theme.textTheme.bodyLarge,
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

          return RefreshIndicator(
            onRefresh: _refreshData,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child:
                        _buildUserProfileHeader(userStats.userProfile, theme),
                  ),
                  SliverToBoxAdapter(
                    child: TabBar(
                      controller: _tabController,
                      labelColor: theme.colorScheme.primary,
                      unselectedLabelColor:
                          theme.colorScheme.onSurface.withOpacity(0.7),
                      indicatorColor: theme.colorScheme.primary,
                      tabs: const [
                        Tab(text: 'Overview'),
                        Tab(text: 'Workouts'),
                        Tab(text: 'Nutrition'),
                        Tab(text: 'Progress'),
                      ],
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(userStats, theme),
                  _buildWorkoutsTab(userStats.workoutStats, theme),
                  _buildNutritionTab(userStats.nutritionStats, theme),
                  _buildProgressTab(userStats, theme),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserProfileHeader(UserProfile profile, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // User avatar and basic info
          Row(
            children: [
              // User avatar
              CircleAvatar(
                radius: 40,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                child: profile.profileImage != null &&
                        profile.profileImage!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: CachedNetworkImage(
                          imageUrl: profile.profileImage!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.primary,
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.person,
                            size: 40,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: 40,
                        color: theme.colorScheme.primary,
                      ),
              ),
              const SizedBox(width: 16),
              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.fullName ?? profile.userName ?? 'Anonymous',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.email,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (profile.fitnessLevel != null)
                          _buildTag(
                            profile.fitnessLevel!,
                            _getFitnessLevelColor(profile.fitnessLevel!),
                            theme,
                          ),
                        if (profile.fitnessLevel != null &&
                            profile.goalType != null)
                          const SizedBox(width: 8),
                        if (profile.goalType != null)
                          _buildTag(
                            _formatGoalType(profile.goalType!),
                            Colors.blue,
                            theme,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // User stats summary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.monitor_weight,
                value: profile.currentWeight != null
                    ? '${profile.currentWeight} kg'
                    : 'N/A',
                label: 'Weight',
                theme: theme,
              ),
              _buildStatItem(
                icon: Icons.height,
                value: profile.height != null ? '${profile.height} cm' : 'N/A',
                label: 'Height',
                theme: theme,
              ),
              _buildStatItem(
                icon: Icons.calendar_today,
                value: profile.birthdate != null
                    ? '${DateTime.now().year - profile.birthdate!.year}'
                    : 'N/A',
                label: 'Age',
                theme: theme,
              ),
              _buildStatItem(
                icon: Icons.local_fire_department,
                value: profile.calorieGoals != null
                    ? '${profile.calorieGoals} kcal'
                    : 'N/A',
                label: 'Daily Goal',
                theme: theme,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required ThemeData theme,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewTab(UserStats stats, ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (stats.membershipInfo != null)
          _buildMembershipCard(stats.membershipInfo!, theme),
        const SizedBox(height: 16),
        _buildAttendanceCard(stats.attendanceStats, theme),
        const SizedBox(height: 16),
        _buildWeightProgressCard(stats.weightStats, theme),
        const SizedBox(height: 16),
        _buildWorkoutSummaryCard(stats.workoutStats, theme),
        const SizedBox(height: 16),
        _buildNutritionSummaryCard(stats.nutritionStats, theme),
        const SizedBox(height: 16),
        _buildPersonalBestsCard(stats.performanceStats, theme),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildMembershipCard(MembershipInfo membership, ThemeData theme) {
    final isActive = membership.status.toLowerCase() == 'active';
    final statusColor = isActive ? Colors.green : Colors.orange;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Membership',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    membership.status,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMembershipDetailItem(
                    label: 'Plan',
                    value: membership.membershipPlan.planType,
                    theme: theme,
                  ),
                ),
                Expanded(
                  child: _buildMembershipDetailItem(
                    label: 'Start Date',
                    value: membership.startDate != null
                        ? DateFormat('MMM d, yyyy')
                            .format(membership.startDate!)
                        : 'N/A',
                    theme: theme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildMembershipDetailItem(
                    label: 'End Date',
                    value: membership.endDate != null
                        ? DateFormat('MMM d, yyyy').format(membership.endDate!)
                        : 'N/A',
                    theme: theme,
                  ),
                ),
                Expanded(
                  child: _buildMembershipDetailItem(
                    label: 'Price',
                    value:
                        '₹${membership.membershipPlan.price.toStringAsFixed(2)}',
                    theme: theme,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembershipDetailItem({
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceCard(AttendanceStats stats, ThemeData theme) {
    final hasAttended = stats.lastAttendance != null;
    final lastAttendanceText = hasAttended
        ? DateFormat('MMM d, yyyy').format(stats.lastAttendance!)
        : 'No records';

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attendance',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAttendanceDetailItem(
                  icon: Icons.calendar_month,
                  value: stats.totalAttendances.toString(),
                  label: 'Total Check-ins',
                  theme: theme,
                ),
                _buildAttendanceDetailItem(
                  icon: Icons.event_available,
                  value: lastAttendanceText,
                  label: 'Last Attendance',
                  theme: theme,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceDetailItem({
    required IconData icon,
    required String value,
    required String label,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeightProgressCard(WeightStats stats, ThemeData theme) {
    final hasWeightLogs = stats.weightLogs.isNotEmpty;
    final weightProgress = stats.weightProgress;

    // Determine progress text and color
    String progressText = 'No change';
    Color progressColor = Colors.blue;

    if (weightProgress != null) {
      if (weightProgress < 0) {
        progressText = '${weightProgress.abs().toStringAsFixed(1)} kg lost';
        progressColor = Colors.green;
      } else if (weightProgress > 0) {
        progressText = '$weightProgress kg gained';
        progressColor = Colors.orange;
      }
    }

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weight Progress',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (weightProgress != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: progressColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      progressText,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: progressColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (!hasWeightLogs)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'No weight logs available',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
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
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() >= stats.weightLogs.length ||
                                value < 0) {
                              return const SizedBox.shrink();
                            }
                            final date =
                                stats.weightLogs[value.toInt()].loggedAt;
                            return SideTitleWidget(
                              meta: meta,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  DateFormat('MMM d').format(date),
                                  style: theme.textTheme.bodySmall,
                                ),
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
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          stats.weightLogs.length,
                          (index) => FlSpot(
                            index.toDouble(),
                            stats.weightLogs[index].weight,
                          ),
                        ),
                        isCurved: true,
                        color: theme.colorScheme.primary,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: theme.colorScheme.primary.withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutSummaryCard(WorkoutStats stats, ThemeData theme) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Workout Summary',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildWorkoutDetailItem(
                  icon: Icons.fitness_center,
                  value: stats.totalWorkouts.toString(),
                  label: 'Total Workouts',
                  theme: theme,
                ),
                _buildWorkoutDetailItem(
                  icon: Icons.timer,
                  value: '${stats.totalDuration.toStringAsFixed(1)} min',
                  label: 'Total Duration',
                  theme: theme,
                ),
                _buildWorkoutDetailItem(
                  icon: Icons.local_fire_department,
                  value: '${stats.totalCaloriesBurned.toStringAsFixed(0)} kcal',
                  label: 'Calories Burned',
                  theme: theme,
                ),
              ],
            ),
            if (stats.recentWorkouts.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Recent Workouts',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...stats.recentWorkouts
                  .map((workout) => _buildRecentWorkoutItem(workout, theme)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutDetailItem({
    required IconData icon,
    required String value,
    required String label,
    required ThemeData theme,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRecentWorkoutItem(WorkoutLogEntry workout, ThemeData theme) {
    final workoutName = workout.workout?.workoutName ?? 'Unknown Workout';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.fitness_center,
              size: 20,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workoutName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('MMM d, yyyy').format(workout.workoutDate),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (workout.totalDuration != null)
                Text(
                  '${workout.totalDuration!.toStringAsFixed(0)} min',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (workout.caloriesBurned != null)
                Text(
                  '${workout.caloriesBurned!.toStringAsFixed(0)} kcal',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionSummaryCard(NutritionStats stats, ThemeData theme) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nutrition Summary',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNutritionDetailItem(
                  icon: Icons.restaurant_menu,
                  value: stats.dietPlans.length.toString(),
                  label: 'Diet Plans',
                  theme: theme,
                ),
                _buildNutritionDetailItem(
                  icon: Icons.restaurant,
                  value: stats.totalMealsLogged.toString(),
                  label: 'Meals Logged',
                  theme: theme,
                ),
                _buildNutritionDetailItem(
                  icon: Icons.local_fire_department,
                  value: '${stats.caloriesConsumed.toStringAsFixed(0)} kcal',
                  label: 'Calories Consumed',
                  theme: theme,
                ),
              ],
            ),
            if (stats.recentMealLogs.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Recent Meals',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...stats.recentMealLogs
                  .take(3)
                  .map((meal) => _buildRecentMealItem(meal, theme)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionDetailItem({
    required IconData icon,
    required String value,
    required String label,
    required ThemeData theme,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRecentMealItem(MealLogEntry meal, ThemeData theme) {
    final mealName = meal.meal?.mealName ?? 'Unknown Meal';
    final mealTime = meal.meal?.mealTime ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.restaurant,
              size: 20,
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mealName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${mealTime.toUpperCase()} • ${DateFormat('MMM d, yyyy').format(meal.logTime)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (meal.meal?.calories != null)
                Text(
                  '${(meal.meal!.calories * meal.quantity).toStringAsFixed(0)} kcal',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              Text(
                'x${meal.quantity}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalBestsCard(PerformanceStats stats, ThemeData theme) {
    final hasRecords = stats.personalBests.isNotEmpty;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Bests',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (!hasRecords)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'No personal records yet',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              )
            else
              Column(
                children: stats.personalBests
                    .take(3)
                    .map((record) => _buildPersonalBestItem(record, theme))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalBestItem(PersonalBest record, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.emoji_events,
              size: 20,
              color: Colors.amber,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.supportedExercise.exerciseName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('MMM d, yyyy').format(record.achievedAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${record.weight.toStringAsFixed(1)} kg',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${record.reps} reps',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutsTab(WorkoutStats stats, ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildWorkoutMetricsCard(stats, theme),
        const SizedBox(height: 16),
        _buildRecentWorkoutsCard(stats.recentWorkouts, theme),
      ],
    );
  }

  Widget _buildWorkoutMetricsCard(WorkoutStats stats, ThemeData theme) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Workout Metrics',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildMetricItem(
                    icon: Icons.fitness_center,
                    value: stats.totalWorkouts.toString(),
                    label: 'Total Workouts',
                    theme: theme,
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    icon: Icons.timer,
                    value: '${stats.totalDuration.toStringAsFixed(0)} min',
                    label: 'Total Duration',
                    theme: theme,
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    icon: Icons.local_fire_department,
                    value:
                        '${stats.totalCaloriesBurned.toStringAsFixed(0)} kcal',
                    label: 'Calories Burned',
                    theme: theme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Average per Workout',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildMetricItem(
                    icon: Icons.timer,
                    value: stats.totalWorkouts > 0
                        ? '${(stats.totalDuration / stats.totalWorkouts).toStringAsFixed(0)} min'
                        : '0 min',
                    label: 'Avg. Duration',
                    theme: theme,
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    icon: Icons.local_fire_department,
                    value: stats.totalWorkouts > 0
                        ? '${(stats.totalCaloriesBurned / stats.totalWorkouts).toStringAsFixed(0)} kcal'
                        : '0 kcal',
                    label: 'Avg. Calories',
                    theme: theme,
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    icon: Icons.calendar_today,
                    value: stats.totalWorkouts > 0 &&
                            stats.recentWorkouts.isNotEmpty
                        ? '${(DateTime.now().difference(stats.recentWorkouts.last.workoutDate).inDays / stats.totalWorkouts).toStringAsFixed(1)} days'
                        : 'N/A',
                    label: 'Frequency',
                    theme: theme,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String value,
    required String label,
    required ThemeData theme,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRecentWorkoutsCard(
      List<WorkoutLogEntry> workouts, ThemeData theme) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Workouts',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (workouts.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'No workout history available',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              )
            else
              ...workouts
                  .map((workout) => _buildWorkoutHistoryItem(workout, theme)),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutHistoryItem(WorkoutLogEntry workout, ThemeData theme) {
    final workoutName = workout.workout?.workoutName ?? 'Unknown Workout';
    final targetMuscleGroup = workout.workout?.targetMuscleGroup ?? '';
    final difficulty = workout.workout?.difficulty ?? '';

    Color difficultyColor;
    switch (difficulty.toLowerCase()) {
      case 'easy':
        difficultyColor = Colors.green;
        break;
      case 'intermediate':
        difficultyColor = Colors.orange;
        break;
      case 'hard':
        difficultyColor = Colors.red;
        break;
      default:
        difficultyColor = Colors.blue;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  size: 24,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workoutName,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      targetMuscleGroup,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: difficultyColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  difficulty,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: difficultyColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildWorkoutDetailChip(
                  icon: Icons.calendar_today,
                  value: DateFormat('MMM d, yyyy').format(workout.workoutDate),
                  theme: theme,
                ),
              ),
              Expanded(
                child: _buildWorkoutDetailChip(
                  icon: Icons.timer,
                  value: workout.totalDuration != null
                      ? '${workout.totalDuration!.toStringAsFixed(0)} min'
                      : 'N/A',
                  theme: theme,
                ),
              ),
              Expanded(
                child: _buildWorkoutDetailChip(
                  icon: Icons.local_fire_department,
                  value: workout.caloriesBurned != null
                      ? '${workout.caloriesBurned!.toStringAsFixed(0)} kcal'
                      : 'N/A',
                  theme: theme,
                ),
              ),
            ],
          ),
          const Divider(height: 32),
        ],
      ),
    );
  }

  Widget _buildWorkoutDetailChip({
    required IconData icon,
    required String value,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            value,
            style: theme.textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionTab(NutritionStats stats, ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildNutritionMetricsCard(stats, theme),
        const SizedBox(height: 16),
        _buildActiveDietPlansCard(stats.dietPlans, theme),
        const SizedBox(height: 16),
        _buildRecentMealsCard(stats.recentMealLogs, theme),
      ],
    );
  }

  Widget _buildNutritionMetricsCard(NutritionStats stats, ThemeData theme) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nutrition Metrics',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildMetricItem(
                    icon: Icons.restaurant_menu,
                    value: stats.dietPlans.length.toString(),
                    label: 'Diet Plans',
                    theme: theme,
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    icon: Icons.restaurant,
                    value: stats.totalMealsLogged.toString(),
                    label: 'Total Meals',
                    theme: theme,
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    icon: Icons.local_fire_department,
                    value: '${stats.caloriesConsumed.toStringAsFixed(0)} kcal',
                    label: 'Calories',
                    theme: theme,
                  ),
                ),
              ],
            ),
            if (stats.recentMealLogs.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                'Daily Average',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildMetricItem(
                      icon: Icons.restaurant,
                      value: _calculateDailyMealAverage(stats.recentMealLogs)
                          .toStringAsFixed(1),
                      label: 'Meals/Day',
                      theme: theme,
                    ),
                  ),
                  Expanded(
                    child: _buildMetricItem(
                      icon: Icons.local_fire_department,
                      value:
                          '${_calculateDailyCalorieAverage(stats.recentMealLogs).toStringAsFixed(0)} kcal',
                      label: 'Calories/Day',
                      theme: theme,
                    ),
                  ),
                  Expanded(
                    child: _buildMetricItem(
                      icon: Icons.schedule,
                      value: _getMostFrequentMealTime(stats.recentMealLogs),
                      label: 'Most Frequent',
                      theme: theme,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  double _calculateDailyMealAverage(List<MealLogEntry> mealLogs) {
    if (mealLogs.isEmpty) return 0;

    // Get the date range
    final dates = mealLogs
        .map((log) => DateFormat('yyyy-MM-dd').format(log.logTime))
        .toSet();
    if (dates.isEmpty) return 0;

    return mealLogs.length / dates.length;
  }

  double _calculateDailyCalorieAverage(List<MealLogEntry> mealLogs) {
    if (mealLogs.isEmpty) return 0;

    // Calculate total calories
    double totalCalories = 0;
    for (var log in mealLogs) {
      if (log.meal?.calories != null) {
        totalCalories += log.meal!.calories * log.quantity;
      }
    }

    // Get the date range
    final dates = mealLogs
        .map((log) => DateFormat('yyyy-MM-dd').format(log.logTime))
        .toSet();
    if (dates.isEmpty) return 0;

    return totalCalories / dates.length;
  }

  String _getMostFrequentMealTime(List<MealLogEntry> mealLogs) {
    if (mealLogs.isEmpty) return 'N/A';

    // Count meal times
    final mealTimeCounts = <String, int>{};
    for (var log in mealLogs) {
      final mealTime = log.meal?.mealTime ?? 'Unknown';
      mealTimeCounts[mealTime] = (mealTimeCounts[mealTime] ?? 0) + 1;
    }

    // Find the most frequent
    String mostFrequent = 'N/A';
    int maxCount = 0;

    mealTimeCounts.forEach((mealTime, count) {
      if (count > maxCount) {
        maxCount = count;
        mostFrequent = mealTime;
      }
    });

    return mostFrequent;
  }

  Widget _buildActiveDietPlansCard(List<DietPlan> dietPlans, ThemeData theme) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Active Diet Plans',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (dietPlans.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'No active diet plans',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              )
            else
              ...dietPlans.map((plan) => _buildDietPlanItem(plan, theme)),
          ],
        ),
      ),
    );
  }

  Widget _buildDietPlanItem(DietPlan plan, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.restaurant_menu,
                  size: 24,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.name,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (plan.description.isNotEmpty)
                      Text(
                        plan.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _formatGoalType(plan.goalType),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDietPlanDetailChip(
                icon: Icons.local_fire_department,
                label: 'Calorie Goal:',
                value: plan.calorieGoal != null
                    ? '${plan.calorieGoal} kcal'
                    : 'Not set',
                theme: theme,
              ),
              _buildDietPlanDetailChip(
                icon: Icons.restaurant,
                label: 'Meals:',
                value: plan.meals.length.toString(),
                theme: theme,
              ),
              _buildDietPlanDetailChip(
                icon: Icons.calendar_today,
                label: 'Created:',
                value: DateFormat('MMM d, yyyy').format(plan.createdAt),
                theme: theme,
              ),
            ],
          ),
          const Divider(height: 32),
        ],
      ),
    );
  }

  Widget _buildDietPlanDetailChip({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 4),
        Text(
          '$label ',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentMealsCard(List<MealLogEntry> mealLogs, ThemeData theme) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Meals',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (mealLogs.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'No meal logs available',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              )
            else
              ...mealLogs.map((meal) => _buildDetailedMealItem(meal, theme)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedMealItem(MealLogEntry meal, ThemeData theme) {
    final mealName = meal.meal?.mealName ?? 'Unknown Meal';
    final mealTime = meal.meal?.mealTime ?? '';
    final dietPlanName = meal.meal?.dietplan?.name ?? 'No Diet Plan';

    // Get macro breakdown if available
    Map<String, dynamic>? macros = meal.meal?.macronutrients;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getMealTimeColor(mealTime).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getMealTimeIcon(mealTime),
                  size: 24,
                  color: _getMealTimeColor(mealTime),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mealName,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      dietPlanName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getMealTimeColor(mealTime).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  mealTime.isNotEmpty ? mealTime.toUpperCase() : 'MEAL',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _getMealTimeColor(mealTime),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMealDetailChip(
                icon: Icons.calendar_today,
                value: DateFormat('MMM d, yyyy').format(meal.logTime),
                theme: theme,
              ),
              _buildMealDetailChip(
                icon: Icons.access_time,
                value: DateFormat('h:mm a').format(meal.logTime),
                theme: theme,
              ),
              _buildMealDetailChip(
                icon: Icons.local_fire_department,
                value: meal.meal?.calories != null
                    ? '${(meal.meal!.calories * meal.quantity).toStringAsFixed(0)} kcal'
                    : 'N/A',
                theme: theme,
              ),
              _buildMealDetailChip(
                icon: Icons.format_list_numbered,
                value: 'x${meal.quantity}',
                theme: theme,
              ),
            ],
          ),
          if (macros != null && macros.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMacroItem(
                    name: 'Protein',
                    value: macros['protein'] != null
                        ? '${macros['protein']}g'
                        : 'N/A',
                    color: Colors.red,
                    theme: theme,
                  ),
                ),
                Expanded(
                  child: _buildMacroItem(
                    name: 'Carbs',
                    value:
                        macros['carbs'] != null ? '${macros['carbs']}g' : 'N/A',
                    color: Colors.blue,
                    theme: theme,
                  ),
                ),
                Expanded(
                  child: _buildMacroItem(
                    name: 'Fat',
                    value: macros['fat'] != null ? '${macros['fat']}g' : 'N/A',
                    color: Colors.amber,
                    theme: theme,
                  ),
                ),
              ],
            ),
          ],
          const Divider(height: 32),
        ],
      ),
    );
  }

  Widget _buildMealDetailChip({
    required IconData icon,
    required String value,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildMacroItem({
    required String name,
    required String value,
    required Color color,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$name: ',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  IconData _getMealTimeIcon(String mealTime) {
    switch (mealTime.toLowerCase()) {
      case 'breakfast':
        return Icons.wb_sunny;
      case 'lunch':
        return Icons.wb_twighlight;
      case 'dinner':
        return Icons.nightlight_round;
      case 'snack':
        return Icons.apple;
      default:
        return Icons.restaurant;
    }
  }

  Color _getMealTimeColor(String mealTime) {
    switch (mealTime.toLowerCase()) {
      case 'breakfast':
        return Colors.orange;
      case 'lunch':
        return Colors.green;
      case 'dinner':
        return Colors.indigo;
      case 'snack':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  Widget _buildProgressTab(UserStats stats, ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildWeightProgressDetailCard(stats.weightStats, theme),
        const SizedBox(height: 16),
        _buildWorkoutProgressCard(stats.workoutStats, theme),
        const SizedBox(height: 16),
        _buildPersonalBestsDetailCard(stats.performanceStats, theme),
      ],
    );
  }

  Widget _buildWeightProgressDetailCard(WeightStats stats, ThemeData theme) {
    final hasWeightLogs = stats.weightLogs.isNotEmpty;
    final weightProgress = stats.weightProgress;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weight Progress',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (weightProgress != null)
                  _buildWeightProgressBadge(weightProgress, theme),
              ],
            ),
            const SizedBox(height: 16),
            if (!hasWeightLogs)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'No weight logs available',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              )
            else ...[
              SizedBox(
                height: 240,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      horizontalInterval: 5,
                      verticalInterval: 1,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: theme.colorScheme.outline.withOpacity(0.2),
                          strokeWidth: 1,
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: theme.colorScheme.outline.withOpacity(0.2),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return SideTitleWidget(
                              meta: meta,
                              child: Text(
                                value.toStringAsFixed(0),
                                style: theme.textTheme.bodySmall,
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() >= stats.weightLogs.length ||
                                value < 0) {
                              return const SizedBox.shrink();
                            }
                            // Only show some dates for readability
                            if (value.toInt() %
                                    (stats.weightLogs.length ~/ 5 + 1) !=
                                0) {
                              return const SizedBox.shrink();
                            }
                            final date =
                                stats.weightLogs[value.toInt()].loggedAt;
                            return SideTitleWidget(
                              meta: meta,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  DateFormat('MMM d').format(date),
                                  style: theme.textTheme.bodySmall,
                                ),
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
                      border: Border.all(
                        color: theme.colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          stats.weightLogs.length,
                          (index) => FlSpot(
                            index.toDouble(),
                            stats.weightLogs[index].weight,
                          ),
                        ),
                        isCurved: true,
                        color: theme.colorScheme.primary,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: theme.colorScheme.primary.withOpacity(0.1),
                        ),
                      ),
                    ],
                    minY: _getMinWeight(stats.weightLogs),
                    maxY: _getMaxWeight(stats.weightLogs),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildWeightLogTable(stats.weightLogs, theme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWeightProgressBadge(double progress, ThemeData theme) {
    // Determine progress text and color
    String progressText;
    Color progressColor;
    IconData progressIcon;

    if (progress < 0) {
      progressText = '${progress.abs().toStringAsFixed(1)} kg lost';
      progressColor = Colors.green;
      progressIcon = Icons.arrow_downward;
    } else if (progress > 0) {
      progressText = '$progress kg gained';
      progressColor = Colors.orange;
      progressIcon = Icons.arrow_upward;
    } else {
      progressText = 'No change';
      progressColor = Colors.blue;
      progressIcon = Icons.remove;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: progressColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            progressIcon,
            size: 14,
            color: progressColor,
          ),
          const SizedBox(width: 4),
          Text(
            progressText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: progressColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightLogTable(List<WeightLog> logs, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weight Log History',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Table(
          border: TableBorder(
            horizontalInside: BorderSide(
              color: theme.colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Date',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Weight (kg)',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            ...logs.take(5).map((log) => TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        DateFormat('MMM d, yyyy').format(log.loggedAt),
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        log.weight.toString(),
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ],
    );
  }

  double _getMinWeight(List<WeightLog> logs) {
    if (logs.isEmpty) return 0;
    double min = logs.first.weight;
    for (var log in logs) {
      if (log.weight < min) min = log.weight;
    }
    return min - 5; // Subtract 5 for some padding
  }

  double _getMaxWeight(List<WeightLog> logs) {
    if (logs.isEmpty) return 100;
    double max = logs.first.weight;
    for (var log in logs) {
      if (log.weight > max) max = log.weight;
    }
    return max + 5; // Add 5 for some padding
  }

  Widget _buildWorkoutProgressCard(WorkoutStats stats, ThemeData theme) {
    final hasWorkouts = stats.totalWorkouts > 0;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Workout Progress',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (!hasWorkouts)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'No workout data available',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              )
            else
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildProgressMetric(
                          title: 'Workouts Completed',
                          value: stats.totalWorkouts.toString(),
                          icon: Icons.fitness_center,
                          color: Colors.blue,
                          theme: theme,
                        ),
                      ),
                      Expanded(
                        child: _buildProgressMetric(
                          title: 'Total Duration',
                          value:
                              '${stats.totalDuration.toStringAsFixed(0)} min',
                          icon: Icons.timer,
                          color: Colors.green,
                          theme: theme,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildProgressMetric(
                          title: 'Calories Burned',
                          value:
                              '${stats.totalCaloriesBurned.toStringAsFixed(0)} kcal',
                          icon: Icons.local_fire_department,
                          color: Colors.orange,
                          theme: theme,
                        ),
                      ),
                      Expanded(
                        child: _buildProgressMetric(
                          title: 'Avg. Workout Duration',
                          value:
                              '${(stats.totalDuration / stats.totalWorkouts).toStringAsFixed(0)} min',
                          icon: Icons.timer_outlined,
                          color: Colors.purple,
                          theme: theme,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (stats.recentWorkouts.length >= 2) ...[
                    _buildWorkoutTrendsChart(stats.recentWorkouts, theme),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressMetric({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutTrendsChart(
      List<WorkoutLogEntry> workouts, ThemeData theme) {
    // Sort workouts by date
    final sortedWorkouts = List<WorkoutLogEntry>.from(workouts)
      ..sort((a, b) => a.workoutDate.compareTo(b.workoutDate));

    // Extract data for graphs
    final durationSpots = <FlSpot>[];
    final caloriesSpots = <FlSpot>[];

    for (var i = 0; i < sortedWorkouts.length; i++) {
      final workout = sortedWorkouts[i];
      if (workout.totalDuration != null) {
        durationSpots.add(FlSpot(i.toDouble(), workout.totalDuration!));
      }
      if (workout.caloriesBurned != null) {
        caloriesSpots.add(FlSpot(i.toDouble(), workout.caloriesBurned!));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Workout Trends',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: 20,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
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
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 35,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= sortedWorkouts.length || value < 0) {
                        return const SizedBox.shrink();
                      }
                      final date = sortedWorkouts[value.toInt()].workoutDate;
                      return SideTitleWidget(
                        meta: meta,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat('MM/dd').format(date),
                            style: theme.textTheme.bodySmall,
                          ),
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
              borderData: FlBorderData(show: false),
              lineBarsData: [
                // Duration line
                LineChartBarData(
                  spots: durationSpots,
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: true),
                ),
                // Calories line
                LineChartBarData(
                  spots: caloriesSpots
                      .map((spot) => FlSpot(spot.x, spot.y / 10))
                      .toList(), // Scale down calories for better visualization
                  isCurved: true,
                  color: Colors.orange,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildChartLegendItem('Duration (min)', Colors.blue, theme),
            const SizedBox(width: 16),
            _buildChartLegendItem('Calories (÷10)', Colors.orange, theme),
          ],
        ),
      ],
    );
  }

  Widget _buildChartLegendItem(String label, Color color, ThemeData theme) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildPersonalBestsDetailCard(
      PerformanceStats stats, ThemeData theme) {
    final hasRecords = stats.personalBests.isNotEmpty;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Records',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (!hasRecords)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'No personal records yet',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              )
            else
              ..._buildPersonalBestsByExercise(stats.personalBests, theme),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPersonalBestsByExercise(
      List<PersonalBest> records, ThemeData theme) {
    // Group records by exercise
    final exerciseGroups = <String, List<PersonalBest>>{};

    for (var record in records) {
      final exerciseName = record.supportedExercise.exerciseName;
      if (!exerciseGroups.containsKey(exerciseName)) {
        exerciseGroups[exerciseName] = [];
      }
      exerciseGroups[exerciseName]!.add(record);
    }

    // Sort records by date for each exercise
    exerciseGroups.forEach((_, records) {
      records.sort((a, b) => b.achievedAt.compareTo(a.achievedAt));
    });

    // Build widgets for each exercise group
    final widgets = <Widget>[];

    exerciseGroups.forEach((exerciseName, records) {
      widgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    color: Colors.amber,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  exerciseName,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Table(
              border: TableBorder(
                horizontalInside: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                  width: 1,
                ),
              ),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Date',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Weight (kg)',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Reps',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                ...records.take(3).map((record) => TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            DateFormat('MMM d, yyyy').format(record.achievedAt),
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            record.weight.toString(),
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            record.reps.toString(),
                            style: theme.textTheme.bodySmall,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    )),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    });

    return widgets;
  }

  Widget _buildTag(String text, Color color, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
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

  String _formatGoalType(String goalType) {
    // Convert 'Weight_Loss' to 'Weight Loss'
    return goalType.replaceAll('_', ' ');
  }
}
