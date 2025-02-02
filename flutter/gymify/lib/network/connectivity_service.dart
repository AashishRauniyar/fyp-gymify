import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkStatusProvider with ChangeNotifier {
  bool _isConnected = true;

  bool get isConnected => _isConnected;

  NetworkStatusProvider() {
    _init();
  }

  Future<void> _init() async {
    Connectivity().onConnectivityChanged.listen((result) {
      _isConnected = result != ConnectivityResult.none;
      notifyListeners();
    });
  }

  Future<void> checkConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    _isConnected = connectivityResult != ConnectivityResult.none;
    notifyListeners();
  }
}
