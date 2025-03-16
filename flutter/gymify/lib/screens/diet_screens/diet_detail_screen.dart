// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:gymify/models/deit_plan_models/diet_plan_model.dart';
// import 'package:gymify/models/deit_plan_models/meal_model.dart';
// import 'package:gymify/utils/custom_appbar.dart';

// class DietDetailScreen extends StatelessWidget {
//   final DietPlan dietPlan;

//   const DietDetailScreen({super.key, required this.dietPlan});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: CustomAppBar(
//         title: dietPlan.name,
//         showBackButton: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             // Diet Plan Image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: CachedNetworkImage(
//                 imageUrl: dietPlan.image,
//                 width: double.infinity,
//                 height: 200,
//                 fit: BoxFit.cover,
//                 placeholder: (context, url) => const Center(
//                   child: CircularProgressIndicator(),
//                 ),
//                 errorWidget: (context, url, error) => const Icon(Icons.error),
//               ),
//             ),
//             // Diet Plan Details Section
//             Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 4,
//               margin: const EdgeInsets.only(bottom: 16),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(Icons.flag, color: theme.colorScheme.primary),
//                         const SizedBox(width: 8),
//                         Text(
//                           'Goal Type: ${dietPlan.goalType}',
//                           style: theme.textTheme.bodyLarge?.copyWith(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         Icon(Icons.access_alarm,
//                             color: theme.colorScheme.primary),
//                         const SizedBox(width: 8),
//                         Text(
//                           'Calorie Goal: ${dietPlan.calorieGoal} kcal',
//                           style: theme.textTheme.bodyLarge?.copyWith(
//                             color: theme.colorScheme.onSurface.withOpacity(0.7),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Description:',
//                       style: theme.textTheme.bodyLarge?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       dietPlan.description,
//                       style: theme.textTheme.bodyMedium?.copyWith(
//                         color: theme.colorScheme.onSurface.withOpacity(0.7),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // Meals Section
//             Text(
//               'Meals',
//               style: theme.textTheme.headlineSmall?.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 12),
//             ...dietPlan.meals.map((meal) {
//               return MealCard(meal: meal, theme: theme);
//             }),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MealCard extends StatelessWidget {
//   final Meal meal;
//   final ThemeData theme;

//   const MealCard({super.key, required this.meal, required this.theme});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       elevation: 2,
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Show the meal image if available
//             if (meal.image.isNotEmpty)
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.network(
//                   meal.image, // Assuming meal.image contains the image URL
//                   width: double.infinity,
//                   height: 200,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             const SizedBox(height: 16), // Space after the image
//             Text(
//               meal.mealName,
//               style: theme.textTheme.headlineSmall?.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Icon(Icons.access_time, color: theme.colorScheme.primary),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Meal Time: ${meal.mealTime}',
//                   style: theme.textTheme.bodyMedium?.copyWith(
//                     color: theme.colorScheme.onSurface.withOpacity(0.7),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Icon(Icons.restaurant, color: theme.colorScheme.primary),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Calories: ${meal.calories} kcal',
//                   style: theme.textTheme.bodyMedium?.copyWith(
//                     color: theme.colorScheme.onSurface.withOpacity(0.7),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Macronutrients: ${meal.macronutrients}',
//               style: theme.textTheme.bodyMedium?.copyWith(
//                 color: theme.colorScheme.onSurface.withOpacity(0.7),
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               'Description:',
//               style: theme.textTheme.bodyLarge?.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               meal.description,
//               style: theme.textTheme.bodySmall?.copyWith(
//                 color: theme.colorScheme.onSurface.withOpacity(0.7),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart'; // For the macronutrient chart
import 'package:gymify/models/deit_plan_models/diet_plan_model.dart';
import 'package:gymify/models/deit_plan_models/meal_model.dart';
import 'package:gymify/utils/custom_appbar.dart';

class DietDetailScreen extends StatelessWidget {
  final DietPlan dietPlan;

  const DietDetailScreen({super.key, required this.dietPlan});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Pre-filter meals by meal time
    final allMeals = dietPlan.meals;
    final breakfastMeals =
        allMeals.where((m) => m.mealTime.toLowerCase() == 'breakfast').toList();
    final lunchMeals =
        allMeals.where((m) => m.mealTime.toLowerCase() == 'lunch').toList();
    final dinnerMeals =
        allMeals.where((m) => m.mealTime.toLowerCase() == 'dinner').toList();
    final snackMeals =
        allMeals.where((m) => m.mealTime.toLowerCase() == 'snack').toList();

    return DefaultTabController(
      length: 5, // 5 tabs: All Meals, Breakfast, Lunch, Dinner, Snack
      child: Scaffold(
        appBar: CustomAppBar(
          title: dietPlan.name,
          showBackButton: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PLAN DETAILS CARD
              PlanDetailsCard(
                badgeText: 'Nutritionally Balanced',
                planTitle: dietPlan.name,
                description: dietPlan.description,
                totalMeals: dietPlan.meals.length,
                calorieGoal: dietPlan.calorieGoal,
                goalType: dietPlan.goalType,
                createdBy: 'Professional Nutritionist',
                circleImageUrl: dietPlan.image, // or a valid network URL
              ),
              const SizedBox(height: 24),
              // TAB BAR
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: theme.colorScheme.onSurface,
                  isScrollable: true,
                  indicatorAnimation: TabIndicatorAnimation.elastic,
                  tabs: [
                    Tab(text: 'All Meals (${allMeals.length})'),
                    Tab(text: 'Breakfast (${breakfastMeals.length})'),
                    Tab(text: 'Lunch (${lunchMeals.length})'),
                    Tab(text: 'Dinner (${dinnerMeals.length})'),
                    Tab(text: 'Snack (${snackMeals.length})'),
                  ],
                ),
              ),

              // TAB BAR VIEW
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: SizedBox(
                  // Provide a fixed height so the TabBarView doesn't expand infinitely
                  height: 800,
                  child: TabBarView(
                    children: [
                      MealsList(meals: allMeals),
                      MealsList(meals: breakfastMeals),
                      MealsList(meals: lunchMeals),
                      MealsList(meals: dinnerMeals),
                      MealsList(meals: snackMeals),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// LIST OF MEALS FOR A GIVEN TAB
class MealsList extends StatelessWidget {
  final List<Meal> meals;

  const MealsList({super.key, required this.meals});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // If no meals for this tab, show a friendly message
    if (meals.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: Text(
            'No meals available for this category',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ),
      );
    }

    // Otherwise, list the meals
    return ListView.builder(
      // physics: const NeverScrollableScrollPhysics(),
      itemCount: meals.length,
      itemBuilder: (context, index) {
        return MealCard(meal: meals[index]);
      },
    );
  }
}

// A single MEAL CARD with ring chart for macros
class MealCard extends StatelessWidget {
  final Meal meal;

  const MealCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Parse macronutrients JSON: {"protein":23.0,"carbs":23.0,"fat":12.0}
    final macroMap = _parseMacros(meal.macronutrients);
    final protein = macroMap['protein'] ?? 0.0;
    final carbs = macroMap['carbs'] ?? 0.0;
    final fat = macroMap['fat'] ?? 0.0;

    // Prepare data for PieChart
    final dataMap = {
      "Protein": protein,
      "Carbs": carbs,
      "Fat": fat,
    };

    // Colors for the chart segments
    final colorList = <Color>[
      Colors.blue, // Protein
      Colors.orange, // Carbs
      Colors.green, // Fat
    ];

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE with top-left and top-right badges
          Stack(
            children: [
              if (meal.image.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: meal.image,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              // Meal Time Badge (top-left)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    meal.mealTime,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Calories Badge (top-right)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${meal.calories} kcal',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // CONTENT
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Meal name
                Text(
                  meal.mealName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Short description or subheading (optional)
                Text(
                  _shortDescription(meal.description),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 16),

                // Macronutrient Chart
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: PieChart(
                        dataMap: dataMap,
                        animationDuration: const Duration(milliseconds: 800),
                        chartRadius: 80,
                        chartType: ChartType.ring,
                        ringStrokeWidth: 16,
                        colorList: colorList,
                        legendOptions: const LegendOptions(
                          showLegendsInRow: false,
                          legendPosition: LegendPosition.bottom,
                          showLegends: true,
                          legendShape: BoxShape.circle,
                          legendTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValues:
                              false, // Hide numeric values on chart
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _MacroIndicator(
                            color: Colors.blue,
                            label: 'Protein',
                            amount: protein,
                          ),
                          _MacroIndicator(
                            color: Colors.orange,
                            label: 'Carbs',
                            amount: carbs,
                          ),
                          _MacroIndicator(
                            color: Colors.green,
                            label: 'Fat',
                            amount: fat,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Full meal description
                Text(
                  meal.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper to parse JSON string for macronutrients
  Map<String, double> _parseMacros(String macroString) {
    // Expected format: {"protein":23.0,"carbs":23.0,"fat":12.0}
    try {
      final decoded = jsonDecode(macroString);
      // Make sure it's a Map<String, dynamic>
      if (decoded is Map) {
        return decoded.map<String, double>((key, value) {
          // Ensure numeric cast
          return MapEntry(key, (value as num).toDouble());
        });
      }
    } catch (e) {
      // ignore or log error
    }
    // Fallback if parsing fails
    return {"protein": 0.0, "carbs": 0.0, "fat": 0.0};
  }

  // Show only the first line of the description (like a preview)
  String _shortDescription(String fullDesc) {
    final lines = fullDesc.split('\n');
    return lines.isNotEmpty ? lines.first : fullDesc;
  }
}

// Shows a color dot + macro label + numeric amount
class _MacroIndicator extends StatelessWidget {
  final Color color;
  final String label;
  final double amount;

  const _MacroIndicator({
    required this.color,
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // If you want to hide "0.0 g" when it's truly zero, you can do:
    // if (amount <= 0) return SizedBox.shrink();

    // Decide how many decimals to show. For instance:
    final showDecimals = (amount % 1 != 0); // true if not a whole number
    final displayAmount =
        showDecimals ? amount.toStringAsFixed(1) : amount.toStringAsFixed(0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          // Color indicator dot
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
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$displayAmount g',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class PlanDetailsCard extends StatelessWidget {
  final String badgeText; // e.g. 'Nutritionally Balanced'
  final String planTitle; // e.g. 'Summer Fitness Plan'
  final String description; // e.g. 'A balanced plan...'
  final int totalMeals; // e.g. dietPlan.meals.length
  final String calorieGoal; // e.g. dietPlan.calorieGoal
  final String goalType; // e.g. dietPlan.goalType
  final String createdBy; // e.g. 'Professional Nutritionist'
  final String circleImageUrl; // e.g. dietPlan.image or asset

  const PlanDetailsCard({
    super.key,
    required this.badgeText,
    required this.planTitle,
    required this.description,
    required this.totalMeals,
    required this.calorieGoal,
    required this.goalType,
    required this.createdBy,
    required this.circleImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        // We no longer need a Stack here if we want the circle image centered
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badgeText,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // const SizedBox(height: 24),
            Text(
              planTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Circular image (centered) + "Created by"
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  // Circle image
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.surface,
                        width: 3,
                      ),
                      image: DecorationImage(
                        image: circleImageUrl.startsWith('http')
                            ? NetworkImage(circleImageUrl)
                            : AssetImage(circleImageUrl) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Created by $createdBy',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Main Title

            // Description
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),

            // Stats Row: total meals, calorie goal, goal type
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoColumn(
                  title: 'Total Meals',
                  value: '$totalMeals',
                  theme: theme,
                ),
                _InfoColumn(
                  title: 'Calorie Goal',
                  value: '$calorieGoal kcal',
                  theme: theme,
                ),
                _InfoColumn(
                  title: 'Goal Type',
                  value: goalType,
                  theme: theme,
                ),
              ],
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// A small widget to display label + value for each stat
class _InfoColumn extends StatelessWidget {
  final String title;
  final String value;
  final ThemeData theme;

  const _InfoColumn({
    required this.title,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// import 'dart:convert';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:pie_chart/pie_chart.dart'; // For the macronutrient chart
// import 'package:gymify/models/deit_plan_models/diet_plan_model.dart';
// import 'package:gymify/models/deit_plan_models/meal_model.dart';
// import 'package:gymify/utils/custom_appbar.dart';

// class DietDetailScreen extends StatelessWidget {
//   final DietPlan dietPlan;

//   const DietDetailScreen({super.key, required this.dietPlan});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     // Pre-filter meals by meal time
//     final allMeals = dietPlan.meals;
//     final breakfastMeals =
//         allMeals.where((m) => m.mealTime.toLowerCase() == 'breakfast').toList();
//     final lunchMeals =
//         allMeals.where((m) => m.mealTime.toLowerCase() == 'lunch').toList();
//     final dinnerMeals =
//         allMeals.where((m) => m.mealTime.toLowerCase() == 'dinner').toList();
//     final snackMeals =
//         allMeals.where((m) => m.mealTime.toLowerCase() == 'snack').toList();

//     return DefaultTabController(
//       // 5 tabs: All Meals, Breakfast, Lunch, Dinner, Snack
//       length: 5,
//       child: Scaffold(
//         appBar: CustomAppBar(
//           title: dietPlan.name,
//           showBackButton: true,
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // TOP HERO / BANNER SECTION
//               Stack(
//                 children: [
//                   // Background Image
//                   ClipRRect(
//                     borderRadius: const BorderRadius.only(
//                       bottomLeft: Radius.circular(24),
//                       bottomRight: Radius.circular(24),
//                     ),
//                     child: CachedNetworkImage(
//                       imageUrl: dietPlan.image,
//                       width: double.infinity,
//                       height: 250,
//                       fit: BoxFit.cover,
//                       placeholder: (context, url) => const Center(
//                         child: CircularProgressIndicator(),
//                       ),
//                       errorWidget: (context, url, error) =>
//                           const Icon(Icons.error),
//                     ),
//                   ),
//                   // Semi-transparent overlay for text contrast
//                   Positioned.fill(
//                     child: Container(
//                       color: Colors.black.withOpacity(0.2),
//                     ),
//                   ),
//                   // Title and small "tag" near the bottom
//                   Positioned(
//                     bottom: 16,
//                     left: 16,
//                     right: 16,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // A small badge/tag
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 4),
//                           decoration: BoxDecoration(
//                             // color: theme.colorScheme.primary.withOpacity(0.9),
//                             color: Colors.green,
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Text(
//                             'Nutritionally Balanced',
//                             style: theme.textTheme.bodySmall?.copyWith(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         // Diet Plan Title
//                         Text(
//                           dietPlan.name,
//                           style: theme.textTheme.headlineSmall?.copyWith(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 16),
//               PlanDetailsCard(
//                 badgeText: 'Nutritionally Balanced',
//                 planTitle: dietPlan.name,
//                 description: dietPlan.description,
//                 totalMeals: dietPlan.meals.length,
//                 calorieGoal: dietPlan.calorieGoal,
//                 goalType: dietPlan.goalType,
//                 createdBy: 'Professional Nutritionist',
//                 circleImageUrl: dietPlan.image, // or a valid network URL
//               ),

//               const SizedBox(height: 24),
//               // TAB BAR
//               Container(
//                 // Add a bit of styling to the TabBar
//                 decoration: BoxDecoration(
//                   color: theme.colorScheme.surface,
//                   borderRadius: BorderRadius.circular(24),
//                 ),
//                 child: TabBar(
//                   indicatorSize: TabBarIndicatorSize.tab,
//                   dividerColor: Colors.transparent,
//                   indicator: const BoxDecoration(
//                     color: Colors.green,
//                     borderRadius: BorderRadius.all(Radius.circular(10)),
//                   ),
//                   labelColor: Colors.white,
//                   unselectedLabelColor: Colors.black54,
//                   isScrollable: true,
//                   tabs: [
//                     Tab(text: 'All Meals ${allMeals.length}'),
//                     Tab(text: 'Breakfast ${breakfastMeals.length} '),
//                     Tab(text: 'Lunch ${lunchMeals.length}'),
//                     Tab(text: 'Dinner ${dinnerMeals.length}'),
//                     Tab(text: 'Snack ${snackMeals.length}'),
//                   ],
//                 ),
//               ),

//               // TAB BAR VIEW
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                 child: SizedBox(
//                   // Provide a fixed height so the TabBarView doesn't expand infinitely
//                   height: 800,
//                   child: TabBarView(
//                     children: [
//                       MealsList(meals: allMeals),
//                       MealsList(meals: breakfastMeals),
//                       MealsList(meals: lunchMeals),
//                       MealsList(meals: dinnerMeals),
//                       MealsList(meals: snackMeals),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // A small reusable widget for showing stats inside the details card
// class _StatItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String value;
//   final ThemeData theme;

//   const _StatItem({
//     required this.icon,
//     required this.label,
//     required this.value,
//     required this.theme,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(icon, color: theme.colorScheme.primary),
//         const SizedBox(width: 8),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               label,
//               style: theme.textTheme.bodySmall?.copyWith(
//                 color: theme.colorScheme.onSurface.withOpacity(0.6),
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               value,
//               style: theme.textTheme.bodyLarge?.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// // LIST OF MEALS FOR A GIVEN TAB
// class MealsList extends StatelessWidget {
//   final List<Meal> meals;

//   const MealsList({super.key, required this.meals});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     // If no meals for this tab, show a friendly message
//     if (meals.isEmpty) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.only(top: 32.0),
//           child: Text(
//             'No meals available for this category',
//             style: theme.textTheme.bodyMedium?.copyWith(
//               color: theme.colorScheme.onSurface.withOpacity(0.7),
//             ),
//           ),
//         ),
//       );
//     }

//     // Otherwise, list the meals
//     return ListView.builder(
//       // Prevent internal scrolling conflicts with the main SingleChildScrollView
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: meals.length,
//       itemBuilder: (context, index) {
//         return MealCard(meal: meals[index]);
//       },
//     );
//   }
// }

// // A single MEAL CARD with ring chart for macros
// class MealCard extends StatelessWidget {
//   final Meal meal;

//   const MealCard({super.key, required this.meal});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     // Parse macronutrients JSON: {"protein":23.0,"carbs":23.0,"fat":12.0}
//     final macroMap = _parseMacros(meal.macronutrients);
//     final protein = macroMap['protein'] ?? 0.0;
//     final carbs = macroMap['carbs'] ?? 0.0;
//     final fat = macroMap['fat'] ?? 0.0;

//     // Prepare data for PieChart
//     final dataMap = {
//       "Protein": protein,
//       "Carbs": carbs,
//       "Fat": fat,
//     };

//     // Colors for the chart segments
//     final colorList = <Color>[
//       Colors.blue, // Protein
//       Colors.orange, // Carbs
//       Colors.green, // Fat
//     ];

//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       elevation: 2,
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // IMAGE with top-left and top-right badges
//           Stack(
//             children: [
//               if (meal.image.isNotEmpty)
//                 ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(12),
//                     topRight: Radius.circular(12),
//                   ),
//                   child: CachedNetworkImage(
//                     imageUrl: meal.image,
//                     width: double.infinity,
//                     height: 200,
//                     fit: BoxFit.cover,
//                     placeholder: (context, url) =>
//                         const Center(child: CircularProgressIndicator()),
//                     errorWidget: (context, url, error) =>
//                         const Icon(Icons.error),
//                   ),
//                 ),
//               // Meal Time Badge (top-left)
//               Positioned(
//                 top: 8,
//                 left: 8,
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: theme.colorScheme.primary,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     meal.mealTime,
//                     style: theme.textTheme.bodySmall?.copyWith(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               // Calories Badge (top-right)
//               Positioned(
//                 top: 8,
//                 right: 8,
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.6),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(
//                         Icons.local_fire_department,
//                         color: Colors.white,
//                         size: 16,
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         '${meal.calories} kcal',
//                         style: theme.textTheme.bodySmall?.copyWith(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           // CONTENT
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Meal name
//                 Text(
//                   meal.mealName,
//                   style: theme.textTheme.titleMedium?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 // Short description or subheading (optional)
//                 Text(
//                   _shortDescription(meal.description),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: theme.textTheme.bodyMedium?.copyWith(
//                     color: theme.colorScheme.onSurface.withOpacity(0.7),
//                   ),
//                 ),
//                 const SizedBox(height: 16),

//                 // Macronutrient Chart
//                 Row(
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: PieChart(
//                         dataMap: dataMap,
//                         animationDuration: const Duration(milliseconds: 800),
//                         chartRadius: 80,
//                         chartType: ChartType.ring,
//                         ringStrokeWidth: 16,
//                         colorList: colorList,
//                         legendOptions: const LegendOptions(
//                           showLegendsInRow: false,
//                           legendPosition: LegendPosition.bottom,
//                           showLegends: true,
//                           legendShape: BoxShape.circle,
//                           legendTextStyle: TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         chartValuesOptions: const ChartValuesOptions(
//                           showChartValues:
//                               false, // Hide numeric values on the chart
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       flex: 3,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _MacroIndicator(
//                             color: Colors.blue,
//                             label: 'Protein',
//                             amount: protein,
//                           ),
//                           _MacroIndicator(
//                             color: Colors.orange,
//                             label: 'Carbs',
//                             amount: carbs,
//                           ),
//                           _MacroIndicator(
//                             color: Colors.green,
//                             label: 'Fat',
//                             amount: fat,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),

//                 // Full meal description
//                 Text(
//                   meal.description,
//                   style: theme.textTheme.bodySmall?.copyWith(
//                     color: theme.colorScheme.onSurface.withOpacity(0.7),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper to parse JSON string for macronutrients
//   Map<String, double> _parseMacros(String macroString) {
//     try {
//       print(macroString);
//       final decoded = jsonDecode(macroString);
//       print(decoded);
//       // Convert each key-value to <String, double>
//       return decoded.map<String, double>((key, value) {
//         return MapEntry(key, (value as num).toDouble());
//       });
//     } catch (e) {
//       return {"protein": 0.0, "carbs": 0.0, "fat": 0.0};
//     }
//   }

//   // Show only the first line of the description (like a preview)
//   String _shortDescription(String fullDesc) {
//     final lines = fullDesc.split('\n');
//     return lines.isNotEmpty ? lines.first : fullDesc;
//   }
// }

// // Shows a color dot + macro label + numeric amount
// class _MacroIndicator extends StatelessWidget {
//   final Color color;
//   final String label;
//   final double amount;

//   const _MacroIndicator({
//     required this.color,
//     required this.label,
//     required this.amount,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8.0),
//       child: Row(
//         children: [
//           // Color indicator dot
//           Container(
//             width: 12,
//             height: 12,
//             decoration: BoxDecoration(
//               color: color,
//               shape: BoxShape.circle,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Text(
//             label,
//             style: theme.textTheme.bodyMedium?.copyWith(
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Text(
//             '${amount.toStringAsFixed(1)} g',
//             style: theme.textTheme.bodyMedium?.copyWith(
//               color: theme.colorScheme.onSurface.withOpacity(0.7),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class PlanDetailsCard extends StatelessWidget {
//   final String badgeText; // e.g. 'Nutritionally Balanced'
//   final String planTitle; // e.g. 'Summer Fitness Plan'
//   final String description; // e.g. 'A balanced plan ...'
//   final int totalMeals; // e.g. dietPlan.meals.length
//   final String calorieGoal; // e.g. dietPlan.calorieGoal
//   final String goalType; // e.g. dietPlan.goalType
//   final String createdBy; // e.g. 'Professional Nutritionist'
//   final String
//       circleImageUrl; // e.g. 'assets/images/plate.jpg' or network image

//   const PlanDetailsCard({
//     super.key,
//     required this.badgeText,
//     required this.planTitle,
//     required this.description,
//     required this.totalMeals,
//     required this.calorieGoal,
//     required this.goalType,
//     required this.createdBy,
//     required this.circleImageUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       elevation: 4,
//       child: Container(
//         // Optional: a subtle gradient background for a polished look
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           // Stack so we can overlap the circular image on the right
//           child: Stack(
//             clipBehavior: Clip.none,
//             children: [
//               // MAIN CONTENT
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Top badge
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: theme.colorScheme.primary.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Text(
//                       badgeText,
//                       style: theme.textTheme.bodySmall?.copyWith(
//                         color: theme.colorScheme.primary,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 8),

//                   // Main Title
//                   Text(
//                     planTitle,
//                     style: theme.textTheme.headlineSmall?.copyWith(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),

//                   // Description
//                   Text(
//                     description,
//                     style: theme.textTheme.bodyMedium?.copyWith(
//                       color: theme.colorScheme.onSurface.withOpacity(0.7),
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   // Stats Row: total meals, calorie goal, goal type
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       _InfoColumn(
//                         title: 'Total Meals',
//                         value: '$totalMeals',
//                         theme: theme,
//                       ),
//                       _InfoColumn(
//                         title: 'Calorie Goal',
//                         value: '$calorieGoal kcal',
//                         theme: theme,
//                       ),
//                       _InfoColumn(
//                         title: 'Goal Type',
//                         value: goalType,
//                         theme: theme,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                       height: 30), // extra space to accommodate image

//                   // imagge and created by
//                   // Circular image + "Created by"
//                   Align(
//                     alignment: Alignment.center,
//                     child: Container(
//                       width: 200,
//                       height: 200,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: theme.colorScheme.surface,
//                           width: 2,
//                         ),
//                         image: DecorationImage(
//                           image: circleImageUrl.startsWith('http')
//                               ? NetworkImage(circleImageUrl)
//                               : AssetImage(circleImageUrl) as ImageProvider,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // A small widget to display label + value for each stat
// class _InfoColumn extends StatelessWidget {
//   final String title;
//   final String value;
//   final ThemeData theme;

//   const _InfoColumn({
//     required this.title,
//     required this.value,
//     required this.theme,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: theme.textTheme.bodySmall?.copyWith(
//             color: theme.colorScheme.onSurface.withOpacity(0.6),
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: theme.textTheme.titleMedium?.copyWith(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }
// }
