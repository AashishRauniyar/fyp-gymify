import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gymify/providers/diet_provider/diet_provider.dart';
import 'package:go_router/go_router.dart';

// class CreateDietPlanScreen extends StatefulWidget {
//   const CreateDietPlanScreen({super.key});

//   @override
//   State<CreateDietPlanScreen> createState() => _CreateDietPlanScreenState();
// }

// class _CreateDietPlanScreenState extends State<CreateDietPlanScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _goalTypeController = TextEditingController();
//   final _calorieGoalController = TextEditingController();
//   final _descriptionController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<DietProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create Diet Plan'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: 'Diet Plan Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _goalTypeController,
//                 decoration: const InputDecoration(labelText: 'Goal Type'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a goal type';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _calorieGoalController,
//                 decoration: const InputDecoration(labelText: 'Calorie Goal'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a calorie goal';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(labelText: 'Description'),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState?.validate() ?? false) {
//                     final name = _nameController.text;
//                     final goalType = _goalTypeController.text;
//                     final calorieGoal = double.tryParse(_calorieGoalController.text);
//                     final description = _descriptionController.text;

//                     if (calorieGoal != null) {
//                       provider.createDietPlan(
//                         name: name,
//                         calorieGoal: calorieGoal,
//                         goalType: goalType,
//                         description: description,
//                       );
//                     }
//                   }
//                 },
//                 child: provider.isLoading
//                     ? const CircularProgressIndicator()
//                     : const Text('Create Diet Plan'),
//               ),
//               if (provider.hasError) const Text('Error creating diet plan')
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class CreateDietPlanScreen extends StatefulWidget {
  const CreateDietPlanScreen({super.key});

  @override
  State<CreateDietPlanScreen> createState() => _CreateDietPlanScreenState();
}

class _CreateDietPlanScreenState extends State<CreateDietPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _goalTypeController = TextEditingController();
  final _calorieGoalController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DietProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Create Exercise",
          style: theme.textTheme.headlineSmall,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_sharp,
              color: Color(0xFFFF5E3A)),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop(); // Navigate back to the previous page
            } else {
              context
                  .pop(); // Navigate to the welcome page if there's nothing to pop
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Diet Plan Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _goalTypeController,
                decoration: const InputDecoration(labelText: 'Goal Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a goal type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _calorieGoalController,
                decoration: const InputDecoration(labelText: 'Calorie Goal'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a calorie goal';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final name = _nameController.text;
                    final goalType = _goalTypeController.text;
                    final calorieGoal =
                        double.tryParse(_calorieGoalController.text);
                    final description = _descriptionController.text;

                    if (calorieGoal != null) {
                      provider.createDietPlan(
                        name: name,
                        calorieGoal: calorieGoal,
                        goalType: goalType,
                        description: description,
                      );
                    }
                  }
                },
                child: provider.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Create Diet Plan'),
              ),
              if (provider.hasError) const Text('Error creating diet plan')
            ],
          ),
        ),
      ),
    );
  }
}

// class CreateDietPlanScreen extends StatefulWidget {
//   const CreateDietPlanScreen({super.key});

//   @override
//   State<CreateDietPlanScreen> createState() => _CreateDietPlanScreenState();
// }

// class _CreateDietPlanScreenState extends State<CreateDietPlanScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _goalTypeController = TextEditingController();
//   final _calorieGoalController = TextEditingController();
//   final _descriptionController = TextEditingController();

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _goalTypeController.dispose();
//     _calorieGoalController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   Future<void> _submitForm(DietProvider provider) async {
//     if (_formKey.currentState?.validate() ?? false) {
//       final name = _nameController.text;
//       final goalType = _goalTypeController.text;
//       final calorieGoal = double.tryParse(_calorieGoalController.text);
//       final description = _descriptionController.text;

//       if (calorieGoal != null) {
//         try {
//           await provider.createDietPlan(
//             name: name,
//             calorieGoal: calorieGoal,
//             goalType: goalType,
//             description: description,
//           );

//           if (!mounted) return;

//           // Show success snackbar
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Diet plan created successfully!'),
//               backgroundColor: Colors.green,
//             ),
//           );

//           // Navigate back to the previous screen after success
//           Navigator.pop(context);
//         } catch (e) {
//           if (!mounted) return;

//           // Show failure snackbar
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Failed to create diet plan: $e'),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<DietProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create Diet Plan'),
//       ),
//       body: provider.isLoading
//           ? const Center(child: CircularProgressIndicator()) // Loading screen
//           : Padding(
//               padding: const EdgeInsets.all(16),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       controller: _nameController,
//                       decoration: const InputDecoration(labelText: 'Diet Plan Name'),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter a name';
//                         }
//                         return null;
//                       },
//                     ),
//                     TextFormField(
//                       controller: _goalTypeController,
//                       decoration: const InputDecoration(labelText: 'Goal Type'),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter a goal type';
//                         }
//                         return null;
//                       },
//                     ),
//                     TextFormField(
//                       controller: _calorieGoalController,
//                       decoration: const InputDecoration(labelText: 'Calorie Goal'),
//                       keyboardType: TextInputType.number,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter a calorie goal';
//                         }
//                         return null;
//                       },
//                     ),
//                     TextFormField(
//                       controller: _descriptionController,
//                       decoration: const InputDecoration(labelText: 'Description'),
//                     ),
//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: provider.isLoading ? null : () => _submitForm(provider),
//                       child: provider.isLoading
//                           ? const CircularProgressIndicator()
//                           : const Text('Create Diet Plan'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }
