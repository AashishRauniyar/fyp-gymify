// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:gymify/providers/multipage_register_provider/signup_provider.dart';
// import 'package:gymify/utils/custom_appbar.dart';
// import 'package:gymify/utils/custom_button.dart';
// import 'package:gymify/utils/custom_snackbar.dart';
// import 'package:provider/provider.dart';
// import 'package:pinput/pinput.dart';

// class OtpVerificationPage extends StatefulWidget {
//   final String email;

//   const OtpVerificationPage({super.key, required this.email});

//   @override
//   _OtpVerificationPageState createState() => _OtpVerificationPageState();
// }

// class _OtpVerificationPageState extends State<OtpVerificationPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _otpController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       backgroundColor: theme.colorScheme.surface,
//       // appBar: AppBar(
//       //   title: const Text("Verify OTP"),
//       //   backgroundColor: theme.colorScheme.primary,
//       //   elevation: 0,
//       //   iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
//       // ),
//       appBar: const CustomAppBar(
//         title: "Verify OTP",
//         showBackButton: true,
//       ),
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
//                       // OTP Illustration
//                       Image.asset(
//                         'assets/images/otp_verification.png', // Replace with your asset path
//                         width: 150,
//                         height: 150,
//                       ),
//                       const SizedBox(height: 24),
//                       // Title
//                       Text(
//                         "Verify Your Email",
//                         style: theme.textTheme.headlineMedium?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           color: theme.colorScheme.onSurface,
//                         ),
//                       ),
//                       const SizedBox(height: 8),

//                       // Subtitle
//                       Text(
//                         "Enter the 6-digit code sent to",
//                         style: theme.textTheme.bodyMedium?.copyWith(
//                           color: theme.colorScheme.onSurface.withOpacity(0.7),
//                         ),
//                       ),
//                       const SizedBox(height: 5),

//                       // Email Display
//                       Text(
//                         widget.email,
//                         style: theme.textTheme.bodyLarge?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           color: theme.colorScheme.primary,
//                         ),
//                       ),
//                       const SizedBox(height: 30),

//                       // OTP Input Field using Pinput
//                       Pinput(
//                         length: 6,
//                         controller: _otpController,
//                         keyboardType: TextInputType.number,
//                         onChanged: provider.setOtp,
//                         defaultPinTheme: PinTheme(
//                           width: 56,
//                           height: 56,
//                           textStyle: theme.textTheme.bodyLarge?.copyWith(
//                             fontWeight: FontWeight.bold,
//                           ),
//                           decoration: BoxDecoration(
//                             color: theme.colorScheme.surface,
//                             borderRadius: BorderRadius.circular(10),
//                             border: Border.all(
//                               color: theme.colorScheme.primary.withOpacity(0.3),
//                             ),
//                           ),
//                         ),
//                         focusedPinTheme: PinTheme(
//                           width: 56,
//                           height: 56,
//                           textStyle: theme.textTheme.bodyLarge?.copyWith(
//                             fontWeight: FontWeight.bold,
//                           ),
//                           decoration: BoxDecoration(
//                             color: theme.colorScheme.surface,
//                             borderRadius: BorderRadius.circular(10),
//                             border: Border.all(
//                               color: theme.colorScheme.primary,
//                               width: 2,
//                             ),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.length != 6) {
//                             return "Enter a valid 6-digit OTP";
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 24),

//                       // Error Message
//                       if (provider.error.isNotEmpty) ...[
//                         Text(
//                           provider.error,
//                           style: const TextStyle(color: Colors.red),
//                         ),
//                         const SizedBox(height: 16),
//                       ],

//                       // Verify OTP Button
//                       provider.isLoading
//                           ? const CircularProgressIndicator()
//                           : CustomButton(
//                               text: "Verify OTP",
//                               onPressed: () async {
//                                 if (_formKey.currentState!.validate()) {
//                                   bool success = await provider.verifyOtp();
//                                   if (success && context.mounted) {
//                                     showCoolSnackBar(
//                                       context,
//                                       "OTP verified successfully! Redirecting...",
//                                       true,
//                                     );
//                                     provider.clear();

//                                     Future.delayed(const Duration(seconds: 2),
//                                         () {
//                                       if (context.mounted) {
//                                         context.pushNamed('login');
//                                       }
//                                     });
//                                   } else {
//                                     if (context.mounted) {
//                                       showCoolSnackBar(
//                                           context, provider.error, false);
//                                     }
//                                   }
//                                 }
//                               },
//                             ),
//                       const SizedBox(height: 16),

//                       // Resend OTP Button
//                       TextButton(
//                         onPressed: provider.isLoading
//                             ? null
//                             : () async {
//                                 bool otpResent = await provider.resendOtp();
//                                 if (otpResent) {
//                                   showCoolSnackBar(
//                                     context,
//                                     "OTP resent successfully!",
//                                     true,
//                                   );
//                                 } else {
//                                   showCoolSnackBar(
//                                     context,
//                                     provider.error,
//                                     false,
//                                   );
//                                 }
//                               },
//                         child: Text(
//                           "Resend OTP",
//                           style: theme.textTheme.bodyMedium?.copyWith(
//                             color: theme.colorScheme.primary,
//                             fontWeight: FontWeight.bold,
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

//   @override
//   void dispose() {
//     _otpController.dispose();
//     super.dispose();
//   }
// }



import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/providers/multipage_register_provider/signup_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:gymify/utils/custom_button.dart';
import 'package:gymify/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;

  const OtpVerificationPage({super.key, required this.email});

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<SignupProvider>(context, listen: false);
    provider.setEmail(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: const CustomAppBar(
        title: "Verify OTP",
        showBackButton: true,
      ),
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
                      // OTP Illustration
                      Image.asset(
                        'assets/images/otp_verification.png',
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(height: 24),
                      // Title
                      Text(
                        "Verify Your Email",
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Subtitle
                      Text(
                        "Enter the 6-digit code sent to",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 5),

                      // Email Display
                      Text(
                        widget.email,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // OTP Input Field using Pinput
                      Pinput(
                        length: 6,
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        onChanged: provider.setOtp,
                        defaultPinTheme: PinTheme(
                          width: 56,
                          height: 56,
                          textStyle: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                            ),
                          ),
                        ),
                        focusedPinTheme: PinTheme(
                          width: 56,
                          height: 56,
                          textStyle: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: theme.colorScheme.primary,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.length != 6) {
                            return "Enter a valid 6-digit OTP";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Error Message
                      if (provider.error.isNotEmpty) ...[
                        Text(
                          provider.error,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Verify OTP Button
                      provider.isLoading
                          ? const CircularProgressIndicator()
                          : CustomButton(
                              text: "Verify OTP",
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  bool success = await provider.verifyOtp();
                                  if (success && context.mounted) {
                                    showCoolSnackBar(
                                      context,
                                      "OTP verified successfully!",
                                      true,
                                    );
                                    
                                    // Redirect to profile completion instead of login
                                    Future.delayed(const Duration(milliseconds: 500), () {
                                      if (context.mounted) {
                                        context.go('/complete-profile', extra: {'email': widget.email});
                                      }
                                    });
                                  } else {
                                    if (context.mounted) {
                                      showCoolSnackBar(
                                          context, provider.error, false);
                                    }
                                  }
                                }
                              },
                            ),
                      const SizedBox(height: 16),

                      // Resend OTP Button
                      TextButton(
                        onPressed: provider.isLoading
                            ? null
                            : () async {
                                bool otpResent = await provider.resendOtp();
                                if (otpResent) {
                                  showCoolSnackBar(
                                    context,
                                    "OTP resent successfully!",
                                    true,
                                  );
                                } else {
                                  showCoolSnackBar(
                                    context,
                                    provider.error,
                                    false,
                                  );
                                }
                              },
                        child: Text(
                          "Resend OTP",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
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

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }
}