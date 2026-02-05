import 'package:flutter/material.dart';

class AppColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF808080);
  // static const Color backgroundStart = Color(0xFF2C3137);
  // static const Color backgroundEnd   = Color(0xFF17191D);
static const LinearGradient backgroundGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF2C3137), // start color
    Color(0xFF17191D), // end color
  ],
);
  static const Color primaryColor = Color(0xFFF9B933);
}

