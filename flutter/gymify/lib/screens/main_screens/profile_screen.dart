import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/providers/auth_provider/auth_provider.dart';
import 'package:gymify/providers/chat_provider/chat_service.dart';
import 'package:gymify/providers/membership_provider/membership_provider.dart';
import 'package:gymify/providers/profile_provider/profile_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Future<void> _logout(BuildContext context) async {
    try {
      // Show a dialog to confirm logout
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                CupertinoDialogAction(
                  onPressed: () => Navigator.pop(context),
                  isDefaultAction: true,
                  child: const Text('Cancel'),
                ),
                CupertinoDialogAction(
                  onPressed: () async {
                    final authProvider =
                        Provider.of<AuthProvider>(context, listen: false);
                    final socketService =
                        Provider.of<ChatProvider>(context, listen: false);

                    socketService.handleLogout();
                    await authProvider.logout();

                    if (context.mounted) {
                      context.go('/welcome');
                    }
                  },
                  isDestructiveAction: true,
                  child: const Text('Logout'),
                ),
              ],
            );
          });
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Logout failed. Please try again.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      profileProvider.fetchProfile();

      final membershipProvider =
          Provider.of<MembershipProvider>(context, listen: false);
      membershipProvider.fetchMembershipStatus(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (profileProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CustomLoadingAnimation()),
      );
    }

    if (profileProvider.hasError) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.exclamationmark_circle,
                  size: 60,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error Loading Profile',
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  profileProvider.errorMessage.toString(),
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: theme.colorScheme.error),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => profileProvider.fetchProfile(),
                  icon: const Icon(CupertinoIcons.refresh),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final user = profileProvider.user;

    if (user != null) {
      _fullNameController.text = user.fullName ?? '';
      _emailController.text = user.email ?? '';
      _phoneController.text = user.phoneNumber ?? '';
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('My Profile'),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(CupertinoIcons.ellipsis_vertical),
      //       onPressed: () {
      //         // Show more options menu
      //         showModalBottomSheet(
      //           context: context,
      //           builder: (context) => SafeArea(
      //             child: Column(
      //               mainAxisSize: MainAxisSize.min,
      //               children: [
      //                 ListTile(
      //                   leading: Icon(CupertinoIcons.arrow_right_square_fill,
      //                       color: theme.colorScheme.primary),
      //                   title: const Text('Log Out'),
      //                   onTap: () {
      //                     Navigator.pop(context);
      //                     _logout(context);
      //                   },
      //                 ),
      //                 ListTile(
      //                   leading: Icon(CupertinoIcons.delete_solid,
      //                       color: theme.colorScheme.error),
      //                   title: Text(
      //                     'Delete Account',
      //                     style: TextStyle(color: theme.colorScheme.error),
      //                   ),
      //                   onTap: () {
      //                     Navigator.pop(context);
      //                     showCupertinoDialog(
      //                       context: context,
      //                       builder: (context) => CupertinoAlertDialog(
      //                         title: const Text('Delete Account'),
      //                         content: const Text(
      //                             'This action cannot be undone. Are you sure?'),
      //                         actions: [
      //                           CupertinoDialogAction(
      //                             onPressed: () => Navigator.pop(context),
      //                             isDefaultAction: true,
      //                             child: const Text('Cancel'),
      //                           ),
      //                           CupertinoDialogAction(
      //                             onPressed: () => Navigator.pop(context),
      //                             isDestructiveAction: true,
      //                             child: const Text('Delete'),
      //                           ),
      //                         ],
      //                       ),
      //                     );
      //                   },
      //                 ),
      //               ],
      //             ),
      //           ),
      //         );
      //       },
      //     ),
      //   ],
      // ),
      appBar: CustomAppBar(
        title: 'My Profile',
        showBackButton: false,
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.ellipsis_vertical,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              // Show more options menu
              showModalBottomSheet(
                context: context,
                builder: (context) => SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(CupertinoIcons.arrow_right_square_fill,
                            color: theme.colorScheme.primary),
                        title: const Text('Log Out'),
                        onTap: () {
                          Navigator.pop(context);
                          _logout(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(CupertinoIcons.delete_solid,
                            color: theme.colorScheme.error),
                        title: Text(
                          'Delete Account',
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          showCupertinoDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                              title: const Text('Delete Account'),
                              content: const Text(
                                  'This action cannot be undone. Are you sure?'),
                              actions: [
                                CupertinoDialogAction(
                                  onPressed: () => Navigator.pop(context),
                                  isDefaultAction: true,
                                  child: const Text('Cancel'),
                                ),
                                CupertinoDialogAction(
                                  onPressed: () => Navigator.pop(context),
                                  isDestructiveAction: true,
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header Section - Redesigned with a more subtle appearance
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Profile Image with updated design
                  Hero(
                    tag: 'profile-image',
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: theme.colorScheme.surface,
                            child: CircleAvatar(
                              radius: 47,
                              backgroundImage: user?.profileImage != null
                                  ? NetworkImage(user!.profileImage!)
                                  : const AssetImage(
                                          'assets/images/default_profile.png')
                                      as ImageProvider,
                            ),
                          ),
                        ),
                        // Small edit indicator
                        GestureDetector(
                          onTap: () {
                            context.pushNamed('editProfile');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.colorScheme.surface,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              CupertinoIcons.pencil,
                              size: 14,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // User Name with regular text color
                  Text(
                    user?.fullName ?? 'Fitness Enthusiast',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 8),

                  // User Email
                  Text(
                    user?.email ?? 'myemail.com',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // User Role Badge with primary color
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      user?.role ?? 'Member',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Edit Profile Button with updated style
                  SizedBox(
                    width: 200,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.pushNamed('editProfile');
                      },
                      icon: const Icon(CupertinoIcons.pencil, size: 16),
                      label: const Text('Edit Profile'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: theme.colorScheme.primary),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Stats Row
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.1),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoColumn(
                        context,
                        CupertinoIcons.calendar_badge_plus,
                        user?.birthdate != null
                            ? '${user!.birthdate!.day}/${user.birthdate!.month}/${user.birthdate!.year}'
                            : 'Not set',
                        'Birthday',
                      ),
                      Container(
                        height: 40,
                        width: 1,
                        color: theme.colorScheme.outline.withOpacity(0.2),
                      ),
                      _buildInfoColumn(
                        context,
                        CupertinoIcons.location_solid,
                        user?.address ?? 'Not set',
                        'Location',
                      ),
                      Container(
                        height: 40,
                        width: 1,
                        color: theme.colorScheme.outline.withOpacity(0.2),
                      ),
                      _buildInfoColumn(
                        context,
                        CupertinoIcons.phone_fill,
                        user?.phoneNumber ?? 'Not set',
                        'Contact',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Membership Status Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Consumer<MembershipProvider>(
                builder: (context, membershipProvider, child) {
                  final membershipStatus = membershipProvider.membership;
                  final currentPlan = membershipStatus != null
                      ? membershipStatus.status ?? 'Not Active'
                      : 'Not Active';

                  Color statusColor = Colors.grey;
                  if (currentPlan == 'Active') {
                    statusColor = Colors.green;
                  } else if (currentPlan == 'Pending') {
                    statusColor = Colors.orange;
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primaryContainer,
                          theme.colorScheme.primaryContainer.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                CupertinoIcons.creditcard,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Membership',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Status',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme
                                          .colorScheme.onPrimaryContainer
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: statusColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        currentPlan,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: theme
                                              .colorScheme.onPrimaryContainer,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  context.pushNamed('membershipPlans');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      theme.colorScheme.onPrimaryContainer,
                                  foregroundColor:
                                      theme.colorScheme.primaryContainer,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                ),
                                child: const Text('Manage'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Trainer Tools Section (if role is trainer)
            if (profileProvider.user?.role == "Trainer") ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Trainer Tools',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Manage your resources',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: theme.colorScheme.outline.withOpacity(0.1),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTrainerToolItem(
                                    context,
                                    CupertinoIcons.flame_fill,
                                    'Workouts',
                                    () => context.pushNamed('manageWorkouts'),
                                  ),
                                ),
                                Expanded(
                                  child: _buildTrainerToolItem(
                                    context,
                                    FontAwesomeIcons.carrot,
                                    'Diet Plans',
                                    () => context.pushNamed('manageDietPlans'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTrainerToolItem(
                                    context,
                                    CupertinoIcons.waveform_path,
                                    'Exercises',
                                    () => context.pushNamed('manageExercise'),
                                  ),
                                ),
                                Expanded(
                                  child: _buildTrainerToolItem(
                                    context,
                                    CupertinoIcons.chart_bar_fill,
                                    'Supported Exercises',
                                    () {
                                      context.pushNamed(
                                          'createSupportedExercise',
                                          extra: profileProvider.user?.userId
                                              .toString());
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Settings & Security Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings & Account',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSettingsCard(
                    context,
                    [
                      _buildActionTile(
                        context,
                        CupertinoIcons.lock_fill,
                        'Reset Password',
                        'Update your security credentials',
                        () => context.pushNamed('forgotPassword'),
                      ),
                      _buildActionTile(
                        context,
                        CupertinoIcons.question_circle_fill,
                        'Help & FAQs',
                        'Contact us for assistance',
                        () {
                          context.pushNamed('helpFaqs');
                        },
                      ),
                      _buildActionTile(
                        context,
                        CupertinoIcons.star_fill,
                        'Rate the App',
                        'Let us know how we\'re doing',
                        () {
                          // Navigate to app rating
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainerToolItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 110, // Slightly increased height for additional text
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.onPrimaryContainer,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Manage',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(
      BuildContext context, IconData icon, String value, String label) {
    final theme = Theme.of(context);

    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
      IconData icon, String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 22,
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color:
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          fontSize: 12,
        ),
      ),
      trailing: Icon(
        CupertinoIcons.forward,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
        size: 18,
      ),
      onTap: onTap,
    );
  }

  Widget _buildToolCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                ),
                child: Icon(
                  icon,
                  color: theme.colorScheme.onPrimaryContainer,
                  size: 28,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, List<Widget> children) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDarkMode
              ? theme.colorScheme.onSurface.withOpacity(0.1)
              : theme.colorScheme.onSurface.withOpacity(0.1),
          width: 1,
        ),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: children,
      ),
    );
  }
}
