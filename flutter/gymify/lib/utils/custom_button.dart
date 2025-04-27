import 'package:flutter/material.dart';
import 'package:gymify/colors/app_colors.dart';
import 'package:gymify/colors/custom_colors.dart'; // Assuming this is where your TextWidget is

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final double height;
  final double fontSize;
  final Color textColor;
  final double? width; // Optional width parameter

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = AppColors.darkPrimary, // Default color if not provided
    this.height = 56.0, // Default height if not provided
    this.fontSize = 16.0,
    this.textColor =
        CustomColors.buttonText, // Default text color if not provided
    this.width, // Optional width parameter
  });

  @override
  Widget build(BuildContext context) {
    // Get the screen width for flexibility
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width ??
          screenWidth *
              0.9, // Use the provided width or default to 90% of the screen width
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero, // Remove default padding
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
