// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:gymify/providers/diet_provider/diet_provider.dart';
// import 'package:gymify/screens/diet_screens/meal_detail_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:gymify/models/diet_log_models/meal_logs_model.dart';

// class MealLogsScreen extends StatelessWidget {
//   const MealLogsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<DietProvider>(context);
//     final theme = Theme.of(context);

//     // Fetch meal logs when the screen is built
//     if (provider.mealLogs.isEmpty) {
//       provider
//           .fetchMealLogs(); // This will load the meal logs if they are not already loaded
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Meal Logs'),
//         backgroundColor: theme.colorScheme.primary,
//       ),
//       body: provider.isLoading
//           ? const Center(
//               child: CircularProgressIndicator()) // Show loading indicator
//           : provider.hasError
//               ? const Center(
//                   child: Text('Error fetching meal logs')) // Show error message
//               : ListView.builder(
//                   itemCount: provider.mealLogs.length,
//                   itemBuilder: (context, index) {
//                     final mealLog = provider.mealLogs[index];
//                     return _MealLogCard(mealLog: mealLog);
//                   },
//                 ),
//     );
//   }
// }

// class _MealLogCard extends StatelessWidget {
//   final MealLog mealLog;

//   const _MealLogCard({required this.mealLog});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     final isDarkMode = theme.brightness == Brightness.dark;

//     return Container(
//       decoration: BoxDecoration(
//         color:
//             isDarkMode ? theme.colorScheme.surface : theme.colorScheme.surface,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: isDarkMode
//               ? theme.colorScheme.onSurface.withOpacity(0.1)
//               : theme.colorScheme.onSurface.withOpacity(0.1),
//           width: 1.5,
//         ),
//       ),
//       child: Card(
//         elevation: 0,
//         child: Row(
//           children: [
//             // Meal Image with rounded corners and shadow
//             if (mealLog.meal.image.isNotEmpty)
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: CachedNetworkImage(
//                     imageUrl: mealLog.meal.image,
//                     width: 90,
//                     height: 90,
//                     fit: BoxFit.cover,
//                     placeholder: (context, url) =>
//                         const Center(child: CircularProgressIndicator()),
//                     errorWidget: (context, url, error) =>
//                         const Icon(Icons.error)),
//               ),
//             const SizedBox(width: 16),
//             // Meal Details Section
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Meal Name
//                   Text(
//                     mealLog.meal.mealName,
//                     style: theme.textTheme.bodyMedium?.copyWith(
//                       fontWeight: FontWeight.bold,
//                       color: theme.colorScheme.onSurface,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   // Quantity and Log Time
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Quantity: ${mealLog.quantity} servings',
//                         style: theme.textTheme.bodyMedium?.copyWith(
//                           color: theme.colorScheme.onSurface.withOpacity(0.7),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         'Logged at: ${mealLog.logTime.toLocal().toString().substring(0, 19)}',
//                         style: theme.textTheme.bodyMedium?.copyWith(
//                           color: theme.colorScheme.onSurface.withOpacity(0.7),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             // View Details Button
//             IconButton(
//               icon: Icon(
//                 Icons.arrow_forward_ios,
//                 color: theme.colorScheme.primary,
//               ),
//               onPressed: () {
//                 // Navigate to meal details screen when tapped
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => MealDetailScreen(meal: mealLog.meal),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:gymify/models/diet_log_models/meal_logs_model.dart';
import 'package:gymify/providers/diet_provider/diet_provider.dart';
import 'package:gymify/screens/diet_screens/meal_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MealLogsScreen extends StatefulWidget {
  const MealLogsScreen({super.key});

  @override
  _MealLogsScreenState createState() => _MealLogsScreenState();
}

class _MealLogsScreenState extends State<MealLogsScreen>
    with SingleTickerProviderStateMixin {
  DateTime? selectedDate;
  String selectedFilter = 'Today';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Fetch meal logs when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DietProvider>(context, listen: false).fetchMealLogs();
    });
  }

  // init state

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DietProvider>(context);
    final theme = Theme.of(context);

    // Show loading indicator if data is being fetched
    if (provider.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Get today's date in the format 'yyyy-MM-dd'
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(selectedDate ?? DateTime.now());

    // Filter the meals based on selected date
    List<MealLog> filteredMealLogs = provider.mealLogs.where((mealLog) {
      String logDate = DateFormat('yyyy-MM-dd').format(mealLog.logTime);
      return logDate == formattedDate;
    }).toList();

    // Calculate total macros for the selected date
    double totalProtein = 0.0,
        totalCarbs = 0.0,
        totalFat = 0.0,
        totalCalories = 0.0;
    for (var mealLog in filteredMealLogs) {
      final macros = _parseMacros(mealLog.meal.macronutrients);
      final quantity = double.tryParse(mealLog.quantity) ?? 1.0;

      totalProtein += (macros['protein'] ?? 0.0) * quantity;
      totalCarbs += (macros['carbs'] ?? 0.0) * quantity;
      totalFat += (macros['fat'] ?? 0.0) * quantity;
      totalCalories +=
          (double.tryParse(mealLog.meal.calories) ?? 0.0) * quantity;
    }

    // Calculate weekly data
    Map<String, double> weeklyCalories =
        _calculateWeeklyData(provider.mealLogs);

    // Calculate meal type distribution
    Map<String, double> mealDistribution =
        _calculateMealDistribution(filteredMealLogs);

    // Target values (you could fetch these from user settings in a real implementation)
    double targetCalories = 2000.0;
    double targetProtein = 150.0;
    double targetCarbs = 200.0;
    double targetFat = 65.0;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Meal Tracker",
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today, color: theme.colorScheme.primary),
            onPressed: () => _showDatePicker(context),
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: theme.colorScheme.primary),
            onPressed: () {
              Provider.of<DietProvider>(context, listen: false).fetchMealLogs();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
          indicatorColor: theme.colorScheme.primary,
          tabs: const [
            Tab(text: 'TODAY'),
            Tab(text: 'TRENDS'),
            Tab(text: 'INSIGHTS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          //         // TODAY TAB
          _buildTodayTab(
              context,
              filteredMealLogs,
              totalCalories,
              totalProtein,
              totalCarbs,
              totalFat,
              targetCalories,
              targetProtein,
              targetCarbs,
              targetFat),

          // TRENDS TAB
          _buildTrendsTab(context, weeklyCalories, provider.mealLogs),

          // INSIGHTS TAB
          _buildInsightsTab(context, mealDistribution, provider.mealLogs),
        ],
      ),

      // body: SafeArea(
      //   child: NestedScrollView(
      //     headerSliverBuilder: (context, innerBoxIsScrolled) {
      //       return [
      //         SliverAppBar(
      //           expandedHeight: 200.0,
      //           floating: true,
      //           pinned: true,
      //           backgroundColor: theme.colorScheme.primary,
      //           flexibleSpace: FlexibleSpaceBar(
      //             title: const Text(
      //               'Nutrition Tracker',
      //               style: TextStyle(
      //                 color: Colors.white,
      //                 fontWeight: FontWeight.bold,
      //               ),
      //             ),
      //             background: Stack(
      //               fit: StackFit.expand,
      //               children: [
      //                 Image.asset(
      //                   'assets/images/nutrition_header.jpg',
      //                   fit: BoxFit.cover,
      //                   errorBuilder: (context, error, stackTrace) {
      //                     return Container(
      //                       color: theme.colorScheme.primary.withOpacity(0.7),
      //                     );
      //                   },
      //                 ),
      //                 Container(
      //                   decoration: BoxDecoration(
      //                     gradient: LinearGradient(
      //                       begin: Alignment.topCenter,
      //                       end: Alignment.bottomCenter,
      //                       colors: [
      //                         Colors.transparent,
      //                         theme.colorScheme.primary.withOpacity(0.8),
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //           actions: [
      //             IconButton(
      //               icon: const Icon(Icons.calendar_today, color: Colors.white),
      //               onPressed: () => _showDatePicker(context),
      //             ),
      //             IconButton(
      //               icon: const Icon(Icons.refresh, color: Colors.white),
      //               onPressed: () {
      //                 Provider.of<DietProvider>(context, listen: false)
      //                     .fetchMealLogs();
      //               },
      //             ),
      //           ],
      //         ),
      //         SliverPersistentHeader(
      //           delegate: _SliverAppBarDelegate(
      //             TabBar(
      //               controller: _tabController,
      //               labelColor: theme.colorScheme.primary,
      //               unselectedLabelColor:
      //                   theme.colorScheme.onSurface.withOpacity(0.6),
      //               indicatorColor: theme.colorScheme.primary,
      //               tabs: const [
      //                 Tab(text: 'TODAY'),
      //                 Tab(text: 'TRENDS'),
      //                 Tab(text: 'INSIGHTS'),
      //               ],
      //             ),
      //           ),
      //           pinned: true,
      //         ),
      //       ];
      //     },
      //     body: TabBarView(
      //       controller: _tabController,
      //       children: [
      //         // TODAY TAB
      //         _buildTodayTab(
      //             context,
      //             filteredMealLogs,
      //             totalCalories,
      //             totalProtein,
      //             totalCarbs,
      //             totalFat,
      //             targetCalories,
      //             targetProtein,
      //             targetCarbs,
      //             targetFat),

      //         // TRENDS TAB
      //         _buildTrendsTab(context, weeklyCalories, provider.mealLogs),

      //         // INSIGHTS TAB
      //         _buildInsightsTab(context, mealDistribution, provider.mealLogs),
      //       ],
      //     ),
      //   ),
      // ),
      //TODO: Implement the floating action button to open meal
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigation to add meal log screen
          // _showAddMealDialog(context);
          // go to meal screen
          context.pushNamed('dietSearch');
        },
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.search, color: Colors.white),
      ),
    );
  }

  Widget _buildTodayTab(
      BuildContext context,
      List<MealLog> filteredMealLogs,
      double totalCalories,
      double totalProtein,
      double totalCarbs,
      double totalFat,
      double targetCalories,
      double targetProtein,
      double targetCarbs,
      double targetFat) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');
    final selectedDateFormatted =
        dateFormat.format(selectedDate ?? DateTime.now());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date display
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    selectedDateFormatted,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _showDatePicker(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Calories summary card
          _buildCaloriesSummaryCard(context, totalCalories, targetCalories),

          const SizedBox(height: 24),

          // Macronutrients progress
          Text(
            'Macronutrients',
            style: theme.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold, fontSize: 22),
          ),

          const SizedBox(height: 16),

          // Macronutrient progress bars
          _buildMacronutrientProgressBars(context, totalProtein, totalCarbs,
              totalFat, targetProtein, targetCarbs, targetFat),

          const SizedBox(height: 24),

          // Meal logs section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Meal Logs',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              TextButton.icon(
                icon: const Icon(Icons.sort),
                label: const Text('Sort'),
                onPressed: () {
                  _showSortOptions(context);
                },
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Meal logs list
          filteredMealLogs.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredMealLogs.length,
                  itemBuilder: (context, index) {
                    return _buildEnhancedMealLogCard(
                        context, filteredMealLogs[index]);
                  },
                ),

          const SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    ).then((pickedDate) {
      if (pickedDate != null) {
        setState(() {
          selectedDate = pickedDate;
          selectedFilter = DateFormat('MMM d, yyyy').format(pickedDate);
        });
      }
    });
  }

  Widget _buildTrendsTab(BuildContext context,
      Map<String, double> weeklyCalories, List<MealLog> allMealLogs) {
    final theme = Theme.of(context);

    // Calculate macronutrient trends for the last 7 days
    Map<String, List<double>> macroTrends = _calculateMacroTrends(allMealLogs);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Calorie Intake',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 250,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
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
            child: weeklyCalories.isEmpty
                ? _buildEmptyChartState('No calorie data available')
                : _buildWeeklyCalorieChart(weeklyCalories),
          ),
          const SizedBox(height: 24),
          Text(
            'Macronutrient Trends',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 250,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
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
            child: macroTrends.isEmpty || macroTrends['days']!.isEmpty
                ? _buildEmptyChartState('No macronutrient data available')
                : _buildMacronutrientTrendsChart(macroTrends),
          ),
          const SizedBox(height: 24),
          Text(
            'Daily Distribution',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 250,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
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
            child: _buildMealTimeDistributionChart(allMealLogs),
          ),
          const SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }

  Widget _buildInsightsTab(BuildContext context,
      Map<String, double> mealDistribution, List<MealLog> mealLogs) {
    final theme = Theme.of(context);

    // Calculate most frequent foods
    Map<String, int> foodFrequency = {};
    for (var log in mealLogs) {
      if (foodFrequency.containsKey(log.meal.mealName)) {
        foodFrequency[log.meal.mealName] =
            (foodFrequency[log.meal.mealName] ?? 0) + 1;
      } else {
        foodFrequency[log.meal.mealName] = 1;
      }
    }

    // Sort by frequency
    var sortedFoods = foodFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Calculate nutrition insights
    Map<String, double> nutritionInsights =
        _calculateNutritionInsights(mealLogs);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Meal Type Distribution',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 250,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
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
            child: mealDistribution.isEmpty
                ? _buildEmptyChartState('No meal distribution data available')
                : _buildMealDistributionChart(mealDistribution),
          ),
          const SizedBox(height: 24),
          Text(
            'Most Frequent Foods',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          sortedFoods.isEmpty
              ? _buildEmptyChartState('No food frequency data available')
              : Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                  child: Column(
                    children: sortedFoods
                        .take(min(5, sortedFoods.length))
                        .map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color:
                                    theme.colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  '${entry.value}x',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                entry.key,
                                style: theme.textTheme.titleMedium,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
          const SizedBox(height: 24),
          Text(
            'Nutrition Tips',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildNutritionTipCard(
            context,
            'Balance Your Plate',
            'Aim to fill half your plate with vegetables, a quarter with protein, and a quarter with whole grains.',
            Icons.restaurant,
          ),
          const SizedBox(height: 12),
          _buildNutritionTipCard(
            context,
            'Stay Hydrated',
            'Drink at least 8 glasses of water daily to support metabolism and overall health.',
            Icons.water_drop,
          ),
          const SizedBox(height: 12),
          _buildNutritionTipCard(
            context,
            'Mindful Eating',
            'Take time to enjoy your food. Eating slowly helps with digestion and can prevent overeating.',
            Icons.psychology,
          ),
          const SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }

  Widget _buildEnhancedMealLogCard(BuildContext context, MealLog mealLog) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat('h:mm a');

    // Handle potential null or invalid image URL
    bool hasValidImage = mealLog.meal.image.isNotEmpty &&
        (mealLog.meal.image.startsWith('http') ||
            mealLog.meal.image.startsWith('https'));

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MealDetailScreen(meal: mealLog.meal),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Meal Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: hasValidImage
                    ? CachedNetworkImage(
                        imageUrl: mealLog.meal.image,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            _buildPlaceholderImage(theme),
                      )
                    : _buildPlaceholderImage(theme),
              ),
              const SizedBox(width: 16),
              // Meal Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Meal Name
                        Expanded(
                          child: Text(
                            mealLog.meal.mealName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Meal Time Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            mealLog.meal.mealTime,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Calories and Quantity
                    Row(
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          size: 16,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${((double.tryParse(mealLog.meal.calories) ?? 0) * (double.tryParse(mealLog.quantity) ?? 1)).toStringAsFixed(0)} cal',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.restaurant,
                          size: 16,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${mealLog.quantity} serving${double.parse(mealLog.quantity) != 1 ? "s" : ""}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Log Time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Logged at ${timeFormat.format(mealLog.logTime)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        // Delete button
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.red, size: 20),
                          onPressed: () {
                            _showDeleteConfirmation(context, mealLog);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage(ThemeData theme) {
    return Container(
      width: 80,
      height: 80,
      color: theme.colorScheme.primary.withOpacity(0.1),
      child: Icon(
        Icons.restaurant,
        color: theme.colorScheme.primary,
        size: 40,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.no_food,
              size: 80,
              color: Colors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'No meals logged for this date',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Meal'),
              onPressed: () {
                _showAddMealDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyChartState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart,
            size: 48,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCaloriesSummaryCard(
      BuildContext context, double totalCalories, double targetCalories) {
    final theme = Theme.of(context);
    final percentage = (totalCalories / targetCalories).clamp(0.0, 1.0);
    final remaining = targetCalories - totalCalories;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Calories',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        totalCalories.toStringAsFixed(0),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' / ${targetCalories.toStringAsFixed(0)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    remaining > 0
                        ? '${remaining.toStringAsFixed(0)} calories remaining'
                        : 'Daily target reached',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              CircularPercentIndicator(
                radius: 45.0,
                lineWidth: 10.0,
                percent: percentage,
                center: Text(
                  '${(percentage * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
                progressColor: Colors.white,
                backgroundColor: Colors.white.withOpacity(0.2),
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 10,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, double> _parseMacros(String macroString) {
    try {
      final decoded = jsonDecode(macroString);
      if (decoded is Map) {
        return decoded.map<String, double>((key, value) {
          if (value is num) {
            return MapEntry(key, value.toDouble());
          } else if (value is String) {
            return MapEntry(key, double.tryParse(value) ?? 0.0);
          }
          return MapEntry(key, 0.0);
        });
      }
    } catch (e) {
      print('Error parsing macronutrients: $e');
    }
    return {"protein": 0.0, "carbs": 0.0, "fat": 0.0};
  }
}

// Continuation of the MealLogsScreen class

Map<String, double> _parseMacros(String macroString) {
  try {
    final decoded = jsonDecode(macroString);
    if (decoded is Map) {
      return decoded.map<String, double>((key, value) {
        if (value is num) {
          return MapEntry(key, value.toDouble());
        } else if (value is String) {
          return MapEntry(key, double.tryParse(value) ?? 0.0);
        }
        return MapEntry(key, 0.0);
      });
    }
  } catch (e) {
    print('Error parsing macronutrients: $e');
  }
  return {"protein": 0.0, "carbs": 0.0, "fat": 0.0};
}

Map<String, double> _calculateWeeklyData(List<MealLog> mealLogs) {
  Map<String, double> weeklyData = {};
  final now = DateTime.now();

  for (int i = 6; i >= 0; i--) {
    final date = now.subtract(Duration(days: i));
    final dayName = DateFormat('E').format(date);
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);

    double dailyCalories = 0.0;
    for (var mealLog in mealLogs) {
      final logDate = DateFormat('yyyy-MM-dd').format(mealLog.logTime);
      if (logDate == formattedDate) {
        final calories = double.tryParse(mealLog.meal.calories) ?? 0.0;
        final quantity = double.tryParse(mealLog.quantity) ?? 1.0;
        dailyCalories += calories * quantity;
      }
    }

    weeklyData[dayName] = dailyCalories;
  }

  return weeklyData;
}

Map<String, List<double>> _calculateMacroTrends(List<MealLog> mealLogs) {
  Map<String, List<double>> trends = {
    'days': [],
    'protein': [],
    'carbs': [],
    'fat': []
  };

  if (mealLogs.isEmpty) return trends;

  final now = DateTime.now();

  for (int i = 6; i >= 0; i--) {
    final date = now.subtract(Duration(days: i));
    final dayName = DateFormat('E').format(date);
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);

    double dailyProtein = 0.0;
    double dailyCarbs = 0.0;
    double dailyFat = 0.0;

    for (var mealLog in mealLogs) {
      final logDate = DateFormat('yyyy-MM-dd').format(mealLog.logTime);
      if (logDate == formattedDate) {
        final macros = _parseMacros(mealLog.meal.macronutrients);
        final quantity = double.tryParse(mealLog.quantity) ?? 1.0;

        dailyProtein += (macros['protein'] ?? 0.0) * quantity;
        dailyCarbs += (macros['carbs'] ?? 0.0) * quantity;
        dailyFat += (macros['fat'] ?? 0.0) * quantity;
      }
    }

    trends['days']!.add(i.toDouble());
    trends['protein']!.add(dailyProtein);
    trends['carbs']!.add(dailyCarbs);
    trends['fat']!.add(dailyFat);
  }

  return trends;
}

Map<String, double> _calculateMealDistribution(List<MealLog> mealLogs) {
  Map<String, double> distribution = {};

  for (var mealLog in mealLogs) {
    final mealTime = mealLog.meal.mealTime;
    if (distribution.containsKey(mealTime)) {
      distribution[mealTime] = (distribution[mealTime] ?? 0.0) + 1.0;
    } else {
      distribution[mealTime] = 1.0;
    }
  }

  return distribution;
}

Map<String, double> _calculateNutritionInsights(List<MealLog> mealLogs) {
  if (mealLogs.isEmpty) {
    return {};
  }

  double totalProtein = 0.0;
  double totalCarbs = 0.0;
  double totalFat = 0.0;
  double totalCalories = 0.0;
  int totalDays = 0;

  // Get unique days
  Set<String> uniqueDays = {};

  for (var mealLog in mealLogs) {
    final logDate = DateFormat('yyyy-MM-dd').format(mealLog.logTime);
    uniqueDays.add(logDate);

    final macros = _parseMacros(mealLog.meal.macronutrients);
    final quantity = double.tryParse(mealLog.quantity) ?? 1.0;
    final calories = double.tryParse(mealLog.meal.calories) ?? 0.0;

    totalProtein += (macros['protein'] ?? 0.0) * quantity;
    totalCarbs += (macros['carbs'] ?? 0.0) * quantity;
    totalFat += (macros['fat'] ?? 0.0) * quantity;
    totalCalories += calories * quantity;
  }

  totalDays = uniqueDays.length;

  if (totalDays == 0) return {};

  // Calculate averages
  return {
    'avgCalories': totalCalories / totalDays,
    'avgProtein': totalProtein / totalDays,
    'avgCarbs': totalCarbs / totalDays,
    'avgFat': totalFat / totalDays,
  };
}

void _showAddMealDialog(BuildContext context) {
  // This would navigate to your meal selection screen
  // For now, we'll just show a placeholder dialog

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Add Meal Log'),
      content: const Text(
          'This would open a meal selection screen to add a meal log'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

void _showDeleteConfirmation(BuildContext context, MealLog mealLog) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Meal Log'),
      content:
          Text('Are you sure you want to delete "${mealLog.meal.mealName}"?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Here you would call the delete function
            final provider = context.read<DietProvider>();
            provider.deleteMealLog(mealLog.mealLogId);

            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
          ),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}

void _showSortOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Sort By',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('Time (Latest First)'),
            onTap: () {
              // Implement sorting
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('Time (Earliest First)'),
            onTap: () {
              // Implement sorting
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_fire_department),
            title: const Text('Calories (Highest First)'),
            onTap: () {
              // Implement sorting
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_fire_department),
            title: const Text('Calories (Lowest First)'),
            onTap: () {
              // Implement sorting
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ),
  );
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverAppBarDelegate(this.tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}

Widget _buildMacronutrientProgressBars(
    BuildContext context,
    double totalProtein,
    double totalCarbs,
    double totalFat,
    double targetProtein,
    double targetCarbs,
    double targetFat) {
  final theme = Theme.of(context);

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
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
    child: Column(
      children: [
        _buildMacroProgressBar(
            context, 'Protein', totalProtein, targetProtein, Colors.blue),
        const SizedBox(height: 16),
        _buildMacroProgressBar(
            context, 'Carbs', totalCarbs, targetCarbs, Colors.orange),
        const SizedBox(height: 16),
        _buildMacroProgressBar(
            context, 'Fat', totalFat, targetFat, Colors.green),
      ],
    ),
  );
}

Widget _buildMacroProgressBar(BuildContext context, String label, double value,
    double target, Color color) {
  final theme = Theme.of(context);
  final percentage = (value / target).clamp(0.0, 1.0);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${value.toStringAsFixed(1)}g / ${target.toStringAsFixed(0)}g',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
      const SizedBox(height: 8),
      Stack(
        children: [
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          FractionallySizedBox(
            widthFactor: percentage,
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget _buildWeeklyCalorieChart(Map<String, double> weeklyCalories) {
  List<String> days = weeklyCalories.keys.toList();

  return BarChart(
    BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: weeklyCalories.values.isEmpty
          ? 2000
          : (weeklyCalories.values.reduce((a, b) => a > b ? a : b) * 1.2),
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              '${rod.toY.round()} cal',
              const TextStyle(
                color: Colors.white,
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
              if (value.toInt() >= 0 && value.toInt() < days.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    days[value.toInt()],
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
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
            getTitlesWidget: (value, meta) {
              if (value % 500 == 0) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                color: Colors.blue,
                width: 20,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: 2000, // Or your target daily calories
                  color: Colors.grey.withOpacity(0.1),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}

Widget _buildMacronutrientTrendsChart(Map<String, List<double>> macroTrends) {
  final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  return LineChart(
    LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: const LineTouchTooltipData(),
        touchCallback:
            (FlTouchEvent event, LineTouchResponse? touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 20,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(0.2),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double value, TitleMeta meta) {
              final index = value.toInt();
              if (index >= 0 && index < days.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    days[index],
                    style: const TextStyle(
                      color: Color(0xff7589a2),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                );
              }
              return const Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 20,
            getTitlesWidget: (double value, TitleMeta meta) {
              return Text(
                value.toInt().toString(),
                style: const TextStyle(
                  color: Color(0xff7589a2),
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              );
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
        border: Border.all(color: const Color(0xff37434d), width: 1),
      ),
      minX: 0,
      maxX: macroTrends['days']!.length - 1.0,
      minY: 0,
      maxY: macroTrends['protein']!.isEmpty
          ? 100
          : (macroTrends['protein']!.reduce((a, b) => a > b ? a : b) * 1.2),
      lineBarsData: [
        // Protein Line
        LineChartBarData(
          spots: List.generate(macroTrends['protein']!.length, (index) {
            return FlSpot(index.toDouble(), macroTrends['protein']![index]);
          }),
          isCurved: true,
          color: Colors.blue,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
        // Carbs Line
        LineChartBarData(
          spots: List.generate(macroTrends['carbs']!.length, (index) {
            return FlSpot(index.toDouble(), macroTrends['carbs']![index]);
          }),
          isCurved: true,
          color: Colors.orange,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
        // Fat Line
        LineChartBarData(
          spots: List.generate(macroTrends['fat']!.length, (index) {
            return FlSpot(index.toDouble(), macroTrends['fat']![index]);
          }),
          isCurved: true,
          color: Colors.green,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      ],
    ),
  );
}

Widget _buildMealTimeDistributionChart(List<MealLog> mealLogs) {
  // Count meals by time of day
  final Map<int, int> mealsByHour = {};

  for (var mealLog in mealLogs) {
    final hour = mealLog.logTime.hour;
    mealsByHour[hour] = (mealsByHour[hour] ?? 0) + 1;
  }

  // Create spots for the chart
  final List<FlSpot> spots = [];
  for (int hour = 0; hour < 24; hour++) {
    spots.add(FlSpot(hour.toDouble(), (mealsByHour[hour] ?? 0).toDouble()));
  }

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
                '$formattedHour: ${spot.y.toInt()} meals',
                const TextStyle(color: Colors.white),
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
            color: Colors.grey.withOpacity(0.2),
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
                style: const TextStyle(
                  color: Color(0xff7589a2),
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
                  style: const TextStyle(
                    color: Color(0xff7589a2),
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                );
              }
              return const Text('');
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
        border: Border.all(color: const Color(0xff37434d), width: 1),
      ),
      minX: 0,
      maxX: 23,
      minY: 0,
      maxY: mealsByHour.isEmpty
          ? 5
          : (mealsByHour.values.reduce((a, b) => a > b ? a : b) + 1).toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: Colors.purple,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            color: Colors.purple.withOpacity(0.2),
          ),
        ),
      ],
    ),
  );
}

Widget _buildMealDistributionChart(Map<String, double> mealDistribution) {
  if (mealDistribution.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pie_chart,
            size: 48,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No meal distribution data available',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  final total = mealDistribution.values.reduce((a, b) => a + b);

  // Create colors for each meal type
  final colors = [
    Colors.blue,
    Colors.orange,
    Colors.green,
    Colors.purple,
    Colors.red,
    Colors.amber,
    Colors.teal,
  ];

  return PieChart(
    PieChartData(
      borderData: FlBorderData(show: false),
      sectionsSpace: 2,
      centerSpaceRadius: 40,
      sections: List.generate(mealDistribution.length, (index) {
        final entry = mealDistribution.entries.elementAt(index);
        final percentage = (entry.value / total * 100).toStringAsFixed(1);

        return PieChartSectionData(
          color: index < colors.length ? colors[index] : Colors.grey,
          value: entry.value,
          title: '$percentage%',
          radius: 100,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      }),
    ),
  );
}

Widget _buildNutritionTipCard(
  BuildContext context,
  String title,
  String description,
  IconData icon,
) {
  final theme = Theme.of(context);

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Helper function to get the minimum of two numbers
int min(int a, int b) {
  return a < b ? a : b;
}
