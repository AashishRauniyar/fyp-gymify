// import 'package:flutter/material.dart';
// import 'package:gymify/providers/pedometer_provider/pedometer_provider.dart';
// import 'package:provider/provider.dart';

// class StepCountScreen extends StatefulWidget {
//   const StepCountScreen({super.key});

//   @override
//   State<StepCountScreen> createState() => _StepCountScreenState();
// }

// class _StepCountScreenState extends State<StepCountScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Start tracking when the screen is initialized
//     Future.delayed(Duration.zero, () {
//       Provider.of<PedometerProvider>(context, listen: false).startTracking();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Step Count Tracker'),
//         centerTitle: true,
//         elevation: 4,
//         backgroundColor: Theme.of(context).primaryColor,
//       ),
//       body: Consumer<PedometerProvider>(
//         builder: (context, pedometerProvider, child) {
//           return Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // Step Count Section
//                 Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   elevation: 6,
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Text(
//                           'Steps Taken',
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.grey,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Text(
//                           pedometerProvider.steps,
//                           style: TextStyle(
//                             fontSize: 60,
//                             fontWeight: FontWeight.bold,
//                             color: Theme.of(context).primaryColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 40),

//                 // Pedestrian Status Section
//                 Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   elevation: 6,
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Text(
//                           'Pedestrian Status',
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.grey,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         Icon(
//                           pedometerProvider.status == 'walking'
//                               ? Icons.directions_walk
//                               : pedometerProvider.status == 'stopped'
//                                   ? Icons.accessibility_new
//                                   : Icons.error,
//                           size: 80,
//                           color: pedometerProvider.status == 'walking'
//                               ? Colors.green
//                               : pedometerProvider.status == 'stopped'
//                                   ? Colors.orange
//                                   : Colors.red,
//                         ),
//                         const SizedBox(height: 10),
//                         Text(
//                           pedometerProvider.status,
//                           style: TextStyle(
//                             fontSize: 30,
//                             fontWeight: FontWeight.w600,
//                             color: pedometerProvider.status == 'walking'
//                                 ? Colors.green
//                                 : pedometerProvider.status == 'stopped'
//                                     ? Colors.orange
//                                     : Colors.red,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 40),

//                 // Start/Stop Tracking Button
//                 ElevatedButton(
//                   onPressed: () {
//                     if (pedometerProvider.isTrackingSteps) {
//                       pedometerProvider.stopTracking();
//                     } else {
//                       pedometerProvider.startTracking();
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(

//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 40, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     elevation: 6,
//                   ),
//                   child: Text(
//                     pedometerProvider.isTrackingSteps
//                         ? 'Stop Tracking'
//                         : 'Start Tracking',
//                     style: const TextStyle(fontSize: 18),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:gymify/providers/pedometer_provider/pedometer_provider.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

class StepCountScreen extends StatefulWidget {
  const StepCountScreen({super.key});

  @override
  State<StepCountScreen> createState() => _StepCountScreenState();
}

class _StepCountScreenState extends State<StepCountScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });

    // Start tracking when the screen is initialized
    Future.delayed(Duration.zero, () {
      Provider.of<PedometerProvider>(context, listen: false).startTracking();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PedometerProvider>(
        builder: (context, provider, child) {
          final progress = provider.goalProgress;

          // Create mock data for weekly view since our simplified provider doesn't have it
          final Map<String, int> mockWeeklyData =
              _createMockWeeklyData(provider);

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // App Bar with circular progress indicator
              _buildAppBar(context, provider, progress),

              // Main content area
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Motivation message
                      _buildMotivationMessage(provider),

                      const SizedBox(height: 20),

                      // Main stats cards
                      _buildStatsCards(provider),

                      const SizedBox(height: 24),

                      // Custom tab bar
                      _buildCustomTabBar(context),

                      const SizedBox(height: 20),

                      // Tab content based on selection
                      _selectedIndex == 0
                          ? _buildDailyView(context, provider, progress)
                          : _buildWeeklyView(context, provider, mockWeeklyData),

                      const SizedBox(height: 24),

                      // Status section
                      _buildStatusSection(context, provider),

                      const SizedBox(height: 80), // Bottom padding for FAB
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // App bar with gradient and circular progress
  Widget _buildAppBar(
      BuildContext context, PedometerProvider provider, double progress) {
    return SliverAppBar(
      expandedHeight: 230.0,
      pinned: true,
      stretch: true,
      backgroundColor: Theme.of(context).primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: const Text(
          'Step Tracker',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Gradient background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.7),
                    Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                  ],
                ),
              ),
            ),

            // Circular pattern for visual interest
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),

            // Centered circular progress indicator
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularPercentIndicator(
                      radius: 55.0,
                      lineWidth: 10.0,
                      percent: progress,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            provider.steps,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            'steps',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.white.withOpacity(0.2),
                      progressColor: provider.goalAchieved
                          ? Colors.greenAccent
                          : Colors.white,
                      animation: true,
                      animationDuration: 1200,
                      circularStrokeCap: CircularStrokeCap.round,
                    ),

                    const SizedBox(height: 10),

                    // Goal percentage
                    Text(
                      '${(progress * 100).toInt()}% of Daily Goal',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined, color: Colors.white),
          onPressed: () => _showGoalSettingDialog(context),
        ),
      ],
    );
  }

  // Motivation message that changes based on progress and time of day
  Widget _buildMotivationMessage(PedometerProvider provider) {
    final hour = DateTime.now().hour;
    final progress = provider.goalProgress;

    String message;
    IconData icon;

    if (provider.goalAchieved) {
      message = "Congrats! You've reached your daily goal! 🎉";
      icon = Icons.emoji_events;
    } else if (progress > 0.75) {
      message = "Almost there! Keep up the great work!";
      icon = Icons.directions_run;
    } else if (progress > 0.5) {
      message = "Halfway there! You're doing great!";
      icon = Icons.trending_up;
    } else if (progress > 0.25) {
      message = "Good progress! Keep moving!";
      icon = Icons.directions_walk;
    } else if (hour < 12) {
      message = "Good morning! Time to start moving!";
      icon = Icons.wb_sunny;
    } else if (hour < 18) {
      message = "Keep active throughout your day!";
      icon = Icons.watch_later;
    } else {
      message = "Evening steps count too! Keep going!";
      icon = Icons.nightlight_round;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Main stats cards (Steps, Calories, Distance)
  Widget _buildStatsCards(PedometerProvider provider) {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _buildStatCard(
            context,
            'Steps',
            provider.steps,
            Icons.directions_walk,
            Colors.blue,
            width: 130,
          ),
          _buildStatCard(
            context,
            'Calories',
            provider.caloriesBurned.toStringAsFixed(1),
            Icons.local_fire_department,
            Colors.orange,
          ),
          _buildStatCard(
            context,
            'Distance',
            '${provider.distanceWalked.toStringAsFixed(2)} km',
            Icons.straighten,
            Colors.green,
          ),
          _buildStatCard(
            context,
            'Time',
            _formatDuration(provider.elapsedTime),
            Icons.timer,
            Colors.purple,
          ),
        ],
      ),
    );
  }

  // Individual stat card
  Widget _buildStatCard(BuildContext context, String label, String value,
      IconData icon, Color color,
      {double width = 120}) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                color.withOpacity(0.1),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 28),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: color is MaterialColor ? color.shade800 : color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom tab bar
  Widget _buildCustomTabBar(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          // Daily tab
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                  _tabController.animateTo(0);
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedIndex == 0
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    'Daily',
                    style: TextStyle(
                      color: _selectedIndex == 0
                          ? Colors.white
                          : Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Weekly tab
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                  _tabController.animateTo(1);
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedIndex == 1
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    'Weekly',
                    style: TextStyle(
                      color: _selectedIndex == 1
                          ? Colors.white
                          : Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Daily view with goal progress
  Widget _buildDailyView(
      BuildContext context, PedometerProvider provider, double progress) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Daily goal header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Daily Goal',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${provider.steps} / ${provider.dailyGoal}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Linear progress indicator
          LinearPercentIndicator(
            lineHeight: 16.0,
            percent: progress,
            backgroundColor: Colors.grey.shade200,
            progressColor:
                _getProgressColor(context, provider.goalAchieved, progress),
            barRadius: const Radius.circular(8),
            animation: true,
            animationDuration: 1000,
            center: Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: progress > 0.5 ? Colors.white : Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Step breakdown
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStepMetric(
                      context,
                      'Avg. Speed',
                      '4.2 km/h',
                      Icons.speed,
                    ),
                    _buildStepMetric(
                      context,
                      'Steps/min',
                      '112',
                      Icons.directions_walk,
                    ),
                    _buildStepMetric(
                      context,
                      'Active Time',
                      '68%',
                      Icons.watch_later_outlined,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Goal achievement badge
          if (provider.goalAchieved) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.green.shade50,
                    Colors.green.shade100,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade300),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.shade200,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      color: Colors.amber,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Daily Goal Achieved!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          'Great job! You\'ve reached your ${provider.dailyGoal} steps goal for today.',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Helper for step metrics
  Widget _buildStepMetric(
      BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).primaryColor.withOpacity(0.7),
          size: 20,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // Weekly view with bar chart
  Widget _buildWeeklyView(BuildContext context, PedometerProvider provider,
      Map<String, int> weeklyData) {
    // Mock weekly goal progress
    const weeklyProgress = 0.65;
    final weeklyTotal = weeklyData.values.fold(0, (sum, value) => sum + value);
    final weeklyGoal = provider.dailyGoal * 7;

    // Prepare data for chart
    final List<BarChartGroupData> barGroups =
        _prepareChartData(context, weeklyData);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Weekly goal header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Weekly Progress',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$weeklyTotal / $weeklyGoal',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Weekly progress bar
          LinearPercentIndicator(
            lineHeight: 16.0,
            percent: weeklyProgress,
            backgroundColor: Colors.grey.shade200,
            progressColor: _getProgressColor(context, false, weeklyProgress),
            barRadius: const Radius.circular(8),
            animation: true,
            animationDuration: 1000,
            center: Text(
              '${(weeklyProgress * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: weeklyProgress > 0.5 ? Colors.white : Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Bar chart
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: (provider.dailyGoal * 1.2).toDouble(),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value % 5000 != 0) return const SizedBox.shrink();
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            '${value ~/ 1000}k',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            weekdays[value.toInt()],
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.shade200,
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: barGroups,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Weekly stats summary
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeeklyStat('Best Day', 'Friday', '11,245'),
                _buildWeeklyStat(
                    'Avg. Daily', 'Steps', '${(weeklyTotal / 7).round()}'),
                _buildWeeklyStat('Total', 'Distance',
                    '${(weeklyTotal * 0.000762).toStringAsFixed(1)} km'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper for weekly stats
  Widget _buildWeeklyStat(String title, String subtitle, String value) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  // Status section (pedestrian status with animation)
  Widget _buildStatusSection(BuildContext context, PedometerProvider provider) {
    // Determine status color and icon
    Color statusColor;
    IconData statusIcon;
    String statusText = provider.status.toUpperCase();

    switch (provider.status) {
      case 'walking':
        statusColor = Colors.green;
        statusIcon = Icons.directions_walk;
        break;
      case 'stopped':
        statusColor = Colors.orange;
        statusIcon = Icons.accessibility_new;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            final provider =
                Provider.of<PedometerProvider>(context, listen: false);
            if (provider.isTrackingSteps) {
              provider.stopTracking();
            } else {
              provider.startTracking();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Status indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    statusIcon,
                    color: statusColor,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),

                // Status info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Status',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // Options button
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            Icons.refresh,
                            color: Theme.of(context).primaryColor,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          const Text('Reset Steps'),
                        ],
                      ),
                      onTap: () {
                        // Small delay to allow popup to close
                        Future.delayed(const Duration(milliseconds: 100), () {
                          _showResetConfirmationDialog(context);
                        });
                      },
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            Icons.settings,
                            color: Theme.of(context).primaryColor,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          const Text('Set Goals'),
                        ],
                      ),
                      onTap: () {
                        // Small delay to allow popup to close
                        Future.delayed(const Duration(milliseconds: 100), () {
                          _showGoalSettingDialog(context);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Floating action button
  Widget _buildFloatingActionButton(BuildContext context) {
    return Consumer<PedometerProvider>(
      builder: (context, provider, child) {
        final isTracking = provider.isTrackingSteps;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isTracking ? 160 : 140,
          height: 56,
          child: FloatingActionButton.extended(
            backgroundColor:
                isTracking ? Colors.redAccent : Theme.of(context).primaryColor,
            onPressed: () {
              if (isTracking) {
                provider.stopTracking();
              } else {
                provider.startTracking();
              }
            },
            icon: Icon(
              isTracking ? Icons.stop_circle : Icons.play_circle_fill,
              size: 28,
            ),
            label: Text(
// Floating action button (continuation)
              isTracking ? 'Stop Tracking' : 'Start Tracking',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }

  // Goal setting dialog
  void _showGoalSettingDialog(BuildContext context) {
    final provider = Provider.of<PedometerProvider>(context, listen: false);
    int dailyGoal = provider.dailyGoal;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.fitness_center,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            const Text('Set Your Step Goal'),
          ],
        ),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('How many steps do you want to take each day?'),
                const SizedBox(height: 20),

                // Goal presets
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildGoalChip(context, 5000, dailyGoal, (value) {
                      setState(() => dailyGoal = value);
                    }),
                    _buildGoalChip(context, 7500, dailyGoal, (value) {
                      setState(() => dailyGoal = value);
                    }),
                    _buildGoalChip(context, 10000, dailyGoal, (value) {
                      setState(() => dailyGoal = value);
                    }),
                  ],
                ),

                const SizedBox(height: 20),

                // Custom slider
                Slider(
                  value: dailyGoal.toDouble(),
                  min: 1000,
                  max: 20000,
                  divisions: 19,
                  activeColor: Theme.of(context).primaryColor,
                  label: dailyGoal.toString(),
                  onChanged: (value) {
                    setState(() => dailyGoal = value.toInt());
                  },
                ),

                // Current value
                Text(
                  '$dailyGoal steps',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Theme.of(context).primaryColor,
                  ),
                ),

                const SizedBox(height: 10),

                // Activity level
                Text(
                  _getActivityLevelText(dailyGoal),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.setDailyGoal(dailyGoal);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('SAVE'),
          ),
        ],
      ),
    );
  }

  // Goal chip
  Widget _buildGoalChip(BuildContext context, int value, int selectedGoal,
      Function(int) onSelected) {
    final isSelected = value == selectedGoal;

    return GestureDetector(
      onTap: () => onSelected(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '$value',
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Reset confirmation dialog
  void _showResetConfirmationDialog(BuildContext context) {
    final provider = Provider.of<PedometerProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Step Count?'),
        content: const Text(
            'This will reset your current step count to zero. Your data will not be saved. Continue?'),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.resetSteps();
              Navigator.pop(context);

              // Show confirmation snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Step count has been reset'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  action: SnackBarAction(
                    label: 'OK',
                    onPressed: () {},
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('RESET'),
          ),
        ],
      ),
    );
  }

  // Helper function to get progress color based on completion
  Color _getProgressColor(
      BuildContext context, bool achieved, double progress) {
    if (achieved) return Colors.green;
    if (progress > 0.7) return Colors.amber;
    return Theme.of(context).primaryColor;
  }

  // Helper to get activity level text based on goal
  String _getActivityLevelText(int goal) {
    if (goal < 5000) return 'Light Activity Level';
    if (goal < 7500) return 'Moderate Activity Level';
    if (goal < 10000) return 'Active Lifestyle';
    if (goal < 15000) return 'Very Active Lifestyle';
    return 'Athletic Level';
  }

  // Format duration as HH:MM:SS
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  // Create mock data for weekly view
  Map<String, int> _createMockWeeklyData(PedometerProvider provider) {
    final Map<String, int> data = {};
    final random = math.Random();
    final today = DateTime.now();

    // Use the current step count for today
    int todaySteps = int.tryParse(provider.steps) ?? 0;
    if (todaySteps == 0) todaySteps = random.nextInt(provider.dailyGoal);

    for (int i = 6; i >= 0; i--) {
      final day = today.subtract(Duration(days: i));
      final dayKey = '${day.year}-${day.month}-${day.day}';

      if (i == 0) {
        // Today
        data[dayKey] = todaySteps;
      } else {
        // Random historical data with higher values on weekdays
        final isWeekend = day.weekday == 6 || day.weekday == 7;
        final baseValue =
            isWeekend ? provider.dailyGoal * 0.7 : provider.dailyGoal * 0.9;

        data[dayKey] = (baseValue + random.nextInt(5000) - 2500)
            .toInt()
            .clamp(2000, 20000);
      }
    }

    return data;
  }

  // Prepare chart data
  List<BarChartGroupData> _prepareChartData(
      BuildContext context, Map<String, int> weeklyData) {
    final List<BarChartGroupData> result = [];
    final today = DateTime.now();
    final todayWeekday = today.weekday - 1; // 0-based index (0 = Monday)

    final values = weeklyData.values.toList();

    for (int i = 0; i < 7; i++) {
      final steps = values[i];
      final isToday = i == 6; // Last day is today

      result.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: steps.toDouble(),
              color: isToday
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade400,
              width: 20,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ],
        ),
      );
    }

    return result;
  }
}
