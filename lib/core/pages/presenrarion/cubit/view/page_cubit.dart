import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/core/network/dio_client.dart';

abstract class PagesState {}
class PagesInitial extends PagesState {}
class PagesLoading extends PagesState {}
class PagesLoaded extends PagesState {
  final Map<String, dynamic> pageData;
  PagesLoaded(this.pageData);
}
class PagesError extends PagesState {
  final String message;
  PagesError(this.message);
}

class PagesCubit extends Cubit<PagesState> {
  final DioClient dioClient;

  // Pass DioClient via constructor
  PagesCubit(this.dioClient) : super(PagesInitial());

  Future<void> fetchPage(String slug) async {
    emit(PagesLoading());
    try {
      // Using your custom DioClient's get method
      final response = await dioClient.get('/pages/$slug');
      
      if (response.data['status'] == true) {
        emit(PagesLoaded(response.data['data']));
      } else {
        emit(PagesError(response.data['message'] ?? 'Unknown error occurred'));
      }
    } on DioException catch (e) {
      // Extract error if it's a Dio exception
      String errorMessage = 'Failed to load page.';
      if (e.response?.data != null && e.response?.data is Map<String, dynamic>) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }
      emit(PagesError(errorMessage));
    } catch (e) {
      emit(PagesError('Failed to load page. Please try again.'));
    }
  }
}