// features/nearby_map/data/datasources/places_remote_data_source.dart

import 'package:dio/dio.dart';
import 'package:listys_app/core/errors/exceptions.dart';
import 'package:listys_app/features/nearby_map/data/models/place_model.dart';

abstract class PlacesRemoteDataSource {
  Future<List<PlaceModel>> getAllPlaces();
}

class PlacesRemoteDataSourceImpl implements PlacesRemoteDataSource {
  final Dio dio;
  final String baseUrl = 'https://listys.net/api';

  PlacesRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PlaceModel>> getAllPlaces() async {
    try {
      print('🗺️ Fetching places with headers: ${dio.options.headers}');
      
      final response = await dio.get(
        '$baseUrl/search/places',
      );

      print('✅ Places API response status: ${response.statusCode}');
      print('📋 Response headers: ${response.headers}');

      if (response.statusCode == 200) {
        final placesResponse = PlacesResponseModel.fromJson(response.data);
        
        if (placesResponse.status) {
          print('✅ Successfully fetched ${placesResponse.places.length} places');
          return placesResponse.places;
        } else {
          throw ServerException(placesResponse.message);
        }
      } else {
        throw ServerException(
          'Failed to fetch places. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      print('   Response: ${e.response?.data}');
      
      if (e.response != null) {
        throw ServerException(
          e.response?.data['message'] ?? 'Failed to fetch places',
        );
      }
      throw ServerException('Network error: ${e.message}');
    } catch (e) {
      print('❌ Unexpected error: $e');
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Error fetching places: ${e.toString()}');
    }
  }
}