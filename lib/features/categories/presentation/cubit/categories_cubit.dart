// features/categories/presentation/cubit/categories_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:listys_app/features/categories/presentation/cubit/categories_satet.dart';


// Cubit
class CategoriesCubit extends Cubit<CategoriesState> {
  final GetCategoriesUseCase getCategoriesUseCase;

  CategoriesCubit(this.getCategoriesUseCase) : super(CategoriesInitial());

  Future<void> fetchCategories(int cityId) async {
    emit(CategoriesLoading());

    final result = await getCategoriesUseCase(cityId);

    result.fold(
      (failure) => emit(CategoriesError(failure.message)),
      (categories) => emit(CategoriesLoaded(categories)),
    );
  }
}