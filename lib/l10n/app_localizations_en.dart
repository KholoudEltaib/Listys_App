// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get login => 'Log In';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get welcomeBack => 'Welcome back!';

  @override
  String get home => 'Home';

  @override
  String get nearYou => 'Near You';

  @override
  String get featured => 'Featured 💫';

  @override
  String get noCountriesFound => 'No countries found';

  @override
  String get noPlacesNearYou => 'No places found near you.';

  @override
  String get createAccount => 'Create Account';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get logout => 'Logout';

  @override
  String get explore => 'Explore';

  @override
  String get favorites => 'Favorites';

  @override
  String get profile => 'Profile';

  @override
  String get name => 'Name';

  @override
  String get changePassword => 'Change Pass';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get yourFavoritePlacesWillAppearHere =>
      'Your favorite places will appear here.';

  @override
  String get welcomeToHomeScreen => 'Welcome to the Home Screen!';

  @override
  String detectedCountry(Object country) {
    return 'Detected country: $country';
  }

  @override
  String get profileUpdated => 'Profile updated successfully!';

  @override
  String get allPasswordFieldsRequired => 'All password fields are required.';

  @override
  String get newPasswordConfirmationNoMatch =>
      'New password and confirmation do not match.';

  @override
  String get passwordChanged => 'Password changed successfully!';

  @override
  String failedToLoadCountries(Object statusCode) {
    return 'Failed to load countries: $statusCode';
  }

  @override
  String errorFetchingCountries(Object error) {
    return 'Error fetching countries: $error';
  }

  @override
  String get noAddressProvided => 'No address provided';

  @override
  String get searchForCountry => 'Search for a city...';

  @override
  String get areYouSureLogout => 'Are you sure you want to logout?';

  @override
  String get deleteAccountConfirm =>
      'Are you sure you want to delete your account? This action cannot be undone.';

  @override
  String get delete => 'Delete';

  @override
  String unsupportedCountry(Object country) {
    return 'Sorry, we do not support your country ($country) yet. We are working to expand!';
  }

  @override
  String get language => 'Language';

  @override
  String get profileInfo => 'Profile Information';

  @override
  String get orSignInWith => 'or sign in with';
}
