// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:gymify/colors/app_colors.dart';

// class CustomInput extends StatefulWidget {
//   final String labelText; // Updated: Label instead of Hint
//   final TextEditingController controller;
//   final String? Function(String?)? validator;
//   final Function(String)? onChanged;
//   final bool isPassword;
//   final TextInputType keyboardType;
//   final Widget? leadingIcon;
//   final Widget? trailingIcon;
//   final bool enabled;

//   const CustomInput({
//     super.key,
//     required this.labelText, // Updated: Label text
//     required this.controller,
//     this.validator,
//     this.onChanged,
//     this.isPassword = false,
//     this.keyboardType = TextInputType.text,
//     this.leadingIcon,
//     this.trailingIcon,
//     this.enabled = true,
//   });

//   @override
//   State<CustomInput> createState() => _CustomInputState();
// }

// class _CustomInputState extends State<CustomInput> {
//   bool _isObscured = false;

//   @override
//   void initState() {
//     super.initState();
//     _isObscured =
//         widget.isPassword; // Initialize visibility based on isPassword
//   }

//   void _toggleVisibility() {
//     setState(() {
//       _isObscured = !_isObscured;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextFormField(
//           controller: widget.controller,
//           obscureText: _isObscured,
//           keyboardType: widget.keyboardType,
//           enabled: widget.enabled,
//           onChanged: widget.onChanged,
//           validator: widget.validator,
//           style: GoogleFonts.poppins(
//             fontSize: 14,
//             fontWeight: FontWeight.w400,
//             color: widget.enabled
//                 ? AppColors.inputText
//                 : AppColors.inputText.withOpacity(0.6),
//           ),
//           decoration: InputDecoration(
//             labelText: widget.labelText, // Floating label
//             labelStyle: GoogleFonts.poppins(
//               fontSize: 14,
//               color: AppColors.lightSecondary,
//             ),
//             filled: true,
//             fillColor: widget.enabled
//                 ? AppColors.inputFill
//                 : AppColors.inputFill.withOpacity(0.5),
//             contentPadding: const EdgeInsets.symmetric(
//               vertical: 14,
//               horizontal: 16,
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide(
//                 color: AppColors.lightSecondary.withOpacity(0.2),
//                 width: 1.5,
//               ),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide(
//                 color: AppColors.lightSecondary.withOpacity(0.2),
//                 width: 1.5,
//               ),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: const BorderSide(
//                 color: AppColors.lightPrimary,
//                 width: 2,
//               ),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: const BorderSide(
//                 color: AppColors.lightError,
//                 width: 1.5,
//               ),
//             ),
//             prefixIcon: widget.leadingIcon != null
//                 ? Padding(
//                     padding: const EdgeInsets.only(left: 12, right: 8),
//                     child: widget.leadingIcon,
//                   )
//                 : null,
//             suffixIcon: widget.isPassword
//                 ? IconButton(
//                     icon: Icon(
//                       _isObscured ? Icons.visibility_off : Icons.visibility,
//                       color: AppColors.lightSecondary,
//                     ),
//                     onPressed: _toggleVisibility,
//                   )
//                 : widget.trailingIcon,
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomInput extends StatefulWidget {
  final String labelText; // Floating label text
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final bool isPassword;
  final TextInputType keyboardType;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool enabled;

  const CustomInput({
    super.key,
    required this.labelText, // Label text for floating effect
    required this.controller,
    this.validator,
    this.onChanged,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.leadingIcon,
    this.trailingIcon,
    this.enabled = true,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool _isObscured = false;

  @override
  void initState() {
    super.initState();
    _isObscured =
        widget.isPassword; // Initialize visibility based on isPassword
  }

  void _toggleVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Dynamically fetch current theme

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          obscureText: _isObscured,
          keyboardType: widget.keyboardType,
          enabled: widget.enabled,
          onChanged: widget.onChanged,
          validator: widget.validator,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: widget.enabled
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          decoration: InputDecoration(
            labelText: widget.labelText, // Floating label
            labelStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            filled: true,
            fillColor: widget.enabled
                ? theme.colorScheme.surface
                : theme.colorScheme.surface.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: theme.colorScheme.onSurface.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: theme.colorScheme.onSurface.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: theme.colorScheme.error,
                width: 1.5,
              ),
            ),
            prefixIcon: widget.leadingIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: widget.leadingIcon,
                  )
                : null,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility_off : Icons.visibility,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    onPressed: _toggleVisibility,
                  )
                : widget.trailingIcon,
          ),
        ),
      ],
    );
  }
}
