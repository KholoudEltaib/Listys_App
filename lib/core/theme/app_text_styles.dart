import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:listys_app/core/theme/app_color.dart';
import 'package:listys_app/core/theme/font_family_helper.dart';
import 'package:listys_app/core/theme/font_weight_helper.dart';

class AppTextStyles {
  static TextStyle font40BlackSemiBoldPlexSans = TextStyle(
    fontWeight: FontWeightHelper.semiBold,
    fontSize: 40.sp,
    color: AppColors.black,
    fontFamily: FontFamilyHelper.plexSansArabic,
  );

  static TextStyle font11GreyRegularLamaSansArabic = TextStyle(
    fontWeight: FontWeightHelper.regular,
    fontSize: 11.sp,
    color: AppColors.grey,
    fontFamily: FontFamilyHelper.lamaSansArabic,
  );

  static TextStyle font26BlackRegularPlexSans = TextStyle(
    fontWeight: FontWeightHelper.regular,
    fontSize: 26.sp,
    color: AppColors.black,
    fontFamily: FontFamilyHelper.plexSansArabic,
  );

}
