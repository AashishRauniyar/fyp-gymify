// import 'package:flutter/material.dart';
// import 'package:gymify/colors/custom_colors.dart';

// class CustomInput extends StatelessWidget {
//   final String hintText;
//   final Color backgroundColor;
//   final Color textColor;
//   final double fontSize;
//   final TextEditingController controller;
//   final String? errorText;
//   final Function(String) onChanged;
//   final bool obscureText;
//   final IconButton? suffixIcon;
//   final double height;

//   const CustomInput({
//     super.key,
//     this.hintText = 'Enter Username',
//     this.backgroundColor = CustomColors.secondary,
//     this.textColor = const Color(0xFF000000),
//     this.fontSize = 14.0,
//     required this.controller,
//     required this.onChanged,
//     this.errorText,
//     this.obscureText = false,
//     this.suffixIcon,
//     this.height = 56.0,
//   });

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           height: height,
//           width: screenWidth * 0.9,
//           decoration: BoxDecoration(
//             color: backgroundColor,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: TextFormField(
//             controller: controller,
//             style: TextStyle(
//               fontSize: fontSize,
//               color: textColor,
//             ),
//             obscureText: obscureText,
//             onChanged: onChanged, // Call onChanged function to update state
//             decoration: InputDecoration(
//               hintText: hintText,
//               hintStyle: TextStyle(color: Colors.grey, fontSize: fontSize),
//               contentPadding:
//                   const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//               border: InputBorder.none, // No border when not focused
//               focusedBorder: OutlineInputBorder(
//                 borderSide: const BorderSide(
//                   color: Color(0xFFFF5E3A), // Orange color when focused
//                   width: 2.0, // Border width when focused
//                 ),
//                 borderRadius: BorderRadius.circular(8), // Same border radius
//               ),
//               suffixIcon: suffixIcon,
//             ),
//           ),
//         ),
//         if (errorText != null) ...[
//           const SizedBox(height: 4), // Add some space between input and error
//           Text(
//             errorText!,
//             style: const TextStyle(
//               color: Colors.red,
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:gymify/colors/custom_colors.dart';

class CustomInput extends StatelessWidget {
  final String hintText;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final TextEditingController controller;
  final String? errorText;
  final Function(String) onChanged;
  final bool obscureText;
  final Widget? suffixIcon;
  final Icon? leadingIcon;
  final double height;

  const CustomInput({
    super.key,
    this.hintText = 'Enter Username',
    this.backgroundColor = CustomColors.secondary,
    this.textColor = const Color(0xFF000000),
    this.fontSize = 14.0,
    required this.controller,
    required this.onChanged,
    this.errorText,
    this.obscureText = false,
    this.suffixIcon,
    this.leadingIcon,
    this.height = 56.0,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: height,
          width: screenWidth * 0.9,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              if (leadingIcon != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: leadingIcon,
                ),
              ],
              Expanded(
                child: TextFormField(
                  controller: controller,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: textColor,
                  ),
                  obscureText: obscureText,
                  onChanged:
                      onChanged, // Call onChanged function to update state
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle:
                        TextStyle(color: Colors.grey, fontSize: fontSize),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    border: InputBorder.none, // No border when not focused
                    suffixIcon: suffixIcon,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4), // Add some space between input and error
          Text(
            errorText!,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}

