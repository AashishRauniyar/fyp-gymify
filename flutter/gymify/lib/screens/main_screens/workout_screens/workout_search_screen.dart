import 'package:flutter/material.dart';
import 'package:gymify/utils/workout_utils.dart/workout_list_item.dart';
import 'package:provider/provider.dart';
import 'package:gymify/providers/workout_provider/workout_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:gymify/utils/custom_loader.dart';

class WorkoutSearchScreen extends StatefulWidget {
  const WorkoutSearchScreen({super.key});

  @override
  State<WorkoutSearchScreen> createState() => _WorkoutSearchScreenState();
}

class _WorkoutSearchScreenState extends State<WorkoutSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  String? selectedDifficulty; // Filter by difficulty: Easy, Intermediate, Hard

  @override
  void initState() {
    super.initState();
    // Automatically focus the search field when the screen loads.
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
          selectedDifficulty = result;
        });
      }
    });
  }

  Widget _buildFilterDrawer(BuildContext context) {
    final theme = Theme.of(context);
    // Temporary variable so changes apply only when "Apply Filters" is tapped.
    String? tempSelectedDifficulty = selectedDifficulty;
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
              labelText: "Difficulty",
              labelStyle: theme.textTheme.bodyMedium,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            value: tempSelectedDifficulty,
            onChanged: (value) {
              tempSelectedDifficulty = value;
            },
            items: ['Easy', 'Intermediate', 'Hard']
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
                  tempSelectedDifficulty = null;
                  setState(() {
                    selectedDifficulty = null;
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
                  Navigator.pop(context, tempSelectedDifficulty);
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
        title: "Search Workouts",
        showBackButton: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: theme.colorScheme.primary),
            onPressed: () => _openFilterDrawer(context),
          ),
        ],
      ),
      body: ChangeNotifierProvider(
        create: (_) => WorkoutProvider()..fetchAllWorkouts(),
        child: Consumer<WorkoutProvider>(
          builder: (context, workoutProvider, child) {
            if (workoutProvider.isLoading) {
              return const Center(child: CustomLoadingAnimation());
            }
            if (workoutProvider.hasError) {
              return Center(
                child: Text(
                  "Error loading workouts.",
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(color: theme.colorScheme.error),
                ),
              );
            }

            final filteredWorkouts = workoutProvider.workouts.where((workout) {
              final matchesSearch = workout.workoutName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase());
              final matchesFilter = selectedDifficulty == null ||
                  workout.difficulty == selectedDifficulty;
              return matchesSearch && matchesFilter;
            }).toList();

            if (filteredWorkouts.isEmpty) {
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
                      hintText: 'Search Workouts...',
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredWorkouts.length,
                    itemBuilder: (context, index) {
                      final workout = filteredWorkouts[index];
                      return WorkoutListItem(workout: workout);
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
