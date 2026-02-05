import 'package:dartz/dartz.dart';
import 'package:listys_app/core/errors/failures.dart';
import 'package:listys_app/features/search/domain/entities/search_country.dart';
import 'package:listys_app/features/search/domain/entities/search_city.dart';
import 'package:listys_app/features/search/domain/entities/search_category.dart';
import 'package:listys_app/features/search/domain/entities/search_place.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<SearchCountry>>> searchCountries({
    required String query,
    String? language,
  });

  Future<Either<Failure, List<SearchCity>>> searchCities({
    required String query,
    required int countryId,
    String? language,
  });

  Future<Either<Failure, List<SearchCategory>>> searchCategories({
    required String query,
    required int cityId,
    String? language,
  });

  Future<Either<Failure, List<SearchPlace>>> searchPlaces({
    required String query,
    required int cityId,
    int? categoryId,
    double? minRating,
    String? language,
  });
}
