import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gymify/models/api_response.dart';

import 'package:gymify/models/deit_plan_models/diet_plan_model.dart';
import 'package:gymify/models/deit_plan_models/meal_model.dart';
import 'package:gymify/models/diet_log_models/meal_logs_model.dart';
import 'package:gymify/network/http.dart';

class DietProvider with ChangeNotifier {
  List<DietPlan> _diets = [];
  List<DietPlan> get diets => _diets;

  List<MealLog> _mealLogs = [];
  List<MealLog> get mealLogs => _mealLogs;

  List<Meal> _meals = [];
  List<Meal> get meals => _meals;

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
        print(_diets);
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

  // Fetch all available meals
  Future<void> fetchMeals() async {
    _setLoading(true);
    try {
      final response = await httpClient.get('/meals');

      final apiResponse = ApiResponse<List<Meal>>.fromJson(
        response.data,
        (data) => (data as List).map((item) => Meal.fromJson(item)).toList(),
      );

      if (apiResponse.status == 'success') {
        _meals = apiResponse.data;
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
      print('Error fetching meals: $e');
      throw Exception('Error fetching meals: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createDietPlan({
    required String name,
    required double calorieGoal,
    required String goalType,
    required String description,
    File? dietImage, // Optional image file for the diet plan
  }) async {
    _setLoading(true);
    try {
      // Prepare base data for the diet plan
      final Map<String, dynamic> dataMap = {
        'name': name,
        'calorie_goal': calorieGoal,
        'goal_type': goalType,
        'description': description,
      };

      // If an image file is provided, add it as a MultipartFile
      if (dietImage != null) {
        dataMap['diet_image'] = await MultipartFile.fromFile(
          dietImage.path,
          filename: 'diet_image.jpeg',
          contentType: getContentType(dietImage),
        );
      }

      // Wrap the dataMap into FormData
      final formData = FormData.fromMap(dataMap);

      final response = await httpClient.post(
        '/diet-plans',
        data: formData,
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.status == 'success') {
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

  Future<void> createMeal({
    required int dietPlanId,
    required String mealName,
    required String mealTime,
    required double calories,
    required String description,
    Map<String, dynamic>? macronutrients,
    File? mealImage, // Optional image file
  }) async {
    _setLoading(true);
    try {
      // Prepare base data.
      final Map<String, dynamic> dataMap = {
        'diet_plan_id': dietPlanId,
        'meal_name': mealName,
        'meal_time': mealTime,
        'calories': calories,
        'description': description,
        // Convert macronutrients map to JSON string if provided.
        if (macronutrients != null)
          'macronutrients': jsonEncode(macronutrients),
      };

      // If an image file is provided, add it as a MultipartFile.
      if (mealImage != null) {
        dataMap['meal_image'] = await MultipartFile.fromFile(
          mealImage.path,
          filename: 'meal_image.jpeg',
          contentType: getContentType(mealImage),
        );
      }

      // Wrap the dataMap into FormData.
      final formData = FormData.fromMap(dataMap);

      final response = await httpClient.post(
        '/meals',
        data: formData,
      );

      final apiResponse = ApiResponse<Meal>.fromJson(
        response.data,
        (data) => Meal.fromJson(data as Map<String, dynamic>),
      );

      if (apiResponse.status == 'success') {
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
      print('Error creating meal: $e');
      throw Exception('Error creating meal: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Method to log a meal
  Future<void> logMeal({
    required int mealId,
    required double quantity,
    DateTime? logTime,
  }) async {
    _setLoading(true);
    try {
      final response = await httpClient.post(
        '/meal-logs', // Backend endpoint for meal logging
        data: {
          'meal_id': mealId,
          'quantity': quantity,
          'log_time':
              logTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
        },
      );
      final apiResponse = ApiResponse<List<MealLog>>.fromJson(
        response.data,
        (data) => (data as List).map((item) => MealLog.fromJson(item)).toList(),
      );

      if (apiResponse.status == 'success') {
        // Update the meal logs list with the newly logged meal
        fetchMealLogs();
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
      print('Error logging meal: $e');
      throw Exception('Error logging meal: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Fetch all meal logs for the user
  Future<void> fetchMealLogs() async {
    _setLoading(true);
    try {
      final response =
          await httpClient.get('/meal-logs'); // Fetch meal logs endpoint

      final apiResponse = ApiResponse<List<MealLog>>.fromJson(
        response.data,
        (data) => (data as List).map((item) => MealLog.fromJson(item)).toList(),
      );

      if (apiResponse.status == 'success') {
        _mealLogs = apiResponse
            .data; // Assuming _mealLogs is a list that holds meal logs
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
      print('Error fetching meal logs: $e');
      throw Exception('Error fetching meal logs: $e');
    } finally {
      _setLoading(false);
    }
  }

  // method to delete a certain meal log
  Future<void> deleteMealLog(int mealLogId) async {
    _setLoading(true);
    try {
      final response = await httpClient.delete('/meal-logs/$mealLogId');

      if (response.data['status'] == 'success') {
        // Remove the meal log from the list
        _mealLogs.removeWhere((mealLog) => mealLog.mealLogId == mealLogId);
        _setError(false);
        notifyListeners();
      } else {
        print('Error: ${response.data['message']}');
        throw Exception(response.data['message'].isNotEmpty
            ? response.data['message']
            : 'Unknown error');
      }
    } catch (e) {
      _setError(true);
      print('Error deleting meal log: $e');
      throw Exception('Error deleting meal log: $e');
    } finally {
      _setLoading(false);
    }
  }

// method to delete a certain diet plan
  Future<void> deleteDietPlan(int dietId) async {
    _setLoading(true);
    try {
      final response = await httpClient.delete('/diet-plans/$dietId');

      // Check if response data is not null
      if (response.data == null) {
        throw Exception('No response data received from the server');
      }

      if (response.data['status'] == 'success') {
        // Remove the diet plan from the list
        _diets.removeWhere((diet) => diet.dietPlanId == dietId);

        // Optionally, notify the user or refresh data
        _setError(false);
        notifyListeners();
      } else {
        print('Error: ${response.data['message']}');
        throw Exception(response.data['message'].isNotEmpty
            ? response.data['message']
            : 'Unknown error');
      }
    } catch (e) {
      _setError(true);
      print('Error deleting diet plan: $e');
      throw Exception('Error deleting diet plan: $e');
    } finally {
      _setLoading(false);
    }
  }
}
