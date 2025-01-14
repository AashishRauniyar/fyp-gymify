// import 'package:flutter/material.dart';
// import 'package:gymify/providers/chat_provider/chat_service.dart';
// import 'package:gymify/screens/main_screens/chat_screen.dart';
// import 'package:provider/provider.dart';



// class ConversationListScreen extends StatelessWidget {
//   final String userId;

//   const ConversationListScreen({required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     final chatProvider = Provider.of<ChatProvider>(context, listen: false);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Conversations')),
//       body: FutureBuilder(
//         future: chatProvider.fetchConversations(userId),
//         builder: (context, snapshot) {
//           if (chatProvider.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final conversations = chatProvider.conversations;

//           return ListView.builder(
//             itemCount: conversations.length,
//             itemBuilder: (context, index) {
//               final conversation = conversations[index];
//               return ListTile(
//                 title: Text('Chat ID: ${conversation['chat_id']}'),
//                 subtitle: Text(conversation['last_message'] ?? 'No messages yet'),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => ChatScreen(
//                         chatId: conversation['chat_id'].toString(),
//                         userId: userId,
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
