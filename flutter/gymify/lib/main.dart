// import 'package:flutter/material.dart';
// import 'package:gymify/providers/auth_provider/auth_provider.dart';
// import 'package:gymify/providers/exercise_provider/exercise_provider.dart';
// import 'package:gymify/providers/log_provider/log_provider.dart';
// import 'package:gymify/providers/workout_provider/workout_provider.dart';
// import 'package:gymify/routes/route_config.dart';
// import 'package:provider/provider.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => WorkoutProvider()),
//         ChangeNotifierProvider(create: (context) => ExerciseProvider()),
//         ChangeNotifierProvider(create: (context) => AuthProvider()),
//         ChangeNotifierProvider(create: (context) => WorkoutLogProvider()),
//       ],
//       child: MaterialApp.router(
//         debugShowCheckedModeBanner: false,
//         title: 'Gymify',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         routerConfig: router,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:gymify/providers/auth_provider/auth_provider.dart';
import 'package:gymify/providers/exercise_provider/exercise_provider.dart';
import 'package:gymify/providers/log_provider/log_provider.dart';
import 'package:gymify/providers/multipage_register_provider/register_provider.dart';
import 'package:gymify/providers/workout_provider/workout_provider.dart';
import 'package:gymify/routes/route_config.dart';
import 'package:gymify/colors/custom_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WorkoutProvider()),
        ChangeNotifierProvider(create: (context) => ExerciseProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => WorkoutLogProvider()),
        ChangeNotifierProvider(create: (context) => RegistrationProvider()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Gymify',
        theme: ThemeData(
          scaffoldBackgroundColor: CustomColors.backgroundLight,
          primaryColor: CustomColors.primary,
          colorScheme: ColorScheme.light(
            primary: CustomColors.primary,
            secondary: CustomColors.accent,
            onPrimary: CustomColors.lightText, // Text color on primary
            onSecondary: CustomColors.lightText,
          ),
          textTheme: GoogleFonts.poppinsTextTheme().copyWith(
            headlineLarge: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: CustomColors.lightText,
            ),
            headlineMedium: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: CustomColors.lightText,
            ),
            headlineSmall: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: CustomColors.lightText,
            ),
            bodyLarge: GoogleFonts.poppins(
              fontSize: 16,
              color: CustomColors.lightText,
            ),
            bodyMedium: GoogleFonts.poppins(
              fontSize: 14,
              color: CustomColors.lightText,
            ),
            bodySmall: GoogleFonts.poppins(
              fontSize: 12,
              color: CustomColors.lightText,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.primary,
              foregroundColor: CustomColors.darkText,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: CustomColors.primary,
            titleTextStyle: GoogleFonts.poppins(
              color: CustomColors.darkText,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: CustomColors.primaryShade2),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: CustomColors.primary),
              borderRadius: BorderRadius.circular(10),
            ),
            hintStyle: GoogleFonts.poppins(
              color: Colors.grey,
            ),
          ),
        ),
        routerConfig: router,
      ),
    );
  }
}
