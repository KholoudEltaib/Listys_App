class ApiConstants {
  // Base URL for Listys API
  static String baseUrl = 'https://listys.net/api';

  // Auth endpoints
  static String login = '/auth/login';
  static String register = '/auth/register';
  static String me = '/auth/me';
  static String refresh = '/auth/refresh';
  static String logout = '/auth/logout';
  static String social = '/auth/social';
  static String passwordSendOtp = '/auth/password/send-otp';
  static String passwordVerifyOtp = '/auth/password/verify-otp';
  static String passwordReset = '/auth/password/reset';

  // Public endpoints
  static String home = '/home';
  static String onboardings = '/onboardings';
  static String countries = '/countries';
  static String cities = '/cities';
  static String places = '/places';
  static String contact = '/contact';

  // Favorites endpoints
  static String favorites = '/favorites';
  static String favoritesToggle = '/favorites/toggle';

  // Profile endpoints
  static String profile = '/profile';
  static String profileUpdate = '/profile/update';
  static String changePassword = '/profile/password';
  static String deleteAccount = '/profile';
  static String language = '/profile/language';

  // Search endpoints
  static String searchCountries = '/search/countries';
  static String searchCities = '/search/cities';
  static String searchCategories = '/search/categories';
  static String searchPlaces = '/search/places';
}
