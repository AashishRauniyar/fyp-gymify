// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; // Required for Clipboard functionality
// import 'package:gymify/utils/custom_appbar.dart';
// import 'package:provider/provider.dart';
// import 'package:gymify/providers/chat_provider/chat_service.dart';

// class ChatScreen extends StatefulWidget {
//   final int chatId;
//   final String userId;
//   final String userName;
//   final String userImage;

//   const ChatScreen({
//     super.key,
//     required this.chatId,
//     required this.userId,
//     required this.userName,
//     required this.userImage,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final FocusNode _inputFocusNode = FocusNode();
//   bool _showScrollToBottom = false;
//   int _previousMessageCount = 0;

//   @override
//   void initState() {
//     super.initState();
//     final chatProvider = context.read<ChatProvider>();

//     // Fetch old messages and join the room
//     chatProvider.fetchMessages(widget.chatId).then((_) {
//       chatProvider.joinRoom(widget.chatId, int.parse(widget.userId));
//       chatProvider.listenToMessages();

//       // Initialize the previous message count after fetching
//       _previousMessageCount = chatProvider.messages.length;

//       // Initial scroll to bottom after loading messages
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _scrollToBottom();
//       });
//     });

//     // Listen for typing events
//     _inputFocusNode.addListener(() {
//       if (_inputFocusNode.hasFocus) {
//         chatProvider.sendTypingEvent(widget.chatId, widget.userId, true);
//       } else {
//         chatProvider.sendTypingEvent(widget.chatId, widget.userId, false);
//       }
//     });

//     // Listen for scroll events to toggle the "Scroll to Bottom" arrow
//     _scrollController.addListener(() {
//       if (_scrollController.offset <
//           _scrollController.position.maxScrollExtent - 100) {
//         if (!_showScrollToBottom) {
//           setState(() {
//             _showScrollToBottom = true;
//           });
//         }
//       } else {
//         if (_showScrollToBottom) {
//           setState(() {
//             _showScrollToBottom = false;
//           });
//         }
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _scrollController.dispose();
//     _inputFocusNode.dispose();
//     super.dispose();
//   }

//   void _sendMessage() {
//     final chatProvider = context.read<ChatProvider>();
//     final message = _messageController.text.trim();

//     if (message.isNotEmpty) {
//       chatProvider.sendMessage(widget.chatId, widget.userId, message);
//       _messageController.clear();

//       // Auto-scroll to the latest message after sending
//       Future.delayed(const Duration(milliseconds: 100), () {
//         _scrollToBottom();
//       });
//     }
//   }

//   void _copyMessage(String message) {
//     Clipboard.setData(ClipboardData(text: message));
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Message copied to clipboard'),
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }

//   void _scrollToBottom() {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return GestureDetector(
//       onTap: () {
//         // Unfocus keyboard when tapping anywhere outside the input
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         appBar: CustomAppBar(
//           showBackButton: true,
//           title: widget.userName,
//           actions: [
//             //profile image

//             ClipRRect(
//               borderRadius: BorderRadius.circular(18),
//               child: CachedNetworkImage(
//                 imageUrl: widget.userImage,
//                 width: 36,
//                 height: 36,
//                 fit: BoxFit.cover,
//                 placeholder: (context, url) => CircularProgressIndicator(
//                   strokeWidth: 2,
//                   valueColor: AlwaysStoppedAnimation<Color>(
//                     Theme.of(context).colorScheme.primary,
//                   ),
//                 ),
//                 errorWidget: (context, url, error) => Text(
//                   widget.userName[0].toUpperCase(),
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//         body: Stack(
//           children: [
//             Column(
//               children: [
//                 Expanded(
//                   child: Consumer<ChatProvider>(
//                     builder: (context, chatProvider, child) {
//                       // Check if new messages have arrived
//                       if (chatProvider.messages.length >
//                           _previousMessageCount) {
//                         // Update the previous count
//                         _previousMessageCount = chatProvider.messages.length;

//                         // Auto-scroll to the latest message after a short delay
//                         // This ensures the ListView has been built
//                         Future.delayed(const Duration(milliseconds: 100), () {
//                           _scrollToBottom();
//                         });
//                       }

//                       return ListView.builder(
//                         controller: _scrollController,
//                         itemCount: chatProvider.messages.length,
//                         itemBuilder: (context, index) {
//                           final message = chatProvider.messages[index];
//                           final isMe =
//                               message['sender_id'].toString() == widget.userId;
//                           final messageText = message['message_content']
//                                   ?['text'] ??
//                               'Message unavailable';
//                           final timestamp =
//                               DateTime.parse(message['sent_at']).toLocal();

//                           return GestureDetector(
//                             onLongPress: () {
//                               // Copy the message on long press
//                               _copyMessage(messageText);
//                             },
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 5, horizontal: 10),
//                               child: Row(
//                                 mainAxisAlignment: isMe
//                                     ? MainAxisAlignment.end
//                                     : MainAxisAlignment.start,
//                                 children: [
//                                   if (!isMe)
//                                     CircleAvatar(
//                                       child: Text(
//                                           widget.userName[0].toUpperCase()),
//                                       // child: CachedNetworkImage(
//                                       //     imageUrl: widget.userImage),
//                                     ),
//                                   const SizedBox(width: 8),
//                                   Flexible(
//                                     child: Container(
//                                       padding: const EdgeInsets.all(10),
//                                       decoration: BoxDecoration(
//                                         color: isMe
//                                             ? theme.colorScheme.primary
//                                             : theme.colorScheme.surface,
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             messageText,
//                                             style: theme.textTheme.bodyMedium
//                                                 ?.copyWith(
//                                               color: isMe
//                                                   ? theme.colorScheme.onPrimary
//                                                   : theme.colorScheme.onSurface,
//                                             ),
//                                           ),
//                                           const SizedBox(height: 5),
//                                           Text(
//                                             "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}",
//                                             style: theme.textTheme.bodySmall
//                                                 ?.copyWith(
//                                               color: isMe
//                                                   ? theme.colorScheme.onPrimary
//                                                   : Colors.grey,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//                 if (context.watch<ChatProvider>().isTyping)
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       "${widget.userName} is typing...",
//                       style: theme.textTheme.bodySmall?.copyWith(
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ),
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           focusNode: _inputFocusNode,
//                           controller: _messageController,
//                           style: theme.textTheme.bodyMedium,
//                           decoration: InputDecoration(
//                             hintText: "Type a message...",
//                             filled: true,
//                             fillColor: theme.colorScheme.surface,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(20),
//                               borderSide: BorderSide.none,
//                             ),
//                             contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 15, vertical: 10),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       IconButton(
//                         icon: const Icon(Icons.send),
//                         color: theme.colorScheme.primary,
//                         onPressed: _sendMessage,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             if (_showScrollToBottom)
//               Positioned(
//                 bottom: 90,
//                 right: 16,
//                 child: GestureDetector(
//                   onTap: _scrollToBottom,
//                   child: Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: theme.colorScheme.primary,
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.arrow_downward,
//                       size: 20,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:gymify/providers/chat_provider/chat_service.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class ChatScreen extends StatefulWidget {
  final int chatId;
  final String userId;
  final String userName;
  final String userImage;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.userId,
    required this.userName,
    required this.userImage,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();
  bool _showScrollToBottom = false;
  int _previousMessageCount = 0;
  late AnimationController _sendButtonController;

  @override
  void initState() {
    super.initState();
    final chatProvider = context.read<ChatProvider>();

    // Initialize animation controller for send button
    _sendButtonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Fetch old messages and join the room
    chatProvider.fetchMessages(widget.chatId).then((_) {
      chatProvider.joinRoom(widget.chatId, int.parse(widget.userId));
      chatProvider.listenToMessages();

      // Initialize the previous message count after fetching
      _previousMessageCount = chatProvider.messages.length;

      // Initial scroll to bottom after loading messages
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    });

    // Listen for typing events
    _inputFocusNode.addListener(() {
      if (_inputFocusNode.hasFocus) {
        chatProvider.sendTypingEvent(widget.chatId, widget.userId, true);
      } else {
        chatProvider.sendTypingEvent(widget.chatId, widget.userId, false);
      }
    });

    // Listen for scroll events to toggle the "Scroll to Bottom" arrow
    _scrollController.addListener(() {
      if (_scrollController.offset <
          _scrollController.position.maxScrollExtent - 100) {
        if (!_showScrollToBottom) {
          setState(() {
            _showScrollToBottom = true;
          });
        }
      } else {
        if (_showScrollToBottom) {
          setState(() {
            _showScrollToBottom = false;
          });
        }
      }
    });

    // Listen for text changes to animate the send button
    _messageController.addListener(() {
      if (_messageController.text.isNotEmpty) {
        _sendButtonController.forward();
      } else {
        _sendButtonController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _inputFocusNode.dispose();
    _sendButtonController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final chatProvider = context.read<ChatProvider>();
    final message = _messageController.text.trim();

    if (message.isNotEmpty) {
      chatProvider.sendMessage(widget.chatId, widget.userId, message);
      _messageController.clear();

      // Add haptic feedback when sending message
      HapticFeedback.lightImpact();

      // Auto-scroll to the latest message after sending
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollToBottom();
      });
    }
  }

  void _copyMessage(String message) {
    Clipboard.setData(ClipboardData(text: message));

    // Enhanced snackbar for copy confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Message copied to clipboard'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String _formatTime(DateTime timestamp) {
    return DateFormat('h:mm a').format(timestamp);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Enhanced background with subtle pattern
    final backgroundColor = colorScheme.surface;

    return GestureDetector(
      onTap: () {
        // Unfocus keyboard when tapping anywhere outside the input
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: CustomAppBar(
          showBackButton: true,
          title: widget.userName,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: Hero(
                tag: 'profile-${widget.userName}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: colorScheme.primary.withOpacity(0.4),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.userImage,
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        padding: const EdgeInsets.all(8),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.primary,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.userName[0].toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            image: const DecorationImage(
              image: AssetImage('assets/images/chat_background.png'),
              opacity: 0.05,
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Consumer<ChatProvider>(
                      builder: (context, chatProvider, child) {
                        // Check if new messages have arrived
                        if (chatProvider.messages.length >
                            _previousMessageCount) {
                          _previousMessageCount = chatProvider.messages.length;

                          Future.delayed(const Duration(milliseconds: 100), () {
                            _scrollToBottom();
                          });
                        }

                        // Group messages by date
                        final groupedMessages = <String, List<dynamic>>{};
                        for (final message in chatProvider.messages) {
                          final date =
                              DateTime.parse(message['sent_at']).toLocal();
                          final dateKey = DateFormat('yyyy-MM-dd').format(date);

                          if (!groupedMessages.containsKey(dateKey)) {
                            groupedMessages[dateKey] = [];
                          }
                          groupedMessages[dateKey]!.add(message);
                        }

                        // Convert to list for ListView
                        final dateGroups = groupedMessages.entries.toList()
                          ..sort((a, b) => a.key.compareTo(b.key));

                        return ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(top: 16, bottom: 4),
                          itemCount: dateGroups.length,
                          itemBuilder: (context, groupIndex) {
                            final dateKey = dateGroups[groupIndex].key;
                            final messages = dateGroups[groupIndex].value;
                            final dateTime = DateTime.parse(dateKey);
                            final isToday =
                                DateTime.now().difference(dateTime).inDays == 0;
                            final isYesterday =
                                DateTime.now().difference(dateTime).inDays == 1;

                            String dateLabel;
                            if (isToday) {
                              dateLabel = 'Today';
                            } else if (isYesterday) {
                              dateLabel = 'Yesterday';
                            } else {
                              dateLabel =
                                  DateFormat('MMMM d, yyyy').format(dateTime);
                            }

                            return Column(
                              children: [
                                // Date header
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colorScheme
                                            .surfaceContainerHighest
                                            .withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        dateLabel,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Messages for this date
                                ...messages.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final message = entry.value;
                                  final isMe =
                                      message['sender_id'].toString() ==
                                          widget.userId;
                                  final messageText = message['message_content']
                                          ?['text'] ??
                                      'Message unavailable';
                                  final timestamp =
                                      DateTime.parse(message['sent_at'])
                                          .toLocal();

                                  // Determine if we should show sender avatar
                                  // (Only show if message is from different sender than previous)
                                  bool showAvatar = !isMe;
                                  if (index > 0) {
                                    final prevMessage = messages[index - 1];
                                    final prevIsMe =
                                        prevMessage['sender_id'].toString() ==
                                            widget.userId;
                                    if (!isMe && !prevIsMe) {
                                      showAvatar = index == 0 ||
                                          DateTime.parse(message['sent_at'])
                                                  .difference(DateTime.parse(
                                                      prevMessage['sent_at']))
                                                  .inMinutes >
                                              2;
                                    }
                                  }

                                  return GestureDetector(
                                    onLongPress: () {
                                      _copyMessage(messageText);
                                      HapticFeedback.mediumImpact();
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        top: 2,
                                        bottom: (index == messages.length - 1)
                                            ? 8
                                            : 2,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: isMe
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          if (!isMe && showAvatar)
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  right: 8),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                child: CachedNetworkImage(
                                                  imageUrl: widget.userImage,
                                                  width: 32,
                                                  height: 32,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      Container(
                                                    width: 32,
                                                    height: 32,
                                                    decoration: BoxDecoration(
                                                      color: colorScheme.primary
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                    child: Center(
                                                      child: SizedBox(
                                                        width: 16,
                                                        height: 16,
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            colorScheme.primary,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          CircleAvatar(
                                                    radius: 16,
                                                    backgroundColor:
                                                        colorScheme.primary,
                                                    child: Text(
                                                      widget.userName[0]
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: colorScheme
                                                            .onPrimary,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          if (!isMe && !showAvatar)
                                            const SizedBox(
                                                width: 40), // Space for avatar
                                          ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                            ),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 14,
                                                vertical: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                color: isMe
                                                    ? colorScheme.primary
                                                    : colorScheme
                                                        .surfaceContainerHighest,
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      const Radius.circular(18),
                                                  topRight:
                                                      const Radius.circular(18),
                                                  bottomLeft: Radius.circular(
                                                      isMe ? 18 : 4),
                                                  bottomRight: Radius.circular(
                                                      isMe ? 4 : 18),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.05),
                                                    blurRadius: 3,
                                                    offset: const Offset(0, 1),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    messageText,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: isMe
                                                          ? colorScheme
                                                              .onPrimary
                                                          : colorScheme
                                                              .onSurface,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Text(
                                                      _formatTime(timestamp),
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color: isMe
                                                            ? colorScheme
                                                                .onPrimary
                                                                .withOpacity(
                                                                    0.7)
                                                            : colorScheme
                                                                .onSurfaceVariant,
                                                      ),
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
                                }),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                  // Typing indicator
                  // Replace the current typing indicator with this simpler, more reliable implementation
// This needs to be placed right before the message input area in your Column

// Typing indicator
                  if (context.watch<ChatProvider>().isTyping)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest
                              .withOpacity(0.7),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Animated dots
                            Row(
                              children: List.generate(3, (index) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 4),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 400),
                                    height: 8,
                                    width: 8,
                                    decoration: BoxDecoration(
                                      color:
                                          colorScheme.primary.withOpacity(0.6),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "${widget.userName} is typing...",
                              style: TextStyle(
                                fontSize: 13,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Message input area
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest
                                    .withOpacity(0.5),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: colorScheme.outline.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: TextField(
                                focusNode: _inputFocusNode,
                                controller: _messageController,
                                style: theme.textTheme.bodyMedium,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                maxLines: 5,
                                minLines: 1,
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.newline,
                                decoration: InputDecoration(
                                  hintText: "Message",
                                  hintStyle: TextStyle(
                                    color: colorScheme.onSurfaceVariant
                                        .withOpacity(0.7),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ScaleTransition(
                            scale: Tween(begin: 0.8, end: 1.0).animate(
                              CurvedAnimation(
                                parent: _sendButtonController,
                                curve: Curves.elasticOut,
                              ),
                            ),
                            child: Container(
                              height: 48,
                              width: 48,
                              margin: const EdgeInsets.only(bottom: 2),
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.primary.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.send_rounded),
                                color: colorScheme.onPrimary,
                                onPressed: _sendMessage,
                                tooltip: 'Send message',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Scroll to bottom button
              if (_showScrollToBottom)
                Positioned(
                  bottom: 90,
                  right: 16,
                  child: InkWell(
                    onTap: _scrollToBottom,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: 24,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypingDot(int index, Color color) {
    return Positioned(
      left: index * 10.0,
      child: AnimatedBuilder(
        animation: _sendButtonController,
        builder: (context, child) {
          return TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, sin((value * 3 + index * 0.4) * 3.14) * 4),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
