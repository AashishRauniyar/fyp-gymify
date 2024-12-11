// import 'package:flutter/material.dart';
// import 'package:gymify/services/login_service.dart';
// import 'package:go_router/go_router.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final LoginService _loginService = LoginService();

//   // Logout function
//   Future<void> _logout() async {
//     // Clear the token (log the user out)
//     await _loginService.logout();

//     // After logout, navigate to the Welcome screen
//     context.go('/welcome');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.exit_to_app),
//             onPressed: _logout, // Call logout when the button is pressed
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               "This is the profile screen",
//               style: TextStyle(fontSize: 24),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _logout, // Logout button
//               child: const Text("Logout"),
//               style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:gymify/providers/auth_provider/auth_provider.dart';
import 'package:gymify/services/login_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart'; // If you're using a provider for Auth

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final LoginService _loginService = LoginService();

  // get user id and role
  late String userId;
  late String role;

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    userId = authProvider.userId ?? 'No user ID';
    role = authProvider.role ?? 'No role assigned';
  }

  // Logout function
  Future<void> _logout() async {
    try {
      // Clear the token (log the user out)
      await _loginService.logout();

      // Optionally, notify listeners in the AuthProvider (if you're using it)
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.logout();

      // After logout, navigate to the Welcome screen
      context.go('/welcome');
    } catch (e) {
      // Handle error (e.g., show a Snackbar or dialog)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _logout, // Call logout when the button is pressed
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "This is the profile screen",
              style: TextStyle(fontSize: 24),
            ),
            Column(
              children: [
                Text("User ID: $userId"),
                Text("Role: $role"),
                InkWell(
                  onTap: () {
                    // go to create workout screen
                    context.go('/createWorkout');
                  },
                  child: const Text(
                    "Create Workout",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logout, // Logout button
              child: const Text("Logout"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
