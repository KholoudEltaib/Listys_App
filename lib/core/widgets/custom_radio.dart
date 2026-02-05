import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_color.dart';

class CustomRadio extends StatelessWidget {
  const CustomRadio({
    super.key,
    required this.value,
    this.onChanged,
    this.checkColor,
  });

  final bool value;
  final void Function()? onChanged;
  final Color? checkColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged,
      child: Container(
        width: 20.w,
        height: 20.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFC86D22), width: 2),
          color: value ? const Color(0xFFC86D22) : Colors.transparent,
        ),
        child: value
            ? Center(
                child: Icon(
                  Icons.check,
                  size: 14.sp,
                  color: AppColors.white,
                ),
              )
            : null,
      ),
    );
  }
}
