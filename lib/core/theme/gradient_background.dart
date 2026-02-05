import 'package:flutter/material.dart';
import 'package:listys_app/core/theme/app_color.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2C3137), // start color
              Color(0xFF17191D), // end color
            ],
          )),
          child: child,
        ),
        Positioned(
          top: -300,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 700,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryColor.withOpacity(0.1), 
                    AppColors.primaryColor.withOpacity(0.0), 
                  ],
                  stops: const [0.0, 0.9],
                  center: Alignment.center,
                  radius: 0.5,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
