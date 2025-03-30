// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// import 'package:gymify/providers/auth_provider/auth_provider.dart';
// import 'package:gymify/utils/custom_button.dart';
// import 'package:gymify/utils/custom_input.dart';
// import 'package:gymify/utils/custom_loader.dart';
// import 'package:provider/provider.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _obscurePassword = true;
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 'assets/images/onboarding/workout.png',
//                 width: 120,
//                 height: 120,
//               ),
//               const SizedBox(height: 32),
//               CustomInput(
//                 controller: _emailController,
//                 hintText: 'Enter your email',
//                 backgroundColor: theme.colorScheme.surface,
//                 onChanged: (value) {},
//                 leadingIcon:
//                     Icon(Icons.email, color: Theme.of(context).iconTheme.color),
//               ),
//               const SizedBox(height: 16),
//               CustomInput(
//                 controller: _passwordController,
//                 hintText: 'Enter your password',
//                 backgroundColor: theme.colorScheme.surface,
//                 obscureText: _obscurePassword,
//                 onChanged: (value) {},
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                       _obscurePassword
//                           ? Icons.visibility
//                           : Icons.visibility_off,
//                       color: Theme.of(context).iconTheme.color),
//                   onPressed: () {
//                     setState(() {
//                       _obscurePassword = !_obscurePassword;
//                     });
//                   },
//                 ),
//                 leadingIcon:
//                     Icon(Icons.lock, color: Theme.of(context).iconTheme.color),
//               ),
//               const SizedBox(height: 24),
//               _isLoading
//                   ? const CustomLoadingAnimation()
//                   : CustomButton(
//                       text: "Login",
//                       onPressed: () async {
//                         setState(() {
//                           _isLoading = true;
//                         });

//                         final authProvider =
//                             Provider.of<AuthProvider>(context, listen: false);
//                         final response = await authProvider.login(
//                           _emailController.text,
//                           _passwordController.text,
//                         );

//                         if (response) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(
//                                   'Login successful! Welcome back, ${_emailController.text}.'),
//                               backgroundColor: Colors.green,
//                             ),
//                           );
//                           if (authProvider.isLoggedIn) {
//                             if (context.mounted) {
//                               await Future.delayed(
//                                 const Duration(milliseconds: 500),
//                                 () => context.go('/home'),
//                               );
//                             }
//                           }
//                         } else {
//                           if (context.mounted) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: const Text(
//                                     'Login failed. Please check your credentials and try again.'),
//                                 backgroundColor: theme.colorScheme.error,
//                               ),
//                             );
//                           }
//                         }
//                         setState(() {
//                           _isLoading = false;
//                         });
//                       },
//                     ),
//               const SizedBox(height: 16),
//               TextButton(
//                 onPressed: () {
//                   context.go('/register');
//                 },
//                 child: const Text(
//                   'Don’t have an account? Sign up',
//                   style: TextStyle(
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';

// import 'package:gymify/providers/auth_provider/auth_provider.dart';
// import 'package:gymify/utils/custom_button.dart';
// import 'package:gymify/utils/custom_input.dart';
// import 'package:gymify/utils/custom_loader.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _obscurePassword = true;
//   bool _isLoading = false;
//   bool _rememberMe = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _login() async {
//     setState(() {
//       _isLoading = true;
//     });

//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final response = await authProvider.login(
//       _emailController.text,
//       _passwordController.text,
//     );

//     if (response) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content:
//               Text('Login successful! Welcome back, ${_emailController.text}.'),
//           backgroundColor: Colors.green,
//         ),
//       );
//       if (authProvider.isLoggedIn) {
//         if (context.mounted) {
//           await Future.delayed(
//             const Duration(milliseconds: 500),
//             () => context.go('/home'),
//           );
//         }
//       }
//     } else {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text(
//                 'Login failed. Please check your credentials and try again.'),
//             backgroundColor: Theme.of(context).colorScheme.error,
//           ),
//         );
//       }
//     }
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Scaffold(
//       backgroundColor: theme.colorScheme.surface,
//       body: Center(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   'assets/images/onboarding/workout.png',
//                   width: 120,
//                   height: 120,
//                 ),
//                 const SizedBox(height: 32),
//                 Text(
//                   'Welcome Back!',
//                   style: theme.textTheme.headlineMedium?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: theme.colorScheme.onSurface,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Login to continue your fitness journey',
//                   style: theme.textTheme.bodyMedium?.copyWith(
//                     color: theme.colorScheme.onSurface.withOpacity(0.7),
//                   ),
//                 ),
//                 const SizedBox(height: 32),
//                 CustomInput(
//                   controller: _emailController,
//                   hintText: 'Enter your email',
//                   backgroundColor: theme.colorScheme.surface,
//                   onChanged: (value) {},
//                   leadingIcon: Icon(Icons.email, color: theme.iconTheme.color),
//                 ),
//                 const SizedBox(height: 16),
//                 CustomInput(
//                   controller: _passwordController,
//                   hintText: 'Enter your password',
//                   backgroundColor: theme.colorScheme.surface,
//                   obscureText: _obscurePassword,
//                   onChanged: (value) {},
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscurePassword
//                           ? Icons.visibility
//                           : Icons.visibility_off,
//                       color: theme.iconTheme.color,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _obscurePassword = !_obscurePassword;
//                       });
//                     },
//                   ),
//                   leadingIcon: Icon(Icons.lock, color: theme.iconTheme.color),
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     Checkbox(
//                       value: _rememberMe,
//                       onChanged: (value) {
//                         setState(() {
//                           _rememberMe = value ?? false;
//                         });
//                       },
//                     ),
//                     Text(
//                       'Remember Me',
//                       style: theme.textTheme.bodyMedium,
//                     ),
//                     const Spacer(),
//                     TextButton(
//                       onPressed: () {
//                         context.go('/forgot-password');
//                       },
//                       child: Text(
//                         'Forgot Password?',
//                         style: theme.textTheme.bodyMedium?.copyWith(
//                           color: theme.colorScheme.primary,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 24),
//                 _isLoading
//                     ? const CustomLoadingAnimation()
//                     : CustomButton(
//                         text: "Login",
//                         onPressed: () async {
//                           if (_emailController.text.isEmpty ||
//                               _passwordController.text.isEmpty) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content:
//                                     const Text('Please fill in all fields.'),
//                                 backgroundColor: theme.colorScheme.error,
//                               ),
//                             );
//                             return;
//                           }
//                           await _login();
//                         },
//                       ),
//                 const SizedBox(height: 16),
//                 TextButton(
//                   onPressed: () {
//                     context.go('/signup');
//                   },
//                   child: Text(
//                     'Don’t have an account? Sign up',
//                     style: theme.textTheme.bodyMedium?.copyWith(
//                       color: theme.colorScheme.primary,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:gymify/providers/auth_provider/auth_provider.dart';
import 'package:gymify/utils/custom_button.dart';
import 'package:gymify/utils/custom_input.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:gymify/utils/custom_snackbar.dart'; // Import reusable Snackbar

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final response = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (response) {
      showCoolSnackBar(context, "Login successful! Welcome back.", true);
      if (authProvider.isLoggedIn) {
        await Future.delayed(const Duration(milliseconds: 500), () {
          // if (mounted) context.go('/home');
          if (authProvider.role == "Trainer") {
            if (mounted) context.go('/trainerScreen');
          } else {
            if (mounted) context.go('/home');
          }
        });
      }
    } else {
      showCoolSnackBar(
        context,
        "Login failed. Check your credentials and try again.",
        false,
      );
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
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

                // Title
                Text(
                  'Welcome Back!',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'Login to continue your fitness journey',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 32),

                // Email Input Field
                CustomInput(
                  controller: _emailController,
                  labelText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  leadingIcon: Icon(Icons.email, color: theme.iconTheme.color),
                ),
                const SizedBox(height: 16),

                // Password Input Field (Now using built-in toggle)
                CustomInput(
                  controller: _passwordController,
                  labelText: 'Enter your password',
                  isPassword: true, // This enables the visibility toggle
                  enabled: !_isLoading,
                  keyboardType: TextInputType.visiblePassword,
                  leadingIcon: Icon(Icons.lock, color: theme.iconTheme.color),
                ),
                const SizedBox(height: 16),

                // Remember Me & Forgot Password
                Row(
                  children: [
                    // Text('Remember Me', style: theme.textTheme.bodyMedium),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        context.pushNamed('forgotPassword');
                      },
                      child: Text(
                        'Forgot Password?',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Login Button
                _isLoading
                    ? const CustomLoadingAnimation()
                    : CustomButton(
                        text: "Login",
                        onPressed: () async {
                          if (_emailController.text.isEmpty ||
                              _passwordController.text.isEmpty) {
                            showCoolSnackBar(
                              context,
                              "Please fill in all fields.",
                              false,
                            );
                            return;
                          }
                          await _login();
                        },
                      ),
                const SizedBox(height: 16),

                // Sign Up Button
                TextButton(
                  onPressed: () {
                    context.go('/signup');
                  },
                  child: Text(
                    'Don’t have an account? Sign up',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
