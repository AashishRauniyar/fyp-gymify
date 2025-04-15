import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/providers/multipage_register_provider/signup_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:gymify/utils/custom_button.dart';
import 'package:gymify/utils/custom_input.dart';
import 'package:gymify/utils/custom_snackbar.dart';
import 'package:pinput/pinput.dart';

class ResetPasswordScreen extends StatefulWidget {
  // Email is passed from the ForgotPasswordScreen via the router's extra property.
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        showCoolSnackBar(context, "Passwords do not match", false);
        return;
      }
      setState(() {
        _isLoading = true;
      });

      // final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final signupProvider =
          Provider.of<SignupProvider>(context, listen: false);

      // Call reset password API using the provided email, OTP, and new password.
      final success = await signupProvider.resetPassword(
        _newPasswordController.text,
        widget.email,
        _otpController.text.trim(),
      );

      if (success) {
        showCoolSnackBar(context, "Password reset successful", true);
        // Navigate to login screen after a short delay
        Future.delayed(const Duration(seconds: 2), () {
          context.go('/login');
        });
      } else {
        showCoolSnackBar(
          context,
          "Failed to reset password. Check OTP and try again.",
          false,
        );
      }
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
      // appBar: AppBar(
      //   title: const Text("Reset Password"),
      //   backgroundColor: theme.colorScheme.primary,
      // ),
      appBar: const CustomAppBar(
        title: "Reset Password",
        showBackButton: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // OTP illustration (can reuse your asset)
                Image.asset(
                  'assets/images/otp_verification.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 24),
                Text(
                  "Reset Your Password",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Enter the OTP sent to ${widget.email} and set your new password",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                // OTP input using Pinput widget
                Pinput(
                  length: 6,
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.length != 6) {
                      return "Enter a valid 6-digit OTP";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomInput(
                  controller: _newPasswordController,
                  labelText: "New Password",
                  isPassword: true,
                  keyboardType: TextInputType.visiblePassword,
                  leadingIcon: Icon(Icons.lock, color: theme.iconTheme.color),
                ),
                const SizedBox(height: 16),
                CustomInput(
                  controller: _confirmPasswordController,
                  labelText: "Confirm New Password",
                  isPassword: true,
                  keyboardType: TextInputType.visiblePassword,
                  leadingIcon: Icon(Icons.lock, color: theme.iconTheme.color),
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _resetPassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            "Reset Password",
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 16),
                // Resend OTP Button
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          // final authProvider = Provider.of<AuthProvider>(context, listen: false);
                          final signupProvider = Provider.of<SignupProvider>(
                              context,
                              listen: false);
                          final success = await signupProvider
                              .resendOtpForPasswordRecovery(widget.email);
                          if (success) {
                            showCoolSnackBar(
                                context, "OTP resent successfully!", true);
                          } else {
                            showCoolSnackBar(
                                context, "Failed to resend OTP", false);
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
          ),
        ),
      ),
    );
  }
}
