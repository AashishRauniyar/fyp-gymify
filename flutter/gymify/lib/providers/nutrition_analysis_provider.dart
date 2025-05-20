import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gymify/models/nutrition_analysis_model.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:gymify/services/ai_services/ai_api_service.dart';

class NutritionAnalysisProvider with ChangeNotifier {
  NutritionAnalysis? _result;
  bool _isLoading = false;
  String? _error;

  NutritionAnalysis? get result => _result;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void reset() {
    _result = null;
    _error = null;
    notifyListeners();
  }

  Future<void> analyzeImage(File imageFile) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final apiKey = ApiService.apiKey;
      if (apiKey == null) throw Exception('API key not found');
      final model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          temperature: 0.4,
          topK: 32,
          topP: 0.95,
          maxOutputTokens: 1024,
        ),
      );
      final bytes = await imageFile.readAsBytes();
      final base64Data = bytes.buffer.asUint8List();
      const prompt = '''
        Analyze this food image and return a JSON object with these fields:
        - food_name (string)
        - calories (int)
        - protein (int, grams)
        - carbs (int, grams)
        - fat (int, grams)
        - fiber (int, grams)
        - sugar (int, grams)
        - sodium (int, mg)
        - potassium (int, mg)
        - health_benefits (string, short summary)
        - is_healthy (bool, true if healthy, false if not)
        Respond ONLY with a valid JSON object, no extra text.
      ''';
      final imagePart = DataPart('image/jpeg', base64Data);
      final content = Content.multi([
        TextPart(prompt),
        imagePart,
      ]);
      final response = await model.generateContent([content]);
      final text = response.text;
      if (text == null) throw Exception('No response from AI');
      // Try to find the JSON in the response (in case of extra text)
      final jsonStart = text.indexOf('{');
      final jsonEnd = text.lastIndexOf('}');
      if (jsonStart == -1 || jsonEnd == -1)
        throw Exception('Invalid JSON response');
      final jsonString = text.substring(jsonStart, jsonEnd + 1);
      final Map<String, dynamic> json = jsonDecode(jsonString);
      _result = NutritionAnalysis.fromJson(json);
    } catch (e) {
      _error = e.toString();
      _result = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
