// import 'package:flutter/material.dart';
// import 'package:gymify/colors/custom_colors.dart';

// class CustomBottomNavigationBar extends StatefulWidget {
//   final Function(int tabIndex) onTabChange;

//   const CustomBottomNavigationBar({super.key, required this.onTabChange});

//   @override
//   _CustomBottomNavigationBarState createState() =>
//       _CustomBottomNavigationBarState();
// }

// class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
//   final List<IconData> _icons = [
//     Icons.home_filled,
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
//         margin: const EdgeInsets.fromLTRB(20, 0, 20, 18),
//         padding: const EdgeInsets.all(1),
//         constraints: const BoxConstraints(maxWidth: 768),
//         child: Container(
//           clipBehavior: Clip.hardEdge,
//           decoration: BoxDecoration(
//             color: CustomColors.primary, // Main background color
//             borderRadius: BorderRadius.circular(24),
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
//                         // Animated Icon
//                         AnimatedOpacity(
//                           opacity: _selectedTab == index ? 1 : 0.6,
//                           duration: const Duration(milliseconds: 200),
//                           child: Icon(
//                             icon,
//                             size: _selectedTab == index ? 30 : 25,
//                             color: _selectedTab == index
//                                 ? CustomColors.backgroundLight // Selected color
//                                 : Colors.white70, // Unselected color
//                           ),
//                         ),
//                         const SizedBox(height: 4),

//                         // Animated Line Indicator
//                         AnimatedOpacity(
//                           opacity: _selectedTab == index ? 1 : 0,
//                           duration: const Duration(milliseconds: 200),
//                           child: AnimatedContainer(
//                             duration: const Duration(milliseconds: 300),
//                             width: _selectedTab == index ? 20 : 0,
//                             height: 2,
//                             color:
//                                 CustomColors.backgroundLight, // Whiteish line
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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final Function(int tabIndex) onTabChange;

  const CustomBottomNavigationBar({super.key, required this.onTabChange});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  final List<_NavigationItem> _navItems = [
    _NavigationItem(icon: FontAwesomeIcons.home, label: 'Home'),
    _NavigationItem(icon: FontAwesomeIcons.dumbbell, label: 'Workouts'),
    _NavigationItem(icon: FontAwesomeIcons.utensils, label: 'Nutrition'),
    _NavigationItem(icon: FontAwesomeIcons.rocketchat, label: 'Community'),
    _NavigationItem(icon: FontAwesomeIcons.user, label: 'Profile'),
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
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.onSurface.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navItems.length, (index) {
                final item = _navItems[index];
                final isSelected = _selectedTab == index;

                return GestureDetector(
                  onTap: () => onTabPress(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Icon(
                      item.icon,
                      size: 28,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationItem {
  final IconData icon;
  final String label;

  _NavigationItem({required this.icon, required this.label});
}

// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class CustomBottomNavigationBar extends StatefulWidget {
//   final Function(int tabIndex) onTabChange;

//   const CustomBottomNavigationBar({super.key, required this.onTabChange});

//   @override
//   _CustomBottomNavigationBarState createState() =>
//       _CustomBottomNavigationBarState();
// }

// class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
//   final List<_NavigationItem> _navItems = [
//     _NavigationItem(icon: Icons.home_outlined),
//     _NavigationItem(icon: Icons.search),
//     _NavigationItem(icon: Icons.add),
//     _NavigationItem(icon: Icons.monitor_heart_outlined),
//     _NavigationItem(icon: Icons.person_outline),
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
//     final theme = Theme.of(context);

//     return Container(
//       color: Colors.black, // Dark background as shown in the image
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: List.generate(_navItems.length, (index) {
//               final item = _navItems[index];
//               final isSelected = _selectedTab == index;

//               return GestureDetector(
//                 onTap: () => onTabPress(index),
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: Colors.transparent,
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                   child: Icon(
//                     item.icon,
//                     size: 28,
//                     color: isSelected
//                         ? Colors.white
//                         : Colors.white
//                             .withOpacity(0.3), // Dimmed icons for inactive
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

// class _NavigationItem {
//   final IconData icon;

//   _NavigationItem({required this.icon});
// }
