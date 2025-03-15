import 'package:flutter/material.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:gymify/utils/workout_utils.dart/workout_list_item.dart';
import 'package:provider/provider.dart';
import 'package:gymify/providers/workout_provider/workout_provider.dart';

class AllWorkouts extends StatefulWidget {
  const AllWorkouts({super.key});

  @override
  State<AllWorkouts> createState() => _AllWorkoutsState();
}

class _AllWorkoutsState extends State<AllWorkouts>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? selectedFitnessLevel;
  String? selectedGoalType;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: "All Workouts",
        showBackButton: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: theme.colorScheme.primary),
            onPressed: () => _openFilterDrawer(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 4,
            ),
            // Negative insets will extend the line beyond the default bounds.
            insets: const EdgeInsets.symmetric(horizontal: -25),
          ),
          indicatorColor: theme.colorScheme.primary,
          tabs: const [
            Tab(text: "Easy"),
            Tab(text: "Intermediate"),
            Tab(text: "Hard"),
          ],
        ),
      ),
      body: ChangeNotifierProvider(
        create: (_) => WorkoutProvider()..fetchAllWorkouts(),
        child: Consumer<WorkoutProvider>(
          builder: (context, workoutProvider, child) {
            if (workoutProvider.isLoading) {
              return const Center(child: CustomLoadingAnimation());
            }

            if (workoutProvider.workouts.isEmpty) {
              return _buildEmptyState(theme);
            }

            final filteredWorkouts =
                _getFilteredWorkouts(workoutProvider.workouts);

            return Column(
              children: [
                _buildSearchBar(theme),
                const SizedBox(height: 10),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildWorkoutList(filteredWorkouts, "Easy", theme),
                      _buildWorkoutList(
                          filteredWorkouts, "Intermediate", theme),
                      _buildWorkoutList(filteredWorkouts, "Hard", theme),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
        },
        decoration: InputDecoration(
          hintText: 'Search Workouts...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: theme.colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutList(List workouts, String difficulty, ThemeData theme) {
    final filteredByDifficulty =
        workouts.where((workout) => workout.difficulty == difficulty).toList();

    if (filteredByDifficulty.isEmpty) {
      return Center(
        child: Text(
          "No $difficulty workouts available.",
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredByDifficulty.length,
      separatorBuilder: (context, index) {
        return Divider(
          color: theme.colorScheme.onSurface.withOpacity(0.2),
          thickness: 0.5,
          indent: 16,
          endIndent: 16,
        );
      },
      itemBuilder: (context, index) {
        final workout = filteredByDifficulty[index];
        return WorkoutListItem(
            workout: workout); // Using WorkoutListItem widget
      },
    );
  }

  List _getFilteredWorkouts(List workouts) {
    return workouts.where((workout) {
      final matchesSearch =
          workout.workoutName.toLowerCase().contains(_searchQuery);
      final matchesFitnessLevel = selectedFitnessLevel == null ||
          workout.fitnessLevel == selectedFitnessLevel;
      final matchesGoalType =
          selectedGoalType == null || workout.goalType == selectedGoalType;
      return matchesSearch && matchesFitnessLevel && matchesGoalType;
    }).toList();
  }

  void _openFilterDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildFilterDrawer(context),
    );
  }

  Widget _buildFilterDrawer(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDropdown(
            hint: "Fitness Level",
            value: selectedFitnessLevel,
            items: ['Beginner', 'Intermediate', 'Advanced', 'Athlete'],
            onChanged: (value) {
              setState(() {
                selectedFitnessLevel = value;
              });
            },
            theme: theme,
          ),
          _buildDropdown(
            hint: "Goal Type",
            value: selectedGoalType,
            items: ['Weight Loss', 'Muscle Gain', 'Endurance', 'Maintenance'],
            onChanged: (value) {
              setState(() {
                selectedGoalType = value;
              });
            },
            theme: theme,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  _resetFilters();
                  Navigator.pop(context);
                },
                child: Text(
                  "Reset Filters",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Apply Filters"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required ThemeData theme,
  }) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: InputDecoration(
        fillColor: theme.colorScheme.surface,
        filled: true,
        labelText: hint,
        labelStyle: theme.textTheme.bodyMedium,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      value: value,
      onChanged: onChanged,
      items: items
          .map((item) => DropdownMenuItem(
              value: item,
              child: Text(item, style: theme.textTheme.bodyMedium)))
          .toList(),
    );
  }

  void _resetFilters() {
    setState(() {
      selectedFitnessLevel = null;
      selectedGoalType = null;
      _searchController.clear();
      _searchQuery = '';
    });
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          Text(
            "No workouts found.",
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Text(
            "Try adjusting your filters or search query.",
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
