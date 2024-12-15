import 'package:flutter/material.dart';
import 'package:gymify/colors/custom_colors.dart';
import 'package:gymify/utils/custom_button.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFF2E3440) ,
      backgroundColor: CustomColors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome to Gymify",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.lightText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Workouts Management, Diet Management, Progress Insights, Expert Advice and much more",
                  style: TextStyle(
                    fontSize: 16,
                    color: CustomColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Join now button
                CustomButton(
                    text: "Join Now",
                    // use 2E3440 by doing Color(0xFF2E3440)
                    textColor: const Color(0xFF2E3440),
                    color: CustomColors.primary,
                    onPressed: () {
                      context.go('/register');
                    }),
                const SizedBox(height: 10),
                // Already a member
                TextButton(
                  onPressed: () {
                    context.go('/login');
                  },
                  child: Text(
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
          ),
        ],
      ),
    );
  }
}
