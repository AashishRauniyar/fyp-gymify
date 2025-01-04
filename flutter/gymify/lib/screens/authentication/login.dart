import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart'; // Import the provider
import 'package:go_router/go_router.dart';
import 'package:gymify/colors/custom_colors.dart';
import 'package:gymify/providers/auth_provider/auth_provider.dart';
import 'package:provider/provider.dart'; // Import provider package;


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // Login logic
  Future<String?> _authUser(LoginData data, BuildContext context) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Attempt login with the email and password
      final response = await authProvider.login(data.name, data.password);

      if (response) {

        // context.read<WorkoutProvider>().fetchAllWorkouts();
        // Login success, navigate to home screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login successful! Welcome back, ${data.name}.'),
            backgroundColor: Colors.green,
          ),
        );
        return null; // Returning null indicates success in FlutterLogin
      } else {
        // Return error message for display
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Login failed. Please check your credentials and try again.'),
            backgroundColor: Colors.red,
          ),
        );
        return 'Login failed. Please try again.';
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('An unexpected error occurred. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
      return 'An unexpected error occurred. Please try again.';
    }
  }

  // Placeholder for password recovery logic
  Future<String?> _recoverPassword(String email) async {
    // Simulate password recovery (Replace with real logic when API is ready)
    await Future.delayed(const Duration(seconds: 2));
    return 'Password recovery is not implemented yet.';
  }

  // Placeholder for sign-up logic
  Future<String?> _signupUser(SignupData data, BuildContext context) async {
    // Simulate user signup (Replace with real logic when API is ready)
    await Future.delayed(const Duration(seconds: 2));
    context.go('/register');
    return 'Signup is not implemented yet.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        // Listen to AuthProvider for changes
        builder: (context, authProvider, child) {
          return FlutterLogin(
            title: 'GYMIFY',
            theme: LoginTheme(
              primaryColor: CustomColors.primary,
              accentColor: CustomColors.primary,
              errorColor: Colors.red,
              logoWidth: 2,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontFamily: 'Quicksand',
                letterSpacing: 4,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            onLogin: (data) => _authUser(data, context),
            onRecoverPassword: _recoverPassword,
            onSignup: (data) => _signupUser(data, context),
            onSubmitAnimationCompleted: () {
              // Check if logged in before navigating
              if (authProvider.isLoggedIn) {
                context.go('/home'); // Navigate if logged in
              }
            },
          );
        },
      ),
    );
  }
}
