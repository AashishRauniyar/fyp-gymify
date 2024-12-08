// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:gymify/utils/custom_button.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 190, 184, 250),
//       appBar: AppBar(
//         title: const Text('Home Page'),
//       ),
//       bottomNavigationBar: CurvedNavigationBar(
//           animationCurve: Curves.fastEaseInToSlowEaseOut,
//           backgroundColor: const Color.fromARGB(255, 190, 184, 250),
//           items: const [
//             Icon(Icons.home),
//             Icon(Icons.search),
//             Icon(Icons.add),
//             Icon(Icons.notifications),
//             Icon(Icons.account_circle),
//           ]),
//       body: Center(
//         child: Column(
//           children: <Widget>[
//             const Text('Welcome to Gymify'),
//             const Text('Your Personal Fitness Trainer'),
//             const Text('Get Started'),
//             Column(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.yellow,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   margin: const EdgeInsets.all(10),
//                   child: const Text(
//                     'Get Started',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//             CustomButton(
//               text: "Login",
//               textStyle: const TextStyle(
//                   color: Colors.black, fontWeight: FontWeight.bold),
//               color: Colors.yellow,
//               onPressed: () {
//                 Navigator.pushNamed(context, '/login');
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:gymify/utils/custom_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA), // Light, clean background
      appBar: AppBar(
        title: const Text('Gymify'),
        centerTitle: true,
        backgroundColor: const Color(0xFF3B3C5D), // Consistent theme color
        elevation: 0,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color(0xFFF7F8FA),
        color: const Color(0xFF3B3C5D),
        height: 60,
        items: const [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.fitness_center, color: Colors.white),
          Icon(Icons.add, color: Colors.white),
          Icon(Icons.notifications, color: Colors.white),
          Icon(Icons.person, color: Colors.white),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Gymify',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3B3C5D),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your Personal Fitness Trainer',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildFeatureTile(Icons.fitness_center, 'Workout Plans'),
                  _buildFeatureTile(Icons.dining, 'Track Your Diet'),
                  _buildFeatureTile(Icons.analytics, 'Progress Insights'),
                  _buildFeatureTile(Icons.support, 'Expert Advice'),
                ],
              ),
            ),
            CustomButton(
              text: "Get Started",
              color: const Color(0xFF3B3C5D),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF3B3C5D)),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }
}
