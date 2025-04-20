import 'package:flutter/material.dart';
import 'package:gymify/models/supported_exercise_model.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:gymify/providers/personal_best_provider/personal_best_provider.dart';

class CreateSupportedExerciseScreen extends StatefulWidget {
  const CreateSupportedExerciseScreen({super.key});

  @override
  State<CreateSupportedExerciseScreen> createState() =>
      _CreateSupportedExerciseScreenState();
}

class _CreateSupportedExerciseScreenState
    extends State<CreateSupportedExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _exerciseNameController = TextEditingController();
  final _searchController = TextEditingController();
  String _searchQuery = '';

  // Define consistent spacing constants (matching your existing ones)
  static const double kSpacingSmall = 8.0;
  static const double kSpacingMedium = 16.0;
  static const double kSpacingLarge = 24.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PersonalBestProvider>().fetchSupportedExercises();
    });
  }

  @override
  void dispose() {
    _exerciseNameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _createExercise() {
    if (_formKey.currentState?.validate() ?? false) {
      final exerciseName = _exerciseNameController.text.trim();

      // Check if the exercise name already exists
      final exists = context
          .read<PersonalBestProvider>()
          .supportedExercises
          .any((exercise) =>
              exercise.exerciseName.toLowerCase() ==
              exerciseName.toLowerCase());

      if (exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('An exercise with this name already exists')),
        );
        return;
      }

      context
          .read<PersonalBestProvider>()
          .createSupportedExercise(exerciseName)
          .then((success) {
        if (success) {
          _exerciseNameController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Exercise created successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to create exercise')),
          );
        }
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      });
    }
  }

  void _showDeleteConfirmationDialog(SupportedExercise exercise) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Exercise'),
        content: Text(
          'Are you sure you want to delete "${exercise.exerciseName}"? This will also delete all personal best records associated with this exercise and cannot be undone.',
          style: const TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context);
              _deleteExercise(
                  exercise.supportedExerciseId, exercise.exerciseName);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteExercise(int exerciseId, String exerciseName) {
    context
        .read<PersonalBestProvider>()
        .deleteSupportedExercise(exerciseId)
        .then((success) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Exercise "$exerciseName" deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete exercise "$exerciseName"')),
        );
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final personalBestProvider = context.watch<PersonalBestProvider>();

    // Filter exercises based on search query
    final filteredExercises = personalBestProvider.supportedExercises
        .where((exercise) =>
            _searchQuery.isEmpty ||
            exercise.exerciseName
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Manage Supported Exercises'),
      body: personalBestProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : personalBestProvider.hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Error: ${personalBestProvider.errorMessage}"),
                      const SizedBox(height: kSpacingMedium),
                      ElevatedButton(
                        onPressed: () {
                          personalBestProvider.resetError();
                          personalBestProvider.fetchSupportedExercises();
                        },
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(kSpacingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // New Exercise Form
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(kSpacingMedium),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Add New Exercise',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: kSpacingSmall),
                                Text(
                                  'Create a new exercise that members can track',
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.6),
                                  ),
                                ),
                                const SizedBox(height: kSpacingMedium),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _exerciseNameController,
                                        decoration: InputDecoration(
                                          labelText: 'Exercise Name',
                                          hintText:
                                              'e.g., Bench Press, Squat, Deadlift',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          prefixIcon:
                                              const Icon(Icons.fitness_center),
                                        ),
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Please enter an exercise name';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: kSpacingMedium),
                                      ElevatedButton(
                                        onPressed: _createExercise,
                                        style: ElevatedButton.styleFrom(
                                          minimumSize:
                                              const Size(double.infinity, 50),
                                          backgroundColor:
                                              theme.colorScheme.primary,
                                          foregroundColor:
                                              theme.colorScheme.onPrimary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: const Text('Create Exercise'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: kSpacingLarge),

                        // Exercise List Section
                        Text(
                          'Existing Exercises',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: kSpacingSmall),

                        // Search Bar
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search exercises...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                        ),

                        const SizedBox(height: kSpacingMedium),

                        // Exercise Count
                        Text(
                          '${filteredExercises.length} exercise${filteredExercises.length != 1 ? 's' : ''} found',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                            fontStyle: FontStyle.italic,
                          ),
                        ),

                        const SizedBox(height: kSpacingSmall),

                        // Exercise List
                        filteredExercises.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(kSpacingLarge),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.search_off,
                                        size: 64,
                                        color: theme.colorScheme.onSurface
                                            .withOpacity(0.3),
                                      ),
                                      const SizedBox(height: kSpacingMedium),
                                      Text(
                                        _searchQuery.isEmpty
                                            ? 'No exercises available yet'
                                            : 'No exercises match your search',
                                        style: TextStyle(
                                          color: theme.colorScheme.onSurface
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filteredExercises.length,
                                itemBuilder: (context, index) {
                                  final exercise = filteredExercises[index];
                                  return Card(
                                    margin: const EdgeInsets.only(
                                        bottom: kSpacingSmall),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: theme
                                            .colorScheme.primary
                                            .withOpacity(0.2),
                                        child: Icon(
                                          Icons.fitness_center,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                      title: Text(
                                        exercise.exerciseName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                          'ID: ${exercise.supportedExerciseId}'),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete_outline),
                                        onPressed: () {
                                          // Show confirmation dialog for deletion
                                          _showDeleteConfirmationDialog(
                                              exercise);
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Quick action to refresh the exercise list
          context.read<PersonalBestProvider>().fetchSupportedExercises();
        },
        icon: const Icon(Icons.refresh),
        label: const Text('Refresh'),
      ),
    );
  }
}
