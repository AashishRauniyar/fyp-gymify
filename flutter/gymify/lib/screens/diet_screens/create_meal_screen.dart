// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:gymify/providers/diet_provider/diet_provider.dart';
// import 'package:gymify/utils/custom_appbar.dart';
// import 'package:gymify/utils/custom_snackbar.dart';
// import 'package:provider/provider.dart';

// enum MealTime {
//   Breakfast,
//   Lunch,
//   Dinner,
//   Snack,
// }

// String mealTimeToString(MealTime time) {
//   switch (time) {
//     case MealTime.Breakfast:
//       return "Breakfast";
//     case MealTime.Lunch:
//       return "Lunch";
//     case MealTime.Dinner:
//       return "Dinner";
//     case MealTime.Snack:
//       return "Snack";
//   }
// }

// class CreateMealScreen extends StatefulWidget {
//   final int dietPlanId;
//   const CreateMealScreen({super.key, required this.dietPlanId});

//   @override
//   State<CreateMealScreen> createState() => _CreateMealScreenState();
// }

// class _CreateMealScreenState extends State<CreateMealScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _mealNameController = TextEditingController();
//   final _caloriesController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _macronutrientsController = TextEditingController();

//   MealTime? _selectedMealTime;
//   File? mealImage;

//   // Use ImagePicker similar to your exercise screen to pick an image
//   Future<void> _pickMealImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         mealImage = File(pickedFile.path);
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _mealNameController.dispose();
//     _caloriesController.dispose();
//     _descriptionController.dispose();
//     _macronutrientsController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final dietProvider = Provider.of<DietProvider>(context);
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: const CustomAppBar(title: "Create Meal"),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               // Meal Name
//               TextFormField(
//                 controller: _mealNameController,
//                 decoration: const InputDecoration(labelText: "Meal Name"),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Please enter a meal name";
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 12),
//               // Dropdown for Meal Time
//               DropdownButtonFormField<MealTime>(
//                 value: _selectedMealTime,
//                 decoration: const InputDecoration(labelText: "Meal Time"),
//                 items: MealTime.values.map((time) {
//                   return DropdownMenuItem(
//                     value: time,
//                     child: Text(mealTimeToString(time)),
//                   );
//                 }).toList(),
//                 onChanged: (MealTime? newValue) {
//                   setState(() {
//                     _selectedMealTime = newValue;
//                   });
//                 },
//                 validator: (value) {
//                   if (value == null) return "Please select meal time";
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 12),
//               // Calories
//               TextFormField(
//                 controller: _caloriesController,
//                 decoration: const InputDecoration(labelText: "Calories"),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Please enter calories";
//                   }
//                   if (double.tryParse(value) == null) {
//                     return "Please enter a valid number";
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 12),
//               // Description
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(labelText: "Description"),
//               ),
//               const SizedBox(height: 12),
//               // Macronutrients as a JSON string (e.g., {"protein":25,"carbs":40,"fat":10})
//               TextFormField(
//                 controller: _macronutrientsController,
//                 decoration: const InputDecoration(labelText: "Macronutrients (JSON)"),
//                 validator: (value) {
//                   if (value != null && value.isNotEmpty) {
//                     try {
//                       jsonDecode(value);
//                     } catch (e) {
//                       return "Invalid JSON format";
//                     }
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 12),
//               // Meal Image Picker
//               Row(
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: _pickMealImage,
//                     icon: const Icon(Icons.image),
//                     label: const Text("Select Image"),
//                   ),
//                   const SizedBox(width: 12),
//                   if (mealImage != null)
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.file(
//                         mealImage!,
//                         width: 80,
//                         height: 80,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               // Create Meal Button
//               ElevatedButton(
//                 onPressed: () async {
//                   if (_formKey.currentState!.validate()) {
//                     final mealName = _mealNameController.text;
//                     final mealTime = _selectedMealTime != null
//                         ? mealTimeToString(_selectedMealTime!)
//                         : "";
//                     final calories = double.tryParse(_caloriesController.text) ?? 0;
//                     final description = _descriptionController.text;
//                     final macronutrientsText = _macronutrientsController.text;
//                     Map<String, dynamic>? macronutrients;
//                     if (macronutrientsText.isNotEmpty) {
//                       macronutrients = jsonDecode(macronutrientsText);
//                     }
//                     // Pass the image file path if an image is selected
//                     // final imageFilePath = mealImage != null ? mealImage!.path : "";

//                     await dietProvider.createMeal(
//                       dietPlanId: widget.dietPlanId,
//                       mealName: mealName,
//                       mealTime: mealTime,
//                       calories: calories,
//                       description: description,
//                       macronutrients: macronutrients,
//                       mealImage: mealImage,
//                     );

//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text("Meal created successfully")),
//                     );
//                     Navigator.of(context).pop();
//                   }
//                 },
//                 child: dietProvider.isLoading
//                     ? const CircularProgressIndicator()
//                     : const Text("Create Meal"),
//               ),
//               if (dietProvider.hasError)
//                 const Padding(
//                   padding: EdgeInsets.only(top: 12),
//                   child: Text(
//                     "Error creating meal",
//                     style: TextStyle(color: Colors.red),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gymify/providers/diet_provider/diet_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:gymify/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';

enum MealTime {
  Breakfast,
  Lunch,
  Dinner,
  Snack,
}

String mealTimeToString(MealTime time) {
  switch (time) {
    case MealTime.Breakfast:
      return "Breakfast";
    case MealTime.Lunch:
      return "Lunch";
    case MealTime.Dinner:
      return "Dinner";
    case MealTime.Snack:
      return "Snack";
  }
}

class CreateMealScreen extends StatefulWidget {
  final int dietPlanId;
  const CreateMealScreen({super.key, required this.dietPlanId});

  @override
  State<CreateMealScreen> createState() => _CreateMealScreenState();
}

class _CreateMealScreenState extends State<CreateMealScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mealNameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _descriptionController = TextEditingController();
  // New controllers for macronutrients
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();

  MealTime? _selectedMealTime;
  File? mealImage;

  // Use ImagePicker to pick an image
  Future<void> _pickMealImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        mealImage = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _mealNameController.dispose();
    _caloriesController.dispose();
    _descriptionController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dietProvider = Provider.of<DietProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: "Create Meal"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Meal Name
              TextFormField(
                controller: _mealNameController,
                decoration: const InputDecoration(labelText: "Meal Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a meal name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              // Dropdown for Meal Time
              DropdownButtonFormField<MealTime>(
                value: _selectedMealTime,
                decoration: const InputDecoration(labelText: "Meal Time"),
                items: MealTime.values.map((time) {
                  return DropdownMenuItem(
                    value: time,
                    child: Text(mealTimeToString(time)),
                  );
                }).toList(),
                onChanged: (MealTime? newValue) {
                  setState(() {
                    _selectedMealTime = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) return "Please select meal time";
                  return null;
                },
              ),
              const SizedBox(height: 12),
              // Calories
              TextFormField(
                controller: _caloriesController,
                decoration: const InputDecoration(labelText: "Calories"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter calories";
                  }
                  if (double.tryParse(value) == null) {
                    return "Please enter a valid number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              const SizedBox(height: 12),
              // Macronutrients: Protein, Carbs, Fat
              Text(
                "Macronutrients",
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _proteinController,
                      decoration: const InputDecoration(
                        labelText: "Protein (g)",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter protein";
                        }
                        if (double.tryParse(value) == null) {
                          return "Invalid number";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _carbsController,
                      decoration: const InputDecoration(
                        labelText: "Carbs (g)",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter carbs";
                        }
                        if (double.tryParse(value) == null) {
                          return "Invalid number";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _fatController,
                      decoration: const InputDecoration(
                        labelText: "Fat (g)",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter fat";
                        }
                        if (double.tryParse(value) == null) {
                          return "Invalid number";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Meal Image Picker
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickMealImage,
                    icon: const Icon(Icons.image),
                    label: const Text("Select Image"),
                  ),
                  const SizedBox(width: 12),
                  if (mealImage != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        mealImage!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              // Create Meal Button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final mealName = _mealNameController.text;
                    final mealTime = _selectedMealTime != null
                        ? mealTimeToString(_selectedMealTime!)
                        : "";
                    final calories =
                        double.tryParse(_caloriesController.text) ?? 0;
                    final description = _descriptionController.text;
                    // Combine the separate macronutrient values into a map.
                    final protein =
                        double.tryParse(_proteinController.text) ?? 0;
                    final carbs = double.tryParse(_carbsController.text) ?? 0;
                    final fat = double.tryParse(_fatController.text) ?? 0;
                    final macronutrients = {
                      "protein": protein,
                      "carbs": carbs,
                      "fat": fat,
                    };

                    try {
                      await Provider.of<DietProvider>(context, listen: false)
                          .createMeal(
                        dietPlanId: widget.dietPlanId,
                        mealName: mealName,
                        mealTime: mealTime,
                        calories: calories,
                        description: description,
                        macronutrients: macronutrients,
                        mealImage: mealImage,
                      );

                      await Provider.of<DietProvider>(context, listen: false)
                          .fetchAllDietPlans();
                      if (context.mounted) {
                        showCoolSnackBar(
                            context, "Meal Successfully Created", true);
                        Navigator.of(context).pop();
                      }
                    } catch (e) {
                      showCoolSnackBar(
                          context, "Error creating meal: $e", false);
                    }
                  }
                },
                child: Provider.of<DietProvider>(context).isLoading
                    ? const CustomLoadingAnimation()
                    : const Text("Create Meal"),
              ),
              if (Provider.of<DietProvider>(context).hasError)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    "Error creating meal",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
