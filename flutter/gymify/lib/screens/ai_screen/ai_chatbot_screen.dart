import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/models/exercise_model.dart';
import 'package:gymify/models/workout_model.dart';
import 'package:gymify/models/deit_plan_models/diet_plan_model.dart';
import 'package:gymify/models/deit_plan_models/meal_model.dart';
import 'package:gymify/providers/ai_chatbot_provider/ai_chatbot_provider.dart';
import 'package:gymify/providers/exercise_provider/exercise_provider.dart';
import 'package:gymify/providers/profile_provider/profile_provider.dart';
import 'package:gymify/providers/workout_provider/workout_provider.dart';
import 'package:gymify/providers/diet_provider/diet_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AIChatbotScreen extends StatefulWidget {
  const AIChatbotScreen({super.key});

  @override
  State<AIChatbotScreen> createState() => _AIChatbotScreenState();
}

class _AIChatbotScreenState extends State<AIChatbotScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  bool _showSuggestionPrompt = true;
  bool _isComposing = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Animation setup
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();

    // Send welcome message after the user profile has been loaded
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Initialize required providers
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      final workoutProvider =
          Provider.of<WorkoutProvider>(context, listen: false);
      final exerciseProvider =
          Provider.of<ExerciseProvider>(context, listen: false);
      final dietProvider = Provider.of<DietProvider>(context, listen: false);

      // Fetch workouts, exercises, and diet plans for AI recommendations
      await Future.wait([
        workoutProvider.fetchAllWorkouts(),
        exerciseProvider.fetchAllExercises(),
        dietProvider.fetchAllDietPlans(),
      ]);

      if (profileProvider.user != null) {
        _sendWelcomeMessage();
      }
    });

    // Listen for text changes to update UI
    _messageController.addListener(() {
      setState(() {
        _isComposing = _messageController.text.isNotEmpty;
      });
    });
  }

  void _sendWelcomeMessage() {
    final user = Provider.of<ProfileProvider>(context, listen: false).user;
    if (user != null) {
      final chatProvider =
          Provider.of<AIChatbotProvider>(context, listen: false);

      // Pass workout and exercise data to AI provider
      final workouts =
          Provider.of<WorkoutProvider>(context, listen: false).workouts;
      final exercises =
          Provider.of<ExerciseProvider>(context, listen: false).exercises;

      chatProvider.initializeWithData(user, workouts, exercises);
      chatProvider.sendWelcomeMessage(user);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final user = Provider.of<ProfileProvider>(context, listen: false).user;
    if (user == null) {
      _showCustomSnackBar('User profile not loaded yet.');
      return;
    }

    final chatProvider = Provider.of<AIChatbotProvider>(context, listen: false);
    _messageController.clear();

    // Hide suggestion prompt when user sends a message
    setState(() {
      _showSuggestionPrompt = false;
      _isComposing = false;
    });

    // Special handling for dietplan and meal commands in the UI layer
    if (message.trim().toLowerCase() == "/dietplan") {
      await _handleDietPlanCommand(chatProvider, user);
    } else if (message.trim().toLowerCase() == "/meal") {
      await _handleMealCommand(chatProvider, user);
    } else {
      await chatProvider.sendMessage(message, user);
    }

    _scrollToBottom();
  }

  // Handle the dietplan command
  Future<void> _handleDietPlanCommand(
      AIChatbotProvider chatProvider, user) async {
    // First, send the command to the provider to add the user message
    await chatProvider.recommendDietPlan(user);

    // Now we need to fetch a diet plan and attach it to the last message
    try {
      // Fetch diet plans from diet provider
      final dietProvider = Provider.of<DietProvider>(context, listen: false);
      await dietProvider.fetchAllDietPlans();

      if (dietProvider.diets.isNotEmpty) {
        // Select a random diet plan
        dietProvider.diets.shuffle();
        final dietPlan = dietProvider.diets.first;

        // Get the last message (which should be the AI response)
        final messages = chatProvider.messages;
        final lastMessageIndex = messages.length - 1;

        // Create a new message with the diet plan attached
        if (lastMessageIndex >= 0 && !messages[lastMessageIndex].isUser) {
          final lastMessage = messages[lastMessageIndex];
          final updatedMessage = Message(
            content: lastMessage.content,
            isUser: false,
            recommendedDietPlan: dietPlan,
          );

          // Replace the last message with our updated one
          chatProvider.updateLastMessage(updatedMessage);
        }
      } else {
        _showCustomSnackBar('No diet plans available. Please try again later.');
      }
    } catch (e) {
      _showCustomSnackBar('Error loading diet plans: ${e.toString()}');
    }
  }

  // Handle the meal command
  Future<void> _handleMealCommand(AIChatbotProvider chatProvider, user) async {
    // First, send the command to the provider to add the user message
    await chatProvider.recommendMeal(user);

    // Now we need to fetch a meal and attach it to the last message
    try {
      // Fetch diet plans from diet provider to get meals
      final dietProvider = Provider.of<DietProvider>(context, listen: false);
      await dietProvider.fetchAllDietPlans();

      // Collect all meals from all diet plans
      final allMeals = <Meal>[];
      for (final diet in dietProvider.diets) {
        allMeals.addAll(diet.meals);
      }

      if (allMeals.isNotEmpty) {
        // Select a random meal
        allMeals.shuffle();
        final meal = allMeals.first;

        // Get the last message (which should be the AI response)
        final messages = chatProvider.messages;
        final lastMessageIndex = messages.length - 1;

        // Create a new message with the meal attached
        if (lastMessageIndex >= 0 && !messages[lastMessageIndex].isUser) {
          final lastMessage = messages[lastMessageIndex];
          final updatedMessage = Message(
            content: lastMessage.content,
            isUser: false,
            recommendedMeal: meal,
          );

          // Replace the last message with our updated one
          chatProvider.updateLastMessage(updatedMessage);
        }
      } else {
        _showCustomSnackBar('No meals available. Please try again later.');
      }
    } catch (e) {
      _showCustomSnackBar('Error loading meals: ${e.toString()}');
    }
  }

  Future<void> _takePicture() async {
    final user = Provider.of<ProfileProvider>(context, listen: false).user;
    if (user == null) {
      _showCustomSnackBar('User profile not loaded yet.');
      return;
    }

    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (photo != null) {
      final chatProvider =
          Provider.of<AIChatbotProvider>(context, listen: false);
      setState(() {
        _showSuggestionPrompt = false;
      });
      await chatProvider.analyzeFood(File(photo.path), user);
      _scrollToBottom();
    }
  }

  Future<void> _pickImage() async {
    final user = Provider.of<ProfileProvider>(context, listen: false).user;
    if (user == null) {
      _showCustomSnackBar('User profile not loaded yet.');
      return;
    }

    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      final chatProvider =
          Provider.of<AIChatbotProvider>(context, listen: false);
      setState(() {
        _showSuggestionPrompt = false;
      });
      await chatProvider.analyzeFood(File(image.path), user);
      _scrollToBottom();
    }
  }

  void _showCustomSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(8),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  // Navigate to a specific workout
  void _navigateToWorkout(int workoutId) {
    context.pushNamed(
      'workoutDetail',
      queryParameters: {
        'workoutId': workoutId.toString(),
      },
    );
  }

  // Navigate to a specific exercise
  void _navigateToExercise(int exerciseId) {
    // Get exercise details from provider
    final exerciseProvider =
        Provider.of<ExerciseProvider>(context, listen: false);
    final exercise = exerciseProvider.exercises.firstWhere(
      (e) => e.exerciseId == exerciseId,
      orElse: () => throw Exception('Exercise not found'),
    );

    // Navigate to exercise details
    context.pushNamed(
      'exerciseDetails', // Use correct route name with 's' at the end
      extra: exercise,
    );
  }

  // Navigate to a specific diet plan
  void _navigateToDietPlan(DietPlan dietPlan) {
    context.pushNamed(
      'dietDetail',
      extra: dietPlan,
    );
  }

  // Navigate to a specific meal
  void _navigateToMeal(Meal meal) {
    context.pushNamed(
      'mealDetails',
      extra: meal,
    );
  }

  void _showHelpPopup() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                FontAwesomeIcons.circleInfo,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'Gymify AI Help',
                style: theme.textTheme.headlineSmall,
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHelpSection(
                  theme,
                  FontAwesomeIcons.terminal,
                  'Commands:',
                  '• Type "/coach" for personalized workout & nutrition plan\n• Type "/workout" to get recommended workouts\n• Type "/exercise" to get exercise suggestions\n• Type "/dietplan" to get diet plan recommendations',
                ),
                const Divider(height: 24),
                _buildHelpSection(
                  theme,
                  FontAwesomeIcons.camera,
                  'Food Analysis:',
                  '• Use camera button to take a food photo\n• Use gallery to analyze existing photos\n• Get nutritional info and fitness recommendations',
                ),
                const Divider(height: 24),
                _buildHelpSection(
                  theme,
                  FontAwesomeIcons.lightbulb,
                  'Tips:',
                  '• Be specific about your fitness questions\n• Ask about exercises, muscle groups, or training\n• Tap on workouts or exercises to view details',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Got it!',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildHelpSection(
      ThemeData theme, IconData icon, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'AI Coach',
        actions: [
          IconButton(
            icon: Icon(
              Icons.help_outline,
              color: theme.colorScheme.primary,
            ),
            onPressed: _showHelpPopup,
            tooltip: 'Help',
          ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: theme.colorScheme.primary,
            ),
            onPressed: () {
              final chatProvider =
                  Provider.of<AIChatbotProvider>(context, listen: false);
              chatProvider.clearChat();
              _sendWelcomeMessage();
              setState(() {
                _showSuggestionPrompt = true;
              });
            },
            tooltip: 'Reset conversation',
          ),
        ],
      ),
      body: Column(
        children: [
          // Modern, sleek fitness banner
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: child,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withBlue(
                      theme.colorScheme.primary.blue + 20,
                    ),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Consumer<AIChatbotProvider>(
                builder: (context, chatProvider, child) {
                  final name =
                      chatProvider.userName?.split(' ')[0] ?? 'Athlete';
                  return Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          FontAwesomeIcons.bolt,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ready to crush your workout today?',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Ask any fitness or nutrition question, $name',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          _messageController.text = "/coach";
                          _sendMessage();
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white24,
                          side: const BorderSide(color: Colors.white, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'GET PLAN',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Messages area
          Expanded(
            child: Consumer<AIChatbotProvider>(
              builder: (context, chatProvider, child) {
                if (chatProvider.messages.isEmpty && !chatProvider.isLoading) {
                  // Empty state
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.robot,
                          size: 48,
                          color: theme.colorScheme.primary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Your AI fitness coach is ready',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ask about workouts, nutrition, or training advice',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        _buildSuggestionChip(
                            '/coach', 'Get a personalized plan'),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: chatProvider.messages.length +
                      (chatProvider.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Show loading indicator at the end if loading
                    if (chatProvider.isLoading &&
                        index == chatProvider.messages.length) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.shadowColor.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Thinking...',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    final message = chatProvider.messages[index];

                    // If it's a suggestion, show it as a suggestion chip
                    if (!message.isUser && message.isSuggestion) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: _buildSuggestionChip(message.content, null),
                      );
                    }

                    // Handle workout recommendations
                    if (!message.isUser && message.recommendedWorkout != null) {
                      return _buildWorkoutRecommendation(
                          message.recommendedWorkout!, message);
                    }

                    // Handle exercise recommendations
                    if (!message.isUser &&
                        message.recommendedExercise != null) {
                      return _buildExerciseRecommendation(
                          message.recommendedExercise!, message);
                    }

                    // Handle diet plan recommendations
                    if (!message.isUser &&
                        message.recommendedDietPlan != null) {
                      return _buildDietPlanRecommendation(
                          message.recommendedDietPlan!, message);
                    }

                    // Handle meal recommendations
                    if (!message.isUser && message.recommendedMeal != null) {
                      return _buildMealRecommendation(
                          message.recommendedMeal!, message);
                    }

                    return _buildMessageBubble(message);
                  },
                );
              },
            ),
          ),

          // Error message display
          Consumer<AIChatbotProvider>(
            builder: (context, chatProvider, child) {
              if (chatProvider.errorMessage != null) {
                return Container(
                  color: theme.colorScheme.error.withOpacity(0.1),
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          chatProvider.errorMessage!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: theme.colorScheme.error,
                          size: 18,
                        ),
                        onPressed: chatProvider.resetError,
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Show suggestion or command prompt
          if (_showSuggestionPrompt)
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: child,
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? theme.colorScheme.surface
                      : theme.colorScheme.surface.withOpacity(0.9),
                  border: Border(
                    top: BorderSide(
                      color: theme.dividerColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Try these:',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            size: 18,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          onPressed: () {
                            setState(() {
                              _showSuggestionPrompt = false;
                            });
                          },
                          constraints: const BoxConstraints.tightFor(
                            width: 32,
                            height: 32,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildPromptChip('/coach', 'Get workout plan', theme),
                          _buildPromptChip(
                              '/workout', 'Browse workouts', theme),
                          _buildPromptChip(
                              '/exercise', 'Find exercises', theme),
                          _buildPromptChip(
                              '/dietplan', 'Get diet plans', theme),
                          _buildPromptChip(
                              'Best abs exercises?', 'Exercise tips', theme),
                          _buildPromptChip(
                              'Protein meal ideas', 'Nutrition', theme),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Input area
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? theme.colorScheme.surface
                  : theme.colorScheme.surface.withOpacity(0.95),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -2),
                  blurRadius: 6,
                  color: Colors.black.withOpacity(0.06),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Action buttons
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        // Camera button
                        IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.camera,
                            size: 16,
                          ),
                          onPressed: _takePicture,
                          tooltip: 'Analyze food with camera',
                          color: theme.colorScheme.primary,
                          visualDensity: VisualDensity.compact,
                        ),
                        // Gallery button
                        IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.image,
                            size: 16,
                          ),
                          onPressed: _pickImage,
                          tooltip: 'Analyze food from gallery',
                          color: theme.colorScheme.primary,
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Text input
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints(
                        maxHeight: 120,
                      ),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? theme.colorScheme.surfaceContainerHighest
                            : theme.colorScheme.onInverseSurface
                                .withOpacity(0.08),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Ask about workouts, nutrition, form...',
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          suffixIcon: _isComposing
                              ? null
                              : IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.lightbulb,
                                    size: 16,
                                    color: theme.colorScheme.primary,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _showSuggestionPrompt =
                                          !_showSuggestionPrompt;
                                    });
                                  },
                                  tooltip: 'Quick prompts',
                                ),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: theme.textTheme.bodyMedium,
                        onSubmitted: (text) {
                          if (text.trim().isNotEmpty) {
                            _sendMessage();
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Send button with animated transition
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isComposing
                          ? theme.colorScheme.primary
                          : theme.colorScheme.primary.withOpacity(0.7),
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isComposing ? Icons.send : Icons.mic,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: _isComposing
                          ? _sendMessage
                          : () {
                              // Voice input would go here
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Voice input coming soon!'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String text, String? tooltip) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        _messageController.text = text;
        _sendMessage();
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildPromptChip(String text, String tooltip, ThemeData theme) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () {
          _messageController.text = text;
          _sendMessage();
        },
        borderRadius: BorderRadius.circular(30),
        child: Container(
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getIconForPrompt(text),
                size: 14,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                text.length > 20 ? '${text.substring(0, 18)}...' : text,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForPrompt(String prompt) {
    final lowerPrompt = prompt.toLowerCase();
    if (prompt.startsWith('/coach')) {
      return FontAwesomeIcons.wandMagicSparkles;
    } else if (prompt.startsWith('/workout')) {
      return FontAwesomeIcons.personRunning;
    } else if (prompt.startsWith('/exercise')) {
      return FontAwesomeIcons.dumbbell;
    } else if (lowerPrompt.contains('exercise') ||
        lowerPrompt.contains('workout') ||
        lowerPrompt.contains('deadlift')) {
      return FontAwesomeIcons.dumbbell;
    } else if (lowerPrompt.contains('protein') ||
        lowerPrompt.contains('meal') ||
        lowerPrompt.contains('macro')) {
      return FontAwesomeIcons.bowlFood;
    }
    return FontAwesomeIcons.circleQuestion;
  }

  Widget _buildWorkoutRecommendation(Workout workout, Message message) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        margin: const EdgeInsets.only(bottom: 12, right: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Message bubble with content
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: const Radius.circular(0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.08),
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Standard message content
                  if (message.content.isNotEmpty)
                    MarkdownBody(
                      data: message.content,
                      styleSheet: MarkdownStyleSheet(
                        p: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                        strong: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                        em: theme.textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: theme.colorScheme.onSurface,
                        ),
                        blockquote: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          fontStyle: FontStyle.italic,
                        ),
                        h1: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                        h2: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                        h3: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),

                  if (message.content.isNotEmpty) const SizedBox(height: 14),

                  // AI signature
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        FontAwesomeIcons.robot,
                        size: 10,
                        color: theme.colorScheme.primary.withOpacity(0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Gymify AI',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                          color: theme.colorScheme.primary.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Workout card
            GestureDetector(
              onTap: () => _navigateToWorkout(workout.workoutId),
              child: Container(
                margin: const EdgeInsets.only(top: 8, left: 12),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? theme.colorScheme.surface.withOpacity(0.8)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.08),
                      blurRadius: 6,
                      spreadRadius: 0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with difficulty badge
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.dumbbell,
                            size: 12,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'RECOMMENDED WORKOUT',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getDifficultyColor(workout.difficulty)
                                  .withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              workout.difficulty,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: _getDifficultyColor(workout.difficulty),
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Workout details
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        children: [
                          // Workout image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: workout.workoutImage.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: workout.workoutImage,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      width: 70,
                                      height: 70,
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.1),
                                      child: Center(
                                        child: Icon(
                                          FontAwesomeIcons.dumbbell,
                                          color: theme.colorScheme.primary
                                              .withOpacity(0.5),
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      width: 70,
                                      height: 70,
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.1),
                                      child: Center(
                                        child: Icon(
                                          FontAwesomeIcons.dumbbell,
                                          color: theme.colorScheme.primary
                                              .withOpacity(0.5),
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 70,
                                    height: 70,
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.1),
                                    child: Center(
                                      child: Icon(
                                        FontAwesomeIcons.dumbbell,
                                        color: theme.colorScheme.primary
                                            .withOpacity(0.5),
                                        size: 18,
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 14),

                          // Workout info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  workout.workoutName,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  workout.description,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.7),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    _buildWorkoutInfoBadge(
                                      theme,
                                      workout.targetMuscleGroup,
                                      FontAwesomeIcons.bullseye,
                                    ),
                                    const SizedBox(width: 8),
                                    _buildWorkoutInfoBadge(
                                      theme,
                                      '${workout.workoutexercises?.length ?? 0} exercises',
                                      FontAwesomeIcons.list,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // View button
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(14),
                          bottomRight: Radius.circular(14),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'VIEW DETAILS',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseRecommendation(Exercise exercise, Message message) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        margin: const EdgeInsets.only(bottom: 12, right: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Message bubble with content
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: const Radius.circular(0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.08),
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Standard message content
                  if (message.content.isNotEmpty)
                    MarkdownBody(
                      data: message.content,
                      styleSheet: MarkdownStyleSheet(
                        p: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                        strong: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                        em: theme.textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: theme.colorScheme.onSurface,
                        ),
                        blockquote: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          fontStyle: FontStyle.italic,
                        ),
                        h1: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                        h2: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                        h3: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),

                  if (message.content.isNotEmpty) const SizedBox(height: 14),

                  // AI signature
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        FontAwesomeIcons.robot,
                        size: 10,
                        color: theme.colorScheme.primary.withOpacity(0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Gymify AI',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                          color: theme.colorScheme.primary.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Exercise card
            GestureDetector(
              onTap: () => _navigateToExercise(exercise.exerciseId),
              child: Container(
                margin: const EdgeInsets.only(top: 8, left: 12),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? theme.colorScheme.surface.withOpacity(0.8)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.08),
                      blurRadius: 6,
                      spreadRadius: 0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.personRunning,
                            size: 12,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'RECOMMENDED EXERCISE',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color:
                                  theme.colorScheme.tertiary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${exercise.caloriesBurnedPerMinute} cal/min',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.tertiary,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Exercise details
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        children: [
                          // Exercise image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: exercise.imageUrl.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: exercise.imageUrl,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      width: 70,
                                      height: 70,
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.1),
                                      child: Center(
                                        child: Icon(
                                          FontAwesomeIcons.personRunning,
                                          color: theme.colorScheme.primary
                                              .withOpacity(0.5),
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      width: 70,
                                      height: 70,
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.1),
                                      child: Center(
                                        child: Icon(
                                          FontAwesomeIcons.personRunning,
                                          color: theme.colorScheme.primary
                                              .withOpacity(0.5),
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 70,
                                    height: 70,
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.1),
                                    child: Center(
                                      child: Icon(
                                        FontAwesomeIcons.personRunning,
                                        color: theme.colorScheme.primary
                                            .withOpacity(0.5),
                                        size: 18,
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 14),

                          // Exercise info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  exercise.exerciseName,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  exercise.description,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.7),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                _buildWorkoutInfoBadge(
                                  theme,
                                  exercise.targetMuscleGroup,
                                  FontAwesomeIcons.bullseye,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // View button
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(14),
                          bottomRight: Radius.circular(14),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'VIEW DETAILS',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDietPlanRecommendation(DietPlan dietPlan, Message message) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        margin: const EdgeInsets.only(bottom: 12, right: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Message bubble with content
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: const Radius.circular(0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.08),
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Standard message content
                  if (message.content.isNotEmpty)
                    MarkdownBody(
                      data: message.content,
                      styleSheet: MarkdownStyleSheet(
                        p: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                        strong: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                        em: theme.textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: theme.colorScheme.onSurface,
                        ),
                        blockquote: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          fontStyle: FontStyle.italic,
                        ),
                        h1: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                        h2: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                        h3: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),

                  if (message.content.isNotEmpty) const SizedBox(height: 14),

                  // AI signature
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        FontAwesomeIcons.robot,
                        size: 10,
                        color: theme.colorScheme.primary.withOpacity(0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Gymify AI',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                          color: theme.colorScheme.primary.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Diet Plan card
            GestureDetector(
              onTap: () => _navigateToDietPlan(dietPlan),
              child: Container(
                margin: const EdgeInsets.only(top: 8, left: 12),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? theme.colorScheme.surface.withOpacity(0.8)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.08),
                      blurRadius: 6,
                      spreadRadius: 0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with type badge
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.utensils,
                            size: 12,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'RECOMMENDED DIET PLAN',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color:
                                  theme.colorScheme.tertiary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              dietPlan.goalType,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.tertiary,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Diet Plan details
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        children: [
                          // Diet Plan image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: dietPlan.image.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: dietPlan.image,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      width: 70,
                                      height: 70,
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.1),
                                      child: Center(
                                        child: Icon(
                                          FontAwesomeIcons.utensils,
                                          color: theme.colorScheme.primary
                                              .withOpacity(0.5),
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      width: 70,
                                      height: 70,
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.1),
                                      child: Center(
                                        child: Icon(
                                          FontAwesomeIcons.utensils,
                                          color: theme.colorScheme.primary
                                              .withOpacity(0.5),
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 70,
                                    height: 70,
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.1),
                                    child: Center(
                                      child: Icon(
                                        FontAwesomeIcons.utensils,
                                        color: theme.colorScheme.primary
                                            .withOpacity(0.5),
                                        size: 18,
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 14),

                          // Diet Plan info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dietPlan.name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  dietPlan.description,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.7),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    _buildWorkoutInfoBadge(
                                      theme,
                                      '${dietPlan.calorieGoal} calories',
                                      FontAwesomeIcons.fire,
                                    ),
                                    const SizedBox(width: 8),
                                    _buildWorkoutInfoBadge(
                                      theme,
                                      '${dietPlan.meals.length} meals',
                                      FontAwesomeIcons.bowlFood,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // View button
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(14),
                          bottomRight: Radius.circular(14),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'VIEW DETAILS',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealRecommendation(Meal meal, Message message) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        margin: const EdgeInsets.only(bottom: 12, right: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Message bubble with content
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: const Radius.circular(0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.08),
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Standard message content
                  if (message.content.isNotEmpty)
                    MarkdownBody(
                      data: message.content,
                      styleSheet: MarkdownStyleSheet(
                        p: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                        strong: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                        em: theme.textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: theme.colorScheme.onSurface,
                        ),
                        blockquote: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          fontStyle: FontStyle.italic,
                        ),
                        h1: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                        h2: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                        h3: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),

                  if (message.content.isNotEmpty) const SizedBox(height: 14),

                  // AI signature
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        FontAwesomeIcons.robot,
                        size: 10,
                        color: theme.colorScheme.primary.withOpacity(0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Gymify AI',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                          color: theme.colorScheme.primary.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Meal card
            GestureDetector(
              onTap: () => _navigateToMeal(meal),
              child: Container(
                margin: const EdgeInsets.only(top: 8, left: 12),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? theme.colorScheme.surface.withOpacity(0.8)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.08),
                      blurRadius: 6,
                      spreadRadius: 0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with meal time badge
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.bowlFood,
                            size: 12,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'RECOMMENDED MEAL',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color:
                                  theme.colorScheme.tertiary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              meal.mealTime,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.tertiary,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Meal details
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        children: [
                          // Meal image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: meal.image.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: meal.image,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      width: 70,
                                      height: 70,
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.1),
                                      child: Center(
                                        child: Icon(
                                          FontAwesomeIcons.bowlFood,
                                          color: theme.colorScheme.primary
                                              .withOpacity(0.5),
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      width: 70,
                                      height: 70,
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.1),
                                      child: Center(
                                        child: Icon(
                                          FontAwesomeIcons.bowlFood,
                                          color: theme.colorScheme.primary
                                              .withOpacity(0.5),
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 70,
                                    height: 70,
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.1),
                                    child: Center(
                                      child: Icon(
                                        FontAwesomeIcons.bowlFood,
                                        color: theme.colorScheme.primary
                                            .withOpacity(0.5),
                                        size: 18,
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 14),

                          // Meal info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  meal.mealName,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  meal.description,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.7),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                _buildWorkoutInfoBadge(
                                  theme,
                                  '${meal.calories} calories',
                                  FontAwesomeIcons.fire,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // View button
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(14),
                          bottomRight: Radius.circular(14),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'VIEW DETAILS',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutInfoBadge(ThemeData theme, String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 10,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green.shade600;
      case 'intermediate':
        return Colors.orange.shade600;
      case 'hard':
        return Colors.red.shade600;
      default:
        return Colors.blue.shade600;
    }
  }

  Widget _buildMessageBubble(Message message) {
    final theme = Theme.of(context);
    final isUser = message.isUser;
    final bubbleColor =
        isUser ? theme.colorScheme.primary : theme.colorScheme.surface;
    final textColor =
        isUser ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: EdgeInsets.only(
          bottom: 12,
          left: isUser ? 40 : 0,
          right: isUser ? 0 : 40,
        ),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomLeft:
                isUser ? const Radius.circular(20) : const Radius.circular(0),
            bottomRight:
                isUser ? const Radius.circular(0) : const Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.08),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show image preview if message has an image
            if (message.imageFile != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    Image.file(
                      message.imageFile!,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.utensils,
                              color: Colors.white,
                              size: 12,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Analyzing Food...',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Add some spacing if there's an image
            if (message.imageFile != null) const SizedBox(height: 10),

            // Show a special command indicator for /coach
            if (isUser && message.content.trim().toLowerCase() == "/coach")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Colors.white.withOpacity(0.3)
                          : theme.colorScheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FontAwesomeIcons.wandMagicSparkles,
                          size: 12,
                          color:
                              isUser ? Colors.white : theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'COACH MODE',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isUser
                                ? Colors.white
                                : theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Generating personalized fitness plan...',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isUser
                          ? Colors.white.withOpacity(0.9)
                          : theme.colorScheme.onSurface,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              )
            // Show workout command
            else if (isUser &&
                message.content.trim().toLowerCase() == "/workout")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Colors.white.withOpacity(0.3)
                          : theme.colorScheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FontAwesomeIcons.personRunning,
                          size: 12,
                          color:
                              isUser ? Colors.white : theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'WORKOUT FINDER',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isUser
                                ? Colors.white
                                : theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Finding workouts based on your profile...',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isUser
                          ? Colors.white.withOpacity(0.9)
                          : theme.colorScheme.onSurface,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              )
            // Show exercise command
            else if (isUser &&
                message.content.trim().toLowerCase() == "/exercise")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Colors.white.withOpacity(0.3)
                          : theme.colorScheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FontAwesomeIcons.dumbbell,
                          size: 12,
                          color:
                              isUser ? Colors.white : theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'EXERCISE FINDER',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isUser
                                ? Colors.white
                                : theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Finding exercises for you...',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isUser
                          ? Colors.white.withOpacity(0.9)
                          : theme.colorScheme.onSurface,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              )
            else if (isUser)
              // Regular user message
              Text(
                message.content,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: textColor,
                ),
              )
            else
              // Use Markdown for AI responses with gym-specific styling
              MarkdownBody(
                data: message.content,
                styleSheet: MarkdownStyleSheet(
                  p: theme.textTheme.bodyMedium?.copyWith(
                    color: textColor,
                  ),
                  strong: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isUser ? Colors.white : theme.colorScheme.primary,
                  ),
                  em: theme.textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: textColor,
                  ),
                  blockquote: theme.textTheme.bodySmall?.copyWith(
                    color: isUser
                        ? Colors.white.withOpacity(0.7)
                        : theme.colorScheme.onSurface.withOpacity(0.7),
                    fontStyle: FontStyle.italic,
                  ),
                  h1: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isUser ? Colors.white : theme.colorScheme.primary,
                  ),
                  h2: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isUser ? Colors.white : theme.colorScheme.primary,
                  ),
                  h3: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isUser ? Colors.white : theme.colorScheme.primary,
                  ),
                  listBullet: theme.textTheme.bodyMedium?.copyWith(
                    color: isUser ? Colors.white : theme.colorScheme.primary,
                  ),
                  checkbox: theme.textTheme.bodyMedium?.copyWith(
                    color: isUser ? Colors.white : theme.colorScheme.primary,
                  ),
                  tableBody: theme.textTheme.bodySmall?.copyWith(
                    color: textColor,
                  ),
                ),
                onTapLink: (text, href, title) {
                  // Handle any links in the markdown
                  if (href != null) {
                    // Implement link handling if needed
                  }
                },
              ),

            // Message timestamp and status indicator
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment:
                    isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  if (isUser) ...[
                    Text(
                      'just now',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        color: isUser
                            ? Colors.white.withOpacity(0.7)
                            : theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.check,
                      size: 12,
                      color: isUser
                          ? Colors.white.withOpacity(0.7)
                          : theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ] else ...[
                    Icon(
                      FontAwesomeIcons.robot,
                      size: 10,
                      color: theme.colorScheme.primary.withOpacity(0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Gymify AI',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        color: theme.colorScheme.primary.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
