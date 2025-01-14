import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegistrationMainScreen extends StatelessWidget {
  final Widget
      child; // The child widget that will represent each registration page

  const RegistrationMainScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor:
          theme.colorScheme.surface, // Use dynamic background color
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_sharp,
            color: theme.colorScheme.primary, // Use primary color for the icon
          ),
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
              child: child, // The child widget for each registration page
            ),
          ],
        ),
      ),
    );
  }
}
