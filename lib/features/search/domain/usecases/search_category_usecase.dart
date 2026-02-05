import 'package:dartz/dartz.dart';
import 'package:listys_app/core/errors/failures.dart';
import 'package:listys_app/features/search/domain/entities/search_category.dart';
import 'package:listys_app/features/search/domain/repositories/search_repository.dart';

class SearchCategoriesUseCase {
  final SearchRepository repository;

  SearchCategoriesUseCase(this.repository);

  Future<Either<Failure, List<SearchCategory>>> call({
    required String query,
    required int cityId,
    String? language,
  }) async {
    return await repository.searchCategories(
      query: query,
      cityId: cityId,
      language: language,
    );
  }
}