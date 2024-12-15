import 'package:flutter/material.dart';

class CustomColors {
  // Primary Colors
  static Color primary = const Color.fromARGB(255, 136, 129, 252); // rgb(136, 129, 252)
  static Color primaryShade1 = const Color.fromARGB(230, 136, 129, 252);
  static Color primaryShade2 = const Color.fromARGB(200, 136, 129, 252);

  // Complementary Colors
  static Color primaryCompliment = const Color.fromARGB(255, 252, 129, 136); // rgb(252, 129, 136)
  static Color primaryComplimentShade1 = const Color.fromARGB(230, 252, 129, 136);
  static Color primaryComplimentShade2 = const Color.fromARGB(200, 252, 129, 136);

  // Additional Colors
  static Color backgroundLight = const Color.fromARGB(255, 245, 246, 250); // rgb(245, 246, 250)
  static Color accent = const Color.fromARGB(255, 113, 101, 227); // rgb(113, 101, 227)

  // Text Colors
  static Color darkText = const Color.fromARGB(255, 255, 255, 255);
  static Color lightText = const Color.fromARGB(255, 0, 0, 0);

  // white color
  static Color white = const Color.fromARGB(255, 255, 255, 255);

  // Gradients
  static LinearGradient primaryGradient = const LinearGradient(
    colors: [
      Color.fromARGB(255, 136, 129, 252),
      Color.fromARGB(255, 113, 101, 227),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient complimentGradient = const LinearGradient(
    colors: [
      Color.fromARGB(255, 252, 129, 136),
      Color.fromARGB(230, 252, 129, 136),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
