import 'dart:async';

import 'package:pedometer/pedometer.dart';

class PedometerService {
  late Stream<StepCount> _stepCountStream;
  late StreamSubscription<StepCount> _stepCountSubscription;
  
  // Stream to listen to step count updates
  Stream<StepCount> get stepCountStream => _stepCountStream;

  // Function to start the pedometer and listen to the step count
  void startStepCounting() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountSubscription = _stepCountStream.listen((stepCount) {
      
    });
  }

  // Function to stop the step count listener
  void stopStepCounting() {
    _stepCountSubscription.cancel();
  }
}
