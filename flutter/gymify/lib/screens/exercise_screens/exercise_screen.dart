import 'package:flutter/material.dart';
import 'package:gymify/models/exercise_model.dart';
import 'package:gymify/providers/exercise_provider/exercise_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:gymify/utils/workout_utils.dart/exercise_list_item.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ExerciseScreen extends StatefulWidget {
  // const ExerciseScreen({super.key});

  final String? muscleGroupFilter;

  const ExerciseScreen({super.key, this.muscleGroupFilter});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Exercise> _filteredExercises = [];

  // Define muscle groups
  final List<String> muscleGroups = [
    'Chest',
    'Back',
    'Arms',
    'Legs',
    'Core',
    'Shoulders',
    'Glutes',
    'Full Body',
  ];

  // Filter variable - only filter by muscle group
  String? selectedTargetMuscleGroup;

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     context.read<ExerciseProvider>().fetchAllExercises();
  //   });
  //   _searchController.addListener(() {
  //     // Debounce search input to prevent too frequent updates
  //     Future.microtask(() => _filterExercises());
  //   });
  // }
  @override
void initState() {
  super.initState();
  if (widget.muscleGroupFilter != null) {
    selectedTargetMuscleGroup = widget.muscleGroupFilter;
  }
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<ExerciseProvider>().fetchAllExercises();
    _filterExercises();
  });
}

  @override
  void didUpdateWidget(ExerciseScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Safely filter again if widget updates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _filterExercises();
    });
  }

  void _filterExercises() {
    if (!mounted) return;

    final query = _searchController.text.toLowerCase();
    final allExercises = context.read<ExerciseProvider>().exercises;

    setState(() {
      // More strict filtering logic
      _filteredExercises = allExercises.where((exercise) {
        final matchesSearch = query.isEmpty ||
            exercise.exerciseName.toLowerCase().contains(query);

        final matchesMuscle = selectedTargetMuscleGroup == null ||
            exercise.targetMuscleGroup.trim().toLowerCase() ==
                selectedTargetMuscleGroup?.trim().toLowerCase();

        return matchesSearch && matchesMuscle;
      }).toList();

      // If we have filters but no results, ensure filtered list stays empty
      if ((query.isNotEmpty || selectedTargetMuscleGroup != null) &&
          _filteredExercises.isEmpty) {
        _filteredExercises = [];
      }
    });
  }

  void _resetFilters() {
    setState(() {
      selectedTargetMuscleGroup = null;
    });
    _filterExercises();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: "Exercises",
        showBackButton: true,
        actions: [
          // Filter icon button
          IconButton(
            icon: Icon(Icons.filter_list, color: theme.colorScheme.primary),
            onPressed: () {
              _openFilterDrawer(context);
            },
          ),
        ],
      ),
      body: Consumer<ExerciseProvider>(
        builder: (context, exerciseProvider, child) {
          if (exerciseProvider.exercises.isEmpty) {
            return _buildShimmerLoading();
          }

          // Changed this logic to properly handle filtering
          final exercisesToDisplay = _searchController.text.isEmpty &&
                  selectedTargetMuscleGroup == null
              ? exerciseProvider.exercises
              : _filteredExercises;

          return Column(
            children: [
              _buildSearchBar(),
              if (selectedTargetMuscleGroup != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.filter_alt_outlined,
                                size: 16,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Filtered by: $selectedTargetMuscleGroup',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  // Use a post-frame callback to avoid setState during build
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    setState(() {
                                      selectedTargetMuscleGroup = null;
                                    });
                                    _filterExercises();
                                  });
                                },
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: exercisesToDisplay.isEmpty
                    ? _buildEmptyState(theme)
                    : ListView.builder(
                        itemCount: exercisesToDisplay.length,
                        itemBuilder: (context, index) {
                          final exercise = exercisesToDisplay[index];
                          return ExerciseTile(exercise: exercise);
                        },
                      ),
              ),
            ],
          );
        },
      ),
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
            "No exercises found.",
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Text(
            "Try adjusting your filters or search query.",
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              _resetFilters();
              _searchController.clear();
            },
            icon: const Icon(Icons.refresh),
            label: const Text("Reset All Filters"),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          labelText: 'Search Exercises',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[400]!),
          ),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterExercises();
                  },
                )
              : null,
        ),
      ),
    );
  }

  // Method to open the filter drawer (modal bottom sheet)
  void _openFilterDrawer(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Filter by Muscle Group",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Wrap the muscle group options in a GridView for better layout
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: muscleGroups.length,
                  itemBuilder: (context, index) {
                    final muscleGroup = muscleGroups[index];
                    final isSelected = selectedTargetMuscleGroup == muscleGroup;

                    return InkWell(
                      onTap: () {
                        setModalState(() {
                          selectedTargetMuscleGroup =
                              isSelected ? null : muscleGroup;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline.withOpacity(0.5),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          muscleGroup,
                          style: TextStyle(
                            color: isSelected
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        setModalState(() {
                          selectedTargetMuscleGroup = null;
                        });
                        Navigator.pop(context);
                        // Update state and filter after navigation
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            selectedTargetMuscleGroup = null;
                          });
                          _filterExercises();
                        });
                      },
                      child: Text(
                        "Clear Filter",
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        // Ensure filter is applied after modal is closed
                        Future.microtask(() {
                          if (mounted) {
                            setState(() {
                              // State is already updated in the modal
                            });
                            _filterExercises();
                          }
                        });
                      },
                      child: const Text("Apply"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 5, // Show 5 loading placeholders
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: const ExerciseTileShimmer(),
        );
      },
    );
  }
}

class ExerciseTileShimmer extends StatelessWidget {
  const ExerciseTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.withOpacity(0.1),
            width: 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Shimmer loading for image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 90,
                height: 90,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(width: 12),

            // Shimmer loading for text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 16,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 80,
                    height: 14,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),

            // Shimmer loading for icon
            const SizedBox(width: 12),
            Container(
              width: 22,
              height: 22,
              color: Colors.grey[300],
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
