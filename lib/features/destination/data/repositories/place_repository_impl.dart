// features/destination/data/repositories/place_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:listys_app/core/errors/failures.dart';
import 'package:listys_app/features/destination/data/datasources/place_remote_datasource.dart';
import 'package:listys_app/features/destination/domain/entities/place.dart';
import 'package:listys_app/features/destination/domain/repositories/place_repository.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  final PlaceRemoteDataSource remoteDataSource;

  PlaceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Place>>> getPlaces({
    String? query,
    int? cityId,
    int? categoryId,
    int? minRating,
  }) async {
    try {
      final places = await remoteDataSource.getPlaces(
        query: query,
        cityId: cityId,
        categoryId: categoryId,
        minRating: minRating,
      );
      return Right(places);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}