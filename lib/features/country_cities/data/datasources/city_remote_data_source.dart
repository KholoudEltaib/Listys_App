import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/city_model.dart';

abstract class CityRemoteDataSource {
  Future<List<CityModel>> getCities(int countryId);
}

class CityRemoteDataSourceImpl implements CityRemoteDataSource {
  final Dio dio;

  CityRemoteDataSourceImpl(this.dio);

  @override
  Future<List<CityModel>> getCities(int countryId) async {
    try {
      // Use countries endpoint to get country with nested cities
      final response = await dio.get(
        '${ApiEndpoints.countries}/$countryId',
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : <String, dynamic>{};
        
        // Extract data from response (could be nested under 'data' key)
        final responseData = data['data'] ?? data;
        final countryData = responseData is Map<String, dynamic>
            ? responseData
            : <String, dynamic>{};
        
        // Cities might be nested in the country object
        final citiesData = countryData['cities'] ?? 
                          data['cities'] ?? 
                          (responseData is Map ? responseData['cities'] : null) ??
                          [];
        
        if (citiesData is List) {
          return citiesData
              .map((json) => CityModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }
        return [];
      } else {
        final message = _extractMessage(response.data) ?? 'Failed to fetch cities';
        throw ServerException(message, statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      if (e.response != null) {
        final message = _extractMessage(e.response?.data) ?? 'Failed to fetch cities';
        throw ServerException(message, statusCode: e.response?.statusCode);
      }
      throw NetworkException('Network error: ${e.message}');
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException('Unexpected error: $e');
    }
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data['message'] != null) return data['message'].toString();
      if (data['error'] != null) return data['error'].toString();
    }
    return null;
  }
}
