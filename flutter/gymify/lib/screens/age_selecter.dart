import 'package:flutter/material.dart';

class WeightSelector extends StatefulWidget {
  @override
  _WeightSelectorState createState() => _WeightSelectorState();
}

class _WeightSelectorState extends State<WeightSelector> {
  double selectedWeight = 75.0; // Default weight
  bool isKg = true; // Unit toggle: true for KG, false for LB

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'What Is Your Weight?',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "What Is Your Weight?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Please scroll to select your weight.",
            style: TextStyle(color: Colors.white54, fontSize: 14),
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
                    color: isKg ? Colors.yellow : Colors.grey,
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
                    color: !isKg ? Colors.yellow : Colors.grey,
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
                    size: Size(15, 15),
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
                            color: isSelected ? Colors.yellow : Colors.grey,
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
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              // Add your onPressed action here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for Vertical Lines
class LineIndicatorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[600]!
      ..strokeWidth = 2;

    const double lineWidthSmall = 30; // Small lines width
    const double lineWidthBig = 60; // Major lines width
    const double spacing = 10; // Space between lines

    for (double i = 0; i < size.height; i += spacing) {
      bool isMajorLine = (i % 50 == 0); // Every 50th line is major
      canvas.drawLine(
        Offset(
            size.width / 2 - (isMajorLine ? lineWidthBig : lineWidthSmall) / 2,
            i),
        Offset(
            size.width / 2 + (isMajorLine ? lineWidthBig : lineWidthSmall) / 2,
            i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom Painter for Triangle Pointer
class TrianglePointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow
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
