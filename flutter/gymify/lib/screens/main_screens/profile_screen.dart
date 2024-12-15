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

// import 'package:flutter/material.dart';
// import 'package:gymify/providers/auth_provider/auth_provider.dart';
// import 'package:gymify/services/login_service.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart'; // If you're using a provider for Auth

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final LoginService _loginService = LoginService();

//   // get user id and role
//   late String userId;
//   late String role;

//   @override
//   void initState() {
//     super.initState();
//     final authProvider = context.read<AuthProvider>();
//     userId = authProvider.userId ?? 'No user ID';
//     role = authProvider.role ?? 'No role assigned';
//   }

//   // Logout function
//   Future<void> _logout() async {
//     try {
//       // Clear the token (log the user out)
//       await _loginService.logout();

//       // Optionally, notify listeners in the AuthProvider (if you're using it)
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       await authProvider.logout();

//       // After logout, navigate to the Welcome screen
//       context.go('/welcome');
//     } catch (e) {
//       // Handle error (e.g., show a Snackbar or dialog)
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Logout failed. Please try again.')),
//       );
//     }
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
//             Column(
//               children: [
//                 Text("User ID: $userId"),
//                 Text("Role: $role"),

//               ],
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

// //? tryy
// import 'package:flutter/material.dart';
// import 'package:gymify/colors/custom_colors.dart';
// import 'package:gymify/providers/log_provider/log_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:gymify/providers/auth_provider/auth_provider.dart';

// import 'package:google_fonts/google_fonts.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   late String userId;
//   late String role;

//   @override
//   void initState() {
//     super.initState();
//     final authProvider = context.read<AuthProvider>();
//     userId = authProvider.userId ?? 'No user ID';
//     role = authProvider.role ?? 'No role assigned';

//     // Fetch logs for the user
//     context.read<WorkoutLogProvider>().fetchUserLogs(userId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final workoutLogProvider = context.watch<WorkoutLogProvider>();

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
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // User Information Section
//             Text(
//               "Profile Information",
//               style: GoogleFonts.poppins(
//                   fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             Text("User ID: $userId", style: GoogleFonts.poppins(fontSize: 16)),
//             Text("Role: $role", style: GoogleFonts.poppins(fontSize: 16)),
//             const SizedBox(height: 24),

//             // Logs Section
//             Text(
//               "Workout Logs",
//               style: GoogleFonts.poppins(
//                   fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),

//             // Logs List
//             Expanded(
//               child: workoutLogProvider.isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : workoutLogProvider.hasError
//                       ? const Center(
//                           child: Text(
//                             "Failed to fetch logs. Please try again.",
//                             style: TextStyle(color: Colors.red, fontSize: 16),
//                           ),
//                         )
//                       : workoutLogProvider.userLogs.isEmpty
//                           ? const Center(
//                               child: Text(
//                                 "No logs available.",
//                                 style: TextStyle(fontSize: 16),
//                               ),
//                             )
//                           : ListView.builder(
//                               itemCount: workoutLogProvider.userLogs.length,
//                               itemBuilder: (context, index) {
//                                 final log = workoutLogProvider.userLogs[index];
//                                 return WorkoutLogCard(log: log);
//                               },
//                             ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class WorkoutLogCard extends StatelessWidget {
//   final Map<String, dynamic> log;

//   const WorkoutLogCard({super.key, required this.log});

//   @override
//   Widget build(BuildContext context) {
//     final workoutDate = log['workout_date'] ?? 'N/A';
//     final totalDuration = log['total_duration'] ?? '0';
//     final caloriesBurned = log['calories_burned'] ?? '0';
//     final exercises = log['workoutexerciseslogs'] ?? [];

//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Workout Date and Stats
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Date: ${_formatDate(workoutDate)}",
//                   style: GoogleFonts.poppins(
//                       fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   "Duration: $totalDuration mins",
//                   style: GoogleFonts.poppins(
//                       fontSize: 14, color: Colors.grey[700]),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 4),
//             Text(
//               "Calories Burned: $caloriesBurned kcal",
//               style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
//             ),
//             const SizedBox(height: 16),

//             // Exercises Section
//             Text(
//               "Exercises:",
//               style: GoogleFonts.poppins(
//                   fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             ListView.builder(
//               itemCount: exercises.length,
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemBuilder: (context, index) {
//                 final exercise = exercises[index]['exercises'];
//                 return ExerciseTile(exercise: exercise);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String _formatDate(String date) {
//     final parsedDate = DateTime.parse(date);
//     return "${parsedDate.day}/${parsedDate.month}/${parsedDate.year}";
//   }
// }

// class ExerciseTile extends StatelessWidget {
//   final Map<String, dynamic> exercise;

//   const ExerciseTile({super.key, required this.exercise});

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       contentPadding: const EdgeInsets.all(8.0),
//       leading: CircleAvatar(
//         backgroundImage: NetworkImage(exercise['image_url']),
//         radius: 30,
//       ),
//       title: Text(
//         exercise['exercise_name'],
//         style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
//       ),
//       subtitle: Text(
//         exercise['description'],
//         style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
//       ),
//       trailing: IconButton(
//         icon: const Icon(Icons.play_circle_fill, color: Colors.blue),
//         onPressed: () {
//           // Play Exercise Video
//           _playVideo(context, exercise['video_url']);
//         },
//       ),
//     );
//   }

//   void _playVideo(BuildContext context, String videoUrl) {
//     showDialog(
//       context: context,
//       builder: (_) {
//         return AlertDialog(
//           content: SizedBox(
//             height: 300,
//             width: 400,
//             child: Center(
//               child: Text(
//                   "Video Player for URL: $videoUrl"), // Replace with actual video player widget
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:gymify/providers/auth_provider/auth_provider.dart';
import 'package:gymify/providers/log_provider/log_provider.dart';
import 'package:gymify/providers/workout_provider/workout_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymify/colors/custom_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.userId ?? 'No user ID';
    final role = authProvider.role ?? 'No role assigned';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: CustomColors.primary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Information
            Text(
              "Profile Information",
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text("User ID: $userId", style: GoogleFonts.poppins(fontSize: 16)),
            Text("Role: $role", style: GoogleFonts.poppins(fontSize: 16)),
            const SizedBox(height: 24),

            // Workout History Tile
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutHistoryScreen(userId: userId),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: CustomColors.primaryShade2,
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      CustomColors.primaryShade2.withOpacity(0.8),
                      CustomColors.primary.withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.history,
                            color: Colors.white, size: 28),
                        const SizedBox(width: 12),
                        Text(
                          "Workout History",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.arrow_forward_ios,
                        size: 18, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutHistoryScreen extends StatefulWidget {
  final String userId;

  const WorkoutHistoryScreen({super.key, required this.userId});

  @override
  State<WorkoutHistoryScreen> createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  @override
  void initState() {
    super.initState();

    // Fetch user logs when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkoutLogProvider>().fetchUserLogs(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final workoutLogProvider = context.watch<WorkoutLogProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Workout History",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: CustomColors.primary,
        centerTitle: true,
      ),
      body: workoutLogProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : workoutLogProvider.hasError
              ? const Center(
                  child: Text(
                    "Failed to fetch workout history. Please try again.",
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                )
              : workoutLogProvider.userLogs.isEmpty
                  ? const Center(
                      child: Text(
                        "No workout history available.",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: workoutLogProvider.userLogs.length,
                      itemBuilder: (context, index) {
                        final log = workoutLogProvider.userLogs[index];
                        return WorkoutLogTile(log: log);
                      },
                    ),
    );
  }
}

class WorkoutLogTile extends StatefulWidget {
  final Map<String, dynamic> log;

  const WorkoutLogTile({super.key, required this.log});

  @override
  State<WorkoutLogTile> createState() => _WorkoutLogTileState();
}

class _WorkoutLogTileState extends State<WorkoutLogTile> {
  String? _workoutName; // To store the fetched workout name
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWorkoutName(); // Fetch workout name when the tile is initialized
  }

  Future<void> _fetchWorkoutName() async {
    final workoutProvider = context.read<WorkoutProvider>();
    final workoutId = widget.log['workout_id'];

    // Check if workoutId is valid
    if (workoutId == null) {
      setState(() {
        _workoutName = "Unknown Workout";
        _isLoading = false;
      });
      return;
    }

    try {
      // Fetch workout by ID
      await workoutProvider.fetchWorkoutById(workoutId);
      final workout = workoutProvider.selectedWorkout;

      setState(() {
        _workoutName = workout?.workoutName ?? "Unknown Workout";
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _workoutName = "Unknown Workout";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final workoutDate = widget.log['workout_date'] ?? 'N/A';
    final exercises = widget.log['workoutexerciseslogs'] ?? [];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 6,
      child: ExpansionTile(
        leading: Icon(Icons.fitness_center, color: CustomColors.primary),
        title: _isLoading
            ? const CircularProgressIndicator()
            : Text(
                "${_formatDate(workoutDate)} - $_workoutName",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
        children: exercises.map<Widget>((exerciseLog) {
          final exercise = exerciseLog['exercises'];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(exercise['image_url']),
            ),
            title: Text(
              exercise['exercise_name'],
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Duration: ${exerciseLog['exercise_duration']} mins, Rest: ${exerciseLog['rest_duration']} mins",
              style: GoogleFonts.poppins(fontSize: 12),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.play_circle_fill, color: Colors.blue),
              onPressed: () {
                _playVideo(context, exercise['video_url']);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return "${parsedDate.day}/${parsedDate.month}/${parsedDate.year}";
  }

  void _playVideo(BuildContext context, String videoUrl) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: SizedBox(
            height: 300,
            width: 400,
            child: Center(
              child: Text("Video Player for URL: $videoUrl"),
            ),
          ),
        );
      },
    );
  }
}
