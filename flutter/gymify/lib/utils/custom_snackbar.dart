import 'package:flutter/material.dart';

void showCoolSnackBar(
  BuildContext context,
  String message,
  bool isSuccess, {
  String? actionLabel,
  VoidCallback? onActionPressed,
  List<Widget>? customActions, // New optional custom actions
}) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  // Dismiss any existing SnackBars before showing a new one
  scaffoldMessenger.hideCurrentSnackBar();

  final snackBar = SnackBar(
    content: Row(
      children: [
        Icon(
          isSuccess ? Icons.check_circle : Icons.error,
          color: Colors.white,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        if (customActions != null) ...customActions,
      ],
    ),
    backgroundColor: isSuccess ? Colors.green.shade600 : Colors.red.shade600,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    // Remove or change this to fixed
    behavior: SnackBarBehavior.fixed, // <- This line is key
    duration: const Duration(seconds: 3),
    action: (actionLabel != null &&
            onActionPressed != null &&
            customActions == null)
        ? SnackBarAction(
            label: actionLabel,
            textColor: Colors.white,
            onPressed: onActionPressed,
          )
        : null,
  );

  scaffoldMessenger.showSnackBar(snackBar);
}
