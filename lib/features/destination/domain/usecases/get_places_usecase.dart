// features/destination/domain/usecases/get_places_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:listys_app/core/errors/failures.dart';
import 'package:listys_app/features/destination/domain/entities/place.dart';
import 'package:listys_app/features/destination/domain/repositories/place_repository.dart';

class GetPlacesUseCase {
  final PlaceRepository repository;

  GetPlacesUseCase(this.repository);

  Future<Either<Failure, List<Place>>> call({
    String? query,
    int? cityId,
    int? categoryId,
    int? minRating,
  }) async {
    return await repository.getPlaces(
      query: query,
      cityId: cityId,
      categoryId: categoryId,
      minRating: minRating,
    );
  }
}