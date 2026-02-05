// features/destination/domain/repositories/place_repository.dart

import 'package:dartz/dartz.dart';
import 'package:listys_app/core/errors/failures.dart';
import 'package:listys_app/features/destination/domain/entities/place.dart';

abstract class PlaceRepository {
  Future<Either<Failure, List<Place>>> getPlaces({
    String? query,
    int? cityId,
    int? categoryId,
    int? minRating,
  });
}