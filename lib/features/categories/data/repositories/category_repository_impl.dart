// features/categories/data/repositories/category_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:listys_app/core/errors/failures.dart';
import 'package:listys_app/features/categories/data/datasources/category_remote_datasource.dart';
import 'package:listys_app/features/categories/domain/entities/category.dart';
import 'package:listys_app/features/categories/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Category>>> getCategories(int cityId) async {
    try {
      final categories = await remoteDataSource.getCategories(cityId);
      return Right(categories);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}