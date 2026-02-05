import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Application-wide constants
class AppConstants {
  // Image asset paths
  static const String imagesAssetsPath = 'assets/images/';
  static const String splashAssetsPath = 'assets/images/splash/';
  static const String onBoardingAssetsPath = 'assets/images/on_boarding/';
  static const String authAssetsPath = 'assets/images/auth/';
  static const String authHomePath = 'assets/images/home/';
  static const String profileAssetsPath = 'assets/images/profile/';
  
  // SVG asset paths
  static const String svgAssetsPath = 'assets/svg/';
  
  // Lottie asset paths
  static const String lottiePath = 'assets/lottie/';
  
  // Padding constants
  static const double defaultPadding = 16.0;
  static double defaultWidthPadding = 16.0.w;
  static double defaultHeightPadding = 16.0.h;
  
  // UI constants
  static const double defaultBorderRadius = 12.0;
  static const double searchFieldHeight = 50.0;
  
  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String localeKey = 'app_locale';
  static const String onboardingKey = 'onboarding_completed';
}

