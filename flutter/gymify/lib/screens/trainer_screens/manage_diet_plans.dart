import 'package:flutter/material.dart';
import 'package:gymify/screens/diet_screens/create_diet_plan_screen.dart';
import 'package:gymify/screens/diet_screens/create_meal_screen.dart';
import 'package:provider/provider.dart';
import 'package:gymify/models/deit_plan_models/diet_plan_model.dart';
import 'package:gymify/providers/diet_provider/diet_provider.dart';

import 'package:gymify/utils/custom_appbar.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:go_router/go_router.dart';

class ManageDietPlans extends StatefulWidget {
  const ManageDietPlans({super.key});

  @override
  State<ManageDietPlans> createState() => _ManageDietPlansState();
}

class _ManageDietPlansState extends State<ManageDietPlans> {
  @override
  void initState() {
    super.initState();
    // Fetch the diet plans when the page is loaded.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DietProvider>(context, listen: false).fetchAllDietPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: const CustomAppBar(title: "Diet Plans"),
      body: Consumer<DietProvider>(
        builder: (context, dietProvider, child) {
          if (dietProvider.isLoading) {
            return const Center(child: CustomLoadingAnimation());
          }

          if (dietProvider.hasError) {
            return Center(
              child: Text(
                "Error loading diet plans.",
                style: theme.textTheme.headlineSmall
                    ?.copyWith(color: theme.colorScheme.error),
              ),
            );
          }

          if (dietProvider.diets.isEmpty) {
            return Center(
              child: Text(
                "No diet plans available.",
                style: theme.textTheme.headlineSmall,
              ),
            );
          }

          return ListView.separated(
            itemCount: dietProvider.diets.length,
            separatorBuilder: (context, index) => Divider(
              color: theme.colorScheme.onSurface.withOpacity(0.2),
              thickness: 0.5,
              indent: 16,
              endIndent: 16,
            ),
            itemBuilder: (context, index) {
              final diet = dietProvider.diets[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  title: Text(
                    diet.name,
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${diet.calorieGoal} kcal • ${diet.goalType}",
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6)),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Navigate to the Diet Plan Detail/Edit screen.
                          // You may use GoRouter or Navigator. For example:
                          context.pushNamed(
                            'dietDetail',
                            extra: diet, // Passing the diet plan as extra
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          // Navigate to the Create Meal screen,
                          // passing the diet plan id so the meal is linked correctly.
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  CreateMealScreen(dietPlanId: diet.dietPlanId),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    // Alternatively, tapping the card navigates to the Diet Detail/Edit screen.
                    context.pushNamed(
                      'dietDetail',
                      extra: diet,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Create Diet Plan screen.
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateDietPlanScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
