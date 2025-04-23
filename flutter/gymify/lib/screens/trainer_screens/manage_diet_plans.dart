import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gymify/screens/diet_screens/create_diet_plan_screen.dart';
import 'package:gymify/screens/diet_screens/create_meal_screen.dart';
import 'package:gymify/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';
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
  final bool _isLoading = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DietProvider>(context, listen: false).fetchAllDietPlans();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<dynamic> _filterDietPlans(List<dynamic> dietPlans) {
    if (_searchQuery.isEmpty) return dietPlans;
    return dietPlans
        .where((diet) =>
            diet.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            diet.goalType.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Widget _buildStatCard(
      BuildContext context, IconData icon, String value, String label) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 20),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(int dietId) async {
    final theme = Theme.of(context);

    bool? deleteConfirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Confirm Deletion",
            style: theme.textTheme.titleLarge,
          ),
          content: Text(
            "Are you sure you want to delete this diet plan?",
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                "Cancel",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                "Delete",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (deleteConfirmed == true) {
      await Provider.of<DietProvider>(context, listen: false)
          .deleteDietPlan(dietId);
      showCoolSnackBar(context, "Diet Deleted Successfully", true);
      Provider.of<DietProvider>(context, listen: false).fetchAllDietPlans();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const CustomAppBar(title: "Manage Diet Plans"),
      body: Consumer<DietProvider>(
        builder: (context, dietProvider, child) {
          if (dietProvider.isLoading) {
            return const Center(child: CustomLoadingAnimation());
          }

          if (dietProvider.hasError) {
            return Center(
              child: Text(
                "Error loading diet plans.",
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            );
          }

          final filteredDietPlans = _filterDietPlans(dietProvider.diets);

          return Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search diet plans...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
              ),

              // Stats panel
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primary.withBlue(
                          (theme.colorScheme.primary.blue + 40).clamp(0, 255),
                        ),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Diet Plans Overview",
                        style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildStatCard(
                            context,
                            Icons.restaurant_menu,
                            dietProvider.diets.length.toString(),
                            'Total Plans',
                          ),
                          const SizedBox(width: 8),
                          _buildStatCard(
                            context,
                            Icons.fitness_center,
                            'Weight Loss',
                            'Most Common',
                          ),
                          const SizedBox(width: 8),
                          _buildStatCard(
                            context,
                            Icons.trending_up,
                            '2000',
                            'Avg Calories',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Diet plans list
              Expanded(
                child: filteredDietPlans.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.magnifyingGlass,
                              size: 50,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No matching diet plans',
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try a different search',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                        itemCount: filteredDietPlans.length,
                        itemBuilder: (context, index) {
                          final diet = filteredDietPlans[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Slidable(
                              key: ValueKey(diet.dietPlanId),
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                extentRatio: 0.25,
                                children: [
                                  SlidableAction(
                                    onPressed: (context) =>
                                        _showDeleteConfirmationDialog(
                                            diet.dietPlanId),
                                    backgroundColor: theme.colorScheme.error,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                ],
                              ),
                              child: InkWell(
                                onTap: () {
                                  context.pushNamed(
                                    'dietDetail',
                                    extra: diet,
                                  );
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Image section with fixed size
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: SizedBox(
                                          width: 70,
                                          height: 70,
                                          child: CachedNetworkImage(
                                            imageUrl: diet.image.isNotEmpty
                                                ? diet.image
                                                : 'https://via.placeholder.com/150',
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Container(
                                              color: theme.colorScheme.primary
                                                  .withOpacity(0.1),
                                              child: Center(
                                                child: FaIcon(
                                                  FontAwesomeIcons.utensils,
                                                  color: theme
                                                      .colorScheme.primary
                                                      .withOpacity(0.5),
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                              color: theme.colorScheme.primary
                                                  .withOpacity(0.1),
                                              child: Center(
                                                child: FaIcon(
                                                  FontAwesomeIcons.utensils,
                                                  color: theme
                                                      .colorScheme.primary
                                                      .withOpacity(0.5),
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Content section with flexible width
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              diet.name,
                                              style: theme.textTheme.bodyLarge
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Wrap(
                                              spacing: 8,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: theme.colorScheme
                                                        .primaryContainer
                                                        .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Text(
                                                    diet.goalType,
                                                    style: theme
                                                        .textTheme.bodySmall
                                                        ?.copyWith(
                                                      color: theme
                                                          .colorScheme.primary,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  '${diet.calorieGoal} kcal',
                                                  style: theme
                                                      .textTheme.bodySmall
                                                      ?.copyWith(
                                                    color: theme
                                                        .colorScheme.onSurface
                                                        .withOpacity(0.6),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Only add meal button
                                      IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          size: 20,
                                          color: theme.colorScheme.primary,
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 40,
                                          minHeight: 40,
                                        ),
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateMealScreen(
                                                      dietPlanId:
                                                          diet.dietPlanId),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateDietPlanScreen(),
            ),
          );
        },
        backgroundColor: theme.colorScheme.primary,
        icon: const Icon(Icons.add),
        label: const Text('New Diet Plan'),
      ),
    );
  }
}
