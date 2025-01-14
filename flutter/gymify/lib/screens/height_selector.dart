import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:gymify/providers/multipage_register_provider/register_provider.dart';
import 'package:gymify/utils/custom_button.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  "What is your height?",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "Scroll to select your height.",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
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
                        left: 110,
                        child: CustomPaint(
                          size: const Size(15, 15),
                          painter: TrianglePointerPainter(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      ListWheelScrollView.useDelegate(
                        itemExtent: 50,
                        diameterRatio: 1.4,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedHeight = 120.0 + index * 0.1;
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            double heightValue = 120.0 + index * 0.1;
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
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurface
                                          .withOpacity(0.6),
                                ),
                                child: Text(heightValue.toStringAsFixed(1)),
                              ),
                            );
                          },
                          childCount: 1001,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "${selectedHeight.toStringAsFixed(1)} cm",
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            CustomButton(
              text: "CONTINUE",
              onPressed: () {
                provider.setHeight(selectedHeight);
                if (provider.height > 0) {
                  context.pushNamed('weight');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter for Triangle Pointer
class TrianglePointerPainter extends CustomPainter {
  final Color color;

  TrianglePointerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
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
