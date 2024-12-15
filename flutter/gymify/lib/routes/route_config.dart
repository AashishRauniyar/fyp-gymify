import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/screens/exercise_screen.dart';
import 'package:gymify/screens/main_screen/main_screen.dart';
import 'package:gymify/screens/main_screens/chat_screen.dart';
import 'package:gymify/screens/main_screens/diet_screen.dart';
import 'package:gymify/screens/main_screens/home_screen.dart';
import 'package:gymify/screens/main_screens/profile_screen.dart';
import 'package:gymify/screens/main_screens/workout_screens/workout_screen.dart';
import 'package:gymify/screens/splash_screen/splash_sreen.dart';
import 'package:gymify/screens/welcome/welcome_screen.dart';
import 'package:gymify/screens/authentication/login.dart';
import 'package:gymify/screens/authentication/register.dart';
import 'package:gymify/screens/workout_screen/create_exercise_screen.dart';
import 'package:gymify/screens/workout_screen/create_workout_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/', // Start with SplashScreen
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) =>
          const SplashScreen(), // Show splash screen first
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) =>
          const WelcomeScreen(), // Show welcome screen if not logged in
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) =>
          const RegisterScreen(), // Registration screen
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(), // Login screen
    ),
    GoRoute(
        path: '/createWorkout',
        builder: (context, state) => const CreateWorkoutScreen()),
    GoRoute(
      path: '/exercises',
      builder: (context, state) => const ExerciseScreen(),
    ),
    GoRoute(
      path: '/createExercise',
      builder: (context, state) => const CreateExerciseScreen(),
    ),
    ShellRoute(
      navigatorKey: rootNavigatorKey,
      builder: (context, state, child) {
        return MainScreen(child: child); // Main screen with bottom navigation
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) =>
              const HomeScreen(), // Home screen after login
        ),
        GoRoute(
          path: '/workout',
          builder: (context, state) => const WorkoutListScreen(),
        ),
        GoRoute(
          path: '/diet',
          builder: (context, state) => const DietScreen(),
        ),
        GoRoute(
          path: '/chat',
          builder: (context, state) => const ChatScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
