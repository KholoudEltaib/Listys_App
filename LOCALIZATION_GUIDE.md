# Localization Architecture Guide

## 📁 Folder Structure

```
lib/
└─ core/
   └─ localization/
      ├─ locale_cubit/
      │   ├─ locale_cubit.dart      # Cubit for managing locale state
      │   └─ locale_state.dart      # State class for locale
      ├─ app_localizations.dart     # Main localization helper class
      ├─ en.json                    # English translations
      └─ ar.json                    # Arabic translations
```

## 🚀 Usage Examples

### 1. Basic Translation

```dart
import 'package:listys_app/core/localization/app_localizations.dart';

// In your widget
Text(AppLocalizations.of(context)?.translate('welcome') ?? 'Welcome')
```

### 2. Translation with Parameters

```dart
AppLocalizations.of(context)?.translate(
  'detectedCountry',
  params: {'country': 'Saudi Arabia'},
)
```

### 3. Using Language Selector Widget

```dart
import 'package:listys_app/core/widgets/language_selector.dart';

// Dropdown selector
LanguageSelector()

// Or switch widget
LanguageSwitch()
```

### 4. Accessing LocaleCubit

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/core/localization/locale_cubit/locale_cubit.dart';

// In your widget
context.read<LocaleCubit>().setArabic();
context.read<LocaleCubit>().setEnglish();
context.read<LocaleCubit>().changeLocale(Locale('ar'));

// Listen to locale changes
BlocBuilder<LocaleCubit, LocaleState>(
  builder: (context, state) {
    final isRTL = state.isRTL;
    final locale = state.locale;
    // Your UI
  },
)
```

### 5. Checking Current Language

```dart
final localeCubit = context.read<LocaleCubit>();
if (localeCubit.isArabic) {
  // Arabic is selected
} else if (localeCubit.isEnglish) {
  // English is selected
}
```

## 🔄 Converting Hard-coded Strings

### Before:
```dart
Text('Welcome')
Text('Login')
Text('Home')
```

### After:
```dart
Text(AppLocalizations.of(context)?.translate('welcome') ?? 'Welcome')
Text(AppLocalizations.of(context)?.translate('login') ?? 'Login')
Text(AppLocalizations.of(context)?.translate('home') ?? 'Home')
```

### Or create a helper extension:

```dart
extension LocalizationExtension on BuildContext {
  String translate(String key, {Map<String, String>? params}) {
    return AppLocalizations.of(this)?.translate(key, params: params) ?? key;
  }
}

// Then use:
Text(context.translate('welcome'))
Text(context.translate('detectedCountry', params: {'country': 'Saudi'}))
```

## 📝 Adding New Translations

1. Add the key-value pair to both `en.json` and `ar.json`
2. Use the key in your code: `context.translate('yourKey')`

### Example:
```json
// en.json
{
  "newKey": "New Translation"
}

// ar.json
{
  "newKey": "ترجمة جديدة"
}
```

## 🎯 RTL/LTR Handling

The `LocaleCubit` automatically handles RTL/LTR:
- Arabic (`ar`) → RTL
- English (`en`) → LTR

The `MaterialApp` builder automatically applies the correct text direction based on the current locale state.

## 🔧 Integration Steps

1. ✅ LocaleCubit is already registered in `main.dart`
2. ✅ MaterialApp uses `BlocBuilder<LocaleCubit>` to rebuild on language change
3. ✅ Language selector widgets are ready to use
4. ✅ JSON files are included in `pubspec.yaml` assets

## 📱 Example: Profile Screen with Language Selector

```dart
import 'package:listys_app/core/widgets/language_selector.dart';
import 'package:listys_app/core/localization/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.translate('profile') ?? 'Profile'),
        actions: [
          LanguageSelector(showLabel: false),
        ],
      ),
      body: Column(
        children: [
          Text(localizations?.translate('profileInfo') ?? 'Profile Information'),
          // ... rest of your UI
        ],
      ),
    );
  }
}
```

## 🎨 Language Selector Placement

You can place the language selector anywhere:
- AppBar actions
- Settings screen
- Profile screen
- Bottom sheet
- Dialog

Both `LanguageSelector` (dropdown) and `LanguageSwitch` (toggle) are available.

