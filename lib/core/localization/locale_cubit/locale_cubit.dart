import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/storage_helper.dart';
import 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(const LocaleState(locale: Locale('en'), isRTL: false)) {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final savedLocale = await StorageHelper.getLocale();
    if (savedLocale != null) {
      changeLocale(Locale(savedLocale));
    }
  }

  Future<void> changeLocale(Locale locale) async {
    final isRTL = locale.languageCode == 'ar';
    await StorageHelper.saveLocale(locale.languageCode);
    emit(LocaleState(locale: locale, isRTL: isRTL));
  }

  Future<void> setArabic() async {
  print('🌍 LocaleCubit: Changing to Arabic');
  await changeLocale(const Locale('ar'));
  print('✅ LocaleCubit state: ${state.locale.languageCode}');
}

Future<void> setEnglish() async {
  print('🌍 LocaleCubit: Changing to English');
  await changeLocale(const Locale('en'));
  print('✅ LocaleCubit state: ${state.locale.languageCode}');
}

  bool get isArabic => state.locale.languageCode == 'ar';
  bool get isEnglish => state.locale.languageCode == 'en';
}

