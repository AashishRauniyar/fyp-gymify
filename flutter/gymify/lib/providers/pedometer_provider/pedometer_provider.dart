import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class PedometerProvider with ChangeNotifier {
  String _status = '?';
  String _steps = '?';
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;

  String get status => _status;
  String get steps => _steps;

  bool _isTrackingSteps = false;
  bool get isTrackingSteps => _isTrackingSteps;

  // Initialize pedometer streams
  Future<void> startTracking() async {
    bool granted = await _checkActivityRecognitionPermission();
    if (!granted) {
      // Notify user that the app will not work without permission
      _status = 'Permission Denied';
      notifyListeners();
      return;
    }

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream.listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _isTrackingSteps = true;
    notifyListeners();
  }

  // Stop pedometer streams
  void stopTracking() {
    _isTrackingSteps = false;
    _stepCountStream.listen((_) {}).cancel();
    _pedestrianStatusStream.listen((_) {}).cancel();
    _status = 'Stopped';
    _steps = '0';
    notifyListeners();
  }

  // Callback when new step count is received
  void onStepCount(StepCount event) {
    _steps = event.steps.toString();
    notifyListeners();
  }

  // Callback when pedestrian status changes
  void onPedestrianStatusChanged(PedestrianStatus event) {
    _status = event.status;
    notifyListeners();
  }

  // Error callback for pedestrian status
  void onPedestrianStatusError(error) {
    _status = 'Error in Pedestrian Status';
    notifyListeners();
  }

  // Error callback for step count
  void onStepCountError(error) {
    _steps = 'Error in Step Count';
    notifyListeners();
  }

  // Request permission to use activity recognition
  Future<bool> _checkActivityRecognitionPermission() async {
    bool granted = await Permission.activityRecognition.isGranted;

    if (!granted) {
      granted = await Permission.activityRecognition.request() ==
          PermissionStatus.granted;
    }

    return granted;
  }
}
