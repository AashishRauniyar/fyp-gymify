import 'package:flutter/material.dart';
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
  final String _selectedActivityLevel = 'Athlete';

  Future<void> _logout(BuildContext context) async {
    try {
      // Show a dialog to confirm logout
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    final authProvider =
                        Provider.of<AuthProvider>(context, listen: false);

                    // Disconnect socket connection
                    final socketService =
                        Provider.of<ChatProvider>(context, listen: false);
                    socketService.handleLogout();
                    await authProvider.logout();
                    if (context.mounted) {
                      context.go('/welcome');
                    }
                  },
                  child: const Text('Logout'),
                ),
              ],
            );
          });
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logout failed. Please try again.')),
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
      profileProvider.fetchProfile(); // Fetch profile data on page load
      final membershipProvider =
          Provider.of<MembershipProvider>(context, listen: false);
      membershipProvider.fetchMembershipStatus(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileProvider = Provider.of<ProfileProvider>(context);

    if (profileProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CustomLoadingAnimation()),
      );
    }

    if (profileProvider.hasError) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Text('Profile Settings', style: theme.textTheme.headlineSmall),
          backgroundColor: theme.colorScheme.surface,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error: ${profileProvider.errorMessage}',
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: theme.colorScheme.error),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => profileProvider.fetchProfile(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final user = profileProvider.user;

    if (user != null) {
      // Populate controllers if profile data exists
      _fullNameController.text = user.fullName ?? '';
      _emailController.text = user.email ?? '';
      _phoneController.text = user.phoneNumber ?? '';
    }

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Profile Settings",
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Profile Section
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: user?.profileImage != null
                            ? NetworkImage(user!.profileImage!)
                            : const NetworkImage(
                                'https://via.placeholder.com/150'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user?.fullName ?? 'No Name',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    user?.email ?? 'No Email',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Personal Info Section
            Text('Personal Information', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.onSurface.withOpacity(0.2),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,

                  spacing: 10,
                  children: [
                    // for full name
                    Row(
                      children: [
                        Icon(Icons.person, color: theme.colorScheme.primary),
                        const SizedBox(width: 10),
                        Text(
                          user?.fullName ?? 'No Name',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    // for email
                    Row(
                      children: [
                        Icon(Icons.email, color: theme.colorScheme.primary),
                        const SizedBox(width: 10),
                        Text(
                          user?.email ?? 'No Email',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.phone, color: theme.colorScheme.primary),
                        const SizedBox(width: 10),
                        Text(
                          user?.phoneNumber ?? 'No Phone Number',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    // for address
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            color: theme.colorScheme.primary),
                        const SizedBox(width: 10),
                        Text(
                          user?.address ?? 'No Address',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    // for birthdate
                    Row(
                      children: [
                        Icon(Icons.cake, color: theme.colorScheme.primary),
                        const SizedBox(width: 10),
                        Text(
                          user?.birthdate?.toString() ?? 'No Birthdate',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    // for card number
                    Row(
                      children: [
                        Icon(Icons.credit_card,
                            color: theme.colorScheme.primary),
                        const SizedBox(width: 10),
                        Text(
                          user?.cardNumber ?? 'No Card Number',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),

                    // button to go to edit profile
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            context.pushNamed('editProfile');
                          },
                          child: const Text('Edit Profile'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Subscriptions Section
            Text('Gym Subscriptions', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 10),

            Consumer<MembershipProvider>(
              builder: (context, membershipProvider, child) {
                final membershipStatus = membershipProvider.membership;
                // final currentPlan = membershipStatus != null &&
                //         membershipStatus['status'] != null
                //     ? membershipStatus['status']
                //     : 'Not Applied';
                final currentPlan = membershipStatus != null
                    ? membershipStatus.status ?? 'Not Applied'
                    : 'Not Applied';

                return ListTile(
                  title: Text(
                    'Mebership Status: $currentPlan',
                    style: theme.textTheme.bodyLarge,
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      context.pushNamed('membershipPlans');
                    },
                    child: const Text('Manage'),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Preferences Section
            Text('Preferences', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 10),
            _buildSwitchTile(context, 'Workout Reminders', true),
            _buildSwitchTile(context, 'Email Notifications', false),
            _buildSwitchTile(context, 'Push Notifications', true),
            const SizedBox(height: 20),

            // Security Section
            Text('Security', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.lock, color: theme.colorScheme.primary),
              title: Text('Change Password',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle change password
              },
            ),

            ListTile(
              leading: Icon(Icons.circle, color: theme.colorScheme.primary),
              title: Text('Create Workout',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                context.pushNamed('createWorkout');
              },
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.circle, color: theme.colorScheme.primary),
              title: Text('Create Exercise',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                context.pushNamed('createExercise');
              },
            ),
            ListTile(
              leading: Icon(Icons.circle, color: theme.colorScheme.primary),
              title: Text('Create Diet Plan',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                context.pushNamed('createDietPlan');
              },
            ),
            // list tile to create meals
            ListTile(
              leading: Icon(Icons.circle, color: theme.colorScheme.primary),
              title: Text('Create Meal',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                context.pushNamed('createMealPlan');
              },
            ),
            ListTile(
              leading: Icon(Icons.circle, color: theme.colorScheme.primary),
              title: Text('Manage Diet Plan',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                context.pushNamed('manageDietPlans');
              },
            ),

            // Support Section
            Text('Support', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.help, color: theme.colorScheme.primary),
              title: Text('FAQs',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to FAQs
              },
            ),
            ListTile(
              leading: Icon(Icons.feedback, color: theme.colorScheme.primary),
              title: Text('Feedback',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to feedback form
              },
            ),

            const SizedBox(height: 20),

            // Logout and Account Management Section
            ListTile(
              leading: Icon(Icons.logout, color: theme.colorScheme.error),
              title: Text('Log Out',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.bold,
                  )),
              onTap: () {
                // Handle logout
                _logout(context);
              },
            ),

            ListTile(
              leading:
                  Icon(Icons.delete_forever, color: theme.colorScheme.error),
              title: Text('Delete Account',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.bold,
                  )),
              onTap: () {
                // Handle account deletion
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      BuildContext context, String label, TextEditingController controller) {
    final theme = Theme.of(context);
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: theme.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      controller: controller,
    );
  }

  Widget _buildDropdownField(
      BuildContext context,
      String label,
      List<String> items,
      String? selectedItem,
      ValueChanged<String?> onChanged) {
    final theme = Theme.of(context);
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: theme.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      value: selectedItem,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item, style: theme.textTheme.bodyMedium),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildSwitchTile(BuildContext context, String title, bool value) {
    final theme = Theme.of(context);
    return SwitchListTile(
      title: Text(title, style: theme.textTheme.bodyLarge),
      value: value,
      activeColor: theme.colorScheme.primary,
      onChanged: (bool newValue) {
        // Handle switch toggle
      },
    );
  }
}
