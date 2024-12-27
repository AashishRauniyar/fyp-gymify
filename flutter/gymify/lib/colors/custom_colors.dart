import 'package:flutter/material.dart';

class CustomColors {
  // Primary Colors
  // static Color primary = const Color.fromARGB(255, 136, 129, 252); // rgb(136, 129, 252)
  static const Color primary =  Color(0xFFFF5E3A); // rgb(136, 129, 252)

  static const Color secondary =  Color(0xFF666666); // rgb(102, 102, 102)

  static const Color buttonText =  Color(0xFFFFFFFF); // rgb(102, 102, 102)

  static const Color black =  Color(0xFF000000); // rgb(102, 102, 102)  
//F6F6F6
  static const Color grey =  Color(0xFFF6F6F6); // rgb(102, 102, 102) 


   // Text Colors
  static Color darkText = const Color.fromARGB(255, 255, 255, 255);
  static const Color lightText =  Color(0xFF666666);
  // primary shade colors

  //white background
  static const backgroundColor =  Color(0xFFFFFFFF); // rgb(102, 102, 102)

  static Color primaryShade1 = const Color.fromARGB(230, 0, 92, 250);

  // static Color primaryShade1 = const Color.fromARGB(230, 136, 129, 252);
  static Color primaryShade2 = const Color.fromARGB(200, 0, 92, 250);

  // Complementary Colors
  static Color primaryCompliment =
      const Color.fromARGB(255, 252, 129, 136); // rgb(252, 129, 136)
  static Color primaryComplimentShade1 =
      const Color.fromARGB(230, 252, 129, 136);
  static Color primaryComplimentShade2 =
      const Color.fromARGB(200, 252, 129, 136);

  // Additional Colors
  static Color backgroundLight =
      const Color.fromARGB(255, 245, 246, 250); // rgb(245, 246, 250)
  static Color accent =
      const Color.fromARGB(255, 255, 149, 0); // rgb(113, 101, 227)

 

  // white color
  static Color white = const Color.fromARGB(255, 255, 255, 255);

  // Gradients
  static LinearGradient primaryGradient = const LinearGradient(
    colors: [
      Color.fromARGB(255, 136, 129, 252),
      Color.fromARGB(255, 113, 101, 227),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient complimentGradient = const LinearGradient(
    colors: [
      Color.fromARGB(255, 252, 129, 136),
      Color.fromARGB(230, 252, 129, 136),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
