import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/providers/multipage_register_provider/signup_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:gymify/utils/custom_button.dart';
import 'package:gymify/utils/custom_input.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:gymify/utils/custom_snackbar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    if (_emailController.text.isEmpty) {
      showCoolSnackBar(context, "Please enter your email", false);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final signupProvider = Provider.of<SignupProvider>(context, listen: false);

    // Call the forgot password API
    final success =
        await signupProvider.forgotPassword(_emailController.text.trim());

    if (success) {
      showCoolSnackBar(context, "OTP sent to your email", true);
      // Navigate to the Reset Password screen and pass the email
      context.pushNamed('resetPassword', extra: _emailController.text.trim());
    } else {
      showCoolSnackBar(context, "Failed to send OTP. Try again.", false);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      // appBar: AppBar(
      //   title: const Text("Forgot Password"),
      //   backgroundColor: theme.colorScheme.primary,
      // ),
      appBar: const CustomAppBar(title: "Forgot Password"),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Illustration for forgot password
              Image.asset(
                'assets/images/forgot_password.png',
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
                "Enter your registered email to receive an OTP",
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              CustomInput(
                controller: _emailController,
                labelText: "Email",
                keyboardType: TextInputType.emailAddress,
                leadingIcon: Icon(Icons.email, color: theme.iconTheme.color),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CustomLoadingAnimation()
                  : CustomButton(
                      text: "Send OTP",
                      onPressed: _sendOTP,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
