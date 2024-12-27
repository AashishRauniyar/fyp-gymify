import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/colors/custom_colors.dart';

class RegistrationMainScreen extends StatelessWidget {
  final Widget
      child; // The child widget that will represent each registration page

  const RegistrationMainScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors
          .backgroundColor, // Set the background color for registration flow
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_sharp,
              color: Color(0xFFFF5E3A)),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop(); // Navigate back to the previous page
            } else {
              context.go(
                  '/welcome'); // Navigate to the welcome page if there's nothing to pop
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child:
                  child, // The child widget representing each registration page (e.g., UserNamePage)
            ),
          ],
        ),
      ),
    );
  }
}
