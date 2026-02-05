// lib/features/favorite/domain/repositories/favorite_repository.dart
import 'package:dartz/dartz.dart';
import 'package:listys_app/core/errors/failures.dart';
import 'package:listys_app/features/favorite/domain/entities/favorite_entity.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, FavoriteEntity>> getFavorites();
  Future<Either<Failure, void>> toggleFavorite({
    required int id,
    required String type, 
  });
}