import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/networking/api_constants.dart';
import '../core/utils/storage_helper.dart';

class FavoriteService {
  Future<Map<String, String>> _getHeaders() async {
    final token = await StorageHelper.getToken();
    final locale = await StorageHelper.getLocale();
    
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    // 🌍 Add language header
    final lang = locale ?? 'en';
    headers['Accept-Language'] = lang;
    headers['lang'] = lang;
    headers['Language'] = lang;

    return headers;
  }

  Future<List<dynamic>> getFavorites() async {
    final headers = await _getHeaders();
    
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.favorites}'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is Map<String, dynamic>) {
        return (data['data'] as List?) ?? (data['favorites'] as List?) ?? [];
      }
      return data as List<dynamic>;
    } else {
      throw Exception('Failed to load favorites');
    }
  }

  Future<void> _toggleFavorite(int id, {String type = 'place'}) async {
    final headers = await _getHeaders();
    
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.favoritesToggle}'),
      headers: headers,
      body: json.encode({'id': id, 'type': type}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to toggle favorite');
    }
  }

  Future<void> addFavorite(int id, {String type = 'place'}) =>
      _toggleFavorite(id, type: type);

  Future<void> removeFavorite(int id, {String type = 'place'}) =>
      _toggleFavorite(id, type: type);
}
