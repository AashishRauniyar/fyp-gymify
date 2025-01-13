import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: const Text("this is the chat screen"),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:gymify/providers/socket_provider/socket_service.dart';
// import 'package:provider/provider.dart';

// class ChatScreen extends StatefulWidget {
//   final int chatId; // Chat room ID
//   final String userId; // Current user ID
//   final String userName; // Current user name

//   const ChatScreen({
//     required this.chatId,
//     required this.userId,
//     required this.userName,
//     super.key,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   late types.User _currentUser;

//   @override
//   void initState() {
//     super.initState();
//     _currentUser = types.User(id: widget.userId, firstName: widget.userName);

//     // Connect to socket and join the room
//     final socketProvider = Provider.of<SocketProvider>(context, listen: false);
//     socketProvider.connectSocket(widget.userId);
//     socketProvider.joinRoom(widget.chatId, widget.userId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final socketProvider = Provider.of<SocketProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat Room ${widget.chatId}'),
//       ),
//       body: Chat(
//         messages: _mapMessages(socketProvider.getMessagesForRoom(widget.chatId)),
//         onSendPressed: (partialMessage) => _handleSendMessage(partialMessage, socketProvider),
//         user: _currentUser,
//         showUserAvatars: true,
//         showUserNames: true,
//       ),
//     );
//   }

//   // Map raw message data to flutter_chat_types messages
//   List<types.Message> _mapMessages(List<Map<String, dynamic>> messages) {
//     return messages.map((message) {
//       final user = types.User(
//         id: message['sender_id'],
//         firstName: message['sender_name'] ?? "User",
//       );

//       return types.TextMessage(
//         author: user,
//         id: message['id'].toString(),
//         text: message['message_content']['text'],
//         createdAt: DateTime.now().millisecondsSinceEpoch,
//       );
//     }).toList();
//   }

//   // Handle sending a message
//   void _handleSendMessage(types.PartialText partialMessage, SocketProvider socketProvider) {
//     socketProvider.sendMessage(widget.chatId, widget.userId, partialMessage.text);
//   }

//   @override
//   void dispose() {
//     final socketProvider = Provider.of<SocketProvider>(context, listen: false);
//     socketProvider.disconnect();
//     super.dispose();
//   }
// }
