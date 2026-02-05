import 'package:dartz/dartz.dart';
import 'package:listys_app/core/errors/failures.dart';
import 'package:listys_app/features/search/domain/entities/search_country.dart';
import 'package:listys_app/features/search/domain/repositories/search_repository.dart';

class SearchCountriesUseCase {
  final SearchRepository repository;

  SearchCountriesUseCase(this.repository);

  Future<Either<Failure, List<SearchCountry>>> call({
    required String query,
    String? language,
  }) async {
    return await repository.searchCountries(
      query: query,
      language: language,
    );
  }
}
