import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/models/deit_plan_models/diet_plan_model.dart';
import 'package:gymify/models/deit_plan_models/meal_model.dart';
import 'package:gymify/models/exercise_model.dart';
import 'package:gymify/models/workout_model.dart';
import 'package:gymify/screens/ai_screen/ai_chatbot_screen.dart';
import 'package:gymify/screens/authentication/account_recovery/forget_password.dart';
import 'package:gymify/screens/authentication/account_recovery/reset_password.dart';
import 'package:gymify/screens/authentication/complete_profile/complete_profile_screen.dart';
import 'package:gymify/screens/authentication/trying/otp_verification.dart';
import 'package:gymify/screens/authentication/trying/signup.dart';
import 'package:gymify/screens/chat/chat_user_list_screen.dart';
import 'package:gymify/screens/create_workout_screen/edit_workout_screen.dart';
import 'package:gymify/screens/create_workout_screen/manage_exercise_screen.dart';
import 'package:gymify/screens/create_workout_screen/manage_workout_exercises_screen.dart';
import 'package:gymify/screens/create_workout_screen/manage_workout_screen.dart';
import 'package:gymify/screens/custom_workout_screen/create_custom_workout_screen.dart';
import 'package:gymify/screens/custom_workout_screen/custom_workout_detail_screen.dart';
import 'package:gymify/screens/custom_workout_screen/custom_workout_screen.dart';
import 'package:gymify/screens/diet_screens/create_diet_plan_screen.dart';
import 'package:gymify/screens/diet_screens/create_meal_screen.dart';
import 'package:gymify/screens/diet_screens/diet_search_screen.dart';
import 'package:gymify/screens/diet_screens/diet_detail_screen.dart';
import 'package:gymify/screens/diet_screens/meal_detail_screen.dart';
import 'package:gymify/screens/diet_screens/meal_log_screen.dart';
import 'package:gymify/screens/diet_screens/meal_list_screen.dart';
import 'package:gymify/screens/exercise_screens/exercise_detail_screen.dart';
import 'package:gymify/screens/help_faqs_screen.dart';
import 'package:gymify/screens/main_screens/attendance_screen/attendance_screen.dart';
import 'package:gymify/screens/main_screens/chat_screen.dart';
import 'package:gymify/screens/main_screens/membership_screen/khalti_payment_screen.dart';
import 'package:gymify/screens/main_screens/membership_screen/membership_screen.dart';
import 'package:gymify/screens/main_screens/trainer_screen.dart';
import 'package:gymify/screens/main_screens/workout_history_screens/workout_history_screen.dart';
import 'package:gymify/screens/main_screens/workout_screens/all_workouts.dart';
import 'package:gymify/screens/main_screens/workout_screens/workout_details_screen.dart';
import 'package:gymify/screens/main_screens/workout_screens/workout_search_screen.dart';
import 'package:gymify/screens/nutrition_analysis_screen.dart';
import 'package:gymify/screens/personal_best_screens/create_supported_exercise_screen.dart';
import 'package:gymify/screens/personal_best_screens/personal_best_screen.dart';
import 'package:gymify/screens/personal_best_screens/weight_update_screen.dart';
import 'package:gymify/screens/profile_screen/edit_profile_screen.dart';
import 'package:gymify/screens/step_count_screen.dart';
import 'package:gymify/screens/trainer_screens/manage_diet_plans.dart';
import 'package:gymify/screens/exercise_screens/exercise_screen.dart';
import 'package:gymify/screens/main_screen/main_screen.dart';
import 'package:gymify/screens/main_screens/diet_screen.dart';
import 'package:gymify/screens/main_screens/home_screen.dart';
import 'package:gymify/screens/main_screens/profile_screen.dart';
import 'package:gymify/screens/main_screens/workout_screens/workout_screen.dart';
import 'package:gymify/screens/splash_screen/splash_sreen.dart';
import 'package:gymify/screens/trainer_screens/trainer_dashboard_screen.dart';
import 'package:gymify/screens/trainer_screens/user_list_trainer_screen.dart';
import 'package:gymify/screens/trainer_screens/user_stats_screen.dart';
import 'package:gymify/screens/welcome/welcome_screen.dart';
import 'package:gymify/screens/authentication/login.dart';
import 'package:gymify/screens/create_workout_screen/create_exercise_screen.dart';
import 'package:gymify/screens/create_workout_screen/create_workout_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
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
    GoRoute(
      name: 'complete-profile',
      path: '/complete-profile',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final email = extra?['email'] ?? '';
        return ProfileCompletionScreen(email: email);
      },
    ),
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
        name: "manageWorkouts",
        path: '/manageWorkouts',
        builder: (context, state) => const ManageWorkoutScreen()),
    GoRoute(
        name: "editWorkout",
        path: '/editWorkout',
        builder: (context, state) {
          final workout = state.extra as Workout;
          return EditWorkoutScreen(workout: workout);
        }),

// New route for managing exercises in a workout
    GoRoute(
        name: "manageWorkoutExercises",
        path: '/manageWorkoutExercises',
        builder: (context, state) {
          final workout = state.extra as Workout;
          return ManageWorkoutExercisesScreen(workout: workout);
        }),
    // GoRoute(
    //   name: 'exercises',
    //   path: '/exercises',
    //   builder: (context, state) => const ExerciseScreen(),
    // ),
    GoRoute(
      name: 'exercises',
      path: '/exercises',
      pageBuilder: (context, state) {
        final filter = state.uri.queryParameters['filter'];
        return MaterialPage(
          child: ExerciseScreen(muscleGroupFilter: filter),
        );
      },
    ),

    GoRoute(
      name: 'createExercise',
      path: '/createExercise',
      builder: (context, state) => const CreateExerciseScreen(),
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
          name: 'home',
          builder: (context, state) =>
              const HomeScreen(), // Home screen after login
        ),
        GoRoute(
          path: '/workout',
          name: 'workout',
          builder: (context, state) => const WorkoutListScreen(),
        ),
        GoRoute(
          path: '/diet',
          builder: (context, state) => const DietScreen(),
        ),
        GoRoute(
          path: '/trainerScreen',
          builder: (context, state) => const TrainerScreen(),
        ),
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
      name: 'editProfile',
      path: '/editProfile',
      builder: (context, state) {
        return const EditProfileScreen();
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
        name: 'aiChatScreen',
        path: '/aiChatScreen',
        builder: (context, state) => const AIChatbotScreen()),

    GoRoute(
      name: 'chatScreen',
      path: '/chatScreen',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final chatId = extra['chatId'] as int;
        final userId = extra['userId'] as String;
        final userName = extra['userName'] as String;
        final userImage = extra['userImage'] as String;

        return ChatScreen(
          chatId: chatId,
          userId: userId,
          userName: userName,
          userImage: userImage,
        );
      },
    ),

    GoRoute(
        name: 'membershipPlans',
        path: '/membershipPlans',
        builder: (context, state) => const MembershipScreen()),
    GoRoute(
        name: 'dietSearch',
        path: '/dietSearch',
        builder: (context, state) => const DietSearchScreen()),
    GoRoute(
        name: 'mealDetails',
        path: '/mealDetails',
        builder: (context, state) => MealDetailScreen(
              meal: state.extra as Meal,
            )),
    GoRoute(
        name: 'mealLog',
        path: '/mealLog',
        builder: (context, state) => const MealLogsScreen()),
    GoRoute(
        name: 'mealList',
        path: '/mealList',
        builder: (context, state) => const MealListScreen()),
    GoRoute(
      name: 'userList',
      path: '/userList',
      builder: (context, state) => const UserListScreen(),
    ),

// User stats route (to view detailed stats for a specific user)
    GoRoute(
      name: 'userStats',
      path: '/userStats/:userId',
      builder: (context, state) {
        final extraData = state.extra as Map<String, dynamic>?;
        final userId =
            int.parse(extraData?['userId'] ?? state.pathParameters['userId']!);
        return UserStatsScreen(userId: userId);
      },
    ),

// Trainer dashboard route (overview of all users)
    GoRoute(
      name: 'trainerDashboard',
      path: '/trainerDashboard',
      builder: (context, state) => const TrainerDashboardScreen(),
    ),
    GoRoute(
        name: 'workoutSearch',
        path: '/workoutSearch',
        builder: (context, state) => const WorkoutSearchScreen()),
    GoRoute(
        name: 'stepCount',
        path: '/stepCount',
        builder: (context, state) => const StepCountScreen()),
    GoRoute(
        name: 'khalti',
        path: '/khalti',
        builder: (context, state) => const KhaltiSDKDemo()),
    GoRoute(
        name: 'forgotPassword',
        path: '/forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen()),
    GoRoute(
        name: 'personalBest',
        path: '/personalBest',
        builder: (context, state) => const PersonalBestScreen()),
    GoRoute(
        name: 'attendance',
        path: '/attendance',
        builder: (context, state) => const AttendanceCalendarScreen()),

    GoRoute(
        name: 'weightLog',
        path: '/weightLog',
        builder: (context, state) => const WeightLog()),
    GoRoute(
        name: 'nutriScan',
        path: '/nutriScan',
        builder: (context, state) => const NutritionAnalysisScreen()),
    GoRoute(
        name: 'helpFaqs',
        path: '/helpFaqs',
        builder: (context, state) => const HelpFAQsScreen()),
    GoRoute(
        name: 'createSupportedExercise',
        path: '/createSupportedExercise',
        builder: (context, state) => const CreateSupportedExerciseScreen()),
    GoRoute(
        name: 'manageExercise',
        path: '/manageExercise',
        builder: (context, state) => const ManageExerciseScreen()),
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
