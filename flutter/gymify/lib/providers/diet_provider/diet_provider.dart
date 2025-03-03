import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
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

  // Future<void> createMeal({
  //   required int dietPlanId,
  //   required String mealName,
  //   required String mealTime,
  //   required double calories,
  //   required String description,
  //   Map<String, dynamic>? macronutrients,
  //   File? mealImage, // Optional image file path or URL
  // }) async {
  //   _setLoading(true);
  //   try {
  //     // Prepare the request data.
  //     // If macronutrients is provided, you can send it as-is if your backend accepts JSON,
  //     // otherwise convert it to a string using jsonEncode if needed.
  //     final requestData = {
  //       'diet_plan_id': dietPlanId,
  //       'meal_name': mealName,
  //       'meal_time': mealTime,
  //       'calories': calories,
  //       'description': description,
  //       'macronutrients':
  //           macronutrients, // or jsonEncode(macronutrients) if required
  //       // 'meal_image': mealImage, // optional; send only if there's an image
  //       if (mealImage != null)
  //         'image': await MultipartFile.fromFile(
  //           mealImage.path,
  //           filename: 'exercise_image.jpeg',
  //           contentType: getContentType(mealImage),
  //         ),
  //     };

  //     final response = await httpClient.post(
  //       '/meals',
  //       data: requestData,
  //     );

  //     // Parse the API response into a Meal object.
  //     final apiResponse = ApiResponse<Meal>.fromJson(
  //       response.data,
  //       (data) => Meal.fromJson(data as Map<String, dynamic>),
  //     );

  //     if (apiResponse.status == 'success') {
  //       // Optionally, you might update your local state to include this new meal.
  //       // For example, find the diet plan in _diets and add the new meal to its meals list.
  //       _setError(false);
  //       notifyListeners();
  //     } else {
  //       print('Error: ${apiResponse.message}');
  //       throw Exception(apiResponse.message.isNotEmpty
  //           ? apiResponse.message
  //           : 'Unknown error');
  //     }
  //   } catch (e) {
  //     _setError(true);
  //     print('Error creating meal: $e');
  //     throw Exception('Error creating meal: $e');
  //   } finally {
  //     _setLoading(false);
  //   }
  // }

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
}
