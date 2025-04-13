import 'package:flutter/material.dart';

void showCoolSnackBar(
  BuildContext context,
  String message,
  bool isSuccess, {
  String? actionLabel,
  VoidCallback? onActionPressed,
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
      ],
    ),
    backgroundColor: isSuccess ? Colors.green.shade600 : Colors.red.shade600,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    behavior: SnackBarBehavior.floating, // Makes it float
    elevation: 2.0,
    margin: const EdgeInsets.all(16.0),
    duration: const Duration(seconds: 3),
    action: actionLabel != null && onActionPressed != null
        ? SnackBarAction(
            label: actionLabel,
            textColor: Colors.white,
            onPressed: onActionPressed,
          )
        : null,
  );

  // Show the new SnackBar
  scaffoldMessenger.showSnackBar(snackBar);
}
