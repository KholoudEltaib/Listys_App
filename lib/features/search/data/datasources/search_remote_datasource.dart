import 'package:dio/dio.dart';
import 'package:listys_app/core/network/dio_client.dart';
import 'package:listys_app/core/networking/api_constants.dart';
import 'package:listys_app/features/search/data/models/search_country_model.dart';
import 'package:listys_app/features/search/data/models/search_city_model.dart';
import 'package:listys_app/features/search/data/models/search_category_model.dart';
import 'package:listys_app/features/search/data/models/search_place_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<SearchCountryModel>> searchCountries({
    required String query,
    String? language,
  });

  Future<List<SearchCityModel>> searchCities({
    required String query,
    required int countryId,
    String? language,
  });

  Future<List<SearchCategoryModel>> searchCategories({
    required String query,
    required int cityId,
    String? language,
  });

  Future<List<SearchPlaceModel>> searchPlaces({
    required String query,
    required int cityId,
    int? categoryId,
    double? minRating,
    String? language,
  });
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final DioClient dioClient;

  SearchRemoteDataSourceImpl({required this.dioClient});

  Map<String, String> _getHeaders(String? language) {
    return {
      'Accept': 'application/json',
      if (language != null) 'Accept-Language': language,
    };
  }

  @override
  Future<List<SearchCountryModel>> searchCountries({
    required String query,
    String? language,
  }) async {
    try {
      final response = await dioClient.get(  
        ApiConstants.searchCountries,
        queryParameters: {'query': query},
        options: Options(headers: _getHeaders(language)),
      );

      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => SearchCountryModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search countries: $e');
    }
  }

  @override
  Future<List<SearchCityModel>> searchCities({
    required String query,
    required int countryId,
    String? language,
  }) async {
    try {
      final response = await dioClient.get(
        ApiConstants.searchCities,
        queryParameters: {
          'query': query,
          'country_id': countryId,
        },
        options: Options(headers: _getHeaders(language)),
      );

      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => SearchCityModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search cities: $e');
    }
  }

  @override
  Future<List<SearchCategoryModel>> searchCategories({
    required String query,
    required int cityId,
    String? language,
  }) async {
    try {
      final response = await dioClient.get(
        ApiConstants.searchCategories,
        queryParameters: {
          'query': query,
          'city_id': cityId,
        },
        options: Options(headers: _getHeaders(language)),
      );

      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => SearchCategoryModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search categories: $e');
    }
  }

  @override
  Future<List<SearchPlaceModel>> searchPlaces({
    required String query,
    required int cityId,
    int? categoryId,
    double? minRating,
    String? language,
  }) async {
    try {
      final queryParams = {
        'query': query,
        'city_id': cityId,
        if (categoryId != null) 'category_id': categoryId,
        if (minRating != null) 'min_rating': minRating,
      };

      final response = await dioClient.get(
        ApiConstants.searchPlaces,
        queryParameters: queryParams,
        options: Options(headers: _getHeaders(language)),
      );

      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => SearchPlaceModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search places: $e');
    }
  }
}
