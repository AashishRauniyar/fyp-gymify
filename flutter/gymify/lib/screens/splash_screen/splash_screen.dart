import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Delay to simulate a splash screen
    Future.delayed(const Duration(seconds: 3), () {
      context.go('/welcome'); // After 3 seconds, go to the Welcome screen
    });

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
