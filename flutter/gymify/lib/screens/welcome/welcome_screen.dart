import 'package:flutter/material.dart';
import 'package:gymify/colors/custom_colors.dart';
import 'package:gymify/utils/custom_button.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Vertically center
        crossAxisAlignment: CrossAxisAlignment.center, // Horizontally center
        children: [
          const Text(
            "WELCOME  TO         GYMIFY",
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: CustomColors.black,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),
          // Join now button
          CustomButton(
            text: "JOIN NOW",
            textColor: Colors.white,
            color: CustomColors.primary,
            onPressed: () {
              context.go('/register');
            },
          ),
          const SizedBox(height: 10),
          // Already a member
          TextButton(
            onPressed: () {
              context.go('/login');
            },
            child: const Text(
              "Already a member? Log in",
              style: TextStyle(
                color: CustomColors.primary,
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
