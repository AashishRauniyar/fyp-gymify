import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/models/deit_plan_models/diet_plan_model.dart';
import 'package:gymify/models/exercise_model.dart';
import 'package:gymify/models/user_model.dart';
import 'package:gymify/screens/authentication/account_recovery/forget_password.dart';
import 'package:gymify/screens/authentication/account_recovery/reset_password.dart';
import 'package:gymify/screens/authentication/trying/otp_verification.dart';
import 'package:gymify/screens/authentication/trying/signup.dart';
import 'package:gymify/screens/chat/trainers_page.dart';
import 'package:gymify/screens/custom_workout_screen/create_custom_workout_screen.dart';
import 'package:gymify/screens/custom_workout_screen/custom_workout_detail_screen.dart';
import 'package:gymify/screens/custom_workout_screen/custom_workout_screen.dart';
import 'package:gymify/screens/diet_screens/create_diet_plan_screen.dart';
import 'package:gymify/screens/diet_screens/create_meal_screen.dart';
import 'package:gymify/screens/diet_screens/diet_detail_screen.dart';
import 'package:gymify/screens/height_selector.dart';
import 'package:gymify/screens/main_screens/membership_screen/khalti_payment_screen.dart';
import 'package:gymify/screens/main_screens/membership_screen/membership_screen.dart';
import 'package:gymify/screens/main_screens/workout_history_screens/workout_history_screen.dart';
import 'package:gymify/screens/main_screens/workout_screens/all%20workouts.dart';
import 'package:gymify/screens/main_screens/workout_screens/workout_details_screen.dart';
import 'package:gymify/screens/profile_screen/edit_profile_screen.dart';
import 'package:gymify/screens/registration_main_screen.dart';
import 'package:gymify/screens/test/test_screen.dart';
import 'package:gymify/screens/trainer_screens/manage_diet_plans.dart';
import 'package:gymify/screens/weight_selecter.dart';
import 'package:gymify/screens/authentication/trying/multi_register.dart';
import 'package:gymify/screens/exercise_screen.dart';
import 'package:gymify/screens/main_screen/main_screen.dart';
import 'package:gymify/screens/main_screens/diet_screen.dart';
import 'package:gymify/screens/main_screens/home_screen.dart';
import 'package:gymify/screens/main_screens/profile_screen.dart';
import 'package:gymify/screens/main_screens/workout_screens/workout_screen.dart';
import 'package:gymify/screens/splash_screen/splash_sreen.dart';
import 'package:gymify/screens/welcome/welcome_screen.dart';
import 'package:gymify/screens/authentication/login.dart';
import 'package:gymify/screens/create_workout_screen/create_exercise_screen.dart';
import 'package:gymify/screens/create_workout_screen/create_workout_screen.dart';

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
    GoRoute(
      name: 'signup',
      path: '/signup',
      builder: (context, state) => const SignupPage(), // Registration screen
    ),
    GoRoute(
      name: 'otp',
      path: '/otp',
      builder: (context, state) {
        final extra =
            state.extra as Map<String, dynamic>?; // Handle null safely
        final email = extra?['email'] ?? ''; // Avoid null issue

        return OtpVerificationPage(email: email);
      },
    ),

    // Register Flow - encapsulated in ShellRoute
    // New ShellRoute for Registration Flow
    // ShellRoute(
    //   navigatorKey:
    //       _registrationNavigatorKey, // Use a new navigator key for registration flow
    //   builder: (context, state, child) {
    //     return RegistrationMainScreen(
    //         child: child); // Your main screen for registration flow
    //   },
    //   routes: [
    //     GoRoute(
    //       path: '/register',
    //       builder: (context, state) => const UserNamePage(),
    //     ),
    //     GoRoute(
    //       path: '/register/fullname',
    //       name: 'fullname',
    //       builder: (context, state) => const FullNamePage(),
    //     ),
    //     GoRoute(
    //       path: '/register/gender',
    //       name: 'gender',
    //       builder: (context, state) => const GenderSelectionPage(),
    //     ),
    //     GoRoute(
    //       path: '/register/email',
    //       name: 'email',
    //       builder: (context, state) => const EmailPage(),
    //     ),
    //     GoRoute(
    //       path: '/register/password',
    //       name: 'password',
    //       builder: (context, state) => const PasswordPage(),
    //     ),
    //     GoRoute(
    //       path: '/register/phonenumber',
    //       name: 'phonenumber',
    //       builder: (context, state) => const PhoneNumberPage(),
    //     ),
    //     GoRoute(
    //       path: '/register/address',
    //       name: 'address',
    //       builder: (context, state) => const AddressPage(),
    //     ),
    //     GoRoute(
    //       path: '/register/birthdate',
    //       name: 'birthdate',
    //       builder: (context, state) => const BirthDatePage(),
    //     ),
    //     GoRoute(
    //       path: '/register/height',
    //       name: 'height',
    //       builder: (context, state) => const HeightSelector(),
    //     ),
    //     GoRoute(
    //       path: '/register/weight',
    //       name: 'weight',
    //       builder: (context, state) => const WeightSelector(),
    //     ),
    //     GoRoute(
    //       path: '/register/fitnesslevel',
    //       name: 'fitnesslevel',
    //       builder: (context, state) => const FitnessLevelPage(),
    //     ),
    //     GoRoute(
    //       path: '/register/goaltype',
    //       name: 'goaltype',
    //       builder: (context, state) => const GoalTypePage(),
    //     ),
    //     GoRoute(
    //       path: '/register/caloriegoals',
    //       name: 'caloriegoals',
    //       builder: (context, state) => const CalorieGoalsPage(),
    //     ),
    //     GoRoute(
    //       path: '/register/allergies',
    //       name: 'allergies',
    //       builder: (context, state) => const AllergiesPage(),
    //     ),
    //     GoRoute(
    //       path: '/register/confirm',
    //       name: 'confirm',
    //       builder: (context, state) => const ConfirmRegistrationPage(),
    //     ),
    //   ],
    // ),

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
      name: 'login',
      path: '/login',
      builder: (context, state) => const LoginScreen(), // Login screen
    ),
    GoRoute(
        name: "createWorkout",
        path: '/createWorkout',
        builder: (context, state) => const CreateWorkoutScreen()),
    GoRoute(
      name: 'exercises',
      path: '/exercises',
      builder: (context, state) => const ExerciseScreen(),
    ),
    GoRoute(
      name: 'createExercise',
      path: '/createExercise',
      builder: (context, state) => const CreateExerciseScreen(),
    ),
    GoRoute(
      path: '/weight',
      builder: (context, state) => const WeightSelector(),
    ),

    GoRoute(
      path: '/height',
      builder: (context, state) => const HeightSelector(),
    ),

    GoRoute(
      path: '/workoutDetail',
      name:
          'workoutDetail', // Define the path with :workoutId as a dynamic parameter
      builder: (context, state) {
        // Get the workoutId from the URL
        return WorkoutDetailScreen(
          workoutId: int.parse(state.uri.queryParameters[
              'workoutId']!), // Pass the workoutId to the screen
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
        // GoRoute(
        //   path: '/chat',
        //   builder: (context, state) => const ChatScreen(),
        // ),
        GoRoute(
          path: '/chat',
          builder: (context, state) => const UserTrainerPage(),
        ),

        GoRoute(
          name: 'profile',
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
        name: 'createCustomWorkout',
        path: '/createCustomWorkout',
        builder: (context, state) => const CreateCustomWorkoutScreen()),
    GoRoute(
        name: 'customWorkout',
        path: '/customWorkout',
        builder: (context, state) => const CustomWorkoutListScreen()),
    GoRoute(
        name: 'customWorkoutDetail',
        path: '/customWorkoutDetail',
        builder: (context, state) {
          return CustomWorkoutDetailScreen(
            customWorkoutId: int.parse(state.uri.queryParameters['id']!),
          );
        }),
    GoRoute(
        name: 'allWorkouts',
        path: '/allWorkouts',
        builder: (context, state) => const AllWorkouts()),

    GoRoute(
      name: 'exerciseDetails',
      path: '/exerciseDetails',
      builder: (context, state) => ExerciseDetailScreen(
        exercise: state.extra as Exercise,
      ),
    ),
    // GoRoute(
    //   name: 'editProfile',
    //   path: '/editProfile',
    //   builder: (context, state) =>  EditProfileScreen(),
    // ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) {
        final user = state.extra as Users; // Extract the passed user object
        return EditProfileScreen(user: user);
      },
    ),
    GoRoute(
        name: 'createDietPlan',
        path: '/createDietPlan',
        builder: (context, state) => const CreateDietPlanScreen()),
    GoRoute(
        name: 'createMealPlan',
        path: '/createMealPlan',
        builder: (context, state) => CreateMealScreen(
              dietPlanId: int.parse(state.uri.queryParameters['dietPlanId']!),
            )),
    GoRoute(
        name: 'manageDietPlans',
        path: '/manageDietPlans',
        builder: (context, state) => const ManageDietPlans()),
    GoRoute(
        name: 'membershipPlans',
        path: '/membershipPlans',
        builder: (context, state) => const MembershipScreen()),
    GoRoute(
        name: 'dietSearch',
        path: '/dietSearch',
        builder: (context, state) => const DietSearchScreen()),
    GoRoute(
        name: 'test',
        path: '/test',
        builder: (context, state) => const TestScreen()),
    GoRoute(
        name: 'khalti',
        path: '/khalti',
        builder: (context, state) => const KhaltiSDKDemo()),
    GoRoute(
        name: 'forgotPassword',
        path: '/forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen()),
    GoRoute(
        name: 'resetPassword',
        path: '/resetPassword',
        builder: (context, state) => ResetPasswordScreen(
              email: state.extra as String,
            )),
    GoRoute(
      path: '/workoutHistory',
      name:
          'workoutHistory', // Ensure the name matches the one used in context.pushNamed()
      builder: (context, state) {
        final userId = state.extra as String; // Get the userId passed as extra
        return WorkoutHistoryScreen(userId: userId);
      },
    ),
    GoRoute(
      name: 'dietDetail',
      path: '/dietDetail',
      builder: (context, state) {
        // Retrieve the DietPlan object from state.extra
        final dietPlan =
            state.extra as DietPlan; // Cast state.extra to DietPlan
        return DietDetailScreen(
            dietPlan: dietPlan); // Pass dietPlan to the DietDetailScreen
      },
    ),
  ],
);
