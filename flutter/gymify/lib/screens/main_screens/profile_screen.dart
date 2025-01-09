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
//             return const Center(child: CircularProgressIndicator());
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

import 'package:flutter/material.dart';
import 'package:gymify/providers/auth_provider/auth_provider.dart';
import 'package:gymify/providers/profile_provider/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymify/colors/custom_colors.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.logout();
      context.go('/welcome');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileProvider()
        ..fetchProfile()
        ..fetchWeightHistory(),
      child: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          if (profileProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final userId =
              profileProvider.user?.userId.toString() ?? 'No user ID';

          if (profileProvider.hasError || profileProvider.user == null) {
            return const Center(child: Text('Error loading profile.'));
          }

          final user = profileProvider.user!;
          final weightHistory = profileProvider.weightHistory ?? [];

          return Scaffold(
            backgroundColor: CustomColors.backgroundColor,
            appBar: AppBar(
              scrolledUnderElevation: 0,
              backgroundColor: CustomColors.backgroundColor,
              title: const Text('Profile',
                  style: TextStyle(color: CustomColors.secondary)),
              actions: [
                IconButton(
                  color: CustomColors.secondary,
                  icon: const Icon(Icons.exit_to_app),
                  onPressed: () => _logout(context),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Profile Header
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              NetworkImage(user.profileImage ?? ''),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.fullName ?? '',
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          user.email ?? '',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: CustomColors.lightText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // User Details
                  Expanded(
                    child: ListView(
                      children: [
                        _buildDetailRow('Phone Number', user.phoneNumber ?? ''),
                        _buildDetailRow('Address', user.address ?? ''),
                        _buildDetailRow('Height', '${user.height} cm'),
                        _buildDetailRow(
                            'Current Weight', '${user.currentWeight} kg'),
                        _buildDetailRow(
                            'Fitness Level', user.fitnessLevel ?? ''),
                        _buildDetailRow('Goal Type', user.goalType ?? ''),
                        _buildDetailRow('Allergies', user.allergies ?? ''),
                        const SizedBox(height: 16),

                        // Edit Profile Button
                        ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to EditProfileScreen
                            final user = Provider.of<ProfileProvider>(context,
                                    listen: false)
                                .user!;
                            context.push('/edit-profile',
                                extra: user); // Pass the user as extra
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit Profile'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Weight History Section
                        const Text(
                          'Weight History',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        weightHistory.isEmpty
                            ? const Text('No weight history available.')
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: weightHistory.length,
                                itemBuilder: (context, index) {
                                  final entry = weightHistory[index];
                                  return ListTile(
                                    title: Text('${entry.weight} kg'),
                                    subtitle: Text(
                                      'Logged on: ${entry.loggedAt.toLocal()}',
                                    ),
                                  );
                                },
                              ),

                        InkWell(
                          onTap: () {
                            context.pushNamed('exercises');
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: CustomColors.primaryShade2,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 12.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.fitness_center,
                                      size: 28, color: Colors.white),
                                  const SizedBox(width: 12),
                                  Text(
                                    'View Exercises',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Create Exercise Card
                        InkWell(
                          onTap: () {
                            context.push('/createExercise');
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: CustomColors.primaryCompliment,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 12.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.add_circle_outline,
                                      size: 28, color: Colors.white),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Create Exercise',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: () => context.pushNamed('workoutHistory',
                              extra: userId),
                          borderRadius: BorderRadius.circular(12),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: CustomColors.primaryCompliment,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 12.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.add_circle_outline,
                                      size: 28, color: Colors.white),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Workout History',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                        // Create Workout Link
                        InkWell(
                          onTap: () {
                            context.push('/createWorkout');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.workspaces_outline,
                                  size: 24, color: Colors.blue),
                              const SizedBox(width: 6),
                              Text(
                                "Create Workout",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Logout Button
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label:',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: CustomColors.primary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: CustomColors.lightText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
