import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gymify/providers/ai_chatbot_provider/ai_chatbot_provider.dart';
import 'package:gymify/providers/attendance_provider/attendance_provider.dart';
import 'package:gymify/providers/chat_provider/chat_service.dart';
import 'package:gymify/providers/chat_provider/trainer_provider.dart';
import 'package:gymify/providers/diet_provider/diet_provider.dart';
import 'package:gymify/providers/membership_provider/membership_provider.dart';
import 'package:gymify/providers/multipage_register_provider/signup_provider.dart';
import 'package:gymify/providers/pedometer_provider/pedometer_provider.dart';
import 'package:gymify/providers/personal_best_provider/personal_best_provider.dart';
import 'package:gymify/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:gymify/providers/auth_provider/auth_provider.dart';
import 'package:gymify/providers/custom_workout_provider/custom_workout_provider.dart';
import 'package:gymify/providers/exercise_provider/exercise_provider.dart';
import 'package:gymify/providers/log_provider/log_provider.dart';
import 'package:gymify/providers/profile_provider/profile_provider.dart';
import 'package:gymify/providers/workout_provider/workout_provider.dart';
import 'package:gymify/routes/route_config.dart';

void main() async {
  await dotenv.load(fileName: "lib/.env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WorkoutProvider()),
        ChangeNotifierProvider(create: (context) => ExerciseProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => WorkoutLogProvider()),
        ChangeNotifierProvider(create: (context) => CustomWorkoutProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(
            create: (context) => ThemeNotifier()), // Add ThemeNotifier
        ChangeNotifierProvider(
            create: (context) => TrainerProvider()), // Add SocketProvider
        ChangeNotifierProvider(create: (context) => ChatProvider()), //
        ChangeNotifierProvider(create: (context) => PersonalBestProvider()), //
        ChangeNotifierProvider(create: (context) => DietProvider()), //
        ChangeNotifierProvider(create: (context) => SignupProvider()),
        ChangeNotifierProvider(create: (context) => MembershipProvider()),
        ChangeNotifierProvider(create: (context) => PedometerProvider()),
        ChangeNotifierProvider(create: (context) => AttendanceProvider()),
        ChangeNotifierProvider(
            create: (context) => AIChatbotProvider(
                // Add AIChatbotProvider
                apiKey: dotenv.env['GEMINI_API_KEY']!)),
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
