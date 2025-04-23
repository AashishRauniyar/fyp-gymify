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
  final _descriptionController = TextEditingController();
  // Controllers for macronutrients
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();

  // Calories will be calculated automatically
  double _calculatedCalories = 0;

  MealTime? _selectedMealTime;
  File? mealImage;

  @override
  void initState() {
    super.initState();
    // Add listeners to calculate calories when any macronutrient value changes
    _proteinController.addListener(_calculateCalories);
    _carbsController.addListener(_calculateCalories);
    _fatController.addListener(_calculateCalories);
  }

  // Calculate calories based on macronutrient values
  void _calculateCalories() {
    double protein = double.tryParse(_proteinController.text) ?? 0;
    double carbs = double.tryParse(_carbsController.text) ?? 0;
    double fat = double.tryParse(_fatController.text) ?? 0;

    // Calories calculation: protein (4 cal/g) + carbs (4 cal/g) + fat (9 cal/g)
    double calories = (protein * 4) + (carbs * 4) + (fat * 9);

    setState(() {
      _calculatedCalories = calories;
    });
  }

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
                    child: Text(
                      mealTimeToString(time),
                      style: theme.textTheme.bodyMedium?.copyWith(),
                    ),
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
              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              const SizedBox(height: 20),

              // Macronutrients Section with Label
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest
                      .withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.analytics_outlined,
                          color: theme.colorScheme.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Macronutrients",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _proteinController,
                            decoration: const InputDecoration(
                              labelText: "Protein (g)",
                              suffixText: "g",
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
                              suffixText: "g",
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
                              suffixText: "g",
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
                    const SizedBox(height: 16),

                    // Auto-calculated calories display
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.primaryContainer.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Calories:",
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                          Text(
                            "${_calculatedCalories.toStringAsFixed(0)} kcal",
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        "Calculated automatically: (protein×4) + (carbs×4) + (fat×9)",
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: theme.colorScheme.onSurfaceVariant
                              .withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // Meal Image Picker
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Meal Image",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: GestureDetector(
                      onTap: _pickMealImage,
                      child: Container(
                        width: 200,
                        height: 150,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.outline.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: mealImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  mealImage!,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate,
                                    size: 48,
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.7),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Add Meal Image",
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Create Meal Button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final mealName = _mealNameController.text;
                    final mealTime = _selectedMealTime != null
                        ? mealTimeToString(_selectedMealTime!)
                        : "";
                    final description = _descriptionController.text;
                    // Get macronutrients values
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
                        calories:
                            _calculatedCalories, // Use calculated calories
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
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Provider.of<DietProvider>(context).isLoading
                    ? const CustomLoadingAnimation()
                    : const Text("Create Meal",
                        style: TextStyle(fontWeight: FontWeight.bold)),
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
