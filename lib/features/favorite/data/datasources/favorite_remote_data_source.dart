// lib/features/favorite/data/datasources/favorite_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:listys_app/features/favorite/data/models/favorite_model.dart';

abstract class FavoriteRemoteDataSource {
  Future<FavoriteModel> getFavorites();
  Future<void> toggleFavorite({required int id, required String type});
}

class FavoriteRemoteDataSourceImpl implements FavoriteRemoteDataSource {
  final Dio dio;

  FavoriteRemoteDataSourceImpl({required this.dio});

  @override
  Future<FavoriteModel> getFavorites() async {
    try {
      final response = await dio.get('/favorites');
      
      if (response.statusCode == 200 && response.data['status'] == true) {
        return FavoriteModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to load favorites');
      }
    } catch (e) {
      throw Exception('Error fetching favorites: $e');
    }
  }

  @override
  Future<void> toggleFavorite({required int id, required String type}) async {
    try {
      print('📡 API Call: POST /favorites/toggle');
      print('📡 Payload: {id: $id, type: $type}');
      
      final response = await dio.post(
        '/favorites/toggle',  
        data: {
          'id': id,
          'type': type,
        },
      );
      
      print('📡 Response Status: ${response.statusCode}');
      print('📡 Response Data: ${response.data}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Toggle successful');
        return;
      } else {
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ API Error: $e');
      if (e is DioException) {
        print('❌ DioException type: ${e.type}');
        print('❌ Response: ${e.response?.data}');
      }
      throw Exception('Error toggling favorite: $e');
    }
  }

}