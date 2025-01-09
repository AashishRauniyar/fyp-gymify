import 'package:flutter/material.dart';
import 'package:gymify/colors/custom_colors.dart';

class DietScreen extends StatelessWidget {
  const DietScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: CustomColors.backgroundColor,
        title: const Text(
          'Diet',
          style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: CustomColors.secondary),
        ),
      ),
      body: Text("this is the diet screen"),
    );
  }
}
