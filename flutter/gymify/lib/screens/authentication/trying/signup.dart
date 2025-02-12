// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:gymify/providers/multipage_register_provider/signup_provider.dart';
// import 'package:gymify/utils/custom_button.dart';
// import 'package:gymify/utils/custom_input.dart';
// import 'package:gymify/colors/custom_colors.dart';
// import 'package:gymify/utils/custom_snackbar.dart';
// import 'package:provider/provider.dart';

// class SignupPage extends StatefulWidget {
//   const SignupPage({super.key});

//   @override
//   _SignupPageState createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();

//   // Toggle visibility state for password fields

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Sign Up"),
//         backgroundColor: CustomColors.primary,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Consumer<SignupProvider>(
//           builder: (context, provider, child) {
//             return Form(
//               key: _formKey,
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Email Input
//                     CustomInput(
//                       labelText: "Email",
//                       controller: _emailController,
//                       onChanged: provider.setEmail,
//                       keyboardType: TextInputType.emailAddress,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return "Email is required";
//                         }
//                         if (!RegExp(
//                                 r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
//                             .hasMatch(value)) {
//                           return "Enter a valid email address";
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 12),
//                     CustomInput(
//                       labelText: "Password",
//                       controller: _passwordController,
//                       onChanged: provider.setPassword,
//                       isPassword: true,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return "Password is required";
//                         }
//                         if (value.length < 8) {
//                           return "Password must be at least 8 characters";
//                         }
//                         if (!RegExp(
//                                 r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$")
//                             .hasMatch(value)) {
//                           return "Password must contain uppercase, lowercase, number, and special character";
//                         }
//                         return null;
//                       },
//                       enabled: !provider.isLoading,
//                     ),
//                     const SizedBox(height: 12),

//                     CustomInput(
//                       labelText: "Confirm Password",
//                       controller: _confirmPasswordController,
//                       onChanged: provider.setConfirmPassword,
//                       isPassword: true,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return "Please confirm your password";
//                         }
//                         if (value != _passwordController.text) {
//                           return "Passwords do not match";
//                         }
//                         return null;
//                       },
//                       enabled: !provider.isLoading,
//                     ),

//                     // Error Message
//                     if (provider.error.isNotEmpty) ...[
//                       Text(
//                         provider.error,
//                         style: const TextStyle(color: Colors.red),
//                       ),
//                       const SizedBox(height: 10),
//                     ],

//                     // Register Button
//                     provider.isLoading
//                         ? const Center(child: CircularProgressIndicator())
//                         : CustomButton(
//                             text: "Register",
//                             onPressed: () async {
//                               if (_formKey.currentState!.validate()) {
//                                 bool success = await provider.register();

//                                 if (success && context.mounted) {
//                                   if (context.mounted) {
//                                     showCoolSnackBar(
//                                       context,
//                                       "Registration successful! OTP sent to your email.",
//                                       true,
//                                     );
//                                   }

//                                   // Navigate to OTP page after short delay
//                                   Future.delayed(const Duration(seconds: 2),
//                                       () {
//                                     if (context.mounted) {
//                                       context.pushNamed(
//                                         'otp',
//                                         extra: {'email': provider.email},
//                                       );
//                                     }
//                                   });
//                                 } else {
//                                   if (context.mounted) {
//                                     showCoolSnackBar(
//                                         context, provider.error, false);
//                                   }
//                                 }
//                               }
//                             },
//                             color: CustomColors.primary,
//                           ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/providers/multipage_register_provider/signup_provider.dart';
import 'package:gymify/utils/custom_button.dart';
import 'package:gymify/utils/custom_input.dart';
import 'package:gymify/colors/custom_colors.dart';
import 'package:gymify/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
            child: Consumer<SignupProvider>(
              builder: (context, provider, child) {
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Header Image
                      Image.asset(
                        'assets/images/onboarding/workout.png',
                        width: 120,
                        height: 120,
                      ),
                      const SizedBox(height: 32),

                      // Title
                      Text(
                        'Create Account',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Subtitle
                      Text(
                        'Sign up to start your fitness journey',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Email Input
                      CustomInput(
                        labelText: 'Email',
                        controller: _emailController,
                        onChanged: provider.setEmail,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email is required";
                          }
                          if (!RegExp(
                                  r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
                              .hasMatch(value)) {
                            return "Enter a valid email address";
                          }
                          return null;
                        },
                        leadingIcon:
                            Icon(Icons.email, color: theme.iconTheme.color),
                      ),
                      const SizedBox(height: 16),

                      // Password Input
                      CustomInput(
                        labelText: 'Password',
                        controller: _passwordController,
                        isPassword: true,
                        onChanged: provider.setPassword,
                        enabled: !provider.isLoading,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }
                          if (value.length < 8) {
                            return "Password must be at least 8 characters";
                          }
                          if (!RegExp(
                                  r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$")
                              .hasMatch(value)) {
                            return "Password must contain uppercase, lowercase, number, and special character";
                          }
                          return null;
                        },
                        leadingIcon:
                            Icon(Icons.lock, color: theme.iconTheme.color),
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password Input
                      CustomInput(
                        labelText: 'Confirm your password',
                        controller: _confirmPasswordController,
                        isPassword: true,
                        onChanged: provider.setConfirmPassword,
                        enabled: !provider.isLoading,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please confirm your password";
                          }
                          if (value != _passwordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                        leadingIcon:
                            Icon(Icons.lock, color: theme.iconTheme.color),
                      ),
                      const SizedBox(height: 24),

                      // Error Message
                      if (provider.error.isNotEmpty) ...[
                        Text(
                          provider.error,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 10),
                      ],

                      // Register Button
                      provider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : CustomButton(
                              text: "Sign Up",
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  bool success = await provider.register();

                                  if (success && context.mounted) {
                                    showCoolSnackBar(
                                      context,
                                      "Registration successful! OTP sent to your email.",
                                      true,
                                    );

                                    // Navigate to OTP page
                                    Future.delayed(const Duration(seconds: 2),
                                        () {
                                      if (context.mounted) {
                                        context.pushNamed(
                                          'otp',
                                          extra: {'email': provider.email},
                                        );
                                      }
                                    });
                                  } else {
                                    showCoolSnackBar(
                                      context,
                                      provider.error,
                                      false,
                                    );
                                  }
                                }
                              },
                            ),
                      const SizedBox(height: 16),

                      // Login Button
                      TextButton(
                        onPressed: () {
                          context.go('/login');
                        },
                        child: Text(
                          'Already have an account? Log in',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
