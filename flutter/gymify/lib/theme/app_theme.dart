import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymify/colors/app_colors.dart';
// Import the AppColors class

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.lightBackground,
      primaryColor: AppColors.lightPrimary,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimary,
        secondary: AppColors.lightSecondary,
        surface: AppColors.lightSurface,
        onPrimary: AppColors.lightOnPrimary,
        onSecondary: AppColors.lightOnSecondary,
        onSurface: AppColors.lightOnSurface,
        error: AppColors.lightError,
        onError: AppColors.lightOnError,
      ),
      textTheme: _textTheme(AppColors.lightOnSurface),
      elevatedButtonTheme: _elevatedButtonTheme(AppColors.lightPrimary),
      outlinedButtonTheme: _outlinedButtonTheme(AppColors.lightPrimary),
      appBarTheme: _appBarTheme(AppColors.lightPrimary),
      inputDecorationTheme: _inputDecorationTheme(
        AppColors.lightOnSurface,
        AppColors.lightPrimary,
      ),
      cardTheme: _cardTheme(AppColors.lightSurface),
      floatingActionButtonTheme: _fabTheme(AppColors.lightPrimary),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.darkBackground,
      primaryColor: AppColors.darkPrimary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        secondary: AppColors.darkSecondary,
        surface: AppColors.darkSurface,
        onPrimary: AppColors.darkOnPrimary,
        onSecondary: AppColors.darkOnSecondary,
        onSurface: AppColors.darkOnSurface,
        error: AppColors.darkError,
        onError: AppColors.darkOnError,
      ),
      textTheme: _textTheme(AppColors.darkOnSurface),
      elevatedButtonTheme: _elevatedButtonTheme(AppColors.darkPrimary),
      outlinedButtonTheme: _outlinedButtonTheme(AppColors.darkPrimary),
      appBarTheme: _appBarTheme(AppColors.darkPrimary),
      inputDecorationTheme: _inputDecorationTheme(
        AppColors.darkOnSurface,
        AppColors.darkPrimary,
      ),
      cardTheme: _cardTheme(AppColors.darkSurface),
      floatingActionButtonTheme: _fabTheme(AppColors.darkPrimary),
    );
  }

  static TextTheme _textTheme(Color textColor) {
    return GoogleFonts.poppinsTextTheme().copyWith(
      headlineLarge: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        color: textColor,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 13,
        color: textColor,
      ),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(Color primaryColor) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: AppColors.buttonText,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme(Color primaryColor) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: primaryColor, width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
    );
  }

  static AppBarTheme _appBarTheme(Color primaryColor) {
    return AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.lightOnPrimary,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(
      Color textColor, Color primaryColor) {
    return InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      filled: true,
      // fillColor: AppColors.inputFill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: primaryColor, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: AppColors.lightSecondary.withOpacity(0.2), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      labelStyle: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      hintStyle: GoogleFonts.poppins(
        fontSize: 16,
        color: textColor.withOpacity(0.6),
      ),
    );
  }

  static CardTheme _cardTheme(Color cardColor) {
    return CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(8),
      color: cardColor,
    );
  }

  static FloatingActionButtonThemeData _fabTheme(Color primaryColor) {
    return FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: AppColors.buttonText,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDarkMode) {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
