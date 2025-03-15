import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:gymify/models/deit_plan_models/diet_plan_model.dart';
import 'package:gymify/providers/diet_provider/diet_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:gymify/utils/custom_loader.dart';

class DietSearchScreen extends StatefulWidget {
  const DietSearchScreen({super.key});

  @override
  State<DietSearchScreen> createState() => _DietSearchScreenState();
}

class _DietSearchScreenState extends State<DietSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  String? selectedGoalType;

  @override
  void initState() {
    super.initState();
    // Automatically focus on the search field when the screen loads.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _openFilterDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildFilterDrawer(context),
    ).then((result) {
      // When the bottom sheet closes, update the filter if a result was returned.
      if (result != null && result is String?) {
        setState(() {
          selectedGoalType = result;
        });
      }
    });
  }

  Widget _buildFilterDrawer(BuildContext context) {
    final theme = Theme.of(context);
    // Temporary variable to store changes until "Apply Filters" is tapped.
    String? tempSelectedGoalType = selectedGoalType;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            isExpanded: true,
            decoration: InputDecoration(
              fillColor: theme.colorScheme.surface,
              filled: true,
              labelText: "Goal Type",
              labelStyle: theme.textTheme.bodyMedium,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            value: tempSelectedGoalType,
            onChanged: (value) {
              tempSelectedGoalType = value;
            },
            items: ['Weight_Loss', 'Muscle_Gain', 'Maintenance']
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(item, style: theme.textTheme.bodyMedium),
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  tempSelectedGoalType = null;
                  setState(() {
                    selectedGoalType = null;
                  });
                },
                child: Text(
                  "Reset Filters",
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.error),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                ),
                onPressed: () {
                  Navigator.pop(context, tempSelectedGoalType);
                },
                child: const Text("Apply Filters"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: "Search Diet Plans",
        showBackButton: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: theme.colorScheme.primary),
            onPressed: () => _openFilterDrawer(context),
          ),
        ],
      ),
      body: ChangeNotifierProvider(
        create: (_) => DietProvider()..fetchAllDietPlans(),
        child: Consumer<DietProvider>(
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
            final filteredDietPlans = dietProvider.diets.where((dietPlan) {
              final matchesSearch = dietPlan.name
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase());
              final matchesFilter = selectedGoalType == null ||
                  dietPlan.goalType == selectedGoalType;
              return matchesSearch && matchesFilter;
            }).toList();

            if (filteredDietPlans.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_off, size: 80, color: Colors.grey),
                    const SizedBox(height: 20),
                    Text(
                      "No diet plans found.",
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Try adjusting your search or filters.",
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    focusNode: _searchFocusNode,
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search Diet Plans...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredDietPlans.length,
                    itemBuilder: (context, index) {
                      final dietPlan = filteredDietPlans[index];
                      return DietPlanListItem(dietPlan: dietPlan);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// A custom widget that displays a diet plan tile.
class DietPlanListItem extends StatelessWidget {
  final DietPlan dietPlan;

  const DietPlanListItem({super.key, required this.dietPlan});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        context.pushNamed('dietDetail', extra: dietPlan);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.onSurface.withOpacity(0.1),
            width: 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Diet Plan Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                dietPlan.image.isNotEmpty
                    ? dietPlan.image
                    : 'https://via.placeholder.com/150',
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            // Diet Plan Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dietPlan.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${dietPlan.calorieGoal} kcal • ${dietPlan.goalType}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.6)
                          : Colors.black.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            // Visual Accent Icon
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.blue,
              size: 22,
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
