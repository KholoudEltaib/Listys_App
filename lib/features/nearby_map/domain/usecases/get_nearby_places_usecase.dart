// features/nearby_map/domain/usecases/get_nearby_places_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:listys_app/core/usecases/usecase.dart';
import 'package:listys_app/features/nearby_map/domain/entities/place_entity.dart';
import 'package:listys_app/features/nearby_map/domain/repositories/places_repository.dart';

class GetNearbyPlacesUseCase
  implements UseCase<List<PlacesEntity>, NearbyPlacesParams> {
  final PlacesRepository repository;

  GetNearbyPlacesUseCase(this.repository);

  @override
  Future<Either<Failure, List<PlacesEntity>>> call(
    NearbyPlacesParams params,
  ) {
    return repository.getNearbyPlaces(
      userLatitude: params.userLatitude,
      userLongitude: params.userLongitude,
      radiusInKm: params.radiusInKm,
    );
  }
}


class NearbyPlacesParams extends Equatable {
  final double userLatitude;
  final double userLongitude;
  final double radiusInKm;

  const NearbyPlacesParams({
    required this.userLatitude,
    required this.userLongitude,
    this.radiusInKm = 50.0,
  });

  @override
  List<Object> get props => [userLatitude, userLongitude, radiusInKm];
}

