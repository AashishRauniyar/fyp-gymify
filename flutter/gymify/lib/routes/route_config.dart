import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/screens/height_selector.dart';
import 'package:gymify/screens/main_screens/workout_screens/workout_details_screen.dart';
import 'package:gymify/screens/registration_main_screen.dart';
import 'package:gymify/screens/weight_selecter.dart';
import 'package:gymify/screens/authentication/trying/multi_register.dart';
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
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final GlobalKey<NavigatorState> _registrationNavigatorKey =
    GlobalKey<NavigatorState>();

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
    // GoRoute(
    //   path: '/register',
    //   builder: (context, state) =>
    //       const RegisterScreen(), // Registration screen
    // ),

    // Register Flow - encapsulated in ShellRoute
    // New ShellRoute for Registration Flow
    ShellRoute(
      navigatorKey:
          _registrationNavigatorKey, // Use a new navigator key for registration flow
      builder: (context, state, child) {
        return RegistrationMainScreen(
            child: child); // Your main screen for registration flow
      },
      routes: [
        GoRoute(
          path: '/register',
          builder: (context, state) => const UserNamePage(),
        ),
        GoRoute(
          path: '/register/fullname',
          name: 'fullname',
          builder: (context, state) => const FullNamePage(),
        ),
        GoRoute(
          path: '/register/email',
          name: 'email',
          builder: (context, state) => const EmailPage(),
        ),
        GoRoute(
          path: '/register/password',
          name: 'password',
          builder: (context, state) => const PasswordPage(),
        ),
        GoRoute(
          path: '/register/phonenumber',
          name: 'phonenumber',
          builder: (context, state) => const PhoneNumberPage(),
        ),
        GoRoute(
          path: '/register/address',
          name: 'address',
          builder: (context, state) => const AddressPage(),
        ),
        GoRoute(
          path: '/register/birthdate',
          name: 'birthdate',
          builder: (context, state) => const BirthDatePage(),
        ),
        GoRoute(
          path: '/register/height',
          name: 'height',
          builder: (context, state) => const HeightSelector(),
        ),
        GoRoute(
          path: '/register/weight',
          name: 'weight',
          builder: (context, state) => WeightSelector(),
        ),
        GoRoute(
          path: '/register/fitnesslevel',
          name: 'fitnesslevel',
          builder: (context, state) => const FitnessLevelPage(),
        ),
        GoRoute(
          path: '/register/goaltype',
          name: 'goaltype',
          builder: (context, state) => const GoalTypePage(),
        ),
        GoRoute(
          path: '/register/caloriegoals',
          name: 'caloriegoals',
          builder: (context, state) => const CalorieGoalsPage(),
        ),
        GoRoute(
          path: '/register/allergies',
          name: 'allergies',
          builder: (context, state) => const AllergiesPage(),
        ),
        GoRoute(
          path: '/register/confirm',
          name: 'confirm',
          builder: (context, state) => const ConfirmRegistrationPage(),
        ),
      ],
    ),

    // GoRoute(
    //   path: '/register',
    //   builder: (context, state) =>
    //       const UserNamePage(), // First step in registration
    // ),
    // GoRoute(
    //   path: '/register/fullname',
    //   builder: (context, state) => const FullNamePage(),
    // ),
    // GoRoute(
    //   path: '/register/email',
    //   builder: (context, state) => const EmailPage(),
    // ),
    // GoRoute(
    //   path: '/register/password',
    //   builder: (context, state) => const PasswordPage(),
    // ),
    // GoRoute(
    //   path: '/register/phonenumber',
    //   builder: (context, state) => const PhoneNumberPage(),
    // ),

    // GoRoute(
    //   path: '/register/address',
    //   builder: (context, state) => const AddressPage(),
    // ),
    // GoRoute(
    //   path: '/register/birthdate',
    //   builder: (context, state) => const BirthDatePage(),
    // ),
    // GoRoute(
    //   path: '/register/height',
    //   builder: (context, state) => const HeightSelector(),
    // ),
    // GoRoute(
    //   path: '/register/weight',
    //   builder: (context, state) =>  WeightSelector(),
    // ),
    // GoRoute(
    //   path: '/register/fitnesslevel',
    //   builder: (context, state) => const FitnessLevelPage(),
    // ),
    // GoRoute(
    //   path: '/register/goaltype',
    //   builder: (context, state) => const GoalTypePage(),
    // ),
    // GoRoute(
    //   path: '/register/caloriegoals',
    //   builder: (context, state) => const CalorieGoalsPage(),
    // ),
    // GoRoute(
    //   path: '/register/allergies',
    //   builder: (context, state) => const AllergiesPage(),
    // ),
    // GoRoute(
    //   path: '/register/confirm',
    //   builder: (context, state) => const ConfirmRegistrationPage(),
    // ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(), // Login screen
    ),
    GoRoute(
        path: '/createWorkout',
        builder: (context, state) => const CreateWorkoutScreen()),
    GoRoute(
      name: 'exercises',
      path: '/exercises',
      builder: (context, state) => const ExerciseScreen(),
    ),
    GoRoute(
      path: '/createExercise',
      builder: (context, state) => const CreateExerciseScreen(),
    ),
    GoRoute(
      path: '/weight',
      builder: (context, state) => WeightSelector(),
    ),

    GoRoute(
      path: '/height',
      builder: (context, state) => HeightSelector(),
    ),

    GoRoute(
      path: '/workoutDetail', 
      name: 'workoutDetail',// Define the path with :workoutId as a dynamic parameter
      builder: (context, state) {
         // Get the workoutId from the URL
        return WorkoutDetailScreen(
          workoutId: int.parse(state.uri.queryParameters['workoutId']!), // Pass the workoutId to the screen
        );
      },
    ),

    ShellRoute(
      navigatorKey: _shellNavigatorKey,
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
