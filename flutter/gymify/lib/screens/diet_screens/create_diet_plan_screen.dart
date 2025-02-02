import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gymify/providers/diet_provider/diet_provider.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Diet Plan'),
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
