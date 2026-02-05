# Screen Conversion Example: Login Screen

## Before (Using Hard-coded Strings)

```dart
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Welcome back!'),
          Text('Log In'),
          TextField(
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email',
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text('Forgot password?'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('Log In'),
          ),
          Text("Don't have an account?"),
          TextButton(
            onPressed: () {},
            child: Text('Register'),
          ),
        ],
      ),
    );
  }
}
```

## After (Using Localization)

```dart
import 'package:flutter/material.dart';
import 'package:listys_app/core/extensions/localization_extension.dart';
import 'package:listys_app/core/widgets/language_selector.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          LanguageSelector(showLabel: false),
        ],
      ),
      body: Column(
        children: [
          Text(context.translate('welcomeBack')),
          Text(context.translate('login')),
          TextField(
            decoration: InputDecoration(
              labelText: context.translate('email'),
              hintText: context.translate('enterEmail'),
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: context.translate('password'),
              hintText: context.translate('password'),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(context.translate('forgotPassword')),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text(context.translate('login')),
          ),
          Text(context.translate('dontHaveAccount')),
          TextButton(
            onPressed: () {},
            child: Text(context.translate('register')),
          ),
        ],
      ),
    );
  }
}
```

## Key Changes

1. **Import the extension**:
   ```dart
   import 'package:listys_app/core/extensions/localization_extension.dart';
   ```

2. **Replace all strings**:
   - `'Welcome back!'` → `context.translate('welcomeBack')`
   - `'Log In'` → `context.translate('login')`
   - `'Email'` → `context.translate('email')`

3. **Add language selector** (optional):
   ```dart
   import 'package:listys_app/core/widgets/language_selector.dart';
   
   AppBar(
     actions: [LanguageSelector(showLabel: false)],
   )
   ```

## Your Current Login Screen

To convert your existing `lib/features/sining/login_screen.dart`:

1. Add import:
   ```dart
   import 'package:listys_app/core/extensions/localization_extension.dart';
   ```

2. Replace `AppLocalizations.of(context)?.login` with:
   ```dart
   context.translate('login')
   ```

3. Replace all hard-coded strings with `context.translate('key')`

4. (Optional) Add language selector to AppBar

## Paste Your Screen Code

**Please paste any screen code you want me to convert**, and I'll:
- Replace all hard-coded strings
- Add proper imports
- Show you the converted version
- Ensure RTL/LTR works correctly

