import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/models/deit_plan_models/meal_model.dart';
import 'package:gymify/providers/diet_provider/diet_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class MealDetailScreen extends StatelessWidget {
  final Meal meal;

  const MealDetailScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<DietProvider>(context,
        listen: false); // Access the provider

    // Parse macronutrients JSON
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

    return Scaffold(
      appBar: CustomAppBar(title: meal.mealName),
      body: ListView(
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
                    height: 300,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Meal name
                Text(
                  meal.mealName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Full description
                Text(
                  meal.description,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 16),

                // Macronutrient Chart
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    PieChart(
                      dataMap: dataMap,
                      animationDuration: const Duration(milliseconds: 800),
                      chartRadius: 80,
                      chartType: ChartType.ring,
                      ringStrokeWidth: 16,
                      colorList: colorList,
                      legendOptions: const LegendOptions(
                        showLegendsInRow: false,
                        legendPosition: LegendPosition.bottom,
                        showLegends: false,
                        legendShape: BoxShape.circle,
                        legendTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      chartValuesOptions: const ChartValuesOptions(
                        showChartValues: false,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Macronutrient Indicators
                    Column(
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
                    )
                  ],
                ),

                // Log Meal Button
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    // Log the meal
                    provider.logMeal(
                      mealId: meal.mealId,
                      quantity:
                          1, // Set quantity as needed, you can make this dynamic if required
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Meal logged successfully!')),
                    );
                  },
                  child: const Text('Log Meal'),
                  // child: const Row(
                  //   children: [
                  //     Icon(
                  //       FontAwesomeIcons.kitchenSet,
                  //       color: Colors.white,
                  //     ),
                  //   ],
                  // ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Log the meal
                    context.pushNamed('mealLog');
                  },
                  child: const Text('View Logs'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper to parse JSON string for macronutrients
  Map<String, double> _parseMacros(String macroString) {
    try {
      final decoded = jsonDecode(macroString);
      if (decoded is Map) {
        return decoded.map<String, double>((key, value) {
          return MapEntry(key, (value as num).toDouble());
        });
      }
    } catch (e) {
      print('Error parsing macronutrients: $e');
    }
    return {"protein": 0.0, "carbs": 0.0, "fat": 0.0};
  }
}

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
