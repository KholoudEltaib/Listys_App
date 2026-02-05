
// lib/features/favorite/domain/usecases/toggle_favorite_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:listys_app/core/errors/failures.dart';
import 'package:listys_app/features/favorite/domain/repositories/favorite_repository.dart';

class ToggleFavoriteUseCase {
  final FavoriteRepository repository;

  ToggleFavoriteUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required int id,
    required String type,
  }) async {
    return await repository.toggleFavorite(id: id, type: type);
  }
}