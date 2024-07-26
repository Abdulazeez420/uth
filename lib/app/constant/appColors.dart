import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  
  static const List<Color> _gradientColors = [
    Color(0xFF00BCD4), 
    Color(0xFF8BC34A), 
  ];

  static const List<double> _gradientStops = [
    0.0,
    1.0,
  ];

 
  static LinearGradient get backgroundGradient => const LinearGradient(
        colors: _gradientColors,
        stops: _gradientStops,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
static const  btnColor=Colors.blueAccent; 
}
