import 'package:flutter/material.dart';
import 'package:gymify/models/personal_best_model.dart';
import 'package:gymify/models/supported_exercise_model.dart';
import 'package:gymify/providers/personal_best_provider/personal_best_provider.dart';
import 'package:provider/provider.dart';

class PersonalBestScreen extends StatefulWidget {
  const PersonalBestScreen({super.key});

  @override
  _PersonalBestScreenState createState() => _PersonalBestScreenState();
}

class _PersonalBestScreenState extends State<PersonalBestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _exerciseIdController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch supported exercises when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PersonalBestProvider>().fetchSupportedExercises();
      
      
    });
  }

  // Method to handle the form submission
  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final exerciseId = int.tryParse(_exerciseIdController.text);
      final weight = double.tryParse(_weightController.text);
      final reps = int.tryParse(_repsController.text);

      if (exerciseId != null && weight != null && reps != null) {
        context.read<PersonalBestProvider>().logPersonalBest(
              context: context,
              exerciseId: exerciseId,
              weight: weight,
              reps: reps,
            );
      } else {
        // Handle invalid input
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid input')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final personalBestProvider = context.watch<PersonalBestProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal Bests"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: personalBestProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : personalBestProvider.hasError
              ? const Center(child: Text("Error loading data"))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      // Form to log a new personal best
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _exerciseIdController,
                                decoration: const InputDecoration(
                                  labelText: "Exercise ID",
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter an Exercise ID';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _weightController,
                                decoration: const InputDecoration(
                                  labelText: "Weight (kg)",
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a weight';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _repsController,
                                decoration: const InputDecoration(
                                  labelText: "Reps",
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter reps';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _submitForm,
                                child: const Text("Log Personal Best"),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Display supported exercises and personal bests
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: personalBestProvider.supportedExercises.isEmpty
                            ? const Center(child: Text('No exercises found'))
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: personalBestProvider
                                    .supportedExercises.length,
                                itemBuilder: (context, index) {
                                  final exercise = personalBestProvider
                                      .supportedExercises[index];
                                  final personalBest = personalBestProvider
                                      .personalBestHistory
                                      .firstWhere(
                                    (pb) =>
                                        pb.supportedExerciseId ==
                                        exercise.supportedExerciseId,
                                    orElse: () => PersonalBest(
                                      personalBestId: 0,
                                      userId: 0,
                                      supportedExerciseId:
                                          exercise.supportedExerciseId,
                                      weight:
                                          "0", // Default if no personal best
                                      reps: 0,
                                      achievedAt: DateTime.now(),
                                    ),
                                  );

                                  return Container(
                                    padding: const EdgeInsets.all(12),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 16),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.2),
                                          Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.1),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          exercise.exerciseName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontSize: 18,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '${personalBest.weight} kg',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${personalBest.reps} reps',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
