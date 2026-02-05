import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

/// Extension to make localization easier to use
extension LocalizationExtension on BuildContext {
  /// Translate a key to the current locale
  String translate(String key, {Map<String, String>? params}) {
    return AppLocalizations.of(this)?.translate(key, params: params) ?? key;
  }

  /// Get the current locale
  Locale? get currentLocale => AppLocalizations.of(this)?.locale;

  /// Check if current locale is Arabic
  bool get isArabic => currentLocale?.languageCode == 'ar';

  /// Check if current locale is English
  bool get isEnglish => currentLocale?.languageCode == 'en';

  /// Get text direction based on current locale
  TextDirection get textDirection => isArabic ? TextDirection.rtl : TextDirection.ltr;
}

