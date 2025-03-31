// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:gymify/providers/auth_provider/auth_provider.dart';
// import 'package:gymify/providers/chat_provider/chat_service.dart';
// import 'package:gymify/providers/membership_provider/membership_provider.dart';
// import 'package:gymify/providers/profile_provider/profile_provider.dart';
// import 'package:gymify/utils/custom_appbar.dart';
// import 'package:gymify/utils/custom_loader.dart';
// import 'package:provider/provider.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final TextEditingController _fullNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();

//   Future<void> _logout(BuildContext context) async {
//     try {
//       // Show a dialog to confirm logout
//       showDialog(
//           context: context,
//           builder: (context) {
//             return AlertDialog(
//               title: const Text('Logout'),
//               content: const Text('Are you sure you want to logout?'),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text('Cancel'),
//                 ),
//                 TextButton(
//                   onPressed: () async {
//                     final authProvider =
//                         Provider.of<AuthProvider>(context, listen: false);

//                     // Disconnect socket connection
//                     final socketService =
//                         Provider.of<ChatProvider>(context, listen: false);
//                     socketService.handleLogout();
//                     await authProvider.logout();
//                     if (context.mounted) {
//                       context.go('/welcome');
//                     }
//                   },
//                   child: const Text('Logout'),
//                 ),
//               ],
//             );
//           });
//     } catch (e) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Logout failed. Please try again.')),
//         );
//       }
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final profileProvider =
//           Provider.of<ProfileProvider>(context, listen: false);
//       profileProvider.fetchProfile(); // Fetch profile data on page load
//       final membershipProvider =
//           Provider.of<MembershipProvider>(context, listen: false);
//       membershipProvider.fetchMembershipStatus(context);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final profileProvider = Provider.of<ProfileProvider>(context);

//     if (profileProvider.isLoading) {
//       return const Scaffold(
//         body: Center(child: CustomLoadingAnimation()),
//       );
//     }

//     if (profileProvider.hasError) {
//       return Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           elevation: 0,
//           title: Text('Profile Settings', style: theme.textTheme.headlineSmall),
//           backgroundColor: theme.colorScheme.surface,
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Error: ${profileProvider.errorMessage}',
//                 style: theme.textTheme.bodyLarge
//                     ?.copyWith(color: theme.colorScheme.error),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () => profileProvider.fetchProfile(),
//                 child: const Text('Retry'),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     final user = profileProvider.user;

//     if (user != null) {
//       // Populate controllers if profile data exists
//       _fullNameController.text = user.fullName ?? '';
//       _emailController.text = user.email ?? '';
//       _phoneController.text = user.phoneNumber ?? '';
//     }

//     return Scaffold(
//       appBar: const CustomAppBar(
//         title: "Profile Settings",
//         showBackButton: false,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),

//             // Profile Section
//             Center(
//               child: Column(
//                 children: [
//                   Stack(
//                     children: [
//                       CircleAvatar(
//                         radius: 50,
//                         backgroundImage: user?.profileImage != null
//                             ? NetworkImage(user!.profileImage!)
//                             : const NetworkImage(
//                                 'https://via.placeholder.com/150'),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     user?.fullName ?? 'No Name',
//                     style: theme.textTheme.headlineSmall,
//                   ),
//                   const SizedBox(height: 5),
//                   Text(
//                     user?.email ?? 'No Email',
//                     style: theme.textTheme.bodyMedium?.copyWith(
//                       color: theme.colorScheme.onSurface.withOpacity(0.6),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 30),

//             // Personal Info Section
//             Text('Personal Information', style: theme.textTheme.headlineSmall),
//             const SizedBox(height: 10),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: theme.colorScheme.surface,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(
//                   color: theme.colorScheme.onSurface.withOpacity(0.2),
//                 ),
//               ),
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
//                 child: Column(
//                   // mainAxisAlignment: MainAxisAlignment.spaceAround,

//                   spacing: 10,
//                   children: [
//                     // for full name
//                     Row(
//                       children: [
//                         Icon(Icons.person, color: theme.colorScheme.primary),
//                         const SizedBox(width: 10),
//                         Text(
//                           user?.fullName ?? 'No Name',
//                           style: theme.textTheme.bodyLarge,
//                         ),
//                       ],
//                     ),
//                     // for email
//                     Row(
//                       children: [
//                         Icon(Icons.email, color: theme.colorScheme.primary),
//                         const SizedBox(width: 10),
//                         Text(
//                           user?.email ?? 'No Email',
//                           style: theme.textTheme.bodyLarge,
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Icon(Icons.phone, color: theme.colorScheme.primary),
//                         const SizedBox(width: 10),
//                         Text(
//                           user?.phoneNumber ?? 'No Phone Number',
//                           style: theme.textTheme.bodyLarge,
//                         ),
//                       ],
//                     ),
//                     // for address
//                     Row(
//                       children: [
//                         Icon(Icons.location_on,
//                             color: theme.colorScheme.primary),
//                         const SizedBox(width: 10),
//                         Text(
//                           user?.address ?? 'No Address',
//                           style: theme.textTheme.bodyLarge,
//                         ),
//                       ],
//                     ),
//                     // for birthdate
//                     Row(
//                       children: [
//                         Icon(Icons.cake, color: theme.colorScheme.primary),
//                         const SizedBox(width: 10),
//                         Text(
//                           user?.birthdate?.toString() ?? 'No Birthdate',
//                           style: theme.textTheme.bodyLarge,
//                         ),
//                       ],
//                     ),
//                     // for card number
//                     Row(
//                       children: [
//                         Icon(Icons.credit_card,
//                             color: theme.colorScheme.primary),
//                         const SizedBox(width: 10),
//                         Text(
//                           user?.cardNumber ?? 'No Card Number',
//                           style: theme.textTheme.bodyLarge,
//                         ),
//                       ],
//                     ),

//                     // button to go to edit profile
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             context.pushNamed('editProfile');
//                           },
//                           child: const Text('Edit Profile'),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // Subscriptions Section
//             Text('Gym Subscriptions', style: theme.textTheme.headlineSmall),
//             const SizedBox(height: 10),

//             Consumer<MembershipProvider>(
//               builder: (context, membershipProvider, child) {
//                 final membershipStatus = membershipProvider.membership;
//                 // final currentPlan = membershipStatus != null &&
//                 //         membershipStatus['status'] != null
//                 //     ? membershipStatus['status']
//                 //     : 'Not Applied';
//                 final currentPlan = membershipStatus != null
//                     ? membershipStatus.status ?? 'Not Applied'
//                     : 'Not Applied';

//                 return ListTile(
//                   title: Text(
//                     'Mebership Status: $currentPlan',
//                     style: theme.textTheme.bodyLarge,
//                   ),
//                   trailing: ElevatedButton(
//                     onPressed: () {
//                       context.pushNamed('membershipPlans');
//                     },
//                     child: const Text('Manage'),
//                   ),
//                 );
//               },
//             ),

//             const SizedBox(height: 20),

//             // Preferences Section
//             Text('Preferences', style: theme.textTheme.headlineSmall),
//             const SizedBox(height: 10),
//             _buildSwitchTile(context, 'Workout Reminders', true),
//             _buildSwitchTile(context, 'Email Notifications', false),
//             _buildSwitchTile(context, 'Push Notifications', true),
//             const SizedBox(height: 20),

//             // Security Section
//             Text('Security', style: theme.textTheme.headlineSmall),
//             const SizedBox(height: 10),
//             ListTile(
//               leading: Icon(Icons.lock, color: theme.colorScheme.primary),
//               title: Text('Change Password',
//                   style: theme.textTheme.bodyLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   )),
//               trailing: const Icon(Icons.arrow_forward_ios),
//               onTap: () {
//                 // Handle change password
//               },
//             ),

//             ListTile(
//               leading: Icon(Icons.circle, color: theme.colorScheme.primary),
//               title: Text('Create Workout',
//                   style: theme.textTheme.bodyLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   )),
//               trailing: const Icon(Icons.arrow_forward_ios),
//               onTap: () {
//                 context.pushNamed('createWorkout');
//               },
//             ),
//             const SizedBox(height: 20),
//             ListTile(
//               leading: Icon(Icons.circle, color: theme.colorScheme.primary),
//               title: Text('Create Exercise',
//                   style: theme.textTheme.bodyLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   )),
//               trailing: const Icon(Icons.arrow_forward_ios),
//               onTap: () {
//                 context.pushNamed('createExercise');
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.circle, color: theme.colorScheme.primary),
//               title: Text('Create Diet Plan',
//                   style: theme.textTheme.bodyLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   )),
//               trailing: const Icon(Icons.arrow_forward_ios),
//               onTap: () {
//                 context.pushNamed('createDietPlan');
//               },
//             ),
//             // list tile to create meals
//             ListTile(
//               leading: Icon(Icons.circle, color: theme.colorScheme.primary),
//               title: Text('Create Meal',
//                   style: theme.textTheme.bodyLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   )),
//               trailing: const Icon(Icons.arrow_forward_ios),
//               onTap: () {
//                 context.pushNamed('createMealPlan');
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.circle, color: theme.colorScheme.primary),
//               title: Text('Manage Diet Plan',
//                   style: theme.textTheme.bodyLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   )),
//               trailing: const Icon(Icons.arrow_forward_ios),
//               onTap: () {
//                 context.pushNamed('manageDietPlans');
//               },
//             ),

//             // Support Section
//             Text('Support', style: theme.textTheme.headlineSmall),
//             const SizedBox(height: 10),
//             ListTile(
//               leading: Icon(Icons.help, color: theme.colorScheme.primary),
//               title: Text('FAQs',
//                   style: theme.textTheme.bodyLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   )),
//               trailing: const Icon(Icons.arrow_forward_ios),
//               onTap: () {
//                 // Navigate to FAQs
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.feedback, color: theme.colorScheme.primary),
//               title: Text('Feedback',
//                   style: theme.textTheme.bodyLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   )),
//               trailing: const Icon(Icons.arrow_forward_ios),
//               onTap: () {
//                 // Navigate to feedback form
//               },
//             ),

//             const SizedBox(height: 20),

//             // Logout and Account Management Section
//             ListTile(
//               leading: Icon(Icons.logout, color: theme.colorScheme.error),
//               title: Text('Log Out',
//                   style: theme.textTheme.bodyLarge?.copyWith(
//                     color: theme.colorScheme.error,
//                     fontWeight: FontWeight.bold,
//                   )),
//               onTap: () {
//                 // Handle logout
//                 _logout(context);
//               },
//             ),

//             ListTile(
//               leading:
//                   Icon(Icons.delete_forever, color: theme.colorScheme.error),
//               title: Text('Delete Account',
//                   style: theme.textTheme.bodyLarge?.copyWith(
//                     color: theme.colorScheme.error,
//                     fontWeight: FontWeight.bold,
//                   )),
//               onTap: () {
//                 // Handle account deletion
//               },
//             ),

//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSwitchTile(BuildContext context, String title, bool value) {
//     final theme = Theme.of(context);
//     return SwitchListTile(
//       title: Text(title, style: theme.textTheme.bodyLarge),
//       value: value,
//       activeColor: theme.colorScheme.primary,
//       onChanged: (bool newValue) {
//         // Handle switch toggle
//       },
//     );
//   }
// }

// App Settings Section

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
            expandedHeight: 210.0,
            floating: false,
            pinned: true,
            backgroundColor: theme.colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'My Profile',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.primary.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Column(
                        children: [
                          Hero(
                            tag: 'profile-image',
                            child: CircleAvatar(
                              radius: 45,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 42,
                                backgroundImage: user?.profileImage != null
                                    ? NetworkImage(user!.profileImage!)
                                    : const AssetImage(
                                            'assets/images/default_profile.png')
                                        as ImageProvider,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            user?.fullName ?? 'Fitness Enthusiast',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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

                  // Fitness Tools Section
                  // Text(
                  //   'Fitness Tools',
                  //   style: theme.textTheme.titleLarge?.copyWith(
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // const SizedBox(height: 16),

                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: _buildToolCard(
                  //         context,
                  //         CupertinoIcons.flame_fill,
                  //         'Workouts',
                  //         'Create and manage your workout routines',
                  //         () => context.pushNamed('createWorkout'),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 16),
                  //     Expanded(
                  //       child: _buildToolCard(
                  //         context,
                  //         CupertinoIcons.shopping_cart,
                  //         'Nutrition',
                  //         'Manage your diet and meal plans',
                  //         () => context.pushNamed('manageDietPlans'),
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  // const SizedBox(height: 16),

                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: _buildToolCard(
                  //         context,
                  //         CupertinoIcons.waveform_path,
                  //         'Exercises',
                  //         'Create custom exercises',
                  //         () => context.pushNamed('createExercise'),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 16),
                  //     Expanded(
                  //       child: _buildToolCard(
                  //         context,
                  //         CupertinoIcons.chart_bar_fill,
                  //         'Progress',
                  //         'Track your fitness journey',
                  //         () {
                  //           context.pushNamed('workoutHistory',
                  //               extra: profileProvider.user?.userId.toString());
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  // Check if the user's role is "Trainer"
                  if (profileProvider.user?.role == "Trainer") ...[
                    Text(
                      'Trainer Tools',
                      style: theme.textTheme.titleLarge?.copyWith(
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
                            'Workouts',
                            'Create and manage your workout routines',
                            () => context.pushNamed('createWorkout'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildToolCard(
                            context,
                            CupertinoIcons.shopping_cart,
                            'Nutrition',
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
                            'Exercises',
                            'Create custom exercises',
                            () => context.pushNamed('createExercise'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildToolCard(
                            context,
                            CupertinoIcons.chart_bar_fill,
                            'Progress',
                            'Track your fitness journey',
                            () {
                              context.pushNamed('workoutHistory',
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
                              style: theme.textTheme.titleMedium?.copyWith(
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
