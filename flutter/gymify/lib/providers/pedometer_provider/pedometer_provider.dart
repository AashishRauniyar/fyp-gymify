import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PedometerProvider with ChangeNotifier {
  String _status = '?';
  String _steps = '0';
  int _initialStepCount = 0;
  int _currentStepCount = 0;
  
  // Goal tracking
  int _dailyGoal = 10000;
  double _distanceWalked = 0.0; // in km
  double _caloriesBurned = 0.0;
  bool _goalAchieved = false;
  
  // Streams
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  
  // Tracking state
  bool _isTrackingSteps = false;
  DateTime? _trackingStartTime;
  
  // Getters
  String get status => _status;
  String get steps => _steps;
  bool get isTrackingSteps => _isTrackingSteps;
  int get dailyGoal => _dailyGoal;
  double get distanceWalked => _distanceWalked;
  double get caloriesBurned => _caloriesBurned;
  bool get goalAchieved => _goalAchieved;
  DateTime? get trackingStartTime => _trackingStartTime;
  
  double get goalProgress {
    if (_currentStepCount == 0 || _dailyGoal == 0) return 0.0;
    return (_currentStepCount / _dailyGoal).clamp(0.0, 1.0);
  }
  
  Duration get elapsedTime {
    if (_trackingStartTime == null) return const Duration();
    return DateTime.now().difference(_trackingStartTime!);
  }
  
  // Constructor
  PedometerProvider() {
    _loadSavedGoal();
  }
  
  // Load saved goal from preferences
  Future<void> _loadSavedGoal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _dailyGoal = prefs.getInt('dailyGoal') ?? 10000;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading saved goal: $e');
    }
  }
  
  // Save goal to preferences
  Future<void> _saveGoal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('dailyGoal', _dailyGoal);
    } catch (e) {
      debugPrint('Error saving goal: $e');
    }
  }
  
  // Set daily goal
  Future<void> setDailyGoal(int goal) async {
    if (goal <= 0) return;
    
    _dailyGoal = goal;
    await _saveGoal();
    
    // Update goal achievement status based on new goal
    _checkGoalAchievement();
    notifyListeners();
  }

  // Initialize pedometer streams
  Future<void> startTracking() async {
    if (_isTrackingSteps) return;
    
    bool granted = await _checkActivityRecognitionPermission();
    if (!granted) {
      // Notify user that the app will not work without permission
      _status = 'Permission Denied';
      notifyListeners();
      return;
    }
    
    try {
      _trackingStartTime = DateTime.now();
      
      // Initialize step count stream
      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream.listen(onStepCount).onError(onStepCountError);
      
      // Initialize pedestrian status stream
      _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
      _pedestrianStatusStream.listen(onPedestrianStatusChanged)
          .onError(onPedestrianStatusError);
      
      _isTrackingSteps = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error starting tracking: $e');
      _status = 'Error Starting Tracker';
      notifyListeners();
    }
  }

  // Stop pedometer streams
  void stopTracking() {
    if (!_isTrackingSteps) return;
    
    try {
      _isTrackingSteps = false;
      _trackingStartTime = null;
      _status = 'Stopped';
      
      // Cancel streams safely
      _stepCountStream.listen((_) {}).cancel();
      _pedestrianStatusStream.listen((_) {}).cancel();
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error stopping tracking: $e');
    }
  }
  
  // Reset step count
  void resetSteps() {
    _initialStepCount = _currentStepCount;
    _steps = '0';
    _distanceWalked = 0.0;
    _caloriesBurned = 0.0;
    _goalAchieved = false;
    notifyListeners();
  }

  // Callback when new step count is received
  void onStepCount(StepCount event) {
    try {
      // If this is the first reading, set as initial value
      if (_initialStepCount == 0) {
        _initialStepCount = event.steps;
      }
      
      _currentStepCount = event.steps;
      int steps = _currentStepCount - _initialStepCount;
      _steps = steps.toString();
      
      // Calculate stats
      _calculateStats(steps);
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error in step count handler: $e');
    }
  }
  
  // Calculate stats based on steps
  void _calculateStats(int steps) {
    // Calculate distance (average stride length is about 0.762 meters)
    const double strideLength = 0.762 / 1000; // in km
    _distanceWalked = steps * strideLength;
    
    // Calculate calories (average calorie burn is about 0.04 calories per step)
    const double caloriesPerStep = 0.04;
    _caloriesBurned = steps * caloriesPerStep;
    
    // Check goal achievement
    _checkGoalAchievement();
  }
  
  // Check if daily goal is achieved
  void _checkGoalAchievement() {
    if (!_goalAchieved && _currentStepCount - _initialStepCount >= _dailyGoal) {
      _goalAchieved = true;
      // Here you could add a notification or celebration
    }
  }

  // Callback when pedestrian status changes
  void onPedestrianStatusChanged(PedestrianStatus event) {
    try {
      _status = event.status;
      notifyListeners();
    } catch (e) {
      debugPrint('Error in pedestrian status handler: $e');
    }
  }

  // Error callback for pedestrian status
  void onPedestrianStatusError(error) {
    debugPrint('Pedestrian status error: $error');
    _status = 'Error in Status';
    notifyListeners();
  }

  // Error callback for step count
  void onStepCountError(error) {
    debugPrint('Step count error: $error');
    _steps = 'Error';
    notifyListeners();
  }

  // Request permission to use activity recognition
  Future<bool> _checkActivityRecognitionPermission() async {
    try {
      bool granted = await Permission.activityRecognition.isGranted;
      
      if (!granted) {
        var status = await Permission.activityRecognition.request();
        granted = status == PermissionStatus.granted;
      }
      
      return granted;
    } catch (e) {
      debugPrint('Error checking permission: $e');
      return false;
    }
  }
}