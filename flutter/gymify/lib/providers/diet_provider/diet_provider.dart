import 'package:flutter/material.dart';
import 'package:gymify/models/api_response.dart';

import 'package:gymify/models/deit_plan_models/diet_plan_model.dart';
import 'package:gymify/network/http.dart';

class DietProvider with ChangeNotifier {
  List<DietPlan> _diets = [];

  List<DietPlan> get diets => _diets;

  bool _hasError = false;
  bool get hasError => _hasError;

  // is loading
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(bool error) {
    _hasError = error;
    notifyListeners();
  }

  Future<void> fetchAllDietPlans() async {
    _setLoading(true);
    try {
      final response = await httpClient.get('/diet-plans');

      final apiResponse = ApiResponse<List<DietPlan>>.fromJson(
        response.data,
        (data) =>
            (data as List).map((item) => DietPlan.fromJson(item)).toList(),
      );

      if (apiResponse.status == 'success') {
        _diets = apiResponse.data;
        _setError(false);
        notifyListeners();
      } else {
        print('Error: ${apiResponse.message}');
        throw Exception(apiResponse.message.isNotEmpty
            ? apiResponse.message
            : 'Unknown error');
      }
    } catch (e) {
      _setError(true);
      print('Error fetching diet plans: $e');
      throw Exception('Error fetching diet plans: $e');
    } finally {
      _setLoading(false);
    }
  }
}
