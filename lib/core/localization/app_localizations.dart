import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  late Map<String, dynamic> _localizedStrings;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ar'),
  ];

  Future<bool> load() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/localization/${locale.languageCode}.json',
      );
      _localizedStrings = json.decode(jsonString) as Map<String, dynamic>;
      return true;
    } catch (e) {
      // Fallback to English if locale file not found
      if (locale.languageCode != 'en') {
        try {
          final String jsonString = await rootBundle.loadString(
            'assets/localization/en.json',
          );
          _localizedStrings = json.decode(jsonString) as Map<String, dynamic>;
        } catch (e2) {
          // If even English fails, use empty map
          _localizedStrings = {};
        }
      } else {
        _localizedStrings = {};
      }
      return false;
    }
  }

  String translate(String key, {Map<String, String>? params}) {
    String translation = _localizedStrings[key]?.toString() ?? key;
    
    // Replace parameters in translation
    if (params != null) {
      params.forEach((paramKey, value) {
        translation = translation.replaceAll('{$paramKey}', value);
      });
    }
    
    return translation;
  }

  // Helper method for easier access
  String get(String key, {Map<String, String>? params}) {
    return translate(key, params: params);
  }

  // Getters for common translations
  String get welcome => translate('welcome');
  String get login => translate('login');
  String get register => translate('register');
  String get email => translate('email');
  String get password => translate('password');
  String get home => translate('home');
  String get logout => translate('logout');
  String get profile => translate('profile');
  String get favorites => translate('favorites');
  String get explore => translate('explore');
  String get language => translate('language');
  String get save => translate('save');
  String get cancel => translate('cancel');
  String get delete => translate('delete');
  String get search => translate('search');
  String get loading => translate('loading');
  String get error => translate('error');
  String get success => translate('success');
  String get ok => translate('ok');
  String get yes => translate('yes');
  String get no => translate('no');
  String get back => translate('back');
  String get next => translate('next');
  String get close => translate('close');
  String get tryAgain => translate('tryAgain');
  String get retry => translate('retry');
  String get forgotPassword => translate('forgotPassword');
  String get dontHaveAccount => translate('dontHaveAccount');
  String get english => translate('english');
  String get arabic => translate('arabic');
  String get welcomeBack => translate('welcomeBack');
  String get splash_screen_title => translate('splash_screen_title');
  String get get_started => translate('get_started');
  String get skip => translate('skip');
  String get welcome_back => translate('welcome_back');
  String get enter_your_email => translate('enter_your_email');
  String get enter_your_password => translate('enter_your_password');
  String get forgot_password => translate('forgot_password');
  String get sign_in => translate('sign_in');
  String get orsign_in_with => translate('orsign_in_with');
  String get dont_have_account => translate('dont_have_account');
  String get sign_up => translate('sign_up');
  String get sign_in_successful => translate('sign_in_successful');
  String get name => translate('name');
  String get confirm_password => translate('confirm_password');
  String get have_account => translate('have_account');
  String get otp_verification => translate('otp_verification');
  String get we_have_sent_otp => translate('we_have_sent_otp');
  String get resend_code => translate('resend_code');
  String get confirm => translate('confirm');
  String get your_account_created => translate('your_account_created');
  String get enter_email_step1 => translate('enter_email_step1');
  String get enter_email_step1_title => translate('enter_email_step1_title');
  String get otp_step2 => translate('otp_step2');
  String get reset_password_step3 => translate('reset_password_step3');
  String get reset => translate('reset');
  String get popular_countries => translate('popular_countries');
  String get popular_places => translate('popular_places');
  String get search_for_any_place => translate('search_for_any_place');
  String get favorite_countries => translate('favorite_countries');
  String get favorite_places => translate('favorite_places');
  String get countries => translate('countries');
  String get cities => translate('cities');
  String get places => translate('places');
  String get from => translate('from');
  String get to => translate('to');
  String get personal_info => translate('personal_info');
  String get language_options => translate('language_options');
  String get delete_account => translate('delete_account');
  String get search_places => translate('search_places');
  String get suggetions => translate('suggetions');
  String get history => translate('history');
  String get clear_all => translate('clear_all');
  String get filter_by => translate('filter_by');
  String get popular_filters => translate('popular_filters');
  String get trip_dates => translate('trip_dates');
  String get star_rating => translate('star_rating');
  String get apply_filters => translate('apply_filters');
  String get clear_filters => translate('clear_filters');
  String get personal_information => translate('personal_information');
  String get email_address => translate('email_address');
  String get enter_your_name => translate('enter_your_name');
  String get save_changes => translate('save_changes');
  String get langugage => translate('langugage');
  String get change_password => translate('change_password');
  String get old_password => translate('old_password');
  String get enter_your_old_password => translate('enter_your_old_password');
  String get new_password => translate('new_password');
  String get enter_your_new_password => translate('enter_your_new_password');
  String get cities_of_country => translate('cities_of_country');
  String get categories_in_city => translate('categories_in_city');
  String get lunch => translate('lunch');
  String get dinner => translate('dinner');
  String get breakfast => translate('breakfast');
  String get things_to_do => translate('things_to_do');
  String get destination => translate('destination');
  String get destination_details => translate('destination_details');
  String get share_destination => translate('share_destination');
  String get directions_to_destination => translate('directions_to_destination');
  String get about_destination => translate('about_destination');
  String get about_destination_description => translate('about_destination_description');
  String get facilities => translate('facilities');
  String get reviews => translate('reviews');
  String get gallery => translate('gallery');
  String get by => translate('by');
  String get otp_step2_title => translate('otp_step2_title');
  String get are_you_sure_logout => translate('are_you_sure_logout');
  String get yes_logout => translate('yes_logout');
  String get no_back => translate('no_back');
  String get see_all => translate('see_all');
  String get current_password => translate('current_password');
  String get enter_current_password => translate('enter_current_password');
  String get enter_new_password => translate('enter_new_password');
  String get confirm_new_password => translate('confirm_new_password');
  String get enter_confirm_new_password => translate('enter_confirm_new_password');
  String get categories => translate('categories');
  String get submit => translate('submit');
  String get enter_your_email_to_receive_otp => translate('enter_your_email_to_receive_otp');
  String get no_images_available => translate('no_images_available');
  String get invalid_email => translate('invalid_email');
  String get enter_new_password_and_confirm_it => translate('enter_new_password_and_confirm_it'); 
  String get onboarding1_title => translate('onboarding1_title');
  String get onboarding_subtitle => translate('onboarding_subtitle');
  String get onboarding2_title => translate('onboarding2_title');
  String get onboarding3_title => translate('onboarding3_title');
  String get no_favorite_countries => translate('no_favorite_countries');
  String get no_favorite_places => translate('no_favorite_places');
  String get back_to_home => translate('back_to_home');
  String get empty_favorite_description => translate('empty_favorite_description');
  String get no_favorites_yet => translate('no_favorites_yet');
  String get delete_account_confirmation => translate('delete_account_confirmation');
  String get all_popular_countries => translate('all_popular_countries');
  String get show_nearby_places => translate('show_nearby_places');
  String get please_allow_location_access_to_view_nearby_places => translate('please_allow_location_access_to_view_nearby_places');
  String get nearby_places => translate('nearby_places');
  String get loading_map => translate('loading_map');
  String get getting_your_location => translate('getting_your_location');
  String get finding_places_in_your_city => translate('finding_places_in_your_city');
  String get loading_nearby_places => translate("Loading nearby places...");
  String get please_enable_location_service => translate("Please enable location service");
  String get location_permission_required => translate("Location Permission Required");
  String get please_grant_location_permission_in_settings => translate("Please grant location permission in app settings");
  String get try_again => translate("Try Again");
  String get settings => translate("Settings");
  String get explore_nearby => translate("Explore Nearby");
  String get view_map => translate("View Map");
  String get within_km => translate("Within km");
  String get city_view => translate("City View");
  String get all_places => translate("All Places");
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
