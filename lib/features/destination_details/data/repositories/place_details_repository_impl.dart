// features/destination_details/data/repositories/place_details_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:listys_app/core/errors/failures.dart';
import 'package:listys_app/features/destination/domain/entities/place.dart';
import 'package:listys_app/features/destination_details/data/datasources/place_details_remote_datasource.dart';
import 'package:listys_app/features/destination_details/domain/repositories/place_details_repository.dart';

class PlaceDetailsRepositoryImpl implements PlaceDetailsRepository {
  final PlaceDetailsRemoteDataSource remoteDataSource;

  PlaceDetailsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Place>> getPlaceDetails(int placeId) async {
    try {
      final place = await remoteDataSource.getPlaceDetails(placeId);
      return Right(place);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}