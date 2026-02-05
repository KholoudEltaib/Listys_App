// features/categories/domain/usecases/get_categories_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:listys_app/core/errors/failures.dart';
import 'package:listys_app/features/categories/domain/entities/category.dart';
import 'package:listys_app/features/categories/domain/repositories/category_repository.dart';

class GetCategoriesUseCase {
  final CategoryRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<Either<Failure, List<Category>>> call(int cityId) async {
    return await repository.getCategories(cityId);
  }
}