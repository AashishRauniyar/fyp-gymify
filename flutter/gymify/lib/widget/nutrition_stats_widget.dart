import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gymify/providers/profile_provider/profile_provider.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:gymify/models/diet_log_models/meal_logs_model.dart';
import 'package:gymify/providers/diet_provider/diet_provider.dart';

class NutritionStatsWidget extends StatelessWidget {
  const NutritionStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DietProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return _buildLoadingState(context);
        }

        if (provider.hasError) {
          return _buildErrorState(context);
        }

        if (provider.mealLogs.isEmpty) {
          return _buildEmptyState(context);
        }

        // Get today's date in the format 'yyyy-MM-dd'
        String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

        // Filter the meals based on today's date
        List<MealLog> todayMealLogs = provider.mealLogs.where((mealLog) {
          String logDate = DateFormat('yyyy-MM-dd').format(mealLog.logTime);
          return logDate == formattedDate;
        }).toList();

        // Calculate total macros for today
        double totalProtein = 0.0,
            totalCarbs = 0.0,
            totalFat = 0.0,
            totalCalories = 0.0;

        for (var mealLog in todayMealLogs) {
          final macros = _parseMacros(mealLog.meal.macronutrients);
          final quantity = double.tryParse(mealLog.quantity) ?? 1.0;

          totalProtein += (macros['protein'] ?? 0.0) * quantity;
          totalCarbs += (macros['carbs'] ?? 0.0) * quantity;
          totalFat += (macros['fat'] ?? 0.0) * quantity;
          totalCalories +=
              (double.tryParse(mealLog.meal.calories) ?? 0.0) * quantity;
        }

        // Target values (could be fetched from user settings in the future)

        final String? calorieGoals =
            context.read<ProfileProvider>().user?.calorieGoals;

        double targetCalories =
            double.tryParse(calorieGoals ?? '2000') ?? 2000.0;
        // double targetCalories = 2000.0;
        double percentage = (totalCalories / targetCalories).clamp(0.0, 1.0);

        return _buildNutritionCard(
          context,
          totalCalories,
          targetCalories,
          percentage,
          totalProtein,
          totalCarbs,
          totalFat,
          todayMealLogs.length,
        );
      },
    );
  }

  Widget _buildNutritionCard(
    BuildContext context,
    double totalCalories,
    double targetCalories,
    double percentage,
    double totalProtein,
    double totalCarbs,
    double totalFat,
    int mealCount,
  ) {
    final theme = Theme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),

        gradient: isDarkMode
            ? LinearGradient(
                colors: [
                  theme.colorScheme.onSurface.withOpacity(0.1),
                  theme.colorScheme.onSurface.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null, // For light mode, no gradient, just a white background
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white // White background for light mode
            : null, // Dark mode will apply the gradient above
        border: Border.all(
          color: theme.colorScheme.onSurface.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today\'s Nutrition',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${totalCalories.toStringAsFixed(0)} / ${targetCalories.toStringAsFixed(0)} calories',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$mealCount meals logged today',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              CircularPercentIndicator(
                radius: 40.0,
                lineWidth: 8.0,
                percent: percentage,
                center: Text(
                  '${(percentage * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                progressColor: theme.colorScheme.primary,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMacroStat(context, 'Protein',
                  totalProtein.toStringAsFixed(1), 'g', Colors.blue),
              _buildMacroStat(context, 'Carbs', totalCarbs.toStringAsFixed(1),
                  'g', Colors.orange),
              _buildMacroStat(context, 'Fat', totalFat.toStringAsFixed(1), 'g',
                  Colors.green),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              context.pushNamed('mealLog');
            },
            label: const Text('View Meal Logs'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: theme.colorScheme.primary,
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroStat(BuildContext context, String label, String value,
      String unit, Color color) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getMacroIcon(label),
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$value$unit',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  IconData _getMacroIcon(String macro) {
    switch (macro.toLowerCase()) {
      case 'protein':
        return Icons.food_bank;
      case 'carbs':
        return Icons.grain;
      case 'fat':
        return Icons.opacity;
      default:
        return Icons.circle;
    }
  }

  Widget _buildLoadingState(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Could not load nutrition data',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Provider.of<DietProvider>(context, listen: false).fetchMealLogs();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.onSurface.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.restaurant,
            color: theme.colorScheme.primary.withOpacity(0.5),
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'No meal data available',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Start tracking your nutrition by logging your meals',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              context.push('/dietSearch');
            },
            // icon: const Icon(Icons.add),
            label: const Text('Explore Diet Plans'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: theme.colorScheme.primary,
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
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
