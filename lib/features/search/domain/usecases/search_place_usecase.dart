import 'package:dartz/dartz.dart';
import 'package:listys_app/core/errors/failures.dart';
import 'package:listys_app/features/search/domain/entities/search_place.dart';
import 'package:listys_app/features/search/domain/repositories/search_repository.dart';

class SearchPlacesUseCase {
  final SearchRepository repository;

  SearchPlacesUseCase(this.repository);

  Future<Either<Failure, List<SearchPlace>>> call({
    required String query,
    required int cityId,
    int? categoryId,
    double? minRating,
    String? language,
  }) async {
    return await repository.searchPlaces(
      query: query,
      cityId: cityId,
      categoryId: categoryId,
      minRating: minRating,
      language: language,
    );
  }
}