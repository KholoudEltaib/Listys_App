import 'package:dio/dio.dart';
import 'package:listys_app/core/constants/api_endpoints.dart';

import '../models/home_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeModel> getHomeData();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl(this.dio);

  @override
  Future<HomeModel> getHomeData() async {
    try {
      // ApiEndpoints.home already includes '/home', and dio baseUrl is 'https://listys.net/api'
      final response = await dio.get(
        ApiEndpoints.home,
        options: Options(
          headers: {'Accept': 'application/json'},
        ),
      );


      if (response.statusCode == 200) {
        final data = response.data;

      // print('data: $data'); // Debug print

        // Handle API response structure: {status, message, data: {...}}
        if (data is Map<String, dynamic>) {
          if (data.containsKey('data')) {
            return HomeModel.fromJson(data['data']);
          }
          // If data is at root level
          return HomeModel.fromJson(data);
        }
        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to load home data 1: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to load home data 2 : ${e.response?.statusCode}');
      }
      throw Exception('Failed to load home data 3: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load home data 4: $e');
    }
  }
}
