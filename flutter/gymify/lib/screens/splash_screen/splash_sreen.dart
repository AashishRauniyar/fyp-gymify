// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:gymify/providers/auth_provider/auth_provider.dart';
// import 'package:provider/provider.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();

//     // Show splash screen for a few seconds before checking login status
//     Future.delayed(const Duration(seconds: 3), () {
//       _checkLoginStatus();
//     });
//   }

//   // Check login status by validating token
//   Future<void> _checkLoginStatus() async {
//     await context.read<AuthProvider>().checkLoginStatus();

//     // Navigate based on login status
//     final isLoggedIn = context.read<AuthProvider>().isLoggedIn;
//     if (isLoggedIn) {
//       context.go('/home'); // Navigate to home screen
//     } else {
//       context.go('/welcome'); // Navigate to the welcome screen
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background GIF
//           Positioned.fill(
//             child: Image.asset(
//               'assets/gif/welcome.gif',
//               fit: BoxFit.cover,
//             ),
//           ),
//           // Content over the background
//           const Center(
//             child: Text(
//               'Welcome to Gymify',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white, // Adjust color as needed
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:gymify/providers/workout_provider/workout_provider.dart';
import 'package:gymify/providers/auth_provider/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Future.delayed(const Duration(seconds: 5), () async {
        await _loadDataAndCheckLoginStatus();
      });
    });

    // Show splash screen for a few seconds before fetching workouts and checking login status
    // Future.delayed(const Duration(seconds: 5), () async {
    //   await _loadDataAndCheckLoginStatus();
    // });
  }

  Future<void> _loadDataAndCheckLoginStatus() async {
    // Fetch all workouts first (without blocking login check)
    //await context.read<WorkoutProvider>().fetchAllWorkouts();

    // Check login status after fetching workouts
    await context.read<AuthProvider>().checkLoginStatus();

    // Navigate based on login status
    final isLoggedIn = context.read<AuthProvider>().isLoggedIn;
    if (isLoggedIn) {
      context.go('/home'); // Navigate to home screen
    } else {
      context.go('/welcome'); // Navigate to the welcome screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background GIF
          Positioned.fill(
            child: Image.asset(
              'assets/gif/welcome.gif',
              fit: BoxFit.cover,
            ),
          ),
          // Content over the background
          const Center(
            child: Text(
              'Welcome to Gymify',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Adjust color as needed
              ),
            ),
          ),
        ],
      ),
    );
  }
}
