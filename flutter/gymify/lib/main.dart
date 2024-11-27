import 'package:flutter/material.dart';
import 'package:gymify/screens/age_selecter.dart';
import 'package:gymify/screens/authentication/login.dart';
import 'package:gymify/screens/authentication/register.dart';
import 'package:gymify/screens/test.dart';
import 'package:gymify/screens/welcome/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gymify',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomeScreen(),
      routes: {
        '/register': (context) => const RegisterScreen(),
        '/login': (context) =>  LoginScreen(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
