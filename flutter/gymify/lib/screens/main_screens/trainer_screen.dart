import 'package:flutter/material.dart';
import 'package:gymify/utils/custom_appbar.dart';

class TrainerScreen extends StatefulWidget {
  const TrainerScreen({super.key});

  @override
  State<TrainerScreen> createState() => _TrainerScreenState();
}

class _TrainerScreenState extends State<TrainerScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'Trainer Screen',
      ),
      body: Center(
        child: Text('Trainer Screen'),
      ),
    );
  }
}
