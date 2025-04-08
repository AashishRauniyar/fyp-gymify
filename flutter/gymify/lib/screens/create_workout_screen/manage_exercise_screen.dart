import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/models/exercise_model.dart';
import 'package:gymify/providers/exercise_provider/exercise_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ManageExerciseScreen extends StatefulWidget {
  const ManageExerciseScreen({super.key});

  @override
  State<ManageExerciseScreen> createState() => _ManageExerciseScreenState();
}

class _ManageExerciseScreenState extends State<ManageExerciseScreen> {
  bool _isLoading = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  String? selectedMuscleGroup;

  // Define muscle groups
  final List<String> muscleGroups = [
    'Chest',
    'Back',
    'Arms',
    'Legs',
    'Core',
    'Shoulders',
    'Glutes',
    'Full Body'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final exerciseProvider =
          Provider.of<ExerciseProvider>(context, listen: false);
      exerciseProvider.fetchAllExercises();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _deleteExercise(BuildContext context, Exercise exercise) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final exerciseProvider =
          Provider.of<ExerciseProvider>(context, listen: false);
      await exerciseProvider.deleteExercise(exercise.exerciseId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Text('${exercise.exerciseName} deleted successfully'),
            ],
          ),
          backgroundColor: Colors.green.shade700,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                  child: Text('Failed to delete exercise: ${e.toString()}')),
            ],
          ),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, Exercise exercise) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.delete_outline, color: theme.colorScheme.error),
            const SizedBox(width: 12),
            const Text('Delete Exercise'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Are you sure you want to delete this exercise?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: exercise.imageUrl.isNotEmpty
                        ? Image.network(exercise.imageUrl,
                            width: 40, height: 40, fit: BoxFit.cover)
                        : Container(
                            width: 40,
                            height: 40,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.fitness_center,
                                color: Colors.grey),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      exercise.exerciseName,
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _deleteExercise(context, exercise);
            },
            icon: const Icon(Icons.delete_outline, size: 18),
            label: const Text('Delete'),
            style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error),
          ),
        ],
      ),
    );
  }

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
                    final isSelected = selectedMuscleGroup == muscleGroup;

                    return InkWell(
                      onTap: () {
                        setModalState(() {
                          selectedMuscleGroup = isSelected ? null : muscleGroup;
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
                        Navigator.pop(context);
                        setState(() {
                          selectedMuscleGroup = null;
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
                        setState(() {
                          // Filter will be applied by the existing _filterExercises method
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

  List<Exercise> _filterExercises(List<Exercise> exercises) {
    if (_searchQuery.isEmpty && selectedMuscleGroup == null) return exercises;
    return exercises.where((exercise) {
      final matchesSearch = _searchQuery.isEmpty ||
          exercise.exerciseName
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          exercise.description
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      final matchesMuscleGroup = selectedMuscleGroup == null ||
          exercise.targetMuscleGroup.trim().toLowerCase() ==
              selectedMuscleGroup!.trim().toLowerCase();

      return matchesSearch && matchesMuscleGroup;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: "Manage Exercises",
        showBackButton: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: theme.colorScheme.primary),
            onPressed: () {
              _openFilterDrawer(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final exerciseProvider =
                  Provider.of<ExerciseProvider>(context, listen: false);
              exerciseProvider.fetchAllExercises();
              setState(() {
                selectedMuscleGroup = null;
                _searchQuery = '';
                _searchController.clear();
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CustomLoadingAnimation())
          : Consumer<ExerciseProvider>(
              builder: (context, exerciseProvider, child) {
                if (exerciseProvider.isLoading) {
                  return const Center(child: CustomLoadingAnimation());
                }

                if (exerciseProvider.error.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.circleExclamation,
                            size: 60, color: theme.colorScheme.error),
                        const SizedBox(height: 16),
                        Text("Failed to load exercises",
                            style: theme.textTheme.headlineSmall
                                ?.copyWith(color: theme.colorScheme.error)),
                        const SizedBox(height: 8),
                        Text("Please try again later",
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey)),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => exerciseProvider.fetchAllExercises(),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary),
                        ),
                      ],
                    ),
                  );
                }

                if (exerciseProvider.exercises.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.dumbbell,
                            size: 60, color: theme.colorScheme.primary),
                        const SizedBox(height: 24),
                        Text("No exercises available",
                            style: theme.textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            "Create your first exercise to start building workout routines",
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey.shade700),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton.icon(
                          onPressed: () => context.pushNamed('createExercise'),
                          icon: const Icon(Icons.add),
                          label: const Text('Create New Exercise'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary),
                        ),
                      ],
                    ),
                  );
                }

                final filteredExercises =
                    _filterExercises(exerciseProvider.exercises);

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search exercises...',
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
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                        ),
                      ),
                    ),

                    // Add filter chip if filter is active
                    if (selectedMuscleGroup != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Wrap(
                          children: [
                            Chip(
                              label: Text(selectedMuscleGroup!),
                              onDeleted: () {
                                setState(() {
                                  selectedMuscleGroup = null;
                                });
                              },
                              deleteIcon: const Icon(Icons.close, size: 18),
                            ),
                          ],
                        ),
                      ),

                    // Exercises list header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            filteredExercises.length ==
                                    exerciseProvider.exercises.length
                                ? 'All Exercises (${filteredExercises.length})'
                                : 'Results (${filteredExercises.length})',
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextButton.icon(
                            onPressed: () =>
                                context.pushNamed('createExercise'),
                            icon: const Icon(Icons.add,
                                size: 18, color: Colors.white),
                            label: const Text(
                              'New',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: TextButton.styleFrom(
                                backgroundColor:
                                    theme.colorScheme.primaryContainer),
                          ),
                        ],
                      ),
                    ),

                    // Exercises list
                    Expanded(
                      child: filteredExercises.isEmpty
                          ? const Center(child: Text('No matching exercises'))
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                              itemCount: filteredExercises.length,
                              itemBuilder: (context, index) {
                                final exercise = filteredExercises[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Slidable(
                                    key: ValueKey(exercise.exerciseId),
                                    endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      extentRatio: 0.25,
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) =>
                                              _showDeleteConfirmationDialog(
                                                  context, exercise),
                                          backgroundColor:
                                              theme.colorScheme.error,
                                          foregroundColor: Colors.white,
                                          icon: Icons.delete,
                                          label: 'Delete',
                                        ),
                                      ],
                                    ),
                                    child:
                                        _buildExerciseCard(context, exercise),
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
        onPressed: () => context.pushNamed('createExercise'),
        backgroundColor: theme.colorScheme.primary,
        icon: const Icon(Icons.add),
        label: const Text('New Exercise'),
      ),
    );
  }

  Widget _buildExerciseCard(BuildContext context, Exercise exercise) {
    final theme = Theme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () => context.pushNamed(
        'exerciseDetails',
        pathParameters: {'id': exercise.exerciseId.toString()},
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isDarkMode
              ? theme.colorScheme.surface
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isDarkMode
                  ? theme.colorScheme.onSurface.withOpacity(0.1)
                  : theme.colorScheme.onSurface.withOpacity(0.1),
              width: 1.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Exercise Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: exercise.imageUrl.isNotEmpty
                    ? exercise.imageUrl
                    : 'https://via.placeholder.com/150', // Placeholder for missing image
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 90,
                  height: 90,
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  child: Center(
                    child: FaIcon(FontAwesomeIcons.dumbbell,
                        color: theme.colorScheme.primary.withOpacity(0.5),
                        size: 24),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 90,
                  height: 90,
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  child: Center(
                    child: FaIcon(FontAwesomeIcons.dumbbell,
                        color: theme.colorScheme.primary.withOpacity(0.5),
                        size: 24),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Exercise Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.exerciseName,
                    style: theme.textTheme.titleMedium?.copyWith(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    exercise.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.6)
                            : Colors.black.withOpacity(0.6)),
                  ),
                ],
              ),
            ),

            // Replace delete button with more options
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: theme.colorScheme.onSurface),
              onSelected: (value) {
                if (value == 'delete') {
                  _showDeleteConfirmationDialog(context, exercise);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline,
                          color: theme.colorScheme.error),
                      const SizedBox(width: 8),
                      Text('Delete',
                          style: TextStyle(color: theme.colorScheme.error)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
