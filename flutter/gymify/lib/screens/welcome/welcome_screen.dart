// import 'package:flutter/material.dart';
// import 'package:gymify/colors/custom_colors.dart';
// import 'package:gymify/utils/custom_button.dart';
// import 'package:go_router/go_router.dart';

// class WelcomeScreen extends StatelessWidget {
//   const WelcomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center, // Vertically center
//         crossAxisAlignment: CrossAxisAlignment.center, // Horizontally center
//         children: [
//           const Text(
//             "WELCOME  TO         GYMIFY",
//             style: TextStyle(
//               fontSize: 56,
//               fontWeight: FontWeight.bold,
//               color: CustomColors.black,
//             ),
//             textAlign: TextAlign.center,
//           ),

//           const SizedBox(height: 20),
//           // Join now button
//           CustomButton(
//             text: "JOIN NOW",
//             textColor: Colors.white,
//             color: CustomColors.primary,
//             onPressed: () {
//               context.go('/register');
//             },
//           ),
//           const SizedBox(height: 10),
//           // Already a member
//           TextButton(
//             onPressed: () {
//               context.go('/login');
//             },
//             child: const Text(
//               "Already a member? Log in",
//               style: TextStyle(
//                 color: CustomColors.primary,
//                 fontSize: 16,
//                 decoration: TextDecoration.underline,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:gymify/colors/custom_colors.dart';
import 'package:gymify/utils/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // List of slider images
    final List<String> sliderImages = [
      'assets/images/loading_screen/1.jpg', // Replace with your assets
      'assets/images/loading_screen/2.jpg', // Replace with your assets
      'assets/images/loading_screen/3.jpg', // Replace with your assets
      'assets/images/loading_screen/4.jpg', // Replace with your assets
      'assets/images/loading_screen/5.jpg', // Replace with your assets
      'assets/images/loading_screen/6.jpg', // Replace with your assets
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF000000), // Pure black background
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.3),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Image Slider
                CarouselSlider(
                  items: sliderImages.map((imagePath) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 250,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    autoPlayInterval: const Duration(seconds: 4),
                    viewportFraction: 0.85,
                  ),
                ),
                const SizedBox(height: 20),
                // Welcome Text
                const Text(
                  "Welcome to\nGYMIFY",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.2,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                // Join Now Button
                CustomButton(
                  text: "JOIN NOW",
                  textColor: Colors.white,
                  color: CustomColors.primary,
                  onPressed: () {
                    context.go('/register');
                  },
                ),
                const SizedBox(height: 15),
                // Already a Member - Highlight "Log in"
                TextButton(
                  onPressed: () {
                    context.go('/login');
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: "Already a member? ",
                      style: TextStyle(
                        color: Colors.white, // Default color
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: "Log in",
                          style: TextStyle(
                            color: CustomColors.primary, // Highlight color
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
