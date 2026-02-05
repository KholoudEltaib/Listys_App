import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/core/helper/app_constants.dart';
import 'package:listys_app/core/networking/dio_factory.dart';
import 'package:listys_app/core/theme/app_color.dart';
import 'package:listys_app/core/localization/locale_cubit/locale_cubit.dart';
import 'package:listys_app/core/localization/locale_cubit/locale_state.dart';
import 'package:listys_app/core/extensions/localization_extension.dart';
import 'package:listys_app/core/utils/storage_helper.dart';

class LanguageOptionsScreen extends StatefulWidget {
  const LanguageOptionsScreen({super.key});

  @override
  State<LanguageOptionsScreen> createState() => _LanguageOptionsScreenState();
}

class _LanguageOptionsScreenState extends State<LanguageOptionsScreen> {
  String? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    // Initialize selected language based on current locale
    final localeCubit = context.read<LocaleCubit>();
    _selectedLanguage = localeCubit.isArabic ? "العربية" : "English";
  }

  void _saveLanguage() async {
  final localeCubit = context.read<LocaleCubit>();
  
  print('🎯 User selected: $_selectedLanguage');
  
  if (_selectedLanguage == "English") {
    await localeCubit.setEnglish();
  } else if (_selectedLanguage == "العربية") {
    await localeCubit.setArabic();
  }

  // 🔄 Force refresh Dio headers after language change
  await DioFactory.addDioHeaders();

  final savedLocale = await StorageHelper.getLocale();
  print('✅ Saved locale verified: $savedLocale');

  if (!mounted) return;
  Navigator.of(context).pop();

  // Show success message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        '${context.translate('language')} ${context.translate('changed_successfully')}',
      ),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
    ),
  );

  // Navigate back
  Future.delayed(const Duration(milliseconds: 500), () {
    if (mounted) {
      Navigator.of(context).pop();
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        // Update selected language when locale changes
        _selectedLanguage ??= localeState.locale.languageCode == 'ar' 
              ? "العربية" 
              : "English";

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  TitleHeader(
                    title: context.translate('language'),
                  ),

                  const SizedBox(height: 20),

                  _languageItem("English"),
                  const SizedBox(height: 12),
                  _languageItem("العربية"),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _saveLanguage,
                      child: Text(
                        context.translate('save'),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _languageItem(String lang) {
  final isSelected = _selectedLanguage == lang;

  return InkWell(
    onTap: () {
      setState(() {
        _selectedLanguage = lang;
      });
    },
    child: Container(
      height: 55,
      decoration: BoxDecoration(
        color: const Color(0x10FFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? AppColors.primaryColor
              : Colors.transparent, // 👈 key
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(
            isSelected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            size: 20,
            color:
                isSelected ? AppColors.primaryColor : Colors.grey,
          ),
          const SizedBox(width: 12),
          Text(
            lang,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight:
                  isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          const Spacer(),
          if (isSelected)
            Icon(
              Icons.check_circle,
              color: AppColors.primaryColor,
              size: 20,
            ),
          const SizedBox(width: 12),
        ],
      ),
    ),
  );
}
}
