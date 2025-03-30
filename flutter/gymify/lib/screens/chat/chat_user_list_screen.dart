// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:gymify/providers/chat_provider/chat_service.dart';
// import 'package:gymify/providers/chat_provider/trainer_provider.dart';
// import 'package:gymify/utils/custom_appbar.dart';
// import 'package:gymify/utils/custom_loader.dart';
// import 'package:gymify/utils/custom_snackbar.dart';
// import 'package:provider/provider.dart';
// import 'package:gymify/providers/auth_provider/auth_provider.dart';
// import 'package:gymify/models/all_user_model.dart';

// class UserTrainerPage extends StatefulWidget {
//   const UserTrainerPage({super.key});

//   @override
//   State<UserTrainerPage> createState() => _UserTrainerPageState();
// }

// class _UserTrainerPageState extends State<UserTrainerPage>
//     with SingleTickerProviderStateMixin {
//   // Future<void>? _fetchFuture;

//   // @override
//   // void didChangeDependencies() {
//   //   super.didChangeDependencies();

//   //   if (_fetchFuture == null) {
//   //     final authProvider = context.read<AuthProvider>();
//   //     final trainerProvider = context.read<TrainerProvider>();
//   //     final role = authProvider.role.toString();

//   //     _fetchFuture = trainerProvider.fetchDataByRole(role);
//   //   }
//   // }

//   Future<void>? _fetchFuture;
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _pulseAnimation;

//   @override
//   void initState() {
//     super.initState();

//     // Initialize animation controller
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2000),
//     )..repeat(reverse: true);

//     // Create a pulsing animation
//     _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeInOut,
//       ),
//     );

//     // Create a scale animation for when the button is pressed
//     _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();

//     if (_fetchFuture == null) {
//       final authProvider = context.read<AuthProvider>();
//       final trainerProvider = context.read<TrainerProvider>();
//       final role = authProvider.role.toString();

//       _fetchFuture = trainerProvider.fetchDataByRole(role);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final trainerProvider = Provider.of<TrainerProvider>(context);
//     final chatProvider = context.read<ChatProvider>();
//     final authProvider = context.read<AuthProvider>();
//     final role = authProvider.role.toString();
//     final currentUserId = authProvider.userId;

//     return Scaffold(
//       appBar: CustomAppBar(
//           showBackButton: false,
//           title: role == 'Trainer'
//               ? 'Chat with Users with Membership'
//               : 'Chat with Trainers'),
//       floatingActionButton: AnimatedBuilder(
//         animation: _animationController,
//         builder: (context, child) {
//           return Transform.scale(
//             scale: _pulseAnimation.value,
//             child: Container(
//               height: 56.0,
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.8),
//                 borderRadius: BorderRadius.circular(28.0),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.3),
//                     blurRadius: 8,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               padding: const EdgeInsets.all(4.0),
//               child: Material(
//                 color: Colors.transparent,
//                 child: InkWell(
//                   borderRadius: BorderRadius.circular(24.0),
//                   onTap: () {
//                     // Play a tap animation
//                     _animationController.stop();
//                     _animationController.reset();
//                     _animationController.forward().then((_) {
//                       // Navigate after animation completes
//                       context.pushNamed('aiChatScreen');
//                     });
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(24.0),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         ShaderMask(
//                           shaderCallback: (Rect bounds) {
//                             return const LinearGradient(
//                               colors: [Color(0xFF00E5FF), Color(0xFF6200EA)],
//                               begin: Alignment.centerLeft,
//                               end: Alignment.centerRight,
//                             ).createShader(bounds);
//                           },
//                           child: const Text(
//                             'AI CHAT',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18.0,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 8.0),
//                         TweenAnimationBuilder<double>(
//                           tween: Tween<double>(begin: 0, end: 1),
//                           duration: const Duration(milliseconds: 1500),
//                           curve: Curves.elasticOut,
//                           builder: (context, value, child) {
//                             return Transform.rotate(
//                               angle: value * 2 * 3.14159,
//                               child: Container(
//                                 height: 30.0,
//                                 width: 30.0,
//                                 decoration: const BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Color(0xFF9C27B0),
//                                 ),
//                                 child: const Icon(
//                                   CupertinoIcons.chat_bubble_2_fill,
//                                   color: Colors.white,
//                                   size: 18.0,
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//       body: _fetchFuture == null
//           ? const Center(child: CustomLoadingAnimation())
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
//                     ? trainerProvider.allActiveMembers
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
//                         child: Text(user.userName[0].toUpperCase()),
//                       ),
//                       title: Text(user.userName),
//                       subtitle: Text(user.role),
//                       onTap: () async {
//                         try {
//                           final chatId = await chatProvider.startConversation(
//                             int.parse(currentUserId!),
//                             user.userId,
//                           );
//                           print(chatId);
//                           print(user.userId);
//                           context.pushNamed(
//                             'chatScreen',
//                             extra: {
//                               'chatId': chatId,
//                               'userId': currentUserId.toString(),
//                               'userName': user.userName,
//                             },
//                           );
//                         } catch (e) {
//                           if (context.mounted) {
//                             showCoolSnackBar(context,
//                                 "Errpr Starting Conversation: $e", false);
//                           }
//                         }
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
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
import 'package:cached_network_image/cached_network_image.dart';

class UserTrainerPage extends StatefulWidget {
  const UserTrainerPage({super.key});

  @override
  State<UserTrainerPage> createState() => _UserTrainerPageState();
}

class _UserTrainerPageState extends State<UserTrainerPage>
    with SingleTickerProviderStateMixin {
  Future<void>? _fetchFuture;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // Create a pulsing animation
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Create a scale animation for when the button is pressed
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: _isSearching
          ? AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              title: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search by name...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Theme.of(context).hintColor,
                  ),
                ),
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                    _searchQuery = '';
                  });
                },
              ),
            )
          : AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              title: Text(
                role == 'Trainer' ? 'Chat with Members' : 'Chat with Trainers',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.search,
                      color: Theme.of(context).colorScheme.primary),
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                ),
              ],
            ),
      body: _fetchFuture == null
          ? const Center(child: CustomLoadingAnimation())
          : Column(
              children: [
                // AI Chat Banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: _buildAiChatBanner(context),
                ),

                // Section Title
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Icon(
                        role == 'Trainer' ? Icons.person : Icons.fitness_center,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        role == 'Trainer'
                            ? 'Active Members'
                            : 'Available Trainers',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Tap to chat',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // Trainer/Member List
                Expanded(
                  child: FutureBuilder(
                    future: _fetchFuture,
                    builder: (context, snapshot) {
                      if (trainerProvider.isLoading) {
                        return const Center(child: CustomLoadingAnimation());
                      }

                      if (trainerProvider.hasError) {
                        return _buildErrorView(() {
                          setState(() {
                            final authProvider = context.read<AuthProvider>();
                            final trainerProvider =
                                context.read<TrainerProvider>();
                            _fetchFuture = trainerProvider
                                .fetchDataByRole(authProvider.role.toString());
                          });
                        });
                      }

                      final list = role == 'Trainer'
                          ? trainerProvider.allActiveMembers
                          : trainerProvider.trainers;

                      if (list.isEmpty) {
                        return _buildEmptyView(role);
                      }

                      // Filter list based on search query
                      final filteredList = _searchQuery.isEmpty
                          ? list
                          : list
                              .where((user) => user.userName
                                  .toLowerCase()
                                  .contains(_searchQuery))
                              .toList();

                      if (filteredList.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 48,
                                color: Theme.of(context).hintColor,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No results found for "$_searchQuery"',
                                style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final AllUserModel user = filteredList[index];
                          return _buildUserCard(
                            context,
                            user,
                            currentUserId,
                            chatProvider,
                            isDarkMode,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildAiChatBanner(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () {
          _animationController.stop();
          _animationController.reset();
          _animationController.forward().then((_) {
            context.pushNamed('aiChatScreen');
          });
        },
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    // colors: isDarkMode
                    //     ? [const Color(0xFF7B1FA2), const Color(0xFF303F9F)]
                    //     : [const Color(0xFFE1BEE7), const Color(0xFF9C27B0)],
                    colors: isDarkMode
                        ? [const Color(0xFF7B1FA2), const Color(0xFF303F9F)]
                        : [const Color(0xFF7B1FA2), const Color(0xFF303F9F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Background decorative elements
                    Positioned(
                      right: -20,
                      top: -20,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -15,
                      bottom: -15,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),

                    // Content
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // AI Icon with animation
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 1500),
                            curve: Curves.elasticOut,
                            builder: (context, value, child) {
                              return Transform.rotate(
                                angle: value * 2 * 3.14159,
                                child: Container(
                                  height: 50.0,
                                  width: 50.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      CupertinoIcons.chat_bubble_2_fill,
                                      color: Color(0xFF9C27B0),
                                      size: 28.0,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 16),

                          // Text content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Title with gradient
                                ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return const LinearGradient(
                                      colors: [Colors.white, Color(0xFFE1BEE7)],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ).createShader(bounds);
                                  },
                                  child: const Text(
                                    'AI FITNESS ASSISTANT',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Get instant answers for workout, nutrition, and fitness questions',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),

                          // Arrow indicator
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildUserCard(
    BuildContext context,
    AllUserModel user,
    String? currentUserId,
    ChatProvider chatProvider,
    bool isDarkMode,
  ) {
    final isOnline = user.userId % 2 ==
        0; // Just for demonstration, replace with actual online status

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          _showLoadingDialog(context);
          try {
            final chatId = await chatProvider.startConversation(
              int.parse(currentUserId!),
              user.userId,
            );

            if (context.mounted) {
              Navigator.pop(context); // Dismiss loading dialog
              context.pushNamed(
                'chatScreen',
                extra: {
                  'chatId': chatId,
                  'userId': currentUserId.toString(),
                  'userName': user.userName,
                  'userImage': user.profileImage
                },
              );
            }
          } catch (e) {
            if (context.mounted) {
              Navigator.pop(context); // Dismiss loading dialog
              showCoolSnackBar(
                  context, "Error Starting Conversation: $e", false);
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Profile image
              Stack(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: _getColorFromName(user.userName),
                    child: user.profileImage.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(26),
                            child: CachedNetworkImage(
                              imageUrl: user.profileImage,
                              width: 52,
                              height: 52,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Text(user.userName[0].toUpperCase()),
                            ),
                          )
                        : Text(
                            user.userName[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),

                  // Online indicator
                  if (isOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDarkMode ? Colors.black : Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 16),

              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getRoleColor(user.role).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            user.role,
                            style: TextStyle(
                              fontSize: 12,
                              color: _getRoleColor(user.role),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (isOnline)
                          const Text(
                            'Online',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                            ),
                          )
                        else
                          Text(
                            'Last seen recently',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Chat button
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chat_bubble_outline,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView(VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load chat contacts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'We couldn\'t connect to the server. Please check your internet connection and try again.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(String role) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              role == 'Trainer' ? Icons.people_outline : Icons.fitness_center,
              size: 64,
              color: Colors.grey.withOpacity(0.6),
            ),
            const SizedBox(height: 16),
            Text(
              role == 'Trainer'
                  ? 'No active members available'
                  : 'No trainers available at the moment',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              role == 'Trainer'
                  ? 'When members with active memberships join, they will appear here'
                  : 'Please check back later or use our AI Assistant for fitness guidance',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Starting conversation..."),
            ],
          ),
        );
      },
    );
  }

  Color _getColorFromName(String name) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.red,
    ];

    // Use the name to deterministically select a color
    int hashCode = name.hashCode;
    return colors[hashCode.abs() % colors.length];
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'trainer':
        return Colors.blue;
      case 'user':
        return Colors.green;
      case 'admin':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
