import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/providers/chat_provider/chat_service.dart';
import 'package:gymify/providers/chat_provider/trainer_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:gymify/utils/custom_snackbar.dart';
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
      appBar: CustomAppBar(
          showBackButton: false,
          title: role == 'Trainer'
              ? 'Chat with Users with Membership'
              : 'Chat with Trainers'),
      // FAB to show chat with AI
      
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
                    ? trainerProvider.allActiveMembers
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
                          context.pushNamed(
                            'chatScreen',
                            extra: {
                              'chatId': chatId,
                              'userId': currentUserId.toString(),
                              'userName': user.userName,
                            },
                          );
                        } catch (e) {
                          if (context.mounted) {
                            showCoolSnackBar(context,
                                "Errpr Starting Conversation: $e", false);
                          }
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
