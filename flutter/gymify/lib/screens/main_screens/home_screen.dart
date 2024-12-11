import 'package:flutter/material.dart';
import 'package:gymify/routes/route_config.dart';
import 'package:gymify/screens/exercise_screen.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body:  Column(
        children: [
          Text("Welcome to Gymify"),
          Text("Your personal fitness trainer"),
          // ink well for showing exercise
          InkWell(
            onTap: () {
              context.go('/exercises');
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Text(
                'Exercises',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          // ink well for creating exercise
          InkWell(
            onTap: () {
              context.go('/createExercise');
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Text(
                'Create Exercise',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )

        ],
      ),
    );
  }
}
