// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:gymify/screens/authentication/login.dart';
// import 'package:gymify/screens/authentication/register.dart';
// import 'package:gymify/screens/main_screens/workout_screen.dart';
// import 'package:gymify/screens/splash_screen/splash_sreen.dart';
// import 'package:gymify/screens/welcome/welcome_screen.dart';

// final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

// final GoRouter router = GoRouter(
//   navigatorKey: rootNavigatorKey,
//   initialLocation: '/',
//   routes: [
//     GoRoute(
//       path: '/',
//       builder: (context, state) => const SplashScreen(),
//     ),
//     GoRoute(
//       path: '/welcome',
//       builder: (context, state) =>  WelcomeScreen(),
//     ),
//     // Register screen
//     GoRoute(
//       path: '/register',
//       builder: (context, state) => const RegisterScreen(),
//     ),
//     GoRoute(
//       path: '/login',
//       builder: (context, state) =>  LoginScreen(),
//     ),
//     GoRoute(
//       path: '/workout',
//       builder: (context, state) => const WorkoutListScreen(),
//     ),
//   ],
// );

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/screens/main_screen/main_screen.dart';
import 'package:gymify/screens/main_screens/chat_screen.dart';
import 'package:gymify/screens/main_screens/diet_screen.dart';
import 'package:gymify/screens/main_screens/home_screen.dart';
import 'package:gymify/screens/main_screens/profile_screen.dart';
import 'package:gymify/screens/main_screens/workout_screen.dart';
import 'package:gymify/screens/splash_screen/splash_sreen.dart';
import 'package:gymify/screens/welcome/welcome_screen.dart';
import 'package:gymify/screens/authentication/login.dart';
import 'package:gymify/screens/authentication/register.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

// final GoRouter router = GoRouter(
//   navigatorKey: rootNavigatorKey,
//   initialLocation: '/', // This makes SplashScreen the initial route
//   routes: [
//     GoRoute(
//       path: '/',
//       builder: (context, state) => const SplashScreen(), // Splash Screen
//     ),
//     GoRoute(
//       path: '/welcome',
//       builder: (context, state) =>
//           WelcomeScreen(), // Welcome Screen after Splash
//     ),
//     GoRoute(
//       path: '/register',
//       builder: (context, state) =>
//           const RegisterScreen(), // Registration Screen
//     ),
//     GoRoute(
//       path: '/login',
//       builder: (context, state) => LoginScreen(), // Login Screen
//     ),
//     ShellRoute(
//       navigatorKey: rootNavigatorKey,
//       builder: (context, state, child) {
//         return MainScreen(child: child); // Main screen with bottom navigation
//       },
//       routes: [
//         // Home route
//         GoRoute(
//           path: '/home',
//           builder: (context, state) => const HomeScreen(),
//         ),
//         // Workout route
//         GoRoute(
//           path: '/workout',
//           builder: (context, state) => const WorkoutListScreen(),
//         ),
//         // Diet route
//         GoRoute(
//           path: '/diet',
//           builder: (context, state) => const DietScreen(),
//         ),
//         // Chat route
//         GoRoute(
//           path: '/chat',
//           builder: (context, state) => const ChatScreen(),
//         ),
//         // Profile route
//         GoRoute(
//           path: '/profile',
//           builder: (context, state) => const ProfileScreen(),
//         ),
//       ],
//     ),
//   ],
// );
final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',  // Start with SplashScreen
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(), // Show splash screen first
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => WelcomeScreen(), // Show welcome screen if not logged in
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(), // Registration screen
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) =>  LoginScreen(), // Login screen
    ),
    ShellRoute(
      navigatorKey: rootNavigatorKey,
      builder: (context, state, child) {
        return MainScreen(child: child);  // Main screen with bottom navigation
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(), // Home screen after login
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
