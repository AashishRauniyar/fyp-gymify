// import 'package:flutter/material.dart';
// import 'package:gymify/colors/custom_colors.dart';
// import 'package:gymify/utils/custom_button.dart';
// import 'package:go_router/go_router.dart';
// import 'package:carousel_slider/carousel_slider.dart';

// class WelcomeScreen extends StatelessWidget {
//   const WelcomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // List of slider images
//     final List<String> sliderImages = [
//       'assets/images/loading_screen/1.jpg', // Replace with your assets
//       'assets/images/loading_screen/2.jpg', // Replace with your assets
//       'assets/images/loading_screen/3.jpg', // Replace with your assets
//       'assets/images/loading_screen/4.jpg', // Replace with your assets
//       'assets/images/loading_screen/5.jpg', // Replace with your assets
//       'assets/images/loading_screen/6.jpg', // Replace with your assets
//     ];

//     return Scaffold(
//       backgroundColor: const Color(0xFF000000), // Pure black background
//       body: Stack(
//         children: [
//           // Background Gradient
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.black.withOpacity(0.6),
//                     Colors.black.withOpacity(0.3),
//                   ],
//                   begin: Alignment.bottomCenter,
//                   end: Alignment.topCenter,
//                 ),
//               ),
//             ),
//           ),
//           SafeArea(
//             child: Column(
//               children: [
//                 const SizedBox(height: 20),
//                 // Image Slider
//                 CarouselSlider(
//                   items: sliderImages.map((imagePath) {
//                     return ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Image.asset(
//                         imagePath,
//                         fit: BoxFit.cover,
//                         width: MediaQuery.of(context).size.width,
//                       ),
//                     );
//                   }).toList(),
//                   options: CarouselOptions(
//                     height: 250,
//                     autoPlay: true,
//                     enlargeCenterPage: true,
//                     aspectRatio: 16 / 9,
//                     autoPlayInterval: const Duration(seconds: 4),
//                     viewportFraction: 0.85,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 // Welcome Text
//                 const Text(
//                   "Welcome to\nGYMIFY",
//                   style: TextStyle(
//                     fontSize: 48,
//                     fontWeight: FontWeight.w900,
//                     color: Colors.white,
//                     height: 1.2,
//                     letterSpacing: 1.5,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 Spacer(),
//                 // Join Now Button
//                 CustomButton(
//                   text: "JOIN NOW",
//                   textColor: Colors.white,
//                   color: CustomColors.primary,
//                   onPressed: () {
//                     context.go('/register');
//                   },
//                 ),
//                 const SizedBox(height: 15),
//                 // Already a Member - Highlight "Log in"
//                 TextButton(
//                   onPressed: () {
//                     context.go('/login');
//                   },
//                   child: const Text.rich(
//                     TextSpan(
//                       text: "Already a member? ",
//                       style: TextStyle(
//                         color: Colors.white, // Default color
//                         fontSize: 16,
//                       ),
//                       children: [
//                         TextSpan(
//                           text: "Log in",
//                           style: TextStyle(
//                             color: CustomColors.primary, // Highlight color
//                             fontWeight: FontWeight.bold,
//                             decoration: TextDecoration.underline,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Spacer()
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/colors/custom_colors.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:gymify/utils/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Gym onboarding data
    final List<OnBoarding> onboardingItems = [
      OnBoarding(
        title: 'Fitness Tracking Made Easy',
        image: 'assets/images/onboarding/allexercise.png',
        description:
            'Set your fitness goals and track your progress with ease.',
      ),
      OnBoarding(
        title: 'Meal Plans & Nutrition',
        image: 'assets/images/onboarding/food.png',
        description:
            'Get personalized meal plans and nutrition advice to fuel your workouts.',
      ),
      OnBoarding(
        title: 'Online Trainer and Guidance',
        image: 'assets/images/onboarding/trainer.png',
        description:
            'Access online trainers and proper guidance for your workouts.',
      ),
      OnBoarding(
        title: 'Build your dream body',
        image: 'assets/images/onboarding/workout.png',
        description:
            'Get access to a wide range of workouts and exercises to build your dream body.',
      ),
    ];

    ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                // Onboarding Carousel
                Expanded(
                  flex: 4,
                  child: CarouselSlider.builder(
                    itemCount: onboardingItems.length,
                    itemBuilder: (context, index, realIndex) {
                      final item = onboardingItems[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  item.image,
                                  fit: BoxFit.contain,
                                  width: MediaQuery.of(context).size.width,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              item.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: CustomColors.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: CustomColors.secondary.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: 400,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      autoPlayInterval: const Duration(seconds: 5),
                      viewportFraction: 0.9,
                      onPageChanged: (index, reason) {
                        currentIndex.value = index;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Dots Indicator
                ValueListenableBuilder<int>(
                  valueListenable: currentIndex,
                  builder: (context, value, child) {
                    return DotsIndicator(
                      dotsCount: onboardingItems.length,
                      position: value,
                      decorator: DotsDecorator(
                        color: CustomColors.secondary.withOpacity(0.5),
                        activeColor: CustomColors.primary,
                        size: const Size.square(8.0),
                        activeSize: const Size(18.0, 8.0),
                        activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Welcome Text
                const Text(
                  "Welcome to\nGYMIFY",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: CustomColors.primary,
                    height: 1.2,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Join Now Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomButton(
                    text: "GET STARTED",
                    textColor: Colors.white,
                    color: CustomColors.primary,
                    onPressed: () {
                      context.go('/register');
                    },
                  ),
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
                        color: CustomColors.secondary,
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: "Log in",
                          style: TextStyle(
                            color: CustomColors.primary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnBoarding {
  final String title;
  final String description;
  final String image;

  OnBoarding({
    required this.title,
    required this.description,
    required this.image,
  });
}
