import 'package:flutter/material.dart';
import 'package:gymify/models/api_response.dart';

import 'package:gymify/models/deit_plan_models/diet_plan_model.dart';
import 'package:gymify/models/deit_plan_models/meal_model.dart';
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

  Future<void> createDietPlan({
    required String name,
    required double calorieGoal,
    required String goalType,
    required String description,
  }) async {
    _setLoading(true);
    try {
      final response = await httpClient.post(
        '/diet-plans',
        data: {
          'name': name,
          'calorie_goal': calorieGoal,
          'goal_type': goalType,
          'description': description,
        },
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.status == 'success') {
         // Add the newly created diet plan
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
      print('Error creating diet plan: $e');
      throw Exception('Error creating diet plan: $e');
    } finally {
      _setLoading(false);
    }
  }

  
  Future<void> addMealToDietPlan({
    required int dietPlanId,
    required List<Map<String, dynamic>> meals,
    required String imageFilePath, // Optional image path for meal
  }) async {
    _setLoading(true);
    try {
      final response = await httpClient.post(
        '/diet-plans/add-meal',
        data: {
          'diet_plan_id': dietPlanId,
          'meals': meals,
          'meal_image': imageFilePath, // If you have an image, send it here
        },
      );

      final apiResponse = ApiResponse<List<Meal>>.fromJson(
        response.data,
        (data) => (data as List).map((item) => Meal.fromJson(item)).toList(),
      );

      if (apiResponse.status == 'success') {
        // Update the diet plan with the newly added meals
        // You may want to fetch the updated diet plan or add meals locally
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
      print('Error adding meals to diet plan: $e');
      throw Exception('Error adding meals to diet plan: $e');
    } finally {
      _setLoading(false);
    }
  }
}
