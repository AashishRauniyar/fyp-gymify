import 'package:flutter/material.dart';
import 'package:gymify/providers/pedometer_provider/pedometer_provider.dart';
import 'package:provider/provider.dart';
// Import PedometerProvider

class StepCountScreen extends StatefulWidget {
  const StepCountScreen({super.key});

  @override
  State<StepCountScreen> createState() => _StepCountScreenState();
}

class _StepCountScreenState extends State<StepCountScreen> {
  @override
  void initState() {
    super.initState();
    // Start tracking when the screen is initialized
    Future.delayed(Duration.zero, () {
      Provider.of<PedometerProvider>(context, listen: false).startTracking();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step Count Tracker'),
      ),
      body: Consumer<PedometerProvider>(
        builder: (context, pedometerProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Display Step Count
                const Text(
                  'Steps Taken',
                  style: TextStyle(fontSize: 30),
                ),
                Text(
                  pedometerProvider.steps,
                  style: const TextStyle(fontSize: 60),
                ),
                const SizedBox(height: 20),

                // Display Pedestrian Status
                const Text(
                  'Pedestrian Status',
                  style: TextStyle(fontSize: 30),
                ),
                Icon(
                  pedometerProvider.status == 'walking'
                      ? Icons.directions_walk
                      : pedometerProvider.status == 'stopped'
                          ? Icons.accessibility_new
                          : Icons.error,
                  size: 100,
                ),
                const SizedBox(height: 10),
                Text(
                  pedometerProvider.status,
                  style: TextStyle(
                    fontSize: pedometerProvider.status == 'walking' ||
                            pedometerProvider.status == 'stopped'
                        ? 30
                        : 20,
                    color: pedometerProvider.status == 'walking' ||
                            pedometerProvider.status == 'stopped'
                        ? null
                        : Colors.red,
                  ),
                ),

                // Button to start/stop tracking
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (pedometerProvider.isTrackingSteps) {
                      pedometerProvider.stopTracking();
                    } else {
                      pedometerProvider.startTracking();
                    }
                  },
                  child: Text(pedometerProvider.isTrackingSteps
                      ? 'Stop Tracking'
                      : 'Start Tracking'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
