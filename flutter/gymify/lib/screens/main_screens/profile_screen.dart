//! working code do not delete
// import 'package:flutter/material.dart';
// import 'package:gymify/providers/auth_provider/auth_provider.dart';
// import 'package:gymify/screens/main_screens/workout_history_screens/workout_history_screen.dart';

// import 'package:provider/provider.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:gymify/colors/custom_colors.dart';
// import 'package:go_router/go_router.dart'; // For navigation

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   Future<void> _logout(BuildContext context) async {
//     try {
//       // Notify the AuthProvider to logout the user
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       await authProvider.logout();

//       // Navigate to the welcome screen after logout
//       context.go('/welcome');
//     } catch (e) {
//       // Handle any errors that occur during logout
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Logout failed. Please try again.')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = context.read<AuthProvider>();
//     final userId = authProvider.userId ?? 'No user ID';
//     final role = authProvider.role ?? 'No role assigned';

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Profile',
//           style: GoogleFonts.poppins(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: CustomColors.primary,
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.exit_to_app),
//             onPressed: () =>
//                 _logout(context), // Logout when the button is pressed
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Profile Information
//             Text(
//               "Profile Information",
//               style: GoogleFonts.poppins(
//                   fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             Text("User ID: $userId", style: GoogleFonts.poppins(fontSize: 16)),
//             Text("Role: $role", style: GoogleFonts.poppins(fontSize: 16)),
//             const SizedBox(height: 24),

//             // Workout History Tile
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => WorkoutHistoryScreen(userId: userId),
//                   ),
//                 );
//               },
//               child: Container(
//                 padding: const EdgeInsets.all(16.0),
//                 decoration: BoxDecoration(
//                   color: CustomColors.primaryShade2,
//                   borderRadius: BorderRadius.circular(12),
//                   gradient: LinearGradient(
//                     colors: [
//                       CustomColors.primaryShade2.withOpacity(0.8),
//                       CustomColors.primary.withOpacity(0.9),
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       blurRadius: 10,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         const Icon(Icons.history,
//                             color: Colors.white, size: 28),
//                         const SizedBox(width: 12),
//                         Text(
//                           "Workout History",
//                           style: GoogleFonts.poppins(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Icon(Icons.arrow_forward_ios,
//                         size: 18, color: Colors.white),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             // Exercises Card
//             InkWell(
//               onTap: () {
//                 context.pushNamed('exercises');
//               },
//               borderRadius: BorderRadius.circular(12),
//               child: Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 color: CustomColors.primaryShade2,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 16.0, horizontal: 12.0),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.fitness_center,
//                           size: 28, color: Colors.white),
//                       const SizedBox(width: 12),
//                       Text(
//                         'View Exercises',
//                         style: GoogleFonts.poppins(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Create Exercise Card
//             InkWell(
//               onTap: () {
//                 context.push('/createExercise');
//               },
//               borderRadius: BorderRadius.circular(12),
//               child: Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 color: CustomColors.primaryCompliment,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 16.0, horizontal: 12.0),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.add_circle_outline,
//                           size: 28, color: Colors.white),
//                       const SizedBox(width: 12),
//                       Text(
//                         'Create Exercise',
//                         style: GoogleFonts.poppins(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Create Workout Link
//             InkWell(
//               onTap: () {
//                 context.push('/createWorkout');
//               },
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.workspaces_outline,
//                       size: 24, color: Colors.blue),
//                   const SizedBox(width: 6),
//                   Text(
//                     "Create Workout",
//                     style: GoogleFonts.poppins(
//                       fontSize: 18,
//                       color: Colors.blue,
//                       decoration: TextDecoration.underline,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Logout Button
//             Center(
//               child: ElevatedButton.icon(
//                 onPressed: () => _logout(context),
//                 icon: const Icon(Icons.logout),
//                 label: const Text("Logout"),
//                 style: ElevatedButton.styleFrom(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//                   backgroundColor: Colors.redAccent,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   textStyle: GoogleFonts.poppins(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//!----------------------------------

// import 'package:flutter/material.dart';
// import 'package:gymify/providers/auth_provider/auth_provider.dart';
// import 'package:gymify/providers/profile_provider/profile_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:gymify/colors/custom_colors.dart';
// import 'package:go_router/go_router.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   Future<void> _logout(BuildContext context) async {
//     try {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       await authProvider.logout();
//       context.go('/welcome');
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Logout failed. Please try again.')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => ProfileProvider()..fetchProfile(),
//       child: Consumer<ProfileProvider>(
//         builder: (context, profileProvider, child) {
//           if (profileProvider.isLoading) {
//             return const Center(child: CustomLoadingAnimation());
//           }

//           if (profileProvider.hasError || profileProvider.user == null) {
//             return const Center(child: Text('Error loading profile.'));
//           }

//           final user = profileProvider.user!;

//           return Scaffold(
//             appBar: AppBar(
//               title: Text(
//                 'Profile',
//                 style: GoogleFonts.poppins(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               backgroundColor: CustomColors.primary,
//               centerTitle: true,
//               actions: [
//                 IconButton(
//                   icon: const Icon(Icons.exit_to_app),
//                   onPressed: () => _logout(context),
//                 ),
//               ],
//             ),
//             body: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   // Profile Header
//                   Center(
//                     child: Column(
//                       children: [
//                         CircleAvatar(
//                           radius: 50,
//                           backgroundImage: NetworkImage(user.profileImage),
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           user.fullName,
//                           style: GoogleFonts.poppins(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: CustomColors.primary,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           user.email,
//                           style: GoogleFonts.poppins(
//                             fontSize: 16,
//                             color: CustomColors.lightText,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 24),

//                   // User Details
//                   Expanded(
//                     child: ListView(
//                       children: [
//                         _buildDetailRow('Phone Number', user.phoneNumber),
//                         _buildDetailRow('Address', user.address),
//                         _buildDetailRow('Height', '${user.height} cm'),
//                         _buildDetailRow(
//                             'Current Weight', '${user.currentWeight} kg'),
//                         _buildDetailRow('Fitness Level', user.fitnessLevel),
//                         _buildDetailRow('Goal Type', user.goalType),
//                         _buildDetailRow('Allergies', user.allergies),
//                         _buildDetailRow('Gender', user.gender),
//                         const SizedBox(height: 16),
//                         // Actions
//                         _buildActionCard(
//                           context,
//                           title: 'Workout History',
//                           icon: Icons.history,
//                           onTap: () => context.push('/workoutHistory',
//                               extra: user.userId),
//                         ),
//                         _buildActionCard(
//                           context,
//                           title: 'View Exercises',
//                           icon: Icons.fitness_center,
//                           onTap: () => context.pushNamed('exercises'),
//                         ),
//                         _buildActionCard(
//                           context,
//                           title: 'Create Exercise',
//                           icon: Icons.add_circle_outline,
//                           onTap: () => context.push('/createExercise'),
//                         ),
//                         _buildActionCard(
//                           context,
//                           title: 'Create Workout',
//                           icon: Icons.workspaces_outline,
//                           onTap: () => context.push('/createWorkout'),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Logout Button
//                   Center(
//                     child: ElevatedButton.icon(
//                       onPressed: () => _logout(context),
//                       icon: const Icon(Icons.logout),
//                       label: const Text("Logout"),
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 12, horizontal: 24),
//                         backgroundColor: Colors.redAccent,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         textStyle: GoogleFonts.poppins(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Text(
//             '$label:',
//             style: GoogleFonts.poppins(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: CustomColors.primary,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               value,
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//                 color: CustomColors.lightText,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionCard(BuildContext context,
//       {required String title,
//       required IconData icon,
//       required VoidCallback onTap}) {
//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             children: [
//               Icon(icon, size: 28, color: CustomColors.primary),
//               const SizedBox(width: 12),
//               Text(
//                 title,
//                 style: GoogleFonts.poppins(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: CustomColors.primary,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

//!workingg
// import 'package:flutter/material.dart';
// import 'package:gymify/providers/auth_provider/auth_provider.dart';
// import 'package:gymify/providers/profile_provider/profile_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:gymify/colors/custom_colors.dart';
// import 'package:go_router/go_router.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   Future<void> _logout(BuildContext context) async {
//     try {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       await authProvider.logout();
//       context.go('/welcome');
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Logout failed. Please try again.')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => ProfileProvider()
//         ..fetchProfile()
//         ..fetchWeightHistory(),
//       child: Consumer<ProfileProvider>(
//         builder: (context, profileProvider, child) {
//           if (profileProvider.isLoading) {
//             return const Center(child: CustomLoadingAnimation());
//           }

//           final userId =
//               profileProvider.user?.userId.toString() ?? 'No user ID';

//           if (profileProvider.hasError || profileProvider.user == null) {
//             return const Center(child: Text('Error loading profile.'));
//           }

//           final user = profileProvider.user!;
//           final weightHistory = profileProvider.weightHistory ?? [];

//           return Scaffold(
//             backgroundColor: CustomColors.backgroundColor,
//             appBar: AppBar(
//               scrolledUnderElevation: 0,
//               backgroundColor: CustomColors.backgroundColor,
//               title: const Text('Profile',
//                   style: TextStyle(color: CustomColors.secondary)),
//               actions: [
//                 IconButton(
//                   color: CustomColors.secondary,
//                   icon: const Icon(Icons.exit_to_app),
//                   onPressed: () => _logout(context),
//                 ),
//               ],
//             ),
//             body: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   // Profile Header
//                   Center(
//                     child: Column(
//                       children: [
//                         CircleAvatar(
//                           radius: 50,
//                           backgroundImage:
//                               NetworkImage(user.profileImage ?? ''),
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           user.fullName ?? '',
//                           style: GoogleFonts.montserrat(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: CustomColors.primary,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           user.email ?? '',
//                           style: GoogleFonts.montserrat(
//                             fontSize: 16,
//                             color: CustomColors.lightText,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 24),

//                   // User Details
//                   Expanded(
//                     child: ListView(
//                       children: [
//                         _buildDetailRow('Phone Number', user.phoneNumber ?? ''),
//                         _buildDetailRow('Address', user.address ?? ''),
//                         _buildDetailRow('Height', '${user.height} cm'),
//                         _buildDetailRow(
//                             'Current Weight', '${user.currentWeight} kg'),
//                         _buildDetailRow(
//                             'Fitness Level', user.fitnessLevel ?? ''),
//                         _buildDetailRow('Goal Type', user.goalType ?? ''),
//                         _buildDetailRow('Allergies', user.allergies ?? ''),
//                         const SizedBox(height: 16),

//                         // Edit Profile Button
//                         ElevatedButton.icon(
//                           onPressed: () {
//                             // Navigate to EditProfileScreen
//                             final user = Provider.of<ProfileProvider>(context,
//                                     listen: false)
//                                 .user!;
//                             context.push('/edit-profile',
//                                 extra: user); // Pass the user as extra
//                           },
//                           icon: const Icon(Icons.edit),
//                           label: const Text('Edit Profile'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: CustomColors.primary,
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 12, horizontal: 24),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 24),

//                         // Weight History Section
//                         const Text(
//                           'Weight History',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         weightHistory.isEmpty
//                             ? const Text('No weight history available.')
//                             : ListView.builder(
//                                 shrinkWrap: true,
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 itemCount: weightHistory.length,
//                                 itemBuilder: (context, index) {
//                                   final entry = weightHistory[index];
//                                   return ListTile(
//                                     title: Text('${entry.weight} kg'),
//                                     subtitle: Text(
//                                       'Logged on: ${entry.loggedAt.toLocal()}',
//                                     ),
//                                   );
//                                 },
//                               ),

//                         InkWell(
//                           onTap: () {
//                             context.pushNamed('exercises');
//                           },
//                           borderRadius: BorderRadius.circular(12),
//                           child: Card(
//                             elevation: 4,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             color: CustomColors.primaryShade2,
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 16.0, horizontal: 12.0),
//                               child: Row(
//                                 children: [
//                                   const Icon(Icons.fitness_center,
//                                       size: 28, color: Colors.white),
//                                   const SizedBox(width: 12),
//                                   Text(
//                                     'View Exercises',
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16),

//                         // Create Exercise Card
//                         InkWell(
//                           onTap: () {
//                             context.push('/createExercise');
//                           },
//                           borderRadius: BorderRadius.circular(12),
//                           child: Card(
//                             elevation: 4,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             color: CustomColors.primaryCompliment,
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 16.0, horizontal: 12.0),
//                               child: Row(
//                                 children: [
//                                   const Icon(Icons.add_circle_outline,
//                                       size: 28, color: Colors.white),
//                                   const SizedBox(width: 12),
//                                   Text(
//                                     'Create Exercise',
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         InkWell(
//                           onTap: () => context.pushNamed('workoutHistory',
//                               extra: userId),
//                           borderRadius: BorderRadius.circular(12),
//                           child: Card(
//                             elevation: 4,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             color: CustomColors.primaryCompliment,
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 16.0, horizontal: 12.0),
//                               child: Row(
//                                 children: [
//                                   const Icon(Icons.add_circle_outline,
//                                       size: 28, color: Colors.white),
//                                   const SizedBox(width: 12),
//                                   Text(
//                                     'Workout History',
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 16),
//                         // Create Workout Link
//                         InkWell(
//                           onTap: () {
//                             context.push('/createWorkout');
//                           },
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Icon(Icons.workspaces_outline,
//                                   size: 24, color: Colors.blue),
//                               const SizedBox(width: 6),
//                               Text(
//                                 "Create Workout",
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 18,
//                                   color: Colors.blue,
//                                   decoration: TextDecoration.underline,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Logout Button
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Text(
//             '$label:',
//             style: GoogleFonts.poppins(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: CustomColors.primary,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               value,
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//                 color: CustomColors.lightText,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/providers/auth_provider/auth_provider.dart';
import 'package:gymify/providers/chat_provider/chat_service.dart';
import 'package:gymify/providers/profile_provider/profile_provider.dart';
import 'package:gymify/providers/socket_provider/socket_service.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:provider/provider.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _selectedActivityLevel = 'Athlete';

  Future<void> _logout(BuildContext context) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Disconnect socket connection
      final socketService = Provider.of<ChatProvider>(context, listen: false);
      socketService.handleLogout();
      await authProvider.logout();
      if (context.mounted) {
        context.go('/welcome');
      }
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          // button for change theme
          IconButton(
            icon: const Icon(Icons.brightness_4),
            onPressed: () {},
          ),
        ],
        title: Text(
          'Profile Settings',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        centerTitle: true,
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
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white),
                            onPressed: () {
                              // Handle profile image edit
                            },
                          ),
                        ),
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
            _buildTextField(context, 'Full Name', _fullNameController),
            const SizedBox(height: 10),
            _buildTextField(context, 'Email', _emailController),
            const SizedBox(height: 10),
            _buildTextField(context, 'Phone Number', _phoneController),
            const SizedBox(height: 20),

            // Fitness Goals Section
            Text('Fitness Goals', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 10),
            _buildDropdownField(
              context,
              'Activity Level',
              ['Beginner', 'Intermediate', 'Advanced', 'Athlete'],
              _selectedActivityLevel,
              (value) => setState(() => _selectedActivityLevel = value),
            ),
            const SizedBox(height: 10),
            _buildTextField(context, 'Target Weight (kg)',
                TextEditingController(text: '70')), // Example
            const SizedBox(height: 20),

            // Subscriptions Section
            Text('Subscriptions', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 10),
            ListTile(
              title: Text('Current Plan: Premium',
                  style: theme.textTheme.bodyLarge),
              trailing: ElevatedButton(
                onPressed: () {
                  // Handle upgrade/cancel subscription
                },
                child: const Text('Manage'),
              ),
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
              leading: Icon(Icons.security, color: theme.colorScheme.primary),
              title: Text('Two-Factor Authentication',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle two-factor authentication
              },
            ),
            const SizedBox(height: 20),

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
