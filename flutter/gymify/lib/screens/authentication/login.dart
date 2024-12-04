import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:gymify/services/login_service.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  // Create an instance of LoginService
  final LoginService _loginService = LoginService();

  // Login logic
  Future<String?> _authUser(LoginData data) async {
    try {
      // Attempt login with the email and password
      final response = await _loginService.login(
        email: data.name,
        password: data.password,
      );

      if (response['success'] == true) {
        // Login success, navigate to home screen
        return null; // Returning null indicates success in FlutterLogin
      } else {
        // Return error message for display
        return response['message'];
      }
    } catch (error) {
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
  Future<String?> _signupUser(SignupData data) async {
    // Simulate user signup (Replace with real logic when API is ready)
    await Future.delayed(const Duration(seconds: 2));
    return 'Signup is not implemented yet.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterLogin(
        title: 'GYMIFY',
        theme: LoginTheme(
          primaryColor: const Color.fromARGB(255, 30, 90, 232),
          accentColor: Colors.green,
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
        onLogin: _authUser,
        onRecoverPassword: _recoverPassword,
        onSignup: _signupUser,
        onSubmitAnimationCompleted: () {
          // Navigate to home screen after successful login
          context.go(
              '/home'); // This should work now with the updated GoRouter routing
        },
      ),
    );
  }
}
