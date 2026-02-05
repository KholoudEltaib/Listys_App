// features/nearby_map/domain/repositories/places_repository.dart

import 'package:dartz/dartz.dart';
import 'package:listys_app/core/errors/failures.dart';
import 'package:listys_app/features/nearby_map/domain/entities/place_entity.dart';

abstract class PlacesRepository {
  Future<Either<Failure, List<PlacesEntity>>> getAllPlaces();
    Future<Either<Failure, List<PlacesEntity>>> getNearbyPlaces({
    required double userLatitude,
    required double userLongitude,
    double radiusInKm = 50.0,
  });
}