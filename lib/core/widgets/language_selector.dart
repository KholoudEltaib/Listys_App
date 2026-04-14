import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../localization/locale_cubit/locale_cubit.dart';
import '../localization/locale_cubit/locale_state.dart';
import '../localization/app_localizations.dart';

class LanguageSelector extends StatelessWidget {
  final bool showLabel;
  final EdgeInsets? padding;

  const LanguageSelector({
    super.key,
    this.showLabel = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final localeCubit = context.read<LocaleCubit>();

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        return Padding(
          padding: padding ?? EdgeInsets.zero,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showLabel) ...[
                const Icon(
                  Icons.language,
                  size: 20,
                  color: Colors.white70,
                ),
                const SizedBox(width: 8),
                Text(
                  localizations?.language ?? 'Language',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: DropdownButton<Locale>(
                  value: state.locale,
                  underline: const SizedBox(),
                  dropdownColor: Colors.grey[900],
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  items: [
                    DropdownMenuItem<Locale>(
                      value: const Locale('en'),
                      child: Row(
                        children: [
                          const Text('🇬🇧'),
                          const SizedBox(width: 8),
                          Text(localizations?.translate('english') ?? 'English'),
                        ],
                      ),
                    ),
                    DropdownMenuItem<Locale>(
                      value: const Locale('ar'),
                      child: Row(
                        children: [
                          const Text('🇸🇦'),
                          const SizedBox(width: 8),
                          Text(localizations?.translate('arabic') ?? 'العربية'),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (Locale? newLocale) {
                    if (newLocale != null) {
                      localeCubit.changeLocale(newLocale);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Alternative: Language Switch Widget
class LanguageSwitch extends StatelessWidget {
  final bool showLabel;

  const LanguageSwitch({
    super.key,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final localeCubit = context.read<LocaleCubit>();

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        final isArabic = state.locale.languageCode == 'ar';

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showLabel) ...[
              Text(
                localizations?.translate('english') ?? 'English',
                style: TextStyle(
                  color: !isArabic ? Colors.white : Colors.white54,
                  fontSize: 14,
                  fontWeight: !isArabic ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(width: 12),
            ],
            Switch(
              value: isArabic,
              onChanged: (value) {
                if (value) {
                  localeCubit.setArabic();
                } else {
                  localeCubit.setEnglish();
                } 
              },
              activeColor: Colors.blue,
            ),
            if (showLabel) ...[
              const SizedBox(width: 12),
              Text(
                localizations?.translate('arabic') ?? 'العربية',
                style: TextStyle(
                  color: isArabic ? Colors.white : Colors.white54,
                  fontSize: 14,
                  fontWeight: isArabic ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

