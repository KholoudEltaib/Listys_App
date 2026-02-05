// features/destination_details/data/datasources/place_details_remote_datasource.dart

import 'package:dio/dio.dart';
import 'package:listys_app/features/destination/data/models/place_model.dart';

abstract class PlaceDetailsRemoteDataSource {
  Future<PlaceModel> getPlaceDetails(int placeId);
}

class PlaceDetailsRemoteDataSourceImpl implements PlaceDetailsRemoteDataSource {
  final Dio dio;

  PlaceDetailsRemoteDataSourceImpl({required this.dio});

  @override
  Future<PlaceModel> getPlaceDetails(int placeId) async {
    try {
      // Fetch all places and filter by ID
      // Note: If your API has a specific endpoint like /places/{id}, use that instead
      final response = await dio.get('/search/places');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true && data['data'] != null) {
          final List<dynamic> placesJson = data['data'];
          
          // Find the place with matching ID
          final placeJson = placesJson.firstWhere(
            (json) => json['id'] == placeId,
            orElse: () => throw Exception('Place not found'),
          );
          
          return PlaceModel.fromJson(placeJson);
        } else {
          throw Exception(data['message'] ?? 'Failed to load place details');
        }
      } else {
        throw Exception('Failed to load place details');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Network error occurred');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}