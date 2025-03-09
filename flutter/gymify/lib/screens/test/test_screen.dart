// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:table_calendar/table_calendar.dart';

// class TestScreen extends StatefulWidget {
//   const TestScreen({super.key});

//   @override
//   State<TestScreen> createState() => _TestScreenState();
// }

// class _TestScreenState extends State<TestScreen> {
//   // The current date that will be highlighted on the calendar

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Theme.of(context).colorScheme.surface,
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           actions: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey,
//                       blurRadius: 1.0,
//                     ),
//                   ],
//                 ),
//                 child: IconButton(
//                   onPressed: () {
//                     GoRouter.of(context).go('/search');
//                   },
//                   icon: const Icon(
//                     LineAwesomeIcons.bell,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         body: SingleChildScrollView(
//           child: Column(children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 const Column(
//                   children: [
//                     Text('Welcome Back'),
//                     Text(
//                       " Aashish",
//                       style:
//                           TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//                 // Search Icon
//                 Row(
//                   spacing: 25,
//                   children: [
//                     Container(
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.white,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey,
//                             blurRadius: 1.0,
//                           ),
//                         ],
//                       ),
//                       child: IconButton(
//                         onPressed: () {
//                           GoRouter.of(context).go('/search');
//                         },
//                         icon: const Icon(LineAwesomeIcons.search_solid),
//                       ),
//                     ),
//                     // Profile image in a circle
//                     ClipOval(
//                       child: Image.asset(
//                         'assets/images/profile/default_avatar.jpg',
//                         width: 50,
//                         height: 50,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//             const SizedBox(height: 20),
//             Container(
//               width: double.infinity,
//               margin: const EdgeInsets.all(20),
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 20,
//                 vertical: 16,
//               ),
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF4A3298), Colors.black],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 8,
//                     offset: Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: const Text.rich(
//                 TextSpan(
//                   style: TextStyle(color: Colors.white),
//                   children: [
//                     TextSpan(text: "A Summer Surpise\n"),
//                     TextSpan(
//                       text: "Apply for Membership",
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ]),
//         ));
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final DateTime _selectedDay = DateTime.now();
  final DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 1.0,
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {
                  GoRouter.of(context).go('/search');
                },
                icon: const Icon(
                  LineAwesomeIcons.bell,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Welcome message and profile section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome Back', style: TextStyle(fontSize: 18)),
                      Text(
                        "Aashish",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  // Profile and search button
                  Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 1.0,
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () {
                            GoRouter.of(context).go('/search');
                          },
                          icon: const Icon(LineAwesomeIcons.search_solid),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ClipOval(
                        child: Image.asset(
                          'assets/images/profile/default_avatar.jpg',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),

              // Offer Container
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4A3298), Colors.black],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text.rich(
                  TextSpan(
                    style: TextStyle(color: Colors.white),
                    children: [
                      TextSpan(text: "Exclusive Gym Offer\n"),
                      TextSpan(
                        text: "Apply for Membership",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Today's Progress Section

              // create four containers with personal bests and currenet weights
            ],
          ),
        ),
      ),
    );
  }
}
