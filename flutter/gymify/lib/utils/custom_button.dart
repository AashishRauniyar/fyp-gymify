import 'package:flutter/material.dart'; // Assuming this is where your TextWidget is

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final double height;
  final double fontSize;
  final Color textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = const Color(0xFF37BD6B), // Default color if not provided
    this.height = 40.0, // Default height if not provided
    this.fontSize = 16.0,
    this.textColor  =  Colors.white// Default font size if not provided
  });

  @override
  Widget build(BuildContext context) {
    // Get the screen width for flexibility
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: screenWidth * 0.8, // 80% of the screen width, adjust as needed
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
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
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
