import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:gymify/models/user_model.dart';
import 'package:image_picker/image_picker.dart';

class Message {
  final String content;
  final bool isUser;
  final File? imageFile;

  Message({required this.content, required this.isUser, this.imageFile});
}

class AIChatbotProvider with ChangeNotifier {
  final String apiKey;
  late GenerativeModel _model;
  late GenerativeModel _visionModel;
  final List<Message> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AIChatbotProvider({required this.apiKey}) {
    _initializeModels();
  }

  void _initializeModels() {
    // Initialize text-only model
    _model = GenerativeModel(
      model: 'gemini-1.5-pro',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 1024,
      ),
    );

    // Initialize vision model for food image analysis
    _visionModel = GenerativeModel(
      model: 'gemini-1.5-pro-vision',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.4,
        topK: 32,
        topP: 0.95,
        maxOutputTokens: 1024,
      ),
    );
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void resetError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Generate system prompt based on user profile
  String _generateSystemPrompt(Users user) {
    final age = user.birthdate != null
        ? DateTime.now().difference(user.birthdate!).inDays ~/ 365
        : 'unknown';

    return '''
    You are a personal fitness and nutrition assistant. Provide helpful, personalized advice based on the following user information:
    - Name: ${user.fullName ?? 'User'}
    - Age: $age years
    - Gender: ${user.gender ?? 'Not specified'}
    - Current Weight: ${user.currentWeight ?? 'Not specified'}
    - Height: ${user.height ?? 'Not specified'}
    - Fitness Level: ${user.fitnessLevel ?? 'Not specified'}
    - Goal: ${user.goalType ?? 'Not specified'}
    - Allergies/Dietary Restrictions: ${user.allergies ?? 'None specified'}
    - Daily Calorie Target: ${user.calorieGoals ?? 'Not specified'}

    Always provide practical, safe, and realistic advice. Be supportive and motivational.
    Provide specific workout and diet recommendations, not vague advice.
    Keep responses concise but informative.
    ''';
  }

  // Send a text message to the AI
  Future<void> sendMessage(String message, Users user) async {
    if (message.trim().isEmpty) return;

    final userMessage = Message(content: message, isUser: true);
    _messages.add(userMessage);
    notifyListeners();

    _setLoading(true);
    try {
      final systemPrompt = _generateSystemPrompt(user);

      // Create chat history from previous messages
      final history = <Content>[];

      // Add system prompt as the first message if we haven't sent any messages yet
      if (_messages.length <= 1) {
        history.add(Content.text(systemPrompt));
      } else {
        // Otherwise, use relevant message history (limited to last 10 messages)
        final relevantMessages = _messages.sublist(
            _messages.length > 11 ? _messages.length - 11 : 0,
            _messages.length - 1);

        for (final msg in relevantMessages) {
          history.add(Content.text(msg.isUser
              ? "User: ${msg.content}"
              : "Assistant: ${msg.content}"));
        }
      }

      // Add current user query
      final userContent = Content.text("User: $message");

      // Combine history and current query
      final chatSession = _model.startChat(history: history);
      final response = await chatSession.sendMessage(userContent);

      final aiResponse =
          response.text ?? "I'm sorry, I couldn't generate a response.";
      final aiMessage = Message(content: aiResponse, isUser: false);

      _messages.add(aiMessage);
    } catch (e) {
      _setError('Error communicating with AI: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Analyze food from image
  Future<void> analyzeFood(File imageFile, Users user) async {
    final userMessage = Message(
        content: "What are the calories in this food?",
        isUser: true,
        imageFile: imageFile);
    _messages.add(userMessage);
    notifyListeners();

    _setLoading(true);
    try {
      // Read image data
      final bytes = await imageFile.readAsBytes();
      final base64Data = bytes.buffer.asUint8List();

      // Create prompt for food analysis with user context
      final prompt = '''
        Analyze this food image and provide:
        1. Name of the food item(s)
        2. Estimated calories per serving
        3. Macronutrients breakdown (protein, carbs, fat)
        4. Whether this food aligns with the user's goals (${user.goalType ?? 'general fitness'})
        
        User has the following dietary considerations:
        - Allergies: ${user.allergies ?? 'None specified'}
        - Daily calorie target: ${user.calorieGoals ?? 'Not specified'}
        
        Be accurate but estimate if uncertain. Provide information in a clean, structured format.
      ''';

      // Create the image part for the content
      final imagePart = DataPart('image/jpeg', base64Data);
      final content = Content.multi([
        TextPart(prompt),
        imagePart,
      ]);

      // Send to the model
      final response = await _visionModel.generateContent([content]);
      final aiResponse =
          response.text ?? "I couldn't analyze this image properly.";

      final aiMessage = Message(content: aiResponse, isUser: false);
      _messages.add(aiMessage);
    } catch (e) {
      _setError('Error analyzing food image: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Clear chat history
  void clearChat() {
    _messages.clear();
    notifyListeners();
  }
}
