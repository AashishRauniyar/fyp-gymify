// import 'package:flutter/material.dart';
// import 'package:gymify/providers/chat_provider/trainer_provider.dart';
// import 'package:gymify/utils/custom_loader.dart';
// import 'package:provider/provider.dart';
// import 'package:gymify/providers/auth_provider/auth_provider.dart';
// import 'package:gymify/models/all_user_model.dart';

// class UserTrainerPage extends StatefulWidget {
//   const UserTrainerPage({super.key});

//   @override
//   State<UserTrainerPage> createState() => _UserTrainerPageState();
// }

// class _UserTrainerPageState extends State<UserTrainerPage> {
//   Future<void>? _fetchFuture; // Initialize as nullable

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();

//     if (_fetchFuture == null) {
//       final authProvider = context.read<AuthProvider>();
//       final trainerProvider = context.read<TrainerProvider>();
//       final role = authProvider.role.toString();

//       _fetchFuture = trainerProvider.fetchDataByRole(role); // Safely initialize
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final trainerProvider = Provider.of<TrainerProvider>(context);
//     final authProvider = context.read<AuthProvider>();
//     final role = authProvider.role.toString();

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         scrolledUnderElevation: 0,
//         toolbarHeight: 60,
//         title: Text(
//           role == 'Trainer' ? 'Chat with Users' : 'Chat with Trainers',
//           style: Theme.of(context).textTheme.headlineMedium,
//         ),
//       ),
//       body: _fetchFuture == null
//           ? const Center(child: CustomLoadingAnimation()) // Handle null case
//           : FutureBuilder(
//               future: _fetchFuture,
//               builder: (context, snapshot) {
//                 if (trainerProvider.isLoading) {
//                   return const Center(child: CustomLoadingAnimation());
//                 }

//                 if (trainerProvider.hasError) {
//                   return const Center(child: Text('Failed to load data.'));
//                 }

//                 final list = role == 'Trainer'
//                     ? trainerProvider.members
//                     : trainerProvider.trainers;

//                 if (list.isEmpty) {
//                   return const Center(child: Text('No data available.'));
//                 }

//                 return ListView.builder(
//                   itemCount: list.length,
//                   itemBuilder: (context, index) {
//                     final AllUserModel user = list[index];
//                     return ListTile(
//                       leading: CircleAvatar(
//                         child: Text(
//                             user.userName[0].toUpperCase()), // Show initial
//                       ),
//                       title: Text(user.userName),
//                       subtitle: Text(user.role),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => DetailsPage(user: user),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//     );
//   }
// }

// class DetailsPage extends StatelessWidget {
//   final AllUserModel user;

//   const DetailsPage({super.key, required this.user});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(user.userName)),
//       body: Center(
//         child: Text('Details for ${user.userName}, Role: ${user.role}'),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

import 'package:gymify/providers/chat_provider/chat_service.dart';
import 'package:gymify/providers/chat_provider/trainer_provider.dart';
import 'package:gymify/screens/main_screens/chat_screen.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:provider/provider.dart';
import 'package:gymify/providers/auth_provider/auth_provider.dart';
import 'package:gymify/models/all_user_model.dart';

class UserTrainerPage extends StatefulWidget {
  const UserTrainerPage({super.key});

  @override
  State<UserTrainerPage> createState() => _UserTrainerPageState();
}

class _UserTrainerPageState extends State<UserTrainerPage> {
  Future<void>? _fetchFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_fetchFuture == null) {
      final authProvider = context.read<AuthProvider>();
      final trainerProvider = context.read<TrainerProvider>();
      final role = authProvider.role.toString();

      _fetchFuture = trainerProvider.fetchDataByRole(role);
    }
  }

  @override
  Widget build(BuildContext context) {
    final trainerProvider = Provider.of<TrainerProvider>(context);
    final chatProvider = context.read<ChatProvider>();
    final authProvider = context.read<AuthProvider>();
    final role = authProvider.role.toString();
    final currentUserId = authProvider.userId;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          role == 'Trainer' ? 'Chat with Users' : 'Chat with Trainers',
        ),
      ),
      body: _fetchFuture == null
          ? const Center(child: CustomLoadingAnimation())
          : FutureBuilder(
              future: _fetchFuture,
              builder: (context, snapshot) {
                if (trainerProvider.isLoading) {
                  return const Center(child: CustomLoadingAnimation());
                }

                if (trainerProvider.hasError) {
                  return const Center(child: Text('Failed to load data.'));
                }

                final list = role == 'Trainer'
                    ? trainerProvider.members
                    : trainerProvider.trainers;

                if (list.isEmpty) {
                  return const Center(child: Text('No data available.'));
                }

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final AllUserModel user = list[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(user.userName[0].toUpperCase()),
                      ),
                      title: Text(user.userName),
                      subtitle: Text(user.role),
                      onTap: () async {
                        try {
                          final chatId = await chatProvider.startConversation(
                            int.parse(currentUserId!),
                            user.userId,
                          );
                          print(chatId);
                          print(user.userId);

                          // Navigate to ChatScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                chatId: chatId,
                                userId: currentUserId.toString(),
                              ),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error starting conversation: $e'),
                            ),
                          );
                        }
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
