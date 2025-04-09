// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import 'package:gymify/providers/auth_provider/auth_provider.dart';
// import 'package:gymify/utils/custom_button.dart';
// import 'package:gymify/utils/custom_input.dart';
// import 'package:gymify/utils/custom_loader.dart';
// import 'package:gymify/utils/custom_snackbar.dart'; // Import reusable Snackbar

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isLoading = false;
//   final bool _rememberMe = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _login() async {
//     if (!mounted) return;

//     setState(() {
//       _isLoading = true;
//     });

//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final response = await authProvider.login(
//       _emailController.text.trim(),
//       _passwordController.text,
//     );

//     if (!mounted) return;

//     if (response) {
//       showCoolSnackBar(context, "Login successful! Welcome back.", true);
//       if (authProvider.isLoggedIn) {
//         await Future.delayed(const Duration(milliseconds: 500), () {
//           // if (mounted) context.go('/home');
//           if (authProvider.role == "Trainer") {
//             if (mounted) context.go('/trainerScreen');
//           } else {
//             if (mounted) context.go('/home');
//           }
//         });
//       }
//     } else {
//       showCoolSnackBar(
//         context,
//         "Login failed. Check your credentials and try again.",
//         false,
//       );
//     }

//     if (mounted) {
//       setState(() {
//         _isLoading = false;
//       });
//     }
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

//                 // Title
//                 Text(
//                   'Welcome Back!',
//                   style: theme.textTheme.headlineMedium?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: theme.colorScheme.onSurface,
//                   ),
//                 ),
//                 const SizedBox(height: 8),

//                 // Subtitle
//                 Text(
//                   'Login to continue your fitness journey',
//                   style: theme.textTheme.bodyMedium?.copyWith(
//                     color: theme.colorScheme.onSurface.withOpacity(0.7),
//                   ),
//                 ),
//                 const SizedBox(height: 32),

//                 // Email Input Field
//                 CustomInput(
//                   controller: _emailController,
//                   labelText: 'Enter your email',
//                   keyboardType: TextInputType.emailAddress,
//                   leadingIcon: Icon(Icons.email, color: theme.iconTheme.color),
//                 ),
//                 const SizedBox(height: 16),

//                 // Password Input Field (Now using built-in toggle)
//                 CustomInput(
//                   controller: _passwordController,
//                   labelText: 'Enter your password',
//                   isPassword: true, // This enables the visibility toggle
//                   enabled: !_isLoading,
//                   keyboardType: TextInputType.visiblePassword,
//                   leadingIcon: Icon(Icons.lock, color: theme.iconTheme.color),
//                 ),
//                 const SizedBox(height: 16),

//                 // Remember Me & Forgot Password
//                 Row(
//                   children: [
//                     // Text('Remember Me', style: theme.textTheme.bodyMedium),
//                     const Spacer(),
//                     TextButton(
//                       onPressed: () {
//                         context.pushNamed('forgotPassword');
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

//                 // Login Button
//                 _isLoading
//                     ? const CustomLoadingAnimation()
//                     : CustomButton(
//                         text: "Login",
//                         onPressed: () async {
//                           if (_emailController.text.isEmpty ||
//                               _passwordController.text.isEmpty) {
//                             showCoolSnackBar(
//                               context,
//                               "Please fill in all fields.",
//                               false,
//                             );
//                             return;
//                           }
//                           await _login();
//                         },
//                       ),
//                 const SizedBox(height: 16),

//                 // Sign Up Button
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
import 'package:gymify/utils/custom_loader.dart';
import 'package:gymify/utils/custom_snackbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;

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
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? Colors.black : theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background design elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
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
                            color: theme.colorScheme.secondary.withOpacity(0.1),
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
                          'Welcome Back!',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Login to continue your fitness journey',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
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
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: isDarkMode
                              ? Colors.white
                              : theme.colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(
                            color:
                                isDarkMode ? Colors.grey[400] : theme.hintColor,
                          ),
                          prefixIcon: Icon(
                            FontAwesomeIcons.envelope,
                            color: theme.colorScheme.primary,
                            size: 18,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 8),
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
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: isDarkMode
                              ? Colors.white
                              : theme.colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(
                            color:
                                isDarkMode ? Colors.grey[400] : theme.hintColor,
                          ),
                          prefixIcon: Icon(
                            FontAwesomeIcons.lock,
                            color: theme.colorScheme.primary,
                            size: 18,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 8),
                        ),
                      ),
                    ),

                    // Remember me & Forgot password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Remember me checkbox
                        Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                                activeColor: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Remember me',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isDarkMode
                                    ? Colors.white70
                                    : theme.colorScheme.onSurface
                                        .withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),

                        // Forgot password link
                        TextButton(
                          onPressed: () {
                            context.pushNamed('forgotPassword');
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Forgot Password?',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Login button
                    _isLoading
                        ? const Center(child: CustomLoadingAnimation())
                        : SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: theme.colorScheme.onPrimary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                'Login',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),

                    const SizedBox(height: 40),

                    // Signup link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDarkMode
                                ? Colors.white70
                                : theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.go('/signup');
                          },
                          child: Text(
                            'Sign Up',
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
        ],
      ),
    );
  }
}
