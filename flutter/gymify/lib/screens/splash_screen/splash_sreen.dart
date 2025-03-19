import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:gymify/providers/auth_provider/auth_provider.dart';
import 'package:gymify/providers/chat_provider/chat_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    final authProvider = context.read<AuthProvider>();

    await authProvider.checkLoginStatus();

    // final chatProvider = context.read<ChatProvider>();
    // if (authProvider.isLoggedIn) {
    //   print('socket ma pugyo');
    //   final userId = authProvider.userId;
    //   if (userId != null) {
    //     chatProvider.initializeSocket(userId);
    //   }
    // }

    Future.delayed(const Duration(seconds: 5), () {
      if (authProvider.isLoggedIn) {
        context.go('/home');
      } else {
        context.go('/welcome');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/gif/welcome.gif',
              fit: BoxFit.cover,
            ),
          ),
          const Center(
            child: Text(
              'Welcome to Gymify',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
