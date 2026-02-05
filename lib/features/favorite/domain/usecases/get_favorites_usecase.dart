// lib/features/favorite/domain/usecases/get_favorites_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:listys_app/core/errors/failures.dart';
import 'package:listys_app/features/favorite/domain/entities/favorite_entity.dart';
import 'package:listys_app/features/favorite/domain/repositories/favorite_repository.dart';

class GetFavoritesUseCase {
  final FavoriteRepository repository;

  GetFavoritesUseCase(this.repository);

  Future<Either<Failure, FavoriteEntity>> call() async {
    return await repository.getFavorites();
  }
}
