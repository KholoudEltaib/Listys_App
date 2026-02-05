import 'package:dartz/dartz.dart';
import 'package:listys_app/core/errors/failures.dart';
import 'package:listys_app/features/search/data/datasources/search_remote_datasource.dart';
import 'package:listys_app/features/search/domain/entities/search_country.dart';
import 'package:listys_app/features/search/domain/entities/search_city.dart';
import 'package:listys_app/features/search/domain/entities/search_category.dart';
import 'package:listys_app/features/search/domain/entities/search_place.dart';
import 'package:listys_app/features/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<SearchCountry>>> searchCountries({
    required String query,
    String? language,
  }) async {
    try {
      final result = await remoteDataSource.searchCountries(
        query: query,
        language: language,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SearchCity>>> searchCities({
    required String query,
    required int countryId,
    String? language,
  }) async {
    try {
      final result = await remoteDataSource.searchCities(
        query: query,
        countryId: countryId,
        language: language,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SearchCategory>>> searchCategories({
    required String query,
    required int cityId,
    String? language,
  }) async {
    try {
      final result = await remoteDataSource.searchCategories(
        query: query,
        cityId: cityId,
        language: language,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SearchPlace>>> searchPlaces({
    required String query,
    required int cityId,
    int? categoryId,
    double? minRating,
    String? language,
  }) async {
    try {
      final result = await remoteDataSource.searchPlaces(
        query: query,
        cityId: cityId,
        categoryId: categoryId,
        minRating: minRating,
        language: language,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}