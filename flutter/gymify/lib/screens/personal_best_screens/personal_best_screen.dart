import 'package:flutter/material.dart';
import 'package:gymify/models/personal_best_model.dart';
import 'package:gymify/models/supported_exercise_model.dart';
import 'package:gymify/providers/personal_best_provider/personal_best_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PersonalBestScreen extends StatefulWidget {
  const PersonalBestScreen({super.key});

  @override
  _PersonalBestScreenState createState() => _PersonalBestScreenState();
}

class _PersonalBestScreenState extends State<PersonalBestScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  SupportedExercise? _selectedExercise;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Fetch data when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<PersonalBestProvider>();
      provider.fetchSupportedExercises();
      provider.fetchCurrentPersonalBests();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  void _logPersonalBest() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedExercise == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an exercise')),
        );
        return;
      }

      final weight = double.tryParse(_weightController.text);
      final reps = int.tryParse(_repsController.text);

      if (weight != null && reps != null) {
        context
            .read<PersonalBestProvider>()
            .logPersonalBest(
              exerciseId: _selectedExercise!.supportedExerciseId,
              weight: weight,
              reps: reps,
            )
            .then((_) {
          // Clear form and refresh data
          _weightController.clear();
          _repsController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Personal best logged successfully!')),
          );

          // Refresh data
          context.read<PersonalBestProvider>().fetchCurrentPersonalBests();
          if (_selectedExercise != null) {
            context.read<PersonalBestProvider>().fetchPersonalBestHistory(
                _selectedExercise!.supportedExerciseId);
          }
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${error.toString()}')),
          );
        });
      }
    }
  }

  void _viewExerciseHistory(SupportedExercise exercise) {
    setState(() {
      _selectedExercise = exercise;
    });
    context
        .read<PersonalBestProvider>()
        .fetchPersonalBestHistory(exercise.supportedExerciseId);
    context
        .read<PersonalBestProvider>()
        .fetchExerciseProgress(exercise.supportedExerciseId);
    _tabController.animateTo(1); // Switch to history tab
  }

  void _deleteRecord(int personalBestId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Record'),
        content: const Text('Are you sure you want to delete this record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context
                  .read<PersonalBestProvider>()
                  .deletePersonalBest(personalBestId)
                  .then((success) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Record deleted successfully')),
                  );
                  // Refresh data
                  if (_selectedExercise != null) {
                    context
                        .read<PersonalBestProvider>()
                        .fetchPersonalBestHistory(
                            _selectedExercise!.supportedExerciseId);
                    context.read<PersonalBestProvider>().fetchExerciseProgress(
                        _selectedExercise!.supportedExerciseId);
                  }
                  context
                      .read<PersonalBestProvider>()
                      .fetchCurrentPersonalBests();
                }
              });
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final personalBestProvider = context.watch<PersonalBestProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal Bests"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Current Bests"),
            Tab(text: "History"),
          ],
        ),
      ),
      body: personalBestProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : personalBestProvider.hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Error: ${personalBestProvider.errorMessage}"),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          personalBestProvider.resetError();
                          personalBestProvider.fetchSupportedExercises();
                          personalBestProvider.fetchCurrentPersonalBests();
                        },
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildCurrentBestsTab(),
                    _buildHistoryTab(),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPersonalBestDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCurrentBestsTab() {
    final personalBestProvider = context.watch<PersonalBestProvider>();

    if (personalBestProvider.currentBests.isEmpty &&
        !personalBestProvider.isLoading) {
      return const Center(
        child: Text("No personal bests recorded yet"),
      );
    }

    return RefreshIndicator(
      onRefresh: () => personalBestProvider.fetchCurrentPersonalBests(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: personalBestProvider.currentBests.length,
        itemBuilder: (context, index) {
          final item = personalBestProvider.currentBests[index];
          final exercise = item['exercise'] as SupportedExercise;
          final personalBest = item['personalBest'] as PersonalBest?;

          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () => _viewExerciseHistory(exercise),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          exercise.exerciseName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.history),
                          onPressed: () => _viewExerciseHistory(exercise),
                          tooltip: 'View History',
                        ),
                      ],
                    ),
                    const Divider(),
                    if (personalBest != null) ...[
                      const Text(
                        "Current Best:",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildStatCard(
                            context,
                            "Weight",
                            "${personalBest.weight} kg",
                            Icons.fitness_center,
                          ),
                          const SizedBox(width: 16),
                          _buildStatCard(
                            context,
                            "Reps",
                            personalBest.reps.toString(),
                            Icons.repeat,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Achieved on: ${DateFormat('MMM d, yyyy').format(personalBest.achievedAt)}",
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ] else ...[
                      const Text(
                        "No personal best recorded yet",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHistoryTab() {
    final personalBestProvider = context.watch<PersonalBestProvider>();

    if (_selectedExercise == null) {
      return const Center(
        child: Text("Select an exercise to view history"),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedExercise!.exerciseName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "History & Progress",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer
                          .withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Log New Entry",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          _buildLogForm(),
          const SizedBox(height: 24),
          const Text(
            "History",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          if (personalBestProvider.personalBestHistory.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("No history found for this exercise"),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: personalBestProvider.personalBestHistory.length,
              itemBuilder: (context, index) {
                final record = personalBestProvider.personalBestHistory[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text("${record.weight} kg × ${record.reps} reps"),
                    subtitle: Text(
                        DateFormat('MMM d, yyyy').format(record.achievedAt)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _deleteRecord(record.personalBestId),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildLogForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(
                    labelText: "Weight (kg)",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Invalid number';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _repsController,
                  decoration: const InputDecoration(
                    labelText: "Reps",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Invalid number';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _logPersonalBest,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text("Log New Entry"),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      BuildContext context, String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPersonalBestDialog() {
    final personalBestProvider = context.read<PersonalBestProvider>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Log New Personal Best",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<SupportedExercise>(
                    decoration: const InputDecoration(
                      labelText: "Select Exercise",
                      border: OutlineInputBorder(),
                    ),
                    items:
                        personalBestProvider.supportedExercises.map((exercise) {
                      return DropdownMenuItem(
                        value: exercise,
                        child: Text(exercise.exerciseName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedExercise = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildLogForm(),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
