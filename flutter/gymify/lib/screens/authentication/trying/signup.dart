// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:gymify/providers/multipage_register_provider/signup_provider.dart';
// import 'package:gymify/utils/custom_button.dart';
// import 'package:gymify/utils/custom_input.dart';
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

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
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
//             child: Consumer<SignupProvider>(
//               builder: (context, provider, child) {
//                 return Form(
//                   key: _formKey,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // Header Image
//                       Image.asset(
//                         'assets/images/onboarding/workout.png',
//                         width: 120,
//                         height: 120,
//                       ),
//                       const SizedBox(height: 32),

//                       // Title
//                       Text(
//                         'Create Account',
//                         style: theme.textTheme.headlineMedium?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           color: theme.colorScheme.onSurface,
//                         ),
//                       ),
//                       const SizedBox(height: 8),

//                       // Subtitle
//                       Text(
//                         'Sign up to start your fitness journey',
//                         style: theme.textTheme.bodyMedium?.copyWith(
//                           color: theme.colorScheme.onSurface.withOpacity(0.7),
//                         ),
//                       ),
//                       const SizedBox(height: 32),

//                       // Email Input
//                       CustomInput(
//                         labelText: 'Email',
//                         controller: _emailController,
//                         onChanged: provider.setEmail,
//                         keyboardType: TextInputType.emailAddress,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Email is required";
//                           }
//                           if (!RegExp(
//                                   r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
//                               .hasMatch(value)) {
//                             return "Enter a valid email address";
//                           }
//                           return null;
//                         },
//                         leadingIcon:
//                             Icon(Icons.email, color: theme.iconTheme.color),
//                       ),
//                       const SizedBox(height: 16),

//                       // Password Input
//                       CustomInput(
//                         labelText: 'Password',
//                         controller: _passwordController,
//                         isPassword: true,
//                         onChanged: provider.setPassword,
//                         enabled: !provider.isLoading,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Password is required";
//                           }
//                           if (value.length < 8) {
//                             return "Password must be at least 8 characters";
//                           }
//                           if (!RegExp(
//                                   r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$")
//                               .hasMatch(value)) {
//                             return "Password must contain uppercase, lowercase, number, and special character";
//                           }
//                           return null;
//                         },
//                         leadingIcon:
//                             Icon(Icons.lock, color: theme.iconTheme.color),
//                       ),
//                       const SizedBox(height: 16),

//                       // Confirm Password Input
//                       CustomInput(
//                         labelText: 'Confirm your password',
//                         controller: _confirmPasswordController,
//                         isPassword: true,
//                         onChanged: provider.setConfirmPassword,
//                         enabled: !provider.isLoading,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Please confirm your password";
//                           }
//                           if (value != _passwordController.text) {
//                             return "Passwords do not match";
//                           }
//                           return null;
//                         },
//                         leadingIcon:
//                             Icon(Icons.lock, color: theme.iconTheme.color),
//                       ),
//                       const SizedBox(height: 24),

//                       // Error Message
//                       if (provider.error.isNotEmpty) ...[
//                         Text(
//                           provider.error,
//                           style: const TextStyle(color: Colors.red),
//                         ),
//                         const SizedBox(height: 10),
//                       ],

//                       // Register Button
//                       provider.isLoading
//                           ? const Center(child: CircularProgressIndicator())
//                           : CustomButton(
//                               text: "Sign Up",
//                               onPressed: () async {
//                                 if (_formKey.currentState!.validate()) {
//                                   bool success = await provider.register();

//                                   if (success && context.mounted) {
//                                     showCoolSnackBar(
//                                       context,
//                                       "Registration successful! OTP sent to your email.",
//                                       true,
//                                     );

//                                     // Navigate to OTP page
//                                     Future.delayed(const Duration(seconds: 2),
//                                         () {
//                                       if (context.mounted) {
//                                         context.pushNamed(
//                                           'otp',
//                                           extra: {'email': provider.email},
//                                         );
//                                       }
//                                     });
//                                   } else {
//                                     showCoolSnackBar(
//                                       context,
//                                       provider.error,
//                                       false,
//                                     );
//                                   }
//                                 }
//                               },
//                             ),
//                       const SizedBox(height: 16),

//                       // Login Button
//                       TextButton(
//                         onPressed: () {
//                           context.go('/login');
//                         },
//                         child: Text(
//                           'Already have an account? Log in',
//                           style: theme.textTheme.bodyMedium?.copyWith(
//                             color: theme.colorScheme.primary,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/providers/multipage_register_provider/signup_provider.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:gymify/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? Colors.black : theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // // Background design elements
          // Positioned(
          //   top: -100,
          //   right: -100,
          //   child: Container(
          //     width: 300,
          //     height: 300,
          //     decoration: BoxDecoration(
          //       color: theme.colorScheme.primary.withOpacity(0.1),
          //       shape: BoxShape.circle,
          //     ),
          //   ),
          // ),
          // Positioned(
          //   bottom: -80,
          //   left: -80,
          //   child: Container(
          //     width: 200,
          //     height: 200,
          //     decoration: BoxDecoration(
          //       color: theme.colorScheme.secondary.withOpacity(0.1),
          //       shape: BoxShape.circle,
          //     ),
          //   ),
          // ),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Consumer<SignupProvider>(
                  builder: (context, provider, child) => Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),

                        // App logo with circle background
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondary
                                    .withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              width: 120,
                              height: 120,
                            ),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                'assets/images/onboarding/workout.png',
                                width: 50,
                                height: 50,
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // App name and tag
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Gymify',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'GYM APP',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        // Welcome text
                        Column(
                          children: [
                            Text(
                              'Create Account',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Sign up to start your fitness journey',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        // Email field
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: isDarkMode
                                ? Colors.grey[900]
                                : theme.colorScheme.surface,
                            border: Border.all(
                              color: isDarkMode
                                  ? Colors.grey[800]!
                                  : theme.dividerColor,
                              width: 1,
                            ),
                          ),
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: provider.setEmail,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email is required";
                              }
                              // Updated regex to allow formats like me.aashish@gmail.com
                              if (!RegExp(
                                      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                                  .hasMatch(value)) {
                                return "Enter a valid email address";
                              }
                              return null;
                            },
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: isDarkMode
                                  ? Colors.white
                                  : theme.colorScheme.onSurface,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter your email',
                              hintStyle: TextStyle(
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : theme.hintColor,
                              ),
                              prefixIcon: Icon(
                                FontAwesomeIcons.envelope,
                                color: theme.colorScheme.primary,
                                size: 18,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 8),
                              errorStyle: const TextStyle(height: 1),
                            ),
                          ),
                        ),

                        // Password field
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: isDarkMode
                                ? Colors.grey[900]
                                : theme.colorScheme.surface,
                            border: Border.all(
                              color: isDarkMode
                                  ? Colors.grey[800]!
                                  : theme.dividerColor,
                              width: 1,
                            ),
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
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
                                return "Must include uppercase, lowercase, number, special character";
                              }
                              return null;
                            },
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: isDarkMode
                                  ? Colors.white
                                  : theme.colorScheme.onSurface,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter your password',
                              hintStyle: TextStyle(
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : theme.hintColor,
                              ),
                              prefixIcon: Icon(
                                FontAwesomeIcons.lock,
                                color: theme.colorScheme.primary,
                                size: 18,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 8),
                              errorStyle: const TextStyle(height: 1),
                            ),
                          ),
                        ),

                        // Confirm Password field
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: isDarkMode
                                ? Colors.grey[900]
                                : theme.colorScheme.surface,
                            border: Border.all(
                              color: isDarkMode
                                  ? Colors.grey[800]!
                                  : theme.dividerColor,
                              width: 1,
                            ),
                          ),
                          child: TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: true,
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
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: isDarkMode
                                  ? Colors.white
                                  : theme.colorScheme.onSurface,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Confirm your password',
                              hintStyle: TextStyle(
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : theme.hintColor,
                              ),
                              prefixIcon: Icon(
                                FontAwesomeIcons.lock,
                                color: theme.colorScheme.primary,
                                size: 18,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 8),
                              errorStyle: const TextStyle(height: 1),
                            ),
                          ),
                        ),

                        // Error Message
                        if (provider.error.isNotEmpty) ...[
                          Text(
                            provider.error,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 10),
                        ],

                        const SizedBox(height: 20),

                        // Register Button
                        provider.isLoading
                            ? const Center(child: CustomLoadingAnimation())
                            : SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
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
                                        Future.delayed(
                                            const Duration(seconds: 2), () {
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
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.colorScheme.primary,
                                    foregroundColor:
                                        theme.colorScheme.onPrimary,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    'Sign Up',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              ),

                        const SizedBox(height: 40),

                        // Login link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isDarkMode
                                    ? Colors.white70
                                    : theme.colorScheme.onSurface
                                        .withOpacity(0.7),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                context.go('/login');
                              },
                              child: Text(
                                'Log In',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
