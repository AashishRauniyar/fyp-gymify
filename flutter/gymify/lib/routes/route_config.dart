import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/screens/authentication/login.dart';
import 'package:gymify/screens/authentication/register.dart';
import 'package:gymify/screens/main_screens/workout_screen.dart';
import 'package:gymify/screens/splash_screen/splash_sreen.dart';
import 'package:gymify/screens/welcome/welcome_screen.dart';


final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) =>  WelcomeScreen(),
    ),
    // Register screen
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) =>  LoginScreen(),
    ),
    GoRoute(
      path: '/workout',
      builder: (context, state) => const WorkoutListScreen(),
    ),
  ],
);
