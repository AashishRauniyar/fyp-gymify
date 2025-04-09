// import 'package:flutter/material.dart';

// class AppColors {
//   // Light Theme Colors
//   // static const Color lightPrimary = Color(0xFF1C8EF7); // Electric Blue
//   // static const Color lightPrimary =Color.fromARGB(255, 152, 115, 50); // Electric purple
//   static const Color lightPrimary = Color(0xFF4A3298); // Electric purple
//   static const Color lightSecondary = Color(0xFF757575); // Grey Accent
//   static const Color lightSurface = Color(0xFFF8FAFC); // Soft White Surface
//   static const Color lightBackground = Color(0xFFFFFFFF); // Pure White
//   static const Color lightOnPrimary = Colors.white;
//   static const Color lightOnSecondary = Colors.black;
//   static const Color lightOnSurface = Colors.black;
//   static const Color lightError = Colors.redAccent;
//   static const Color lightOnError = Colors.white;

//   // Dark Theme Colors
//   // static const Color darkPrimary = Color(0xFF1C8EF7); // Electric Blue
//   static const Color darkPrimary = Color(0xFF4A3298); // Electric Purple
//   // static const Color darkPrimary =Color.fromARGB(255, 152, 115, 50); // Electric Purple
//   static const Color darkSecondary = Color(0xFF1A1A1A); // Dark Grey
//   static const Color darkSurface = Color(0xFF080808); // Deep Black Surface
//   static const Color darkBackground = Color(0xFF080808); // Dark Background
//   static const Color darkOnPrimary = Colors.white;
//   static const Color darkOnSecondary = Colors.white;
//   static const Color darkOnSurface = Colors.white;
//   static const Color darkError = Colors.redAccent;
//   static const Color darkOnError = Colors.black;

//   // Common Colors
//   static const Color buttonText = Colors.white;
//   static const Color inputFill =
//       Color(0xFF1A1A1A); // Dark Input Field Background
//   static const Color inputText =
//       Color(0xFFF8FAFC); // Light Text for Dark Fields
// }
import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors

  static const Color lightPrimary = Color(0xFF0A559E); // Deep Athletic Blue
  static const Color lightSecondary = Color(0xFF757575); // Grey Accent
  static const Color lightSurface = Color(0xFFF8FAFC); // Soft White Surface
  static const Color lightBackground = Color(0xFFFFFFFF); // Pure White
  static const Color lightOnPrimary = Colors.white;
  static const Color lightOnSecondary = Colors.black;
  static const Color lightOnSurface = Colors.black;
  static const Color lightError = Colors.redAccent;
  static const Color lightOnError = Colors.white;

  // Dark Theme Colors
  static const Color darkPrimary = Color(0xFF1D8EF8); // Darker Athletic Blue
  static const Color darkSecondary = Color(0xFF1A1A1A); // Dark Grey
  static const Color darkSurface = Color(0xFF121212); // Deep Grey Surface
  static const Color darkBackground =
      Color(0xFF1E1E1E); // Softer Dark Background (not pure black)
  static const Color darkOnPrimary = Colors.white;
  static const Color darkOnSecondary = Colors.white;
  static const Color darkOnSurface = Colors.white;
  static const Color darkError =
      Color(0xFFFF5252); // Brighter red for dark mode
  static const Color darkOnError = Colors.black;

  // Common Colors
  static const Color buttonText = Colors.white;
  static const Color inputFill =
      Color(0xFF2C2C2C); // Slightly lighter input field
  static const Color inputText =
      Color(0xFFF8FAFC); // Light Text for Dark Fields

  // Gym-specific accent colors
  static const Color energy =
      Color(0xFF4B89DC); // Medium blue for secondary elements
  static const Color success = Color(0xFF4CAF50); // Green for achievements
  static const Color intensity =
      Color(0xFF083D77); // Navy Blue for intensity levels
}
