import 'package:flutter/material.dart';
import 'package:gymify/models/all_user_model.dart';
import 'package:gymify/network/http.dart';
import 'package:gymify/models/api_response.dart';

class TrainerProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _hasError = false;
  List<AllUserModel> _members = [];
  List<AllUserModel> _trainers = [];
  List<AllUserModel> _allActiveMembers = [];

  List<AllUserModel> get trainers => _trainers;
  List<AllUserModel> get members => _members;
  List<AllUserModel> get allActiveMembers => _allActiveMembers;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  void _setLoading(bool loading) {
    _isLoading = loading;
    // Delay notifyListeners to avoid conflicts with the build process
    Future.microtask(() => notifyListeners());
  }

  void _setError(bool error) {
    _hasError = error;
    Future.microtask(() => notifyListeners());
  }

  Future<void> fetchAllMembers() async {
    _setLoading(true);
    try {
      final response = await httpClient.get('/members');
      final apiResponse = ApiResponse<List<AllUserModel>>.fromJson(
        response.data,
        (data) =>
            (data as List).map((item) => AllUserModel.fromJson(item)).toList(),
      );

      if (apiResponse.status == 'success') {
        _members = apiResponse.data;
        _setError(false);
      } else {
        _setError(true);
      }
    } catch (e) {
      _setError(true);
      print('Error fetching users: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchAllActiveMembers() async {
    _setLoading(true);
    try {
      final response = await httpClient.get('/activeMembers');
      final apiResponse = ApiResponse<List<AllUserModel>>.fromJson(
        response.data,
        (data) =>
            (data as List).map((item) => AllUserModel.fromJson(item)).toList(),
      );

      if (apiResponse.status == 'success') {
        _allActiveMembers = apiResponse.data;
        _setError(false);
      } else {
        _setError(true);
      }
    } catch (e) {
      _setError(true);
      print('Error fetching active users: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchAllTrainers() async {
    _setLoading(true);
    try {
      final response = await httpClient.get('/trainers');
      final apiResponse = ApiResponse<List<AllUserModel>>.fromJson(
        response.data,
        (data) =>
            (data as List).map((item) => AllUserModel.fromJson(item)).toList(),
      );

      if (apiResponse.status == 'success') {
        _trainers = apiResponse.data;
        _setError(false);
      } else {
        _setError(true);
      }
    } catch (e) {
      _setError(true);
      print('Error fetching trainers: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchDataByRole(String role) async {
    if (role == 'Trainer') {
      await fetchAllMembers();
      await fetchAllActiveMembers();
    } else {
      await fetchAllTrainers();
    }
  }
}
