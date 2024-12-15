// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home'),
//       ),
//       body: Column(
//         children: [
//           Text("Welcome to Gymify"),
//           Text("Your personal fitness trainer"),
//           // ink well for showing exercise
//           InkWell(
//             onTap: () {
//               context.push('/exercises'); // Adds to the stack
//             },
//             child: Container(
//               padding: const EdgeInsets.all(8.0),
//               margin: const EdgeInsets.all(8.0),
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//               child: const Text(
//                 'Exercises',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//           // ink well for creating exercise
//           InkWell(
//             onTap: () {
//               context.push('/createExercise');
//             },
//             child: Container(
//               padding: const EdgeInsets.all(8.0),
//               margin: const EdgeInsets.all(8.0),
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//               child: const Text(
//                 'Create Exercise',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//           InkWell(
//             onTap: () {
//               // go to create workout screen
//               context.push('/createWorkout');
//             },
//             child: const Text(
//               "Create Workout",
//               style: TextStyle(
//                 color: Colors.blue,
//                 fontSize: 16,
//                 decoration: TextDecoration.underline,
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/colors/custom_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: CustomColors.darkText,
          ),
        ),
        backgroundColor: CustomColors.primary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Header
              Text(
                "Welcome to Gymify",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Your personal fitness trainer",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: CustomColors.lightText,
                ),
              ),
              const SizedBox(height: 20),

              // Exercises Card
              InkWell(
                onTap: () {
                  context.push('/exercises');
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
              const SizedBox(height: 24),

              // Footer Text
              Center(
                child: Text(
                  "Let's build a stronger you 💪",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: CustomColors.lightText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
