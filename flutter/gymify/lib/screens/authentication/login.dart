import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:gymify/providers/auth_provider/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // Login logic
  Future<String?> _authUser(LoginData data, BuildContext context) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Attempt login with the email and password
      final response = await authProvider.login(data.name, data.password);

      if (response) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login successful! Welcome back, ${data.name}.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return null; // Returning null indicates success in FlutterLogin
      } else {
        return 'Login failed. Please check your credentials and try again.';
      }
    } catch (error) {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  // Placeholder for password recovery logic
  Future<String?> _recoverPassword(String email) async {
    await Future.delayed(const Duration(seconds: 2));
    return 'Password recovery is not implemented yet.';
  }

  // Placeholder for sign-up logic
  Future<String?> _signupUser(SignupData data, BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    context.go('/register');
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return FlutterLogin(
            title: 'GYMIFY',
            theme: LoginTheme(
              primaryColor: theme.colorScheme.primary,
              accentColor: theme.colorScheme.secondary,
              errorColor: theme.colorScheme.error,
              titleStyle: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
              bodyStyle: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              inputTheme: InputDecorationTheme(
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary.withOpacity(0.5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                  ),
                ),
                labelStyle: theme.textTheme.bodyMedium,
              ),
              buttonStyle: TextStyle(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
              cardTheme: CardTheme(
                color: theme.colorScheme.surface,
                elevation: 8,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              buttonTheme: LoginButtonTheme(
                backgroundColor: theme.colorScheme.primary,
                highlightColor: theme.colorScheme.primary.withOpacity(0.8),
                elevation: 4,
                highlightElevation: 2,
              ),
            ),
            onLogin: (data) => _authUser(data, context),
            onRecoverPassword: _recoverPassword,
            onSignup: (data) => _signupUser(data, context),
            onSubmitAnimationCompleted: () {
              if (authProvider.isLoggedIn) {
                context.go('/home');
              }
            },
          );
        },
      ),
    );
  }
}
