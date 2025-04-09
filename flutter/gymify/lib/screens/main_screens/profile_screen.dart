import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/providers/auth_provider/auth_provider.dart';
import 'package:gymify/providers/chat_provider/chat_service.dart';
import 'package:gymify/providers/membership_provider/membership_provider.dart';
import 'package:gymify/providers/profile_provider/profile_provider.dart';
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

  bool _workoutReminders = true;
  bool _emailNotifications = false;
  bool _pushNotifications = true;

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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280.0, // Increased height to accommodate content
            floating: false,
            pinned: true,
            backgroundColor: theme.colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 16),
              title: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: 1.0,
                child: Text(
                  'My Profile',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.8),
                          theme.colorScheme.primary,
                        ],
                      ),
                    ),
                  ),
                  // Profile content
                  SafeArea(
                    child: Column(
                      children: [
                        const SizedBox(height: 32), // Increased top spacing
                        // Profile image with hero animation
                        Hero(
                          tag: 'profile-image',
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.colorScheme.onPrimary
                                    .withOpacity(0.5),
                                width: 3,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: theme.colorScheme.onPrimary,
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
                        ),
                        const SizedBox(
                            height: 24), // Increased spacing between elements
                        // User name
                        Text(
                          user?.fullName ?? 'Fitness Enthusiast',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12), // Increased spacing
                        // User role badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onPrimary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            user?.role ?? 'Member',
                            style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24), // Added bottom spacing
                      ],
                    ),
                  ),
                  // Decorative pattern overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            theme.colorScheme.primary.withOpacity(0.2),
                            theme.colorScheme.primary.withOpacity(0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Membership Status Card
                  Consumer<MembershipProvider>(
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
                        decoration: BoxDecoration(
                          // color: isDarkMode
                          //     ? theme.colorScheme.surface
                          //     : theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDarkMode
                                ? theme.colorScheme.onSurface.withOpacity(0.1)
                                : theme.colorScheme.onSurface.withOpacity(0.1),
                            width: 1.5,
                          ),
                        ),
                        child: Card(
                          elevation: 0,
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(16),
                          // ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.creditcard,
                                      color: theme.colorScheme.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Membership',
                                      style:
                                          theme.textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Status',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withOpacity(0.6),
                                          ),
                                        ),
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
                                              style: theme.textTheme.bodyLarge
                                                  ?.copyWith(
                                                fontWeight: FontWeight.w500,
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
                                            theme.colorScheme.primary,
                                        foregroundColor:
                                            theme.colorScheme.onPrimary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text('Manage'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Personal Info Section
                  Text(
                    'Personal Information',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    decoration: BoxDecoration(
                      // color: isDarkMode
                      //     ? theme.colorScheme.surface
                      //     : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDarkMode
                            ? theme.colorScheme.onSurface.withOpacity(0.1)
                            : theme.colorScheme.onSurface.withOpacity(0.1),
                        width: 1.5,
                      ),
                    ),
                    child: Card(
                      elevation: 0,
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(16),
                      // ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              CupertinoIcons.person_fill,
                              'Full Name',
                              user?.fullName ?? 'Not set',
                            ),
                            _buildInfoRow(
                              CupertinoIcons.mail_solid,
                              'Email',
                              user?.email ?? 'Not set',
                            ),
                            _buildInfoRow(
                              CupertinoIcons.phone_fill,
                              'Phone',
                              user?.phoneNumber ?? 'Not set',
                            ),
                            _buildInfoRow(
                              CupertinoIcons.location_solid,
                              'Address',
                              user?.address ?? 'Not set',
                            ),
                            _buildInfoRow(
                              CupertinoIcons.calendar_badge_plus,
                              'Birthdate',
                              user?.birthdate != null
                                  ? '${user!.birthdate!.day}/${user.birthdate!.month}/${user.birthdate!.year}'
                                  : 'Not set',
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  context.pushNamed('editProfile');
                                },
                                icon: const Icon(CupertinoIcons.pencil),
                                label: const Text('Edit Profile'),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Check if the user's role is "Trainer"
                  if (profileProvider.user?.role == "Trainer") ...[
                    Text(
                      'Trainer Tools',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildToolCard(
                            context,
                            CupertinoIcons.flame_fill,
                            'Manage Workouts',
                            'Create and manage your workout routines',
                            () => context.pushNamed('manageWorkouts'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildToolCard(
                            context,
                            FontAwesomeIcons.carrot,
                            'Manage Diet Plans',
                            'Manage your diet and meal plans',
                            () => context.pushNamed('manageDietPlans'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildToolCard(
                            context,
                            CupertinoIcons.waveform_path,
                            'Manage Exercises',
                            'Create custom exercises',
                            () => context.pushNamed('manageExercise'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildToolCard(
                            context,
                            CupertinoIcons.chart_bar_fill,
                            'Create Supported Exercise',
                            'create exercise which can be logged',
                            () {
                              context.pushNamed('createSupportedExercise',
                                  extra:
                                      profileProvider.user?.userId.toString());
                            },
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 24),

                  //

                  Text(
                    'App Settings',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    decoration: BoxDecoration(
                      // color: isDarkMode
                      //     ? theme.colorScheme.surface
                      //     : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDarkMode
                            ? theme.colorScheme.onSurface.withOpacity(0.1)
                            : theme.colorScheme.onSurface.withOpacity(0.1),
                        width: 1.5,
                      ),
                    ),
                    child: Card(
                      elevation: 0,
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(16),
                      // ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildSwitchTile(
                              CupertinoIcons.bell_fill,
                              'Workout Reminders',
                              _workoutReminders,
                              (value) {
                                setState(() {
                                  _workoutReminders = value;
                                });
                              },
                            ),
                            _buildSwitchTile(
                              CupertinoIcons.mail_solid,
                              'Email Notifications',
                              _emailNotifications,
                              (value) {
                                setState(() {
                                  _emailNotifications = value;
                                });
                              },
                            ),
                            _buildSwitchTile(
                              CupertinoIcons.app_badge_fill,
                              'Push Notifications',
                              _pushNotifications,
                              (value) {
                                setState(() {
                                  _pushNotifications = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Security Section
                  Text(
                    'Security',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    decoration: BoxDecoration(
                      // color: isDarkMode
                      //     ? theme.colorScheme.surface
                      //     : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDarkMode
                            ? theme.colorScheme.onSurface.withOpacity(0.1)
                            : theme.colorScheme.onSurface.withOpacity(0.1),
                        width: 1.5,
                      ),
                    ),
                    child: Card(
                      elevation: 0,
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(16),
                      // ),
                      child: Column(
                        children: [
                          _buildActionTile(
                            context,
                            CupertinoIcons.lock_fill,
                            'Reset Password',
                            'Update your account password',
                            () {
                              // Handle change password action

                              context.pushNamed('forgotPassword');
                            },
                          ),
                          _buildActionTile(
                            context,
                            CupertinoIcons.shield_fill,
                            'Privacy Settings',
                            'Manage your data and privacy',
                            () {
                              // Handle privacy settings action
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Support Section
                  Text(
                    'Support',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    decoration: BoxDecoration(
                      // color: isDarkMode
                      //     ? theme.colorScheme.surface
                      //     : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDarkMode
                            ? theme.colorScheme.onSurface.withOpacity(0.1)
                            : theme.colorScheme.onSurface.withOpacity(0.1),
                        width: 1.5,
                      ),
                    ),
                    child: Card(
                      elevation: 0,
                      child: Column(
                        children: [
                          _buildActionTile(
                            context,
                            CupertinoIcons.question_circle_fill,
                            'Help & FAQs',
                            'Get answers to common questions',
                            () {
                              // Navigate to FAQs
                            },
                          ),
                          _buildActionTile(
                            context,
                            CupertinoIcons.chat_bubble_text_fill,
                            'Contact Support',
                            'Reach out to our support team',
                            () {
                              // Navigate to contact form
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
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Account Actions Section
                  Container(
                    decoration: BoxDecoration(
                      // color: isDarkMode
                      //     ? theme.colorScheme.surface
                      //     : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDarkMode
                            ? theme.colorScheme.onSurface.withOpacity(0.1)
                            : theme.colorScheme.onSurface.withOpacity(0.1),
                        width: 1.5,
                      ),
                    ),
                    child: Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 32, top: 12),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              CupertinoIcons.arrow_right_square_fill,
                              color: theme.colorScheme.primary,
                            ),
                            title: Text(
                              'Log Out',
                              style: theme.textTheme.bodyLarge,
                            ),
                            trailing: const Icon(CupertinoIcons.forward),
                            onTap: () => _logout(context),
                          ),
                          ListTile(
                            leading: Icon(
                              CupertinoIcons.delete_solid,
                              color: theme.colorScheme.error,
                            ),
                            title: Text(
                              'Delete Account',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.error,
                              ),
                            ),
                            trailing: const Icon(CupertinoIcons.forward),
                            onTap: () {
                              // Handle account deletion
                              showCupertinoDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: const Text('Delete Account'),
                                      content: const Text(
                                          'This action cannot be undone. Are you sure you want to permanently delete your account?'),
                                      actions: [
                                        CupertinoDialogAction(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          isDefaultAction: true,
                                          child: const Text('Cancel'),
                                        ),
                                        CupertinoDialogAction(
                                          onPressed: () {
                                            // Handle account deletion
                                            Navigator.pop(context);
                                          },
                                          isDestructiveAction: true,
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    );
                                  });
                            },
                          ),
                        ],
                      ),
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 22,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
      IconData icon, String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
          size: 24,
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
      trailing: const Icon(CupertinoIcons.forward),
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
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
