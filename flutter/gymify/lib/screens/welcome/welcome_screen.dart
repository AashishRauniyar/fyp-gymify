// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// class WelcomeScreen extends StatelessWidget {
//   final masonryItems = [
//     'assets/images/loading_screen/1.jpg',
//     'assets/images/loading_screen/2.jpg',
//     'assets/images/loading_screen/3.jpg',
//     'assets/images/loading_screen/4.jpg',
//     'assets/images/loading_screen/5.jpg',
//     'assets/images/loading_screen/6.jpg',
//     'assets/images/loading_screen/5.jpg',
//     'assets/images/loading_screen/3.jpg',
//   ];

//   WelcomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor:
//           const Color.fromARGB(255, 0, 0, 0), // Vibrant green background
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Header: Grid of images
//           Expanded(
//             flex: 2,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: MasonryGridView.extent(
//                 padding: EdgeInsets.zero,
//                 physics: const NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 maxCrossAxisExtent: 120,
//                 mainAxisSpacing: 8,
//                 crossAxisSpacing: 8,
//                 itemCount: masonryItems.length,
//                 itemBuilder: (context, index) {
//                   return ClipRRect(
//                     borderRadius: BorderRadius.circular(15.0),
//                     child: Image.asset(
//                       masonryItems[index],
//                       fit: BoxFit.cover,
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//           // Heart icon
//           const Padding(
//             padding: EdgeInsets.symmetric(vertical: 10),
//             child: Icon(
//               Icons.favorite,
//               size: 48,
//               color: Colors.white,
//             ),
//           ),
//           // Welcome message
//           Expanded(
//             flex: 1,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [

//                 const Text(
//                   "Welcome to Gymify",
//                   style: TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   "Chat, get to know each other, and flirt\nface-to-face. Enjoy safe, discreet messaging.",
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.white,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 20),
//                 // Join now button
//                 ElevatedButton(
//                   onPressed: () {
//                     // Handle join now
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 50, vertical: 15),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                     ),
//                   ),
//                   child: Text(
//                     "Join now",
//                     style: TextStyle(
//                       color: const Color(0xFF00A86B),
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 // Already a member
//                 TextButton(
//                   onPressed: () {
//                     // Handle log in
//                   },
//                   child: Text(
//                     "Already a member? Log in",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       decoration: TextDecoration.underline,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gymify/screens/splash_screen/splash_sreen.dart';
import 'package:gymify/utils/custom_button.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  final masonryItems = [
    'assets/images/loading_screen/1.jpg',
    'assets/images/loading_screen/2.jpg',
    'assets/images/loading_screen/3.jpg',
    'assets/images/loading_screen/4.jpg',
    'assets/images/loading_screen/4.jpg',
    'assets/images/loading_screen/5.jpg',
    'assets/images/loading_screen/6.jpg',
    'assets/images/loading_screen/6.jpg',
  ];

  WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Vibrant green background
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          // Header: Grid of images with borders
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: MasonryGridView.extent(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                maxCrossAxisExtent: 120,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                itemCount: masonryItems.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                        color: Colors.white, // Border color
                        width: 2.0, // Border width
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(13.0), // Inner border radius
                      child: Image.asset(
                        masonryItems[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Heart icon
          // const Padding(
          //   padding: EdgeInsets.symmetric(vertical: 10),
          //   child: Icon(
          //     Icons.arrow_drop_up_outlined,
          //     size: 48,
          //     color: Colors.white,
          //   ),
          // ),
          // Welcome message
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome to Gymify",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Workouts Management, Diet Management, Progress Insights, Expert Advice and much more",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Join now button
                CustomButton(
                    text: "Join Now",
                    color: Colors.black,
                    onPressed: () {
                      context.go('/register');
                    }),
                const SizedBox(height: 10),
                // Already a member
                TextButton(
                  onPressed: () {
                    context.go('/login');
                  },
                  child: const Text(
                    "Already a member? Log in",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
