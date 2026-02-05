// features/destination_details/domain/repositories/place_details_repository.dart

import 'package:dartz/dartz.dart';
import 'package:listys_app/core/errors/failures.dart';
import 'package:listys_app/features/destination/domain/entities/place.dart';

abstract class PlaceDetailsRepository {
  Future<Either<Failure, Place>> getPlaceDetails(int placeId);
}