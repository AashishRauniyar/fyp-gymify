// import 'package:flutter/material.dart';
// import 'package:gymify/models/deit_plan_models/diet_plan_model.dart';
// import 'package:gymify/models/deit_plan_models/meal_model.dart';
// import 'package:gymify/colors/app_colors.dart';

// class DietDetailScreen extends StatelessWidget {
//   final DietPlan dietPlan;

//   const DietDetailScreen({super.key, required this.dietPlan});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           dietPlan.name,
//           style: theme.textTheme.headlineSmall?.copyWith(
//             fontWeight: FontWeight.bold,
//             color: AppColors.lightOnPrimary,
//           ),
//         ),
//         backgroundColor: theme.colorScheme.primary,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
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
//                     Text(
//                       'Goal Type: ${dietPlan.goalType}',
//                       style: theme.textTheme.bodyLarge?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Calorie Goal: ${dietPlan.calorieGoal} kcal',
//                       style: theme.textTheme.bodyLarge?.copyWith(
//                         color: theme.colorScheme.onSurface.withOpacity(0.6),
//                       ),
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
//             Text(
//               meal.mealName,
//               style: theme.textTheme.headlineSmall?.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Meal Time: ${meal.mealTime}',
//               style: theme.textTheme.bodyMedium?.copyWith(
//                 color: theme.colorScheme.onSurface.withOpacity(0.7),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Calories: ${meal.calories} kcal',
//               style: theme.textTheme.bodyMedium?.copyWith(
//                 color: theme.colorScheme.onSurface.withOpacity(0.7),
//               ),
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

import 'package:flutter/material.dart';
import 'package:gymify/models/deit_plan_models/diet_plan_model.dart';
import 'package:gymify/models/deit_plan_models/meal_model.dart';
import 'package:gymify/colors/app_colors.dart';

class DietDetailScreen extends StatelessWidget {
  final DietPlan dietPlan;

  const DietDetailScreen({super.key, required this.dietPlan});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          dietPlan.name,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.lightOnPrimary,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Diet Plan Details Section
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.flag, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Goal Type: ${dietPlan.goalType}',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_alarm,
                            color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Calorie Goal: ${dietPlan.calorieGoal} kcal',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Description:',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dietPlan.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Meals Section
            Text(
              'Meals',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...dietPlan.meals.map((meal) {
              return MealCard(meal: meal, theme: theme);
            }),
          ],
        ),
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  final Meal meal;
  final ThemeData theme;

  const MealCard({super.key, required this.meal, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meal.mealName,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Meal Time: ${meal.mealTime}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.restaurant, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Calories: ${meal.calories} kcal',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Macronutrients: ${meal.macronutrients}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Description:',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              meal.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
