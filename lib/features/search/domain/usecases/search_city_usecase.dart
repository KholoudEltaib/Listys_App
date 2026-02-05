import 'package:dartz/dartz.dart';
import 'package:listys_app/core/errors/failures.dart';
import 'package:listys_app/features/search/domain/entities/search_city.dart';
import 'package:listys_app/features/search/domain/repositories/search_repository.dart';

class SearchCitiesUseCase {
  final SearchRepository repository;

  SearchCitiesUseCase(this.repository);

  Future<Either<Failure, List<SearchCity>>> call({
    required String query,
    required int countryId,
    String? language,
  }) async {
    return await repository.searchCities(
      query: query,
      countryId: countryId,
      language: language,
    );
  }
}