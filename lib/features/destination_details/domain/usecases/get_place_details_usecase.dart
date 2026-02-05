// features/destination_details/domain/usecases/get_place_details_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:listys_app/core/errors/failures.dart';
import 'package:listys_app/features/destination/domain/entities/place.dart';
import 'package:listys_app/features/destination_details/domain/repositories/place_details_repository.dart';

class GetPlaceDetailsUseCase {
  final PlaceDetailsRepository repository;

  GetPlaceDetailsUseCase(this.repository);

  Future<Either<Failure, Place>> call(int placeId) async {
    return await repository.getPlaceDetails(placeId);
  }
}