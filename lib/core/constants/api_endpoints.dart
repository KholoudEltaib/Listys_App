/// API endpoints constants
class ApiEndpoints {
  // Base URL
  static const String baseUrl = 'https://listys.net/api';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String me = '/auth/me';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String social = '/auth/social';
  static const String passwordSendOtp = '/auth/password/send-otp';
  static const String passwordVerifyOtp = '/auth/password/verify-otp';
  static const String passwordReset = '/auth/password/reset';

  // Public endpoints
  static const String home = '/home';
  static const String onboardings = '/onboardings';
  static const String countries = '/countries';
  static const String cities = '/cities';
  static const String places = '/places';
  static const String contact = '/contact';

  // Search endpoints
  static const String searchCountries = '/search/countries';
  static const String searchCities = '/search/cities';
  static const String searchCategories = '/search/categories';
  static const String searchPlaces = '/search/places';

  // Favorites endpoints
  static const String favorites = '/favorites';
  static const String favoritesToggle = '/favorites/toggle';

  // Profile endpoints
  static const String profile = '/profile';
  static const String profileUpdate = '/profile/update';
  static const String profilePassword = '/profile/password';
  static const String profileLanguage = '/profile/language';
  static const String profileDelete = '/profile';

  // Helper method to replace path parameters
  static String replacePathParams(String endpoint, Map<String, String> params) {
    String result = endpoint;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value);
    });
    return result;
  }

  static String withId(String endpoint, String id) => '$endpoint/$id';
}

