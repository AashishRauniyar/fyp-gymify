// import 'package:flutter/material.dart';

// class CustomBottomNavigationBar extends StatefulWidget {
//   final Function(int tabIndex) onTabChange;

//   const CustomBottomNavigationBar({super.key, required this.onTabChange});

//   @override
//   _CustomBottomNavigationBarState createState() =>
//       _CustomBottomNavigationBarState();
// }

// class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
//   final List<IconData> _icons = [
//     Icons.home,
//     Icons.fitness_center,
//     Icons.dining,
//     Icons.chat,
//     Icons.account_circle,
//   ];

//   int _selectedTab = 0;

//   void onTabPress(int index) {
//     if (_selectedTab != index) {
//       setState(() {
//         _selectedTab = index;
//       });
//       widget.onTabChange(index);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Container(
//         margin: const EdgeInsets.fromLTRB(24, 0, 24, 8),
//         padding: const EdgeInsets.all(1),
//         constraints: const BoxConstraints(maxWidth: 768),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(24),
//           gradient: LinearGradient(
//             colors: [
//               Colors.white.withOpacity(0.5),
//               Colors.white.withOpacity(0)
//             ],
//           ),
//         ),
//         child: Container(
//           clipBehavior: Clip.hardEdge,
//           decoration: BoxDecoration(
//             color: const Color(0xFF434C5E),
//             borderRadius: BorderRadius.circular(24),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 15,
//                 offset: const Offset(0, 5),
//               ),
//             ],
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: List.generate(_icons.length, (index) {
//               IconData icon = _icons[index];

//               return Expanded(
//                 child: GestureDetector(
//                   onTap: () => onTabPress(index),
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     curve: Curves.easeInOut,
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         AnimatedOpacity(
//                           opacity: _selectedTab == index ? 1 : 0.6,
//                           duration: const Duration(milliseconds: 200),
//                           child: Icon(
//                             icon,
//                             size: _selectedTab == index ? 30 : 25,
//                             color: _selectedTab == index
//                                 // use this color #434c5e
//                                 ? Colors.white
//                                 : Colors.white70,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         AnimatedOpacity(
//                           opacity: _selectedTab == index ? 1 : 0,
//                           duration: const Duration(milliseconds: 200),
//                           child: AnimatedContainer(
//                             duration: const Duration(milliseconds: 300),
//                             width: _selectedTab == index ? 20 : 0,
//                             height: 2,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             }),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:gymify/colors/custom_colors.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final Function(int tabIndex) onTabChange;

  const CustomBottomNavigationBar({super.key, required this.onTabChange});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  final List<IconData> _icons = [
    Icons.home,
    Icons.fitness_center,
    Icons.dining,
    Icons.chat,
    Icons.account_circle,
  ];

  int _selectedTab = 0;

  void onTabPress(int index) {
    if (_selectedTab != index) {
      setState(() {
        _selectedTab = index;
      });
      widget.onTabChange(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 18),
        padding: const EdgeInsets.all(1),
        constraints: const BoxConstraints(maxWidth: 768),
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(24),
        //   gradient: LinearGradient(
        //     colors: [
        //       CustomColors.primaryShade2
        //           .withOpacity(0.4), // Light gradient color
        //       CustomColors.primaryShade2.withOpacity(0), // Fade out
        //     ],
        //   ),
        // ),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: CustomColors.primary, // Main background color
            borderRadius: BorderRadius.circular(24),
            // boxShadow: [
            //   BoxShadow(
            //     color: CustomColors.lightText.withOpacity(0.1), // Subtle shadow
            //     blurRadius: 15,
            //     offset: const Offset(0, 5),
            //   ),
            // ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_icons.length, (index) {
              IconData icon = _icons[index];

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTabPress(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Animated Icon
                        AnimatedOpacity(
                          opacity: _selectedTab == index ? 1 : 0.6,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            icon,
                            size: _selectedTab == index ? 30 : 25,
                            color: _selectedTab == index
                                ? CustomColors.backgroundLight // Selected color
                                : Colors.white70, // Unselected color
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Animated Line Indicator
                        AnimatedOpacity(
                          opacity: _selectedTab == index ? 1 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: _selectedTab == index ? 20 : 0,
                            height: 2,
                            color:
                                CustomColors.backgroundLight, // Whiteish line
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
