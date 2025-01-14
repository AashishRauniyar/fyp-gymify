import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for Clipboard functionality
import 'package:provider/provider.dart';
import 'package:gymify/providers/chat_provider/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final int chatId;
  final String userId;
  final String userName;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.userId,
    required this.userName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();
  bool _showScrollToBottom = false;

  @override
  void initState() {
    super.initState();
    final chatProvider = context.read<ChatProvider>();

    // Fetch old messages and join the room
    chatProvider.fetchMessages(widget.chatId).then((_) {
      chatProvider.joinRoom(widget.chatId, int.parse(widget.userId));
      chatProvider.listenToMessages();
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
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final chatProvider = context.read<ChatProvider>();
    final message = _messageController.text.trim();

    if (message.isNotEmpty) {
      chatProvider.sendMessage(widget.chatId, widget.userId, message);
      _messageController.clear();

      // Auto-scroll to the latest message after sending
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollToBottom();
      });
    }
  }

  void _copyMessage(String message) {
    Clipboard.setData(ClipboardData(text: message));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        // Unfocus keyboard when tapping anywhere outside the input
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                child: Text(widget.userName[0].toUpperCase()),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userName,
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(color: theme.colorScheme.onPrimary),
                  ),
                  Text(
                    context.watch<ChatProvider>().connectionStatus,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.onPrimary),
                  ),
                ],
              ),
            ],
          ),
          backgroundColor: theme.colorScheme.primary,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Consumer<ChatProvider>(
                    builder: (context, chatProvider, child) {
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: chatProvider.messages.length,
                        itemBuilder: (context, index) {
                          final message = chatProvider.messages[index];
                          final isMe =
                              message['sender_id'].toString() == widget.userId;
                          final messageText = message['message_content']
                                  ?['text'] ??
                              'Message unavailable';
                          final timestamp =
                              DateTime.parse(message['sent_at']).toLocal();

                          return GestureDetector(
                            onLongPress: () {
                              // Copy the message on long press
                              _copyMessage(messageText);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Row(
                                mainAxisAlignment: isMe
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  if (!isMe)
                                    CircleAvatar(
                                      child: Text(
                                          widget.userName[0].toUpperCase()),
                                    ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: isMe
                                            ? theme.colorScheme.primary
                                            : theme.colorScheme.surface,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            messageText,
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                              color: isMe
                                                  ? theme.colorScheme.onPrimary
                                                  : theme.colorScheme.onSurface,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}",
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                              color: isMe
                                                  ? theme.colorScheme.onPrimary
                                                  : Colors.grey,
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
                        },
                      );
                    },
                  ),
                ),
                if (context.watch<ChatProvider>().isTyping)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${widget.userName} is typing...",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: _inputFocusNode,
                          controller: _messageController,
                          style: theme.textTheme.bodyMedium,
                          decoration: InputDecoration(
                            hintText: "Type a message...",
                            filled: true,
                            fillColor: theme.colorScheme.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.send),
                        color: theme.colorScheme.primary,
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_showScrollToBottom)
              Positioned(
                bottom: 90,
                right: 16,
                child: GestureDetector(
                  onTap: _scrollToBottom,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_downward,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
