import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      toolbarHeight: 60,
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back,
                  color: Theme.of(context).iconTheme.color),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
      title: Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      // actions: [
      //   IconButton(
      //     icon: Icon(Icons.settings, color: Theme.of(context).iconTheme.color),
      //     onPressed: () {
      //       // Navigate to Settings Screen
      //       Navigator.of(context).pushNamed('/settings');
      //     },
      //   ),
      // ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
