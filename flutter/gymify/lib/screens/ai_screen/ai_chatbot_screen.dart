// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:gymify/colors/app_colors.dart';
// import 'package:gymify/providers/ai_chatbot_provider/ai_chatbot_provider.dart';
// import 'package:gymify/providers/profile_provider/profile_provider.dart';
// import 'package:gymify/utils/custom_appbar.dart';
// import 'package:provider/provider.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';

// class AIChatbotScreen extends StatefulWidget {
//   const AIChatbotScreen({super.key});

//   @override
//   State<AIChatbotScreen> createState() => _AIChatbotScreenState();
// }

// class _AIChatbotScreenState extends State<AIChatbotScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final ImagePicker _picker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();
//     // Send an initial greeting after the user profile has been loaded
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final profileProvider =
//           Provider.of<ProfileProvider>(context, listen: false);
//       if (profileProvider.user != null) {
//         _sendInitialGreeting();
//       }
//     });
//   }

//   void _sendInitialGreeting() {
//     final user = Provider.of<ProfileProvider>(context, listen: false).user;
//     if (user != null) {
//       final chatProvider =
//           Provider.of<AIChatbotProvider>(context, listen: false);
//       chatProvider.sendMessage(
//           "Hi! I'd like some personalized fitness and nutrition advice based on my profile.",
//           user);
//     }
//   }

//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   Future<void> _sendMessage() async {
//     final message = _messageController.text.trim();
//     if (message.isEmpty) return;

//     final user = Provider.of<ProfileProvider>(context, listen: false).user;
//     if (user == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('User profile not loaded yet.')));
//       return;
//     }

//     final chatProvider = Provider.of<AIChatbotProvider>(context, listen: false);
//     _messageController.clear();

//     await chatProvider.sendMessage(message, user);
//     _scrollToBottom();
//   }

//   Future<void> _takePicture() async {
//     final user = Provider.of<ProfileProvider>(context, listen: false).user;
//     if (user == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('User profile not loaded yet.')));
//       return;
//     }

//     final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
//     if (photo != null) {
//       final chatProvider =
//           Provider.of<AIChatbotProvider>(context, listen: false);
//       await chatProvider.analyzeFood(File(photo.path), user);
//       _scrollToBottom();
//     }
//   }

//   Future<void> _pickImage() async {
//     final user = Provider.of<ProfileProvider>(context, listen: false).user;
//     if (user == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('User profile not loaded yet.')));
//       return;
//     }

//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       final chatProvider =
//           Provider.of<AIChatbotProvider>(context, listen: false);
//       await chatProvider.analyzeFood(File(image.path), user);
//       _scrollToBottom();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: 'Your AI Chatbot',
//         actions: [
//           IconButton(
//             icon: const Icon(
//               Icons.refresh,
//               color: AppColors.darkPrimary,
//             ),
//             onPressed: () {
//               final chatProvider =
//                   Provider.of<AIChatbotProvider>(context, listen: false);
//               chatProvider.clearChat();
//               _sendInitialGreeting();
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Consumer<AIChatbotProvider>(
//               builder: (context, chatProvider, child) {
//                 return ListView.builder(
//                   controller: _scrollController,
//                   padding: const EdgeInsets.all(12),
//                   itemCount: chatProvider.messages.length +
//                       (chatProvider.isLoading ? 1 : 0),
//                   itemBuilder: (context, index) {
//                     // Show loading indicator at the end if loading
//                     if (chatProvider.isLoading &&
//                         index == chatProvider.messages.length) {
//                       return const Align(
//                         alignment: Alignment.centerLeft,
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(vertical: 8.0),
//                           child: CircularProgressIndicator(),
//                         ),
//                       );
//                     }

//                     final message = chatProvider.messages[index];
//                     return _buildMessageBubble(message);
//                   },
//                 );
//               },
//             ),
//           ),
//           // Error message display
//           Consumer<AIChatbotProvider>(
//             builder: (context, chatProvider, child) {
//               if (chatProvider.errorMessage != null) {
//                 return Container(
//                   color: Colors.red.shade100,
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.error, color: Colors.red),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           chatProvider.errorMessage!,
//                           style: const TextStyle(color: Colors.red),
//                         ),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.close, color: Colors.red),
//                         onPressed: chatProvider.resetError,
//                       ),
//                     ],
//                   ),
//                 );
//               }
//               return const SizedBox.shrink();
//             },
//           ),
//           // Input area
//           Container(
//             padding: const EdgeInsets.all(8.0),
//             decoration: BoxDecoration(
//               color: Theme.of(context).cardColor,
//               boxShadow: [
//                 BoxShadow(
//                   offset: const Offset(0, -2),
//                   blurRadius: 4,
//                   color: Colors.black.withOpacity(0.1),
//                 ),
//               ],
//             ),
//             child: SafeArea(
//               child: Row(
//                 children: [
//                   // Camera button
//                   IconButton(
//                     icon: const Icon(Icons.camera_alt),
//                     onPressed: _takePicture,
//                     tooltip: 'Take a picture of food',
//                   ),
//                   // Gallery button
//                   IconButton(
//                     icon: const Icon(Icons.photo_library),
//                     onPressed: _pickImage,
//                     tooltip: 'Pick image from gallery',
//                   ),
//                   // Text input
//                   Expanded(
//                     child: TextField(
//                       controller: _messageController,
//                       decoration: const InputDecoration(
//                         hintText: 'Type a message...',
//                         border: InputBorder.none,
//                         contentPadding:
//                             EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                       ),
//                       textCapitalization: TextCapitalization.sentences,
//                       keyboardType: TextInputType.multiline,
//                       maxLines: 5,
//                       minLines: 1,
//                       onSubmitted: (text) {
//                         if (text.trim().isNotEmpty) {
//                           _sendMessage();
//                         }
//                       },
//                     ),
//                   ),
//                   // Send button
//                   IconButton(
//                     icon: const Icon(Icons.send),
//                     onPressed: _sendMessage,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessageBubble(Message message) {
//     final isUser = message.isUser;
//     return Align(
//       alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width * 0.75,
//         ),
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isUser
//               ? Theme.of(context).colorScheme.primary
//               : Theme.of(context).colorScheme.surfaceContainerHighest,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Show image preview if message has an image
//             if (message.imageFile != null)
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Image.file(
//                   message.imageFile!,
//                   height: 150,
//                   fit: BoxFit.cover,
//                 ),
//               ),

//             // Add some spacing if there's an image
//             if (message.imageFile != null) const SizedBox(height: 8),

//             // Use Markdown for AI responses to get better formatting
//             isUser
//                 ? Text(
//                     message.content,
//                     style: TextStyle(
//                       color: isUser ? Colors.white : null,
//                     ),
//                   )
//                 : MarkdownBody(
//                     data: message.content,
//                     styleSheet: MarkdownStyleSheet(
//                       p: TextStyle(
//                         color: isUser ? Colors.white : null,
//                       ),
//                       strong: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: isUser ? Colors.white : null,
//                       ),
//                       em: TextStyle(
//                         fontStyle: FontStyle.italic,
//                         color: isUser ? Colors.white : null,
//                       ),
//                       blockquote: TextStyle(
//                         color: isUser ? Colors.white70 : Colors.grey.shade700,
//                         fontStyle: FontStyle.italic,
//                       ),
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gymify/colors/app_colors.dart';
import 'package:gymify/providers/ai_chatbot_provider/ai_chatbot_provider.dart';
import 'package:gymify/providers/profile_provider/profile_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class AIChatbotScreen extends StatefulWidget {
  const AIChatbotScreen({super.key});

  @override
  State<AIChatbotScreen> createState() => _AIChatbotScreenState();
}

class _AIChatbotScreenState extends State<AIChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  bool _showSuggestionPrompt = false;

  @override
  void initState() {
    super.initState();
    // Send welcome message after the user profile has been loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      if (profileProvider.user != null) {
        _sendWelcomeMessage();
      }
    });
  }

  void _sendWelcomeMessage() {
    final user = Provider.of<ProfileProvider>(context, listen: false).user;
    if (user != null) {
      final chatProvider =
          Provider.of<AIChatbotProvider>(context, listen: false);
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
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User profile not loaded yet.')));
      return;
    }

    final chatProvider = Provider.of<AIChatbotProvider>(context, listen: false);
    _messageController.clear();

    // Hide suggestion prompt when user sends a message
    setState(() {
      _showSuggestionPrompt = false;
    });

    await chatProvider.sendMessage(message, user);
    _scrollToBottom();
  }

  void _sendSuggestion(String suggestion) {
    _messageController.text = suggestion;
    _sendMessage();
  }

  Future<void> _takePicture() async {
    final user = Provider.of<ProfileProvider>(context, listen: false).user;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User profile not loaded yet.')));
      return;
    }

    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      final chatProvider =
          Provider.of<AIChatbotProvider>(context, listen: false);
      await chatProvider.analyzeFood(File(photo.path), user);
      _scrollToBottom();
    }
  }

  Future<void> _pickImage() async {
    final user = Provider.of<ProfileProvider>(context, listen: false).user;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User profile not loaded yet.')));
      return;
    }

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final chatProvider =
          Provider.of<AIChatbotProvider>(context, listen: false);
      await chatProvider.analyzeFood(File(image.path), user);
      _scrollToBottom();
    }
  }

  void _showHelpPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('GymBuddy AI Help'),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Commands:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                    '• Type "/coach" for personalized workout & nutrition plan'),
                SizedBox(height: 16),
                Text(
                  'Food Analysis:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('• Use camera or gallery button to analyze food'),
                Text('• Get nutritional info and fitness recommendations'),
                SizedBox(height: 16),
                Text(
                  'Tips:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('• Tap on suggestions for quick answers'),
                Text('• Be specific about your fitness questions'),
                Text(
                    '• Ask about specific exercises, muscle groups, or training methods'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Got it!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'GymBuddy AI Coach',
        actions: [
          IconButton(
            icon: const Icon(
              Icons.help_outline,
              color: AppColors.darkPrimary,
            ),
            onPressed: _showHelpPopup,
            tooltip: 'Help',
          ),
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: AppColors.darkPrimary,
            ),
            onPressed: () {
              final chatProvider =
                  Provider.of<AIChatbotProvider>(context, listen: false);
              chatProvider.clearChat();
              _sendWelcomeMessage();
            },
            tooltip: 'Reset conversation',
          ),
        ],
      ),
      body: Column(
        children: [
          // Fitness-themed banner
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: AppColors.darkPrimary.withOpacity(0.1),
            child: Consumer<AIChatbotProvider>(
              builder: (context, chatProvider, child) {
                final name = chatProvider.userName?.split(' ')[0] ?? 'Athlete';
                return Row(
                  children: [
                    const Icon(Icons.fitness_center,
                        color: AppColors.darkPrimary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Ready to crush your workout today, $name?',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkPrimary,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _messageController.text = "/coach";
                        _sendMessage();
                      },
                      child: const Text('GET PLAN'),
                    ),
                  ],
                );
              },
            ),
          ),

          // Messages area
          Expanded(
            child: Consumer<AIChatbotProvider>(
              builder: (context, chatProvider, child) {
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: chatProvider.messages.length +
                      (chatProvider.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Show loading indicator at the end if loading
                    if (chatProvider.isLoading &&
                        index == chatProvider.messages.length) {
                      return const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final message = chatProvider.messages[index];

                    // If it's a suggestion, show it as a suggestion chip
                    if (!message.isUser && message.isSuggestion) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: GestureDetector(
                          onTap: () => _sendSuggestion(message.content),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.darkPrimary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.darkPrimary.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              message.content,
                              style: TextStyle(
                                color: AppColors.darkPrimary.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ),
                      );
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
                  color: Colors.red.shade100,
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          chatProvider.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
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
          _showSuggestionPrompt
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.grey.shade200,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Try asking:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 8,
                              children: [
                                _buildPromptChip(
                                    '/coach', 'Get personalized plan'),
                                _buildPromptChip(
                                    'How many sets?', 'Form questions'),
                                _buildPromptChip(
                                    '🍽️', 'Analyze food (camera)'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          setState(() {
                            _showSuggestionPrompt = false;
                          });
                        },
                      )
                    ],
                  ),
                )
              : const SizedBox.shrink(),

          // Input area
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -2),
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Camera button
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: _takePicture,
                    tooltip: 'Analyze food with camera',
                    color: AppColors.darkPrimary,
                  ),
                  // Gallery button
                  IconButton(
                    icon: const Icon(Icons.photo_library),
                    onPressed: _pickImage,
                    tooltip: 'Analyze food from gallery',
                    color: AppColors.darkPrimary,
                  ),
                  // Help button
                  IconButton(
                    icon: const Icon(Icons.electric_bolt),
                    onPressed: () {
                      setState(() {
                        _showSuggestionPrompt = !_showSuggestionPrompt;
                      });
                    },
                    tooltip: 'Quick prompts',
                    color: AppColors.darkPrimary,
                  ),
                  // Text input
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Ask about workouts, nutrition, form...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      minLines: 1,
                      onSubmitted: (text) {
                        if (text.trim().isNotEmpty) {
                          _sendMessage();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Send button
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.darkPrimary,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
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

  Widget _buildPromptChip(String text, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () {
          if (text.startsWith('🍽️')) {
            _takePicture();
          } else {
            _messageController.text = text;
            _sendMessage();
          }
        },
        child: Chip(
          backgroundColor: AppColors.lightPrimary,
          label: Text(text),
          labelStyle: const TextStyle(
            fontSize: 12,
            color: AppColors.darkPrimary,
          ),
          padding: EdgeInsets.zero,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    final isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser
              ? AppColors.darkPrimary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          // Add drop shadow for better visibility
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show image preview if message has an image
            if (message.imageFile != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    Image.file(
                      message.imageFile!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        color: Colors.black54,
                        child: const Text(
                          'Analyzing Food...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Add some spacing if there's an image
            if (message.imageFile != null) const SizedBox(height: 8),

            // Show a special command indicator for /coach
            if (isUser && message.content.trim().toLowerCase() == "/coach")
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'COACH MODE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Generating personalized fitness plan...',
                    style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              )
            else if (isUser)
              // Regular user message
              Text(
                message.content,
                style: const TextStyle(
                  color: Colors.white,
                ),
              )
            else
              // Use Markdown for AI responses with gym-specific styling
              MarkdownBody(
                data: message.content,
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(
                    color: isUser ? Colors.white : Colors.black87,
                    fontSize: 15,
                  ),
                  strong: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isUser ? Colors.white : AppColors.darkPrimary,
                  ),
                  em: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: isUser ? Colors.white : Colors.black87,
                  ),
                  blockquote: TextStyle(
                    color: isUser ? Colors.white70 : Colors.grey.shade700,
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                  ),
                  h1: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isUser ? Colors.white : AppColors.darkPrimary,
                  ),
                  h2: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isUser ? Colors.white : AppColors.darkPrimary,
                  ),
                  h3: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isUser ? Colors.white : AppColors.darkPrimary,
                  ),
                  listBullet: TextStyle(
                    color: isUser ? Colors.white : AppColors.darkPrimary,
                  ),
                  checkbox: TextStyle(
                    color: isUser ? Colors.white : AppColors.darkPrimary,
                  ),
                ),
                onTapLink: (text, href, title) {
                  // Handle any links in the markdown
                  if (href != null) {
                    // Implement link handling if needed
                  }
                },
              ),

            // Show message timestamp for user messages
            if (isUser)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    'just now',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
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
    super.dispose();
  }
}
