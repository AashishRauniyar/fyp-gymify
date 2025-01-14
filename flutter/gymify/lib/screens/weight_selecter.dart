import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/providers/multipage_register_provider/register_provider.dart';
import 'package:gymify/utils/custom_button.dart';
import 'package:provider/provider.dart';

class WeightSelector extends StatefulWidget {
  const WeightSelector({super.key});

  @override
  _WeightSelectorState createState() => _WeightSelectorState();
}

class _WeightSelectorState extends State<WeightSelector> {
  double selectedWeight = 75.0; // Default weight
  bool isKg = true; // Unit toggle: true for KG, false for LB

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "What Is Your Weight?",
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Please scroll to select your weight.",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isKg = true;
                  });
                },
                child: Text(
                  "KG",
                  style: TextStyle(
                    fontSize: 18,
                    // use FF5E3A color
                    color: isKg
                        ? theme.colorScheme.primary
                        : theme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isKg = false;
                  });
                },
                child: Text(
                  "LB",
                  style: TextStyle(
                    fontSize: 18,
                    color: !isKg
                        ? theme.colorScheme.primary
                        : theme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Add vertical indicator lines

                // Add triangle pointer
                // Inside the Stack
                Positioned(
                  top: 96,
                  left:
                      138, // Adjust this value to move the triangle to the left
                  child: CustomPaint(
                    size: const Size(15, 15),
                    painter: TrianglePointerPainter(),
                  ),
                ),
                // Weight selector
                ListWheelScrollView.useDelegate(
                  itemExtent: 50,
                  diameterRatio: 1.4,
                  physics: const FixedExtentScrollPhysics(), // Smooth snapping
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedWeight = 40.0 + (index * 0.1).toDouble();
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      double weightValue = 40.0 + (index * 0.1);
                      bool isSelected = weightValue.toStringAsFixed(1) ==
                          selectedWeight.toStringAsFixed(1);
                      return Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: TextStyle(
                            fontSize: isSelected ? 36 : 24,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? theme.colorScheme.primary
                                : Theme.of(context).colorScheme.inverseSurface,
                          ),
                          child: Text(weightValue.toStringAsFixed(1)),
                        ),
                      );
                    },
                    childCount: 1001, // Example: Weight range 40.0 to 140.0
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "${selectedWeight.toStringAsFixed(1)} ${isKg ? 'Kg' : 'Lb'}",
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          CustomButton(
              text: "Continue",
              onPressed: () {
                provider.setWeight(selectedWeight);
                if (provider.weight > 0) {
                  context.go('/register/fitnesslevel');
                }
              }),
        ],
      ),
    );
  }
}

// Custom Painter for Triangle Pointer
class TrianglePointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF5E3A)
      ..style = PaintingStyle.fill;

    // Create a right-pointing triangle
    final path = Path();
    path.moveTo(0, 0); // Top left
    path.lineTo(size.width, size.height / 2); // Middle right
    path.lineTo(0, size.height); // Bottom left
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
