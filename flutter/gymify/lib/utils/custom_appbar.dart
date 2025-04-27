import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool showBackButton;
  final TabBar? bottom; // Added TabBar for tabs

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.actions,
    this.showBackButton = true,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: theme.colorScheme.onSurface,
              ),
              onPressed: onBackPressed ?? () => context.pop(),
            )
          : null,
      title: Text(
        title,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
      centerTitle: true,
      actions: actions,
      bottom: bottom, // Pass TabBar here
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(bottom == null ? 56 : 56 + kTextTabBarHeight);
}
