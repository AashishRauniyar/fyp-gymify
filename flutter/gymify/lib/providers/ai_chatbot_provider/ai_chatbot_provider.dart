import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:gymify/models/user_model.dart';
import 'package:gymify/models/workout_model.dart';
import 'package:gymify/models/exercise_model.dart';
import 'package:gymify/models/deit_plan_models/diet_plan_model.dart';
import 'package:gymify/models/deit_plan_models/meal_model.dart';

class Message {
  final String content;
  final bool isUser;
  final File? imageFile;
  final bool isSuggestion; // For quick reply suggestions
  final Workout? recommendedWorkout; // For workout recommendations
  final Exercise? recommendedExercise; // For exercise recommendations
  final DietPlan? recommendedDietPlan; // For diet plan recommendations
  final Meal? recommendedMeal; // For meal recommendations

  Message({
    required this.content,
    required this.isUser,
    this.imageFile,
    this.isSuggestion = false,
    this.recommendedWorkout,
    this.recommendedExercise,
    this.recommendedDietPlan,
    this.recommendedMeal,
  });
}

class AIChatbotProvider with ChangeNotifier {
  final String apiKey;
  late GenerativeModel _model;
  late GenerativeModel _visionModel;
  final List<Message> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _userName;

  // Store workout and exercise data for recommendations
  List<Workout> _workouts = [];
  List<Exercise> _exercises = [];

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
      model: 'gemini-2.0-flash',
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

  // Initialize with workout and exercise data
  void initializeWithData(
      Users user, List<Workout> workouts, List<Exercise> exercises) {
    _userName = user.fullName ?? 'User';
    _workouts = workouts;
    _exercises = exercises;
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
    
    Special commands:
    - If the user types "/coach", provide a personalized workout and nutrition recommendation based on their profile data
    - If the user types "/workout", recommend specific workouts from the database that match their goals
    - If the user types "/exercise", recommend specific exercises from the database that match their needs
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

You can also use these special commands:
- **/coach** for a personalized fitness plan
- **/workout** to discover workout recommendations
- **/exercise** to find exercises that match your goals
- **/dietplan** for diet plan recommendations

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
    } else if (message.trim().toLowerCase() == "/workout") {
      return await recommendWorkout(user);
    } else if (message.trim().toLowerCase() == "/exercise") {
      return await recommendExercise(user);
    } else if (message.trim().toLowerCase() == "/dietplan") {
      return await recommendDietPlan(user);
    } else if (message.trim().toLowerCase() == "/meal") {
      return await recommendMeal(user);
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

  // Recommend workout based on user profile
  Future<void> recommendWorkout(Users user) async {
    final userMessage = Message(content: "/workout", isUser: true);
    _messages.add(userMessage);
    notifyListeners();

    _setLoading(true);
    try {
      // Check if we have workouts to recommend
      if (_workouts.isEmpty) {
        final aiMessage = Message(
          content:
              "I couldn't find any workouts in the database. Please try again later.",
          isUser: false,
        );
        _messages.add(aiMessage);
        addSuggestions();
        return;
      }

      // Filter workouts based on user's fitness level and goals if possible
      List<Workout> filteredWorkouts = _workouts;

      if (user.fitnessLevel != null && user.fitnessLevel!.isNotEmpty) {
        final matchingLevelWorkouts = _workouts
            .where((w) =>
                w.fitnessLevel.toLowerCase() ==
                user.fitnessLevel!.toLowerCase())
            .toList();

        if (matchingLevelWorkouts.isNotEmpty) {
          filteredWorkouts = matchingLevelWorkouts;
        }
      }

      if (user.goalType != null &&
          user.goalType!.isNotEmpty &&
          filteredWorkouts.length > 1) {
        final matchingGoalWorkouts = filteredWorkouts
            .where(
                (w) => w.goalType.toLowerCase() == user.goalType!.toLowerCase())
            .toList();

        if (matchingGoalWorkouts.isNotEmpty) {
          filteredWorkouts = matchingGoalWorkouts;
        }
      }

      // Select a random workout from filtered list
      filteredWorkouts.shuffle();
      final recommendedWorkout = filteredWorkouts.first;

      // Create a message explaining the recommendation
      final messageContent = '''
I've found a workout that matches your profile:

**${recommendedWorkout.workoutName}** is a ${recommendedWorkout.difficulty} workout designed for ${recommendedWorkout.fitnessLevel} level users with ${recommendedWorkout.goalType} goals.

This workout targets the ${recommendedWorkout.targetMuscleGroup} muscles. Check it out below!
''';

      final aiMessage = Message(
        content: messageContent,
        isUser: false,
        recommendedWorkout: recommendedWorkout,
      );

      _messages.add(aiMessage);
      addSuggestions();
    } catch (e) {
      _setError('Error finding workout recommendations: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Recommend exercise based on user profile
  Future<void> recommendExercise(Users user) async {
    final userMessage = Message(content: "/exercise", isUser: true);
    _messages.add(userMessage);
    notifyListeners();

    _setLoading(true);
    try {
      // Check if we have exercises to recommend
      if (_exercises.isEmpty) {
        final aiMessage = Message(
          content:
              "I couldn't find any exercises in the database. Please try again later.",
          isUser: false,
        );
        _messages.add(aiMessage);
        addSuggestions();
        return;
      }

      // Select a random exercise or filter based on profile if possible
      _exercises.shuffle();
      final recommendedExercise = _exercises.first;

      // Create a message explaining the recommendation
      final messageContent = '''
Here's an exercise I recommend for you:

**${recommendedExercise.exerciseName}** targets the ${recommendedExercise.targetMuscleGroup} muscles and burns approximately ${recommendedExercise.caloriesBurnedPerMinute} calories per minute.

This exercise would be a great addition to your workout routine!
''';

      final aiMessage = Message(
        content: messageContent,
        isUser: false,
        recommendedExercise: recommendedExercise,
      );

      _messages.add(aiMessage);
      addSuggestions();
    } catch (e) {
      _setError('Error finding exercise recommendations: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Recommend diet plan based on user profile
  Future<void> recommendDietPlan(Users user) async {
    final userMessage = Message(content: "/dietplan", isUser: true);
    _messages.add(userMessage);
    notifyListeners();

    _setLoading(true);
    try {
      const messageContent = '''
I'd be happy to recommend a diet plan that matches your goals! 

Please check the diet plan card below that I've selected based on your profile. You can tap on it to view more details.

Diet plans are customized to help you reach your fitness goals while meeting your nutritional needs.
''';

      final aiMessage = Message(
        content: messageContent,
        isUser: false,
        // The actual diet plan will be fetched and attached in the UI layer
      );

      _messages.add(aiMessage);
      addSuggestions();
    } catch (e) {
      _setError('Error finding diet plan recommendations: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Recommend meal based on user profile
  Future<void> recommendMeal(Users user) async {
    final userMessage = Message(content: "/meal", isUser: true);
    _messages.add(userMessage);
    notifyListeners();

    _setLoading(true);
    try {
      // This would typically fetch meals from your provider
      // Since we don't have direct access to the diet provider here,
      // we'll need to implement this in the UI layer

      const messageContent = '''
Looking for meal inspiration? 

I've selected a meal recommendation that aligns with your fitness goals. Check out the meal card below for details on ingredients, nutrition facts, and preparation tips.

You can tap on the card to see the full meal details.
''';

      final aiMessage = Message(
        content: messageContent,
        isUser: false,
        // The actual meal will be fetched and attached in the UI layer
      );

      _messages.add(aiMessage);
      addSuggestions();
    } catch (e) {
      _setError('Error finding meal recommendations: ${e.toString()}');
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

  // Method to update the last message (needed for diet plan and meal recommendations)
  void updateLastMessage(Message newMessage) {
    if (_messages.isNotEmpty) {
      _messages[_messages.length - 1] = newMessage;
      notifyListeners();
    }
  }
}
