import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/services/login_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LoginService _loginService = LoginService();

  @override
  void initState() {
    super.initState();

    // Show splash screen for a few seconds before checking login status
    Future.delayed(const Duration(seconds: 3), () {
      _checkLoginStatus();
    });
  }

  // Check login status by validating token
  Future<void> _checkLoginStatus() async {
    bool isLoggedIn = await _loginService.isTokenValid();

    // Navigate to the appropriate screen after checking login status
    if (isLoggedIn) {
      // If logged in, go directly to Home screen
      context.go('/home');
    } else {
      // If not logged in, go to the Welcome screen
      context.go('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Welcome to Gymify',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
