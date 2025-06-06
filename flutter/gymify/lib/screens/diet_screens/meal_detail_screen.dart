import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gymify/models/deit_plan_models/meal_model.dart';
import 'package:gymify/providers/diet_provider/diet_provider.dart';
import 'package:gymify/utils/custom_snackbar.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class MealDetailScreen extends StatelessWidget {
  final Meal meal;

  const MealDetailScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<DietProvider>(context, listen: false);

    // Set system UI overlay style for immersive experience
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: theme.scaffoldBackgroundColor,
    ));

    // Parse macronutrients JSON
    final macroMap = _parseMacros(meal.macronutrients);
    final protein = macroMap['protein'] ?? 0.0;
    final carbs = macroMap['carbs'] ?? 0.0;
    final fat = macroMap['fat'] ?? 0.0;
    final calories = (protein * 4) + (carbs * 4) + (fat * 9);

    // Prepare data for PieChart
    final dataMap = {
      "Protein": protein,
      "Carbs": carbs,
      "Fat": fat,
    };

    // Colors for the chart segments
    final colorList = <Color>[
      Colors.blue, // Protein
      Colors.orange, // Carbs
      Colors.green, // Fat
    ];

    // Show quantity popup and log meal
    void showQuantityDialog() {
      int quantity = 1;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(
                  'Log Meal',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'How many servings of "${meal.mealName}" did you consume?',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.remove_circle,
                            color: theme.colorScheme.primary,
                            size: 36,
                          ),
                          onPressed: () {
                            if (quantity > 1) {
                              setState(() {
                                quantity--;
                              });
                            }
                          },
                        ),
                        Container(
                          width: 60,
                          height: 40,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: theme.colorScheme.primary),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              quantity.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.add_circle,
                            color: theme.colorScheme.primary,
                            size: 36,
                          ),
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Total calories: ${(calories * quantity).toStringAsFixed(0)} kcal',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.7)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                    ),
                    child: const Text('Log Meal'),
                    onPressed: () {
                      // Log the meal with selected quantity
                      provider.logMeal(
                        mealId: meal.mealId,
                        quantity: quantity.toDouble(),
                      );

                      final navigator = Navigator.of(context);

                      // Close the dialog first
                      navigator.pop();

                      // Delay pushNamed to next frame to ensure context is still valid
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        showCoolSnackBar(
                          navigator.context,
                          "$quantity serving(s) logged successfully!",
                          true,
                          customActions: [
                            SnackBarAction(
                              label: 'View Logs',
                              textColor: Colors.white,
                              onPressed: () {
                                // Ensure context is mounted before navigating
                                if (navigator.context.mounted) {
                                  navigator.context.pushNamed('mealLog');
                                }
                              },
                            ),
                          ],
                        );
                      });
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // App bar with image
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                stretch: true,
                backgroundColor: theme.colorScheme.primary,
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Meal image
                      meal.image.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: meal.image,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color:
                                    theme.colorScheme.primary.withOpacity(0.2),
                                child: const Center(
                                    child: CircularProgressIndicator()),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color:
                                    theme.colorScheme.primary.withOpacity(0.2),
                                child: const Icon(Icons.restaurant,
                                    size: 80, color: Colors.white54),
                              ),
                            )
                          : Container(
                              color: theme.colorScheme.primary,
                              child: const Icon(Icons.restaurant,
                                  size: 80, color: Colors.white54),
                            ),
                      // Gradient overlay for better text visibility
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                            stops: const [0.5, 1.0],
                          ),
                        ),
                      ),
                      // Meal information overlay
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Calories badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "${calories.toStringAsFixed(0)} CALORIES",
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Meal title
                              Text(
                                meal.mealName,
                                style: GoogleFonts.poppins(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quick info bar
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildInfoElement(
                            'PROTEIN',
                            '${protein.toStringAsFixed(1)}g',
                            FontAwesomeIcons.dna,
                            theme,
                          ),
                          _buildInfoElement(
                            'CARBS',
                            '${carbs.toStringAsFixed(1)}g',
                            FontAwesomeIcons.breadSlice,
                            theme,
                          ),
                          _buildInfoElement(
                            'FAT',
                            '${fat.toStringAsFixed(1)}g',
                            FontAwesomeIcons.oilWell,
                            theme,
                          ),
                        ],
                      ),
                    ),

                    // Description
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About This Meal',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            meal.description,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              height: 1.6,
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Divider
                    Divider(
                        color: theme.colorScheme.onSurface.withOpacity(0.1)),

                    // Nutrition Chart Section
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nutrition Information',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Pie Chart
                              SizedBox(
                                height: 160,
                                width: 160,
                                child: PieChart(
                                  dataMap: dataMap,
                                  animationDuration:
                                      const Duration(milliseconds: 800),
                                  chartRadius: 80,
                                  chartType: ChartType.ring,
                                  ringStrokeWidth: 16,
                                  colorList: colorList,
                                  centerText:
                                      '${calories.toStringAsFixed(0)}\nkcal',
                                  centerTextStyle: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                  legendOptions: const LegendOptions(
                                    showLegendsInRow: false,
                                    legendPosition: LegendPosition.bottom,
                                    showLegends: false,
                                  ),
                                  chartValuesOptions: const ChartValuesOptions(
                                    showChartValues: false,
                                  ),
                                ),
                              ),
                              // Macro details
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildMacroDetail(
                                    color: colorList[0],
                                    label: 'Protein',
                                    amount: protein,
                                    percentage: protein * 4 / calories * 100,
                                    theme: theme,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildMacroDetail(
                                    color: colorList[1],
                                    label: 'Carbs',
                                    amount: carbs,
                                    percentage: carbs * 4 / calories * 100,
                                    theme: theme,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildMacroDetail(
                                    color: colorList[2],
                                    label: 'Fat',
                                    amount: fat,
                                    percentage: fat * 9 / calories * 100,
                                    theme: theme,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Add padding at the bottom to ensure content isn't hidden behind the persistent action bar
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),

          // Persistent bottom action bar - Reduced height version
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8), // Reduced vertical padding from 12 to 8
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: true,
                top: false,
                child: Row(
                  children: [
                    // Log Meal Button - Primary action
                    Expanded(
                      flex: 3,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical:
                                  8), // Reduced vertical padding from 12 to 8
                          minimumSize: const Size.fromHeight(
                              36), // Added minimum height control
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.add_circle_outline,
                            size: 20), // Reduced icon size from default to 20
                        label: Text(
                          'Log This Meal',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                15, // Slightly reduced font size from 16 to 15
                          ),
                        ),
                        onPressed: showQuantityDialog,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // View History Button - Secondary action
                    Expanded(
                      flex: 2,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical:
                                  8), // Reduced vertical padding from 12 to 8
                          minimumSize: const Size.fromHeight(
                              36), // Added minimum height control
                          side: BorderSide(color: theme.colorScheme.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: Icon(
                          FontAwesomeIcons.clockRotateLeft,
                          size: 13, // Reduced icon size from 14 to 13
                          color: theme.colorScheme.primary,
                        ),
                        label: Text(
                          'Meal History',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                            fontSize: 13, // Reduced font size from 14 to 13
                          ),
                        ),
                        onPressed: () {
                          context.pushNamed('mealLog');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  Widget _buildInfoElement(
      String label, String value, IconData icon, ThemeData theme) {
    return Column(
      children: [
        Icon(
          icon,
          size: 22,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMacroDetail({
    required Color color,
    required String label,
    required double amount,
    required double percentage,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${amount.toStringAsFixed(1)}g (${percentage.toStringAsFixed(0)}%)',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Helper to parse JSON string for macronutrients
  Map<String, double> _parseMacros(String macroString) {
    try {
      final decoded = jsonDecode(macroString);
      if (decoded is Map) {
        return decoded.map<String, double>((key, value) {
          return MapEntry(key, (value as num).toDouble());
        });
      }
    } catch (e) {
      print('Error parsing macronutrients: $e');
    }
    return {"protein": 0.0, "carbs": 0.0, "fat": 0.0};
  }
}
