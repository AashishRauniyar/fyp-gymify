import 'package:flutter/material.dart';
import 'package:gymify/models/api_response.dart';
import 'package:gymify/models/trainer_models/user_list_trainer.dart';

import 'package:gymify/network/http.dart';

class UserStatsProvider with ChangeNotifier {
  List<UserListItem> _users = [];
  List<UserListItem> get users => _users;

  UserStats? _userStats;
  UserStats? get userStats => _userStats;

  StatsSummary? _statsSummary;
  StatsSummary? get statsSummary => _statsSummary;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasError = false;
  bool get hasError => _hasError;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(bool error, [String message = '']) {
    _hasError = error;
    _errorMessage = message;
    notifyListeners();
  }

  // Fetch all users (members)
  Future<void> fetchAllUsers() async {
    _setLoading(true);
    _setError(false);

    try {
      final response = await httpClient.get('/all-users');

      final apiResponse = ApiResponse<List<UserListItem>>.fromJson(
        response.data,
        (data) => (data as List)
            .map((item) => UserListItem.fromJson(item))
            .toList(),
      );

      if (apiResponse.status == 'success') {
        _users = apiResponse.data;
      } else {
        _setError(true, apiResponse.message);
      }
    } catch (e) {
      print('Error fetching users: $e');
      _setError(true, 'Failed to load users. Please try again.');
    } finally {
      _setLoading(false);
    }
  }

  // Fetch user statistics by ID
  Future<void> fetchUserStats(int userId) async {
    _setLoading(true);
    _setError(false);

    try {
      final response = await httpClient.get('/user-stats/$userId');

      final apiResponse = ApiResponse<UserStats>.fromJson(
        response.data,
        (data) => UserStats.fromJson(data as Map<String, dynamic>),
      );

      if (apiResponse.status == 'success') {
        _userStats = apiResponse.data;
      } else {
        _setError(true, apiResponse.message);
      }
    } catch (e) {
      print('Error fetching user stats: $e');
      _setError(true, 'Failed to load user statistics. Please try again.');
    } finally {
      _setLoading(false);
    }
  }

  // Fetch summary statistics
  Future<void> fetchStatsSummary() async {
    _setLoading(true);
    _setError(false);

    try {
      final response = await httpClient.get('/users-stats-summary');

      final apiResponse = ApiResponse<StatsSummary>.fromJson(
        response.data,
        (data) => StatsSummary.fromJson(data as Map<String, dynamic>),
      );

      if (apiResponse.status == 'success') {
        _statsSummary = apiResponse.data;
      } else {
        _setError(true, apiResponse.message);
      }
    } catch (e) {
      print('Error fetching stats summary: $e');
      _setError(
          true, 'Failed to load statistics summary. Please try again.');
    } finally {
      _setLoading(false);
    }
  }

  // Clear user stats when no longer needed
  void clearUserStats() {
    _userStats = null;
    notifyListeners();
  }
}