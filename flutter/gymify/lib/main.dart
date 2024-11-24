import 'package:flutter/material.dart';
import 'package:gymify/screens/age_selecter.dart';
import 'package:gymify/screens/login.dart';
import 'package:gymify/screens/register.dart';
import 'package:gymify/screens/test.dart';

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
      home: LoginScreen(),
      routes: {
        '/register': (context) => const RegisterScreen(),
        '/login': (context) =>  LoginScreen(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
