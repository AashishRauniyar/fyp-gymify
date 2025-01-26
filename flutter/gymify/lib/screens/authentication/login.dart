import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:gymify/providers/auth_provider/auth_provider.dart';
import 'package:gymify/utils/custom_button.dart';
import 'package:gymify/utils/custom_input.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/onboarding/workout.png',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 32),
              CustomInput(
                controller: _emailController,
                hintText: 'Enter your email',
                backgroundColor: theme.colorScheme.surface,
                onChanged: (value) {},
                leadingIcon:
                    Icon(Icons.email, color: Theme.of(context).iconTheme.color),
              ),
              const SizedBox(height: 16),
              CustomInput(
                controller: _passwordController,
                hintText: 'Enter your password',
                backgroundColor: theme.colorScheme.surface,
                obscureText: _obscurePassword,
                onChanged: (value) {},
                suffixIcon: IconButton(
                  icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Theme.of(context).iconTheme.color),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                leadingIcon:
                    Icon(Icons.lock, color: Theme.of(context).iconTheme.color),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CustomLoadingAnimation()
                  : CustomButton(
                      text: "Login",
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                        final response = await authProvider.login(
                          _emailController.text,
                          _passwordController.text,
                        );

                        if (response) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Login successful! Welcome back, ${_emailController.text}.'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          if (authProvider.isLoggedIn) {
                            if (context.mounted) {
                              await Future.delayed(
                                const Duration(milliseconds: 500),
                                () => context.go('/home'),
                              );
                            }
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    'Login failed. Please check your credentials and try again.'),
                                backgroundColor: theme.colorScheme.error,
                              ),
                            );
                          }
                        }
                        setState(() {
                          _isLoading = false;
                        });
                      },
                    ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  context.go('/register');
                },
                child: const Text(
                  'Don’t have an account? Sign up',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
