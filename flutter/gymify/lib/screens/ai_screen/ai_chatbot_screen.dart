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
//   bool _showSuggestionPrompt = false;

//   @override
//   void initState() {
//     super.initState();
//     // Send welcome message after the user profile has been loaded
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final profileProvider =
//           Provider.of<ProfileProvider>(context, listen: false);
//       if (profileProvider.user != null) {
//         _sendWelcomeMessage();
//       }
//     });
//   }

//   void _sendWelcomeMessage() {
//     final user = Provider.of<ProfileProvider>(context, listen: false).user;
//     if (user != null) {
//       final chatProvider =
//           Provider.of<AIChatbotProvider>(context, listen: false);
//       chatProvider.sendWelcomeMessage(user);
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

//     // Hide suggestion prompt when user sends a message
//     setState(() {
//       _showSuggestionPrompt = false;
//     });

//     await chatProvider.sendMessage(message, user);
//     _scrollToBottom();
//   }

//   void _sendSuggestion(String suggestion) {
//     _messageController.text = suggestion;
//     _sendMessage();
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

//   void _showHelpPopup() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Gymify AI Help'),
//           content: const SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Commands:',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                     '• Type "/coach" for personalized workout & nutrition plan'),
//                 SizedBox(height: 16),
//                 Text(
//                   'Food Analysis:',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 8),
//                 Text('• Use camera or gallery button to analyze food'),
//                 Text('• Get nutritional info and fitness recommendations'),
//                 SizedBox(height: 16),
//                 Text(
//                   'Tips:',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 8),
//                 Text('• Tap on suggestions for quick answers'),
//                 Text('• Be specific about your fitness questions'),
//                 Text(
//                     '• Ask about specific exercises, muscle groups, or training methods'),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               child: const Text('Got it!'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: 'Gymify AI Coach',
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.help_outline,
//               color: Theme.of(context).colorScheme.primary,
//             ),
//             onPressed: _showHelpPopup,
//             tooltip: 'Help',
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.refresh,
//               color: Theme.of(context).colorScheme.primary,
//             ),
//             onPressed: () {
//               final chatProvider =
//                   Provider.of<AIChatbotProvider>(context, listen: false);
//               chatProvider.clearChat();
//               _sendWelcomeMessage();
//             },
//             tooltip: 'Reset conversation',
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Fitness-themed banner
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//             color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
//             child: Consumer<AIChatbotProvider>(
//               builder: (context, chatProvider, child) {
//                 final name = chatProvider.userName?.split(' ')[0] ?? 'Athlete';
//                 return Row(
//                   children: [
//                     Icon(Icons.fitness_center,
//                         color: Theme.of(context).colorScheme.primary),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         'Ready to crush your workout today, $name?',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Theme.of(context).colorScheme.primary,
//                         ),
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         _messageController.text = "/coach";
//                         _sendMessage();
//                       },
//                       child: const Text('GET PLAN'),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),

//           // Messages area
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

//                     // If it's a suggestion, show it as a suggestion chip
//                     if (!message.isUser && message.isSuggestion) {
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 8.0),
//                         child: GestureDetector(
//                           onTap: () => _sendSuggestion(message.content),
//                           child: Container(
//                             margin: const EdgeInsets.only(right: 8),
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 12, vertical: 8),
//                             decoration: BoxDecoration(
//                               color: Theme.of(context)
//                                   .colorScheme
//                                   .primary
//                                   .withOpacity(0.15),
//                               borderRadius: BorderRadius.circular(16),
//                               border: Border.all(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .primary
//                                     .withOpacity(0.3),
//                               ),
//                             ),
//                             child: Text(
//                               message.content,
//                               style: TextStyle(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .primary
//                                     .withOpacity(0.8),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     }

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

//           // Show suggestion or command prompt
//           _showSuggestionPrompt
//               ? Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   color:
//                       Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Try asking:',
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                             const SizedBox(height: 4),
//                             Wrap(
//                               spacing: 8,
//                               children: [
//                                 _buildPromptChip(
//                                     '/coach', 'Get personalized plan'),
//                                 _buildPromptChip(
//                                     'How many sets?', 'Form questions'),
//                                 _buildPromptChip(
//                                     '🍽️', 'Analyze food (camera)'),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.close, size: 18),
//                         onPressed: () {
//                           setState(() {
//                             _showSuggestionPrompt = false;
//                           });
//                         },
//                       )
//                     ],
//                   ),
//                 )
//               : const SizedBox.shrink(),

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
//                     tooltip: 'Analyze food with camera',
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//                   // Gallery button
//                   IconButton(
//                     icon: const Icon(Icons.photo_library),
//                     onPressed: _pickImage,
//                     tooltip: 'Analyze food from gallery',
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//                   // Help button
//                   IconButton(
//                     icon: const Icon(Icons.electric_bolt),
//                     onPressed: () {
//                       setState(() {
//                         _showSuggestionPrompt = !_showSuggestionPrompt;
//                       });
//                     },
//                     tooltip: 'Quick prompts',
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//                   // Text input
//                   Expanded(
//                     child: TextField(
//                       controller: _messageController,
//                       decoration: InputDecoration(
//                         hintText: 'Ask about workouts, nutrition, form...',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(24),
//                           borderSide: BorderSide.none,
//                         ),
//                         filled: true,
//                         fillColor: Colors.grey.shade200,
//                         contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 8),
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
//                   const SizedBox(width: 8),
//                   // Send button
//                   Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Theme.of(context).colorScheme.primary,
//                     ),
//                     child: IconButton(
//                       icon: const Icon(Icons.send, color: Colors.white),
//                       onPressed: _sendMessage,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPromptChip(String text, String tooltip) {
//     return Tooltip(
//       message: tooltip,
//       child: InkWell(
//         onTap: () {
//           if (text.startsWith('🍽️')) {
//             _takePicture();
//           } else {
//             _messageController.text = text;
//             _sendMessage();
//           }
//         },
//         child: Chip(
//           backgroundColor: AppColors.lightPrimary,
//           label: Text(text),
//           labelStyle: const TextStyle(
//             fontSize: 12,
//             color: Colors.white,
//           ),
//           padding: EdgeInsets.zero,
//           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//         ),
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
//           // Add drop shadow for better visibility
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               spreadRadius: 0,
//               blurRadius: 2,
//               offset: const Offset(0, 1),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Show image preview if message has an image
//             if (message.imageFile != null)
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Stack(
//                   children: [
//                     Image.file(
//                       message.imageFile!,
//                       height: 150,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                     ),
//                     Positioned(
//                       top: 0,
//                       left: 0,
//                       right: 0,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 4, horizontal: 8),
//                         color: Colors.black54,
//                         child: const Text(
//                           'Analyzing Food...',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//             // Add some spacing if there's an image
//             if (message.imageFile != null) const SizedBox(height: 8),

//             // Show a special command indicator for /coach
//             if (isUser && message.content.trim().toLowerCase() == "/coach")
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.3),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Text(
//                       'COACH MODE',
//                       style: TextStyle(
//                         fontSize: 10,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   const Text(
//                     'Generating personalized fitness plan...',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontStyle: FontStyle.italic,
//                     ),
//                   ),
//                 ],
//               )
//             else if (isUser)
//               // Regular user message
//               Text(
//                 message.content,
//                 style: const TextStyle(
//                   color: Colors.white,
//                 ),
//               )
//             else
//               // Use Markdown for AI responses with gym-specific styling
//               MarkdownBody(
//                 data: message.content,
//                 styleSheet: MarkdownStyleSheet(
//                   p: TextStyle(
//                     color: isUser ? Colors.white : Colors.black87,
//                     fontSize: 15,
//                   ),
//                   strong: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: isUser
//                         ? Colors.white
//                         : Theme.of(context).colorScheme.primary,
//                   ),
//                   em: TextStyle(
//                     fontStyle: FontStyle.italic,
//                     color: isUser ? Colors.white : Colors.black87,
//                   ),
//                   blockquote: TextStyle(
//                     color: isUser ? Colors.white70 : Colors.grey.shade700,
//                     fontStyle: FontStyle.italic,
//                     fontSize: 14,
//                   ),
//                   h1: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: isUser
//                         ? Colors.white
//                         : Theme.of(context).colorScheme.primary,
//                   ),
//                   h2: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: isUser
//                         ? Colors.white
//                         : Theme.of(context).colorScheme.primary,
//                   ),
//                   h3: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                     color: isUser
//                         ? Colors.white
//                         : Theme.of(context).colorScheme.primary,
//                   ),
//                   listBullet: TextStyle(
//                     color: isUser
//                         ? Colors.white
//                         : Theme.of(context).colorScheme.primary,
//                   ),
//                   checkbox: TextStyle(
//                     color: isUser
//                         ? Colors.white
//                         : Theme.of(context).colorScheme.primary,
//                   ),
//                 ),
//                 onTapLink: (text, href, title) {
//                   // Handle any links in the markdown
//                   if (href != null) {
//                     // Implement link handling if needed
//                   }
//                 },
//               ),

//             // Show message timestamp for user messages
//             if (isUser)
//               Padding(
//                 padding: const EdgeInsets.only(top: 4),
//                 child: Align(
//                   alignment: Alignment.bottomRight,
//                   child: Text(
//                     'just now',
//                     style: TextStyle(
//                       fontSize: 10,
//                       color: Colors.white.withOpacity(0.7),
//                     ),
//                   ),
//                 ),
//               ),
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
import 'package:gymify/providers/ai_chatbot_provider/ai_chatbot_provider.dart';
import 'package:gymify/providers/profile_provider/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
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
                  '• Type "/coach" for personalized workout & nutrition plan',
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
                  '• Be specific about your fitness questions\n• Ask about exercises, muscle groups, or training\n• Tap on suggestions for quick answers',
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
      appBar: AppBar(
        title: Row(
          children: [
            Hero(
              tag: 'ai-coach-icon',
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  FontAwesomeIcons.dumbbell,
                  color: theme.colorScheme.primary,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Gymify AI Coach',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
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
                              'Best abs exercises?', 'Exercise tips', theme),
                          _buildPromptChip(
                              'Protein meal ideas', 'Nutrition', theme),
                          _buildPromptChip(
                              'How to improve deadlift?', 'Form help', theme),
                          _buildPromptChip(
                              'Calculate my macros', 'Nutrition', theme),
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
      onTap: () => _sendSuggestion(text),
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
    if (prompt.startsWith('/')) {
      return FontAwesomeIcons.wandMagicSparkles;
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
