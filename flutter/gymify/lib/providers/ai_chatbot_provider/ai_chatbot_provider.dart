// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:gymify/models/user_model.dart';
// import 'package:image_picker/image_picker.dart';

// class Message {
//   final String content;
//   final bool isUser;
//   final File? imageFile;

//   Message({required this.content, required this.isUser, this.imageFile});
// }

// class AIChatbotProvider with ChangeNotifier {
//   final String apiKey;
//   late GenerativeModel _model;
//   late GenerativeModel _visionModel;
//   final List<Message> _messages = [];
//   bool _isLoading = false;
//   String? _errorMessage;

//   List<Message> get messages => _messages;
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;

//   AIChatbotProvider({required this.apiKey}) {
//     _initializeModels();
//   }

//   void _initializeModels() {
//     // Initialize text-only model
//     _model = GenerativeModel(
//       model: 'gemini-1.5-pro',
//       apiKey: apiKey,
//       generationConfig: GenerationConfig(
//         temperature: 0.7,
//         topK: 40,
//         topP: 0.95,
//         maxOutputTokens: 1024,
//       ),
//     );

//     // Initialize vision model for food image analysis
//     _visionModel = GenerativeModel(
//       model: 'gemini-1.5-pro-vision',
//       apiKey: apiKey,
//       generationConfig: GenerationConfig(
//         temperature: 0.4,
//         topK: 32,
//         topP: 0.95,
//         maxOutputTokens: 1024,
//       ),
//     );
//   }

//   void _setLoading(bool loading) {
//     _isLoading = loading;
//     notifyListeners();
//   }

//   void _setError(String? error) {
//     _errorMessage = error;
//     notifyListeners();
//   }

//   void resetError() {
//     _errorMessage = null;
//     notifyListeners();
//   }

//   // Generate system prompt based on user profile
//   String _generateSystemPrompt(Users user) {
//     final age = user.birthdate != null
//         ? DateTime.now().difference(user.birthdate!).inDays ~/ 365
//         : 'unknown';

//     return '''
//     You are a personal fitness and nutrition assistant. Provide helpful, personalized advice based on the following user information:
//     - Name: ${user.fullName ?? 'User'}
//     - Age: $age years
//     - Gender: ${user.gender ?? 'Not specified'}
//     - Current Weight: ${user.currentWeight ?? 'Not specified'}
//     - Height: ${user.height ?? 'Not specified'}
//     - Fitness Level: ${user.fitnessLevel ?? 'Not specified'}
//     - Goal: ${user.goalType ?? 'Not specified'}
//     - Allergies/Dietary Restrictions: ${user.allergies ?? 'None specified'}
//     - Daily Calorie Target: ${user.calorieGoals ?? 'Not specified'}

//     Always provide practical, safe, and realistic advice. Be supportive and motivational.
//     Provide specific workout and diet recommendations, not vague advice.
//     Keep responses concise but informative.
//     ''';
//   }

//   // Send a text message to the AI
//   Future<void> sendMessage(String message, Users user) async {
//     if (message.trim().isEmpty) return;

//     final userMessage = Message(content: message, isUser: true);
//     _messages.add(userMessage);
//     notifyListeners();

//     _setLoading(true);
//     try {
//       final systemPrompt = _generateSystemPrompt(user);

//       // Create chat history from previous messages
//       final history = <Content>[];

//       // Add system prompt as the first message if we haven't sent any messages yet
//       if (_messages.length <= 1) {
//         history.add(Content.text(systemPrompt));
//       } else {
//         // Otherwise, use relevant message history (limited to last 10 messages)
//         final relevantMessages = _messages.sublist(
//             _messages.length > 11 ? _messages.length - 11 : 0,
//             _messages.length - 1);

//         for (final msg in relevantMessages) {
//           history.add(Content.text(msg.isUser
//               ? "User: ${msg.content}"
//               : "Assistant: ${msg.content}"));
//         }
//       }

//       // Add current user query
//       final userContent = Content.text("User: $message");

//       // Combine history and current query
//       final chatSession = _model.startChat(history: history);
//       final response = await chatSession.sendMessage(userContent);

//       final aiResponse =
//           response.text ?? "I'm sorry, I couldn't generate a response.";
//       final aiMessage = Message(content: aiResponse, isUser: false);

//       _messages.add(aiMessage);
//     } catch (e) {
//       _setError('Error communicating with AI: ${e.toString()}');
//     } finally {
//       _setLoading(false);
//     }
//   }

//   // Analyze food from image
//   Future<void> analyzeFood(File imageFile, Users user) async {
//     final userMessage = Message(
//         content: "What are the calories in this food?",
//         isUser: true,
//         imageFile: imageFile);
//     _messages.add(userMessage);
//     notifyListeners();

//     _setLoading(true);
//     try {
//       // Read image data
//       final bytes = await imageFile.readAsBytes();
//       final base64Data = bytes.buffer.asUint8List();

//       // Create prompt for food analysis with user context
//       final prompt = '''
//         Analyze this food image and provide:
//         1. Name of the food item(s)
//         2. Estimated calories per serving
//         3. Macronutrients breakdown (protein, carbs, fat)
//         4. Whether this food aligns with the user's goals (${user.goalType ?? 'general fitness'})

//         User has the following dietary considerations:
//         - Allergies: ${user.allergies ?? 'None specified'}
//         - Daily calorie target: ${user.calorieGoals ?? 'Not specified'}

//         Be accurate but estimate if uncertain. Provide information in a clean, structured format.
//       ''';

//       // Create the image part for the content
//       final imagePart = DataPart('image/jpeg', base64Data);
//       final content = Content.multi([
//         TextPart(prompt),
//         imagePart,
//       ]);

//       // Send to the model
//       final response = await _visionModel.generateContent([content]);
//       final aiResponse =
//           response.text ?? "I couldn't analyze this image properly.";

//       final aiMessage = Message(content: aiResponse, isUser: false);
//       _messages.add(aiMessage);
//     } catch (e) {
//       _setError('Error analyzing food image: ${e.toString()}');
//     } finally {
//       _setLoading(false);
//     }
//   }

//   // Clear chat history
//   void clearChat() {
//     _messages.clear();
//     notifyListeners();
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:gymify/models/user_model.dart';
import 'package:image_picker/image_picker.dart';

class Message {
  final String content;
  final bool isUser;
  final File? imageFile;
  final bool isSuggestion; // Added for quick reply suggestions

  Message(
      {required this.content,
      required this.isUser,
      this.imageFile,
      this.isSuggestion = false});
}

class AIChatbotProvider with ChangeNotifier {
  final String apiKey;
  late GenerativeModel _model;
  late GenerativeModel _visionModel;
  final List<Message> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _userName;

  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get userName => _userName;

  // Predefined questions for quick user selection
  final List<String> predefinedQuestions = [
    "What workouts are best for my fitness goals?",
    "Can you suggest a meal plan based on my calorie target?",
    "How do I improve my form for weightlifting?",
    "What's a good workout routine for beginners?",
    "How can I track my fitness progress effectively?",
    "What supplements should I consider for my goals?",
    "How many rest days should I take per week?",
    "What exercises target specific muscle groups?",
  ];

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
    _userName = user.fullName ?? 'User';

    final age = user.birthdate != null
        ? DateTime.now().difference(user.birthdate!).inDays ~/ 365
        : 'unknown';

    return '''
    You are GymBuddy AI, a specialized fitness and nutrition assistant exclusively for gym-goers. Focus only on providing gym-related advice and information. Keep responses concise (maximum 4 sentences unless detailed information is specifically requested).
    
    Current user profile:
    - Name: ${user.fullName ?? 'User'}
    - Age: $age years
    - Gender: ${user.gender ?? 'Not specified'}
    - Current Weight: ${user.currentWeight ?? 'Not specified'} 
    - Height: ${user.height ?? 'Not specified'}
    - Fitness Level: ${user.fitnessLevel ?? 'Not specified'}
    - Goal: ${user.goalType ?? 'Not specified'}
    - Allergies/Dietary Restrictions: ${user.allergies ?? 'None specified'}
    - Daily Calorie Target: ${user.calorieGoals ?? 'Not specified'}

    Reply guidelines:
    1. Provide specific, actionable gym and fitness advice tailored to user's profile
    2. Use motivational language appropriate for fitness coaching
    3. Include precise exercise recommendations with reps, sets when relevant
    4. For nutrition questions, base responses on user's calorie goals and restrictions
    5. Present information in clean, structured formats using markdown for readability
    6. Refuse to discuss topics unrelated to fitness, nutrition, or gym training
    7. Use gym-specific terminology appropriately
    8. For complex topics, break down information into steps or bullet points
    9. Never provide medical diagnoses or treatment recommendations
    
    If the user types "/coach", provide a personalized workout and nutrition recommendation based on their profile data.
    ''';
  }

  // Send welcome message when chat is initialized
  Future<void> sendWelcomeMessage(Users user) async {
    _userName = user.fullName ?? 'User';
    final firstName = _userName!.split(' ')[0];

    final welcomeMessage = '''
Hi $firstName! 👋 Welcome to Gymify AI - your personal fitness assistant!

I'm here to help you reach your fitness goals. You can ask me about:
- Workout routines
- Nutrition advice
- Form guidance
- Progress tracking

Type **/coach** anytime for a personalized recommendation based on your profile!

What can I help you with today?
''';

    final aiMessage = Message(content: welcomeMessage, isUser: false);
    _messages.add(aiMessage);
    notifyListeners();

    // Add suggestions after welcome message
    addSuggestions();
  }

  // Add quick reply suggestions to the chat
  void addSuggestions() {
    // Shuffle the questions to get different ones each time
    final shuffled = List<String>.from(predefinedQuestions)..shuffle();
    // Take only the first 3 questions
    final suggestions = shuffled.take(3).toList();

    for (final question in suggestions) {
      _messages.add(Message(
        content: question,
        isUser: false,
        isSuggestion: true,
      ));
    }
    notifyListeners();
  }

  // Send a text message to the AI
  Future<void> sendMessage(String message, Users user) async {
    if (message.trim().isEmpty) return;

    // Special command handling
    if (message.trim().toLowerCase() == "/coach") {
      return await sendCoachRequest(user);
    }

    final userMessage = Message(content: message, isUser: true);
    _messages.add(userMessage);
    notifyListeners();

    _setLoading(true);
    try {
      final systemPrompt = _generateSystemPrompt(user);

      // Create chat history from previous messages
      final history = <Content>[];

      // Add system prompt at the beginning
      history.add(Content.text(systemPrompt));

      // Filter non-suggestion messages for history
      final filteredMessages =
          _messages.where((msg) => !msg.isSuggestion).toList();

      // Only process history if we have at least 2 messages (to avoid range errors)
      if (filteredMessages.length > 1) {
        // Determine how many messages to include in history (max 6)
        final startIndex =
            filteredMessages.length > 7 ? filteredMessages.length - 7 : 0;
        final endIndex =
            filteredMessages.length - 1; // Exclude the most recent user message

        // Only proceed if valid range
        if (startIndex < endIndex) {
          final relevantMessages =
              filteredMessages.sublist(startIndex, endIndex);

          for (final msg in relevantMessages) {
            history.add(Content.text(msg.isUser
                ? "User: ${msg.content}"
                : "Assistant: ${msg.content}"));
          }
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

      // Add new suggestions after every AI response
      addSuggestions();
    } catch (e) {
      _setError('Error communicating with AI: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Special handler for the /coach command
  Future<void> sendCoachRequest(Users user) async {
    final userMessage = Message(content: "/coach", isUser: true);
    _messages.add(userMessage);
    notifyListeners();

    _setLoading(true);
    try {
      final prompt = '''
Based on the user's profile:
- Name: ${user.fullName ?? 'User'}
- Fitness Level: ${user.fitnessLevel ?? 'Not specified'}
- Goal: ${user.goalType ?? 'Not specified'}
- Current Weight: ${user.currentWeight ?? 'Not specified'}
- Height: ${user.height ?? 'Not specified'}
- Daily Calorie Target: ${user.calorieGoals ?? 'Not specified'}

Provide a personalized:
1. Workout plan for the next 7 days with specific exercises, sets, reps
2. Brief nutrition guidance including macro breakdown and meal timing
3. Two specific tips to help them achieve their stated goals

Format this as a clear, bulleted plan that's easy to follow. Keep it concise but actionable.
''';

      final chatSession = _model.startChat();
      final response = await chatSession.sendMessage(Content.text(prompt));

      final aiResponse =
          response.text ?? "I'm sorry, I couldn't generate a coaching plan.";
      final aiMessage = Message(content: aiResponse, isUser: false);

      _messages.add(aiMessage);

      // Add suggestions after coach response
      addSuggestions();
    } catch (e) {
      _setError('Error generating coaching plan: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Analyze food from image
  Future<void> analyzeFood(File imageFile, Users user) async {
    final userMessage = Message(
        content: "What are the nutrition facts of this food?",
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
        You are GymBuddy AI, a fitness nutrition expert. Analyze this food image for a gym-goer with the following profile:
        - Fitness goal: ${user.goalType ?? 'general fitness'}
        - Daily calorie target: ${user.calorieGoals ?? 'Not specified'}
        - Dietary restrictions: ${user.allergies ?? 'None specified'}
        
        Provide:
        1. Name of the food item(s)
        2. Estimated calories per serving
        3. Protein, carbs, and fat content
        4. How this food fits into a gym nutrition plan for their goals
        5. One suggestion for optimizing this meal for better gym results
        
        Format response with clear headings and bullet points. Be precise with nutritional estimates.
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

      // Add suggestions after food analysis
      addSuggestions();
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
