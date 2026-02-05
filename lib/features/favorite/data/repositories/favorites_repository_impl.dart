// lib/features/favorite/data/repositories/favorite_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:listys_app/core/errors/failures.dart';
import 'package:listys_app/features/favorite/data/datasources/favorite_remote_data_source.dart';
import 'package:listys_app/features/favorite/domain/entities/favorite_entity.dart';
import 'package:listys_app/features/favorite/domain/repositories/favorite_repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteRemoteDataSource remoteDataSource;

  FavoriteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, FavoriteEntity>> getFavorites() async {
    try {
      final favorites = await remoteDataSource.getFavorites();
      return Right(favorites);
    } catch (e) {
      return Left(ServerFailure( message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite({
    required int id,
    required String type,
  }) async {
    try {
      await remoteDataSource.toggleFavorite(id: id, type: type);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}