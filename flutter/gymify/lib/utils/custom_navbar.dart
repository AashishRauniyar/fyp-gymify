import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final Function(int tabIndex) onTabChange;

  const CustomBottomNavigationBar({super.key, required this.onTabChange});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  final List<_NavigationItem> _navItems = [
    _NavigationItem(icon: Iconsax.home, label: 'Home'),
    _NavigationItem(icon: FontAwesomeIcons.dumbbell, label: 'Workouts'),
    _NavigationItem(icon: FontAwesomeIcons.utensils, label: 'Nutrition'),
    _NavigationItem(icon: FontAwesomeIcons.rocketchat, label: 'Chat'),
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
    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.padding.bottom;

    return Container(
      color: theme.colorScheme.surface,
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 10,
        // Add extra padding at the bottom if there's a system navigation bar
        bottom: bottomPadding > 0 ? bottomPadding + 5 : 10,
      ),
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
    );
  }
}

class _NavigationItem {
  final IconData icon;
  final String label;

  _NavigationItem({required this.icon, required this.label});
}
