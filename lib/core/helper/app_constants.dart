import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

// const kBackgroundColor = Color(0xFF212121);
// const kAccentColor = Color(0xFFFFB800);
// const kCardBackgroundColor = Color(0xFF2A2A2A);
// const kTextColor = Colors.white70;

const kTitleTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 22,
  fontWeight: FontWeight.bold,
);

const kSubtitleTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 14,
);

const kButtonTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
);

const double kDefaultPadding = 16.0;

class AppConstants {
  // images
  static const String imagesAssetsPath = 'assets/images/';
  static const String splashAssetsPath = 'assets/images/splash/';
  static const String onBoardingAssetsPath = 'assets/images/on_boarding/';
  static const String authAssetsPath = 'assets/images/auth/';
  static const String authHomePath = 'assets/images/home/';
  static const String profileAssetsPath = 'assets/images/profile/';
  // svg
  static const String svgAssetsPath = 'assets/svg/';
  // lottie
  static const String lottiePath = 'assets/lottie/';
  //padding
  static const double defaultPadding = 16.0;
  static double defaultWidthPadding = 16.0.w;
  static double defaultHeightPadding = 16.0.h;

  static const double defaultBorderRadius = 12.0;
  static const double searchFieldHeight = 50.0;

    static const String baseImageUrl = 'https://listys.net/storage/';

}

class TitleHeader extends StatelessWidget {
  const TitleHeader({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white12,
          ),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}