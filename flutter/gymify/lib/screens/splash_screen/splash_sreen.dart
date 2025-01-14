// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import 'package:gymify/providers/auth_provider/auth_provider.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       Future.delayed(const Duration(seconds: 5), () async {
//         await _loadDataAndCheckLoginStatus();
//       });
//     });

//     // Show splash screen for a few seconds before fetching workouts and checking login status
//     // Future.delayed(const Duration(seconds: 5), () async {
//     //   await _loadDataAndCheckLoginStatus();
//     // });
//   }

//   Future<void> _loadDataAndCheckLoginStatus() async {
//     // Fetch all workouts first (without blocking login check)
//     //await context.read<WorkoutProvider>().fetchAllWorkouts();

//     // Check login status after fetching workouts
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
import 'package:gymify/providers/auth_provider/auth_provider.dart';
import 'package:gymify/providers/chat_provider/chat_service.dart';

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
      await _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    final authProvider = context.read<AuthProvider>();
    final chatProvider = context.read<ChatProvider>();

    await authProvider.checkLoginStatus();

    if (authProvider.isLoggedIn) {
      final userId = authProvider.userId;
      if (userId != null) {
        chatProvider.initializeSocket(userId);
      }
    }

    Future.delayed(const Duration(seconds: 5), () {
      if (authProvider.isLoggedIn) {
        context.go('/home');
      } else {
        context.go('/welcome');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/gif/welcome.gif',
              fit: BoxFit.cover,
            ),
          ),
          const Center(
            child: Text(
              'Welcome to Gymify',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
