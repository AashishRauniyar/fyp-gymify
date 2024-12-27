import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/colors/custom_colors.dart';
import 'package:gymify/providers/multipage_register_provider/register_provider.dart';
import 'package:gymify/utils/custom_button.dart';
import 'package:provider/provider.dart';

class HeightSelector extends StatefulWidget {
  const HeightSelector({super.key});

  @override
  _HeightSelectorState createState() => _HeightSelectorState();
}

class _HeightSelectorState extends State<HeightSelector> {
  double selectedHeight = 170.0; // Default height in CM

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "What Is Your Height?",
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Please scroll to select your height.",
            style: TextStyle(color: Color(0xFF666666), fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 96,
                  left:
                      138, // Adjust this value to move the triangle to the left
                  child: CustomPaint(
                    size: Size(15, 15),
                    painter: TrianglePointerPainter(),
                  ),
                ),
                // Height selector
                ListWheelScrollView.useDelegate(
                  itemExtent: 50,
                  diameterRatio: 1.4,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedHeight =
                          120.0 + (index * 0.1); // CM range 120 to 220
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      double heightValue = 120.0 + (index * 0.1);
                      bool isSelected = heightValue.toStringAsFixed(1) ==
                          selectedHeight.toStringAsFixed(1);
                      return Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: TextStyle(
                            fontSize: isSelected ? 36 : 24,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? CustomColors.primary
                                : CustomColors.secondary,
                          ),
                          child: Text(heightValue.toStringAsFixed(1)),
                        ),
                      );
                    },
                    childCount: 1001, // Height range from 120 to 220 cm
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "${selectedHeight.toStringAsFixed(1)} cm",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          CustomButton(
              text: "Continue",
              onPressed: () {
                provider.setHeight(selectedHeight);
                if (provider.height > 0) {
                  context.go('/register/weight');
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
      ..color = Color(0xFFFF5E3A)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
