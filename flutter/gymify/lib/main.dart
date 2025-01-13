// import 'package:flutter/material.dart';
// import 'package:gymify/providers/auth_provider/auth_provider.dart';
// import 'package:gymify/providers/custom_workout_provider/custom_workout_provider.dart';
// import 'package:gymify/providers/exercise_provider/exercise_provider.dart';
// import 'package:gymify/providers/log_provider/log_provider.dart';
// import 'package:gymify/providers/multipage_register_provider/register_provider.dart';
// import 'package:gymify/providers/profile_provider/profile_provider.dart';
// import 'package:gymify/providers/workout_provider/workout_provider.dart';
// import 'package:gymify/routes/route_config.dart';
// import 'package:gymify/colors/custom_colors.dart';
// import 'package:google_fonts/google_fonts.dart';
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
//         ChangeNotifierProvider(create: (context) => RegistrationProvider()),
//         ChangeNotifierProvider(create: (context) => CustomWorkoutProvider()),
//         ChangeNotifierProvider(create: (context) => ProfileProvider()),
//       ],
//       child: MaterialApp.router(
//         debugShowCheckedModeBanner: false,
//         title: 'Gymify',

//         // theme: ThemeData(
//         //   scaffoldBackgroundColor: CustomColors.backgroundColor,
//         //   primaryColor: CustomColors.primary,
//         //   colorScheme: ColorScheme.light(
//         //     primary: CustomColors.primary,
//         //     secondary: CustomColors.accent,
//         //     onPrimary: CustomColors.lightText, // Text color on primary
//         //     onSecondary: CustomColors.lightText,
//         //   ),
//         //   textTheme: GoogleFonts.montserratTextTheme().copyWith(
//         //     headlineLarge: GoogleFonts.montserrat(
//         //       fontSize: 32,
//         //       fontWeight: FontWeight.bold,
//         //       color: CustomColors.lightText,
//         //     ),
//         //     headlineMedium: GoogleFonts.montserrat(
//         //       fontSize: 24,
//         //       fontWeight: FontWeight.bold,
//         //       color: CustomColors.lightText,
//         //     ),
//         //     headlineSmall: GoogleFonts.montserrat(
//         //       fontSize: 20,
//         //       fontWeight: FontWeight.bold,
//         //       color: CustomColors.lightText,
//         //     ),
//         //     bodyLarge: GoogleFonts.montserrat(
//         //       color: CustomColors.lightText,
//         //       fontSize: 16,
//         //     ),
//         //     bodyMedium: GoogleFonts.montserrat(
//         //       fontSize: 14,
//         //       color: CustomColors.lightText,
//         //     ),
//         //     bodySmall: GoogleFonts.montserrat(
//         //       fontSize: 12,
//         //       color: CustomColors.lightText,
//         //     ),
//         //   ),
//         //   elevatedButtonTheme: ElevatedButtonThemeData(
//         //     style: ElevatedButton.styleFrom(
//         //       backgroundColor: CustomColors.primary,
//         //       foregroundColor: CustomColors.darkText,
//         //       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
//         //       shape: RoundedRectangleBorder(
//         //         borderRadius: BorderRadius.circular(12),
//         //       ),
//         //       textStyle: GoogleFonts.poppins(
//         //         fontWeight: FontWeight.bold,
//         //         fontSize: 16,
//         //       ),
//         //     ),
//         //   ),
//         //   appBarTheme: AppBarTheme(
//         //     backgroundColor: CustomColors.primary,
//         //     titleTextStyle: GoogleFonts.poppins(
//         //       color: CustomColors.darkText,
//         //       fontSize: 20,
//         //       fontWeight: FontWeight.bold,
//         //     ),
//         //     iconTheme: const IconThemeData(color: Colors.white),
//         //   ),
//         // ),
//         routerConfig: router,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:gymify/providers/socket_provider/socket_service.dart';
import 'package:gymify/theme/app_theme.dart';
import 'package:provider/provider.dart'; 
import 'package:gymify/providers/auth_provider/auth_provider.dart';
import 'package:gymify/providers/custom_workout_provider/custom_workout_provider.dart';
import 'package:gymify/providers/exercise_provider/exercise_provider.dart';
import 'package:gymify/providers/log_provider/log_provider.dart';
import 'package:gymify/providers/multipage_register_provider/register_provider.dart';
import 'package:gymify/providers/profile_provider/profile_provider.dart';
import 'package:gymify/providers/workout_provider/workout_provider.dart';
import 'package:gymify/routes/route_config.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WorkoutProvider()),
        ChangeNotifierProvider(create: (context) => ExerciseProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => WorkoutLogProvider()),
        ChangeNotifierProvider(create: (context) => RegistrationProvider()),
        ChangeNotifierProvider(create: (context) => CustomWorkoutProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => ThemeNotifier()), // Add ThemeNotifier
        ChangeNotifierProvider(create: (context) => SocketProvider()), // Add ThemeNotifier
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp.router(  
      debugShowCheckedModeBanner: false,
      title: 'Gymify',
      theme: AppTheme.lightTheme, // Light theme
      darkTheme: AppTheme.darkTheme, // Dark theme
      themeMode: themeNotifier.themeMode, // Dynamically switch themes
      routerConfig: router, // Use your routing configuration
    );
  }
}
