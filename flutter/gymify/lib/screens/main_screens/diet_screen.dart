import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:gymify/models/deit_plan_models/diet_plan_model.dart';
import 'package:gymify/providers/diet_provider/diet_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:gymify/utils/custom_loader.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DietProvider>(context, listen: false).fetchAllDietPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: "Diet Plans",
        showBackButton: false,
        actions: [
          // Search action.
          IconButton(
            icon: Icon(Icons.search, color: theme.colorScheme.primary),
            onPressed: () {
              context.pushNamed('dietSearch');
            },
          ),
          // Filter action.
          IconButton(
            icon: Icon(Icons.filter_list, color: theme.colorScheme.primary),
            onPressed: () {
              context.pushNamed('dietSearch');
            },
          ),
        ],
        bottom: TabBar(
          physics: const BouncingScrollPhysics(),
          controller: _tabController,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 4,
            ),
            // Negative insets will extend the line beyond the default bounds.
            insets: const EdgeInsets.symmetric(horizontal: -20),
          ),
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
          indicatorColor: theme.colorScheme.primary,
          tabs: const [
            Tab(text: "Weight Loss"),
            Tab(text: "Muscle Gain"),
            Tab(text: "Maintenance"),
          ],
        ),
      ),
      body: ChangeNotifierProvider(
        create: (_) => DietProvider()..fetchAllDietPlans(),
        child: Consumer<DietProvider>(
          builder: (context, dietProvider, child) {
            if (dietProvider.isLoading) {
              return const Center(child: CustomLoadingAnimation());
            }
            if (dietProvider.hasError) {
              return _buildErrorState(theme);
            }
            if (dietProvider.diets.isEmpty) {
              return _buildEmptyState(theme);
            }
            return TabBarView(
              controller: _tabController,
              children: [
                _buildDietPlanList(dietProvider.diets, "Weight_Loss", theme),
                _buildDietPlanList(dietProvider.diets, "Muscle_Gain", theme),
                _buildDietPlanList(dietProvider.diets, "Maintenance", theme),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDietPlanList(
      List<DietPlan> dietPlans, String goalType, ThemeData theme) {
    final filteredByGoalType =
        dietPlans.where((dietPlan) => dietPlan.goalType == goalType).toList();

    if (filteredByGoalType.isEmpty) {
      return Center(
        child: Text(
          "No $goalType diet plans available.",
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredByGoalType.length,
      itemBuilder: (context, index) {
        final dietPlan = filteredByGoalType[index];
        return DietPlanListItem(dietPlan: dietPlan);
      },
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
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
            "Try adjusting your filters.",
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return Center(
      child: Text(
        "Error loading diet plans.",
        style: theme.textTheme.headlineSmall?.copyWith(
          color: theme.colorScheme.error,
        ),
      ),
    );
  }
}

/// A custom widget for displaying a diet plan tile.
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
            // Diet Image
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
            // Diet Details
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
            // Blue Icon for visual accent
            const Icon(
              // FontAwesomeIcons.clone,
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
