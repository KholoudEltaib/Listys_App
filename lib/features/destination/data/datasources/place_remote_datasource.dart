// features/destination/data/datasources/place_remote_datasource.dart

import 'package:dio/dio.dart';
import 'package:listys_app/features/destination/data/models/place_model.dart';

abstract class PlaceRemoteDataSource {
  Future<List<PlaceModel>> getPlaces({
    String? query,
    int? cityId,
    int? categoryId,
    int? minRating,
  });
}

class PlaceRemoteDataSourceImpl implements PlaceRemoteDataSource {
  final Dio dio;

  PlaceRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PlaceModel>> getPlaces({
    String? query,
    int? cityId,
    int? categoryId,
    int? minRating,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {};
      
      if (query != null && query.isNotEmpty) {
        queryParameters['query'] = query;
      }
      if (cityId != null) {
        queryParameters['city_id'] = cityId;
      }
      if (categoryId != null) {
        queryParameters['category_id'] = categoryId;
      }
      if (minRating != null) {
        queryParameters['min_rating'] = minRating;
      }

      final response = await dio.get(
        '/search/places',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true && data['data'] != null) {
          final List<dynamic> placesJson = data['data'];
          return placesJson
              .map((json) => PlaceModel.fromJson(json))
              .toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to load places');
        }
      } else {
        throw Exception('Failed to load places');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Network error occurred');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}