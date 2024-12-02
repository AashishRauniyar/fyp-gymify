import 'package:flutter/material.dart';
import 'package:gymify/providers/exercise_provider/exercise_provider.dart';
import 'package:gymify/providers/workout_provider/workout_provider.dart';
import 'package:gymify/screens/exercise_screen.dart';
import 'package:gymify/screens/main_screens/workout_screen.dart';
import 'package:gymify/screens/test.dart';
import 'package:provider/provider.dart';

import 'package:gymify/screens/authentication/login.dart';
import 'package:gymify/screens/authentication/register.dart';
import 'package:gymify/screens/workout_screen.dart';

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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gymify',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(),
        routes: {
          '/register': (context) => const RegisterScreen(),
          '/login': (context) => LoginScreen(),
          '/home': (context) => const HomePage(),
          '/workouts': (context) => WorkoutListScreen(),
          '/exercises': (context) => const ExerciseScreen(),
        },
      ),
    );
  }
}
