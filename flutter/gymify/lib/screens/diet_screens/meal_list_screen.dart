import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:gymify/models/deit_plan_models/meal_model.dart';
import 'package:gymify/providers/diet_provider/diet_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:gymify/utils/custom_loader.dart';

class MealListScreen extends StatefulWidget {
  const MealListScreen({super.key});

  @override
  State<MealListScreen> createState() => _MealListScreenState();
}

class _MealListScreenState extends State<MealListScreen> {
  // Selected meal type filters
  final Set<String> _selectedMealTypes = {};

  // Sorting options
  String _sortBy = "name"; // Default sort by name
  bool _sortAscending = true; // Default ascending order

  // Search functionality
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch meals when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DietProvider>(context, listen: false).fetchMeals();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter meals based on selected meal types and search query
  List<Meal> _filterMeals(List<Meal> meals) {
    // First filter by meal type
    List<Meal> filteredMeals = _selectedMealTypes.isEmpty
        ? meals
        : meals
            .where((meal) => _selectedMealTypes.contains(meal.mealTime))
            .toList();

    // Then filter by search query if not empty
    if (_searchQuery.isNotEmpty) {
      filteredMeals = filteredMeals
          .where((meal) =>
              meal.mealName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              meal.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filteredMeals;
  }

  // Sort meals based on selected sort criteria
  List<Meal> _sortMeals(List<Meal> meals) {
    switch (_sortBy) {
      case "name":
        meals.sort((a, b) => _sortAscending
            ? a.mealName.compareTo(b.mealName)
            : b.mealName.compareTo(a.mealName));
        break;
      case "calories":
        meals.sort((a, b) {
          double caloriesA = double.tryParse(a.calories) ?? 0;
          double caloriesB = double.tryParse(b.calories) ?? 0;
          return _sortAscending
              ? caloriesA.compareTo(caloriesB)
              : caloriesB.compareTo(caloriesA);
        });
        break;
    }
    return meals;
  }

  // Toggle a meal type filter
  void _toggleMealTypeFilter(String mealType) {
    setState(() {
      if (_selectedMealTypes.contains(mealType)) {
        _selectedMealTypes.remove(mealType);
      } else {
        _selectedMealTypes.add(mealType);
      }
    });
  }

  // Set sort criteria
  void _setSortCriteria(String sortBy) {
    setState(() {
      if (_sortBy == sortBy) {
        // If already sorting by this criteria, toggle direction
        _sortAscending = !_sortAscending;
      } else {
        // New sort criteria, default to ascending
        _sortBy = sortBy;
        _sortAscending = true;
      }
    });
    Navigator.pop(context);
  }

  // Handle search
  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  // Clear search
  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: "All Meals",
        actions: [
          // Filter button
          IconButton(
            icon: Icon(Icons.filter_list, color: theme.colorScheme.primary),
            onPressed: () {
              _showFilterOptions(context);
            },
          ),
        ],
      ),
      body: Consumer<DietProvider>(
        builder: (context, dietProvider, _) {
          if (dietProvider.isLoading) {
            return const Center(child: CustomLoadingAnimation());
          }

          if (dietProvider.hasError) {
            return _buildErrorState(theme);
          }

          // Apply filtering and sorting
          final filteredMeals = _filterMeals(dietProvider.meals);
          final meals = _sortMeals(filteredMeals);

          if (meals.isEmpty) {
            if (_searchQuery.isNotEmpty || _selectedMealTypes.isNotEmpty) {
              // Empty results due to filtering
              return _buildNoResultsState(theme);
            }
            return _buildEmptyState(theme);
          }

          return Column(
            children: [
              // Search bar at the top
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search meals...",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: _clearSearch,
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.colorScheme.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: theme.colorScheme.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onChanged: _handleSearch,
                ),
              ),

              // Show active filters
              if (_selectedMealTypes.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        "Filters: ",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _selectedMealTypes
                                .map((type) => Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Chip(
                                        label: Text(type),
                                        onDeleted: () =>
                                            _toggleMealTypeFilter(type),
                                        backgroundColor: theme
                                            .colorScheme.primary
                                            .withOpacity(0.1),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear_all),
                        tooltip: "Clear all filters",
                        onPressed: () {
                          setState(() {
                            _selectedMealTypes.clear();
                          });
                        },
                      ),
                    ],
                  ),
                ),

              // Display sort indicator
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Show count of meals
                    Text(
                      "${meals.length} meal${meals.length != 1 ? 's' : ''}",
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: Colors.grey),
                    ),
                    // Sort indicator with better formatting
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Sort: ${_sortBy == 'name' ? 'Name' : 'Calories'}",
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            _sortAscending
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            size: 14,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Meal list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    return _buildMealCard(context, meals[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMealCard(BuildContext context, Meal meal) {
    final theme = Theme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    bool hasValidImage = meal.image.isNotEmpty &&
        (meal.image.startsWith('http') || meal.image.startsWith('https'));

    return GestureDetector(
      onTap: () {
        context.pushNamed('mealDetails', extra: meal);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.onSurface.withOpacity(0.1),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Meal Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: hasValidImage
                  ? CachedNetworkImage(
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      imageUrl: meal.image,
                      placeholder: (context, url) => Container(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        child: Icon(
                          Icons.restaurant,
                          color: theme.colorScheme.primary,
                          size: 40,
                        ),
                      ),
                    )
                  : Container(
                      width: 120,
                      height: 120,
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      child: Icon(
                        Icons.restaurant,
                        color: theme.colorScheme.primary,
                        size: 40,
                      ),
                    ),
            ),
            // Meal Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Meal Name
                    Text(
                      meal.mealName,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Meal Time Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        meal.mealTime,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Calories
                    Row(
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          size: 16,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${meal.calories} kcal',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Arrow icon
            Padding(
              padding: const EdgeInsets.all(16),
              child: Icon(
                Icons.arrow_forward_ios,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.no_food,
            size: 80,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            "No meals available",
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Text(
            "Try adding some meals first.",
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: theme.colorScheme.error.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            "Error loading meals",
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Please try again later.",
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text("Retry"),
            onPressed: () {
              Provider.of<DietProvider>(context, listen: false).fetchMeals();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            "No meals found",
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Text(
            "Try adjusting your search or filters",
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (_searchQuery.isNotEmpty || _selectedMealTypes.isNotEmpty)
            ElevatedButton.icon(
              icon: const Icon(Icons.clear),
              label: const Text("Clear Filters"),
              onPressed: () {
                setState(() {
                  _searchQuery = "";
                  _searchController.clear();
                  _selectedMealTypes.clear();
                });
              },
            ),
        ],
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Filter Meals",
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Meal Type",
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildFilterChip(context, "Breakfast"),
                _buildFilterChip(context, "Lunch"),
                _buildFilterChip(context, "Dinner"),
                _buildFilterChip(context, "Snack"),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "Sort By",
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.sort_by_alpha),
              title: const Text("Name"),
              trailing: _sortBy == "name"
                  ? Icon(_sortAscending
                      ? Icons.arrow_upward
                      : Icons.arrow_downward)
                  : null,
              onTap: () {
                _setSortCriteria("name");
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_fire_department),
              title: const Text("Calories"),
              trailing: _sortBy == "calories"
                  ? Icon(_sortAscending
                      ? Icons.arrow_upward
                      : Icons.arrow_downward)
                  : null,
              onTap: () {
                _setSortCriteria("calories");
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label) {
    return FilterChip(
      label: Text(label),
      selected: _selectedMealTypes.contains(label),
      onSelected: (selected) {
        _toggleMealTypeFilter(label);
      },
    );
  }
}
