// features/destination/presentation/cubit/places_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/features/destination/domain/usecases/get_places_usecase.dart';
import 'package:listys_app/features/destination/presentation/cubit/place_state.dart';


// Cubit
class PlacesCubit extends Cubit<PlacesState> {
  final GetPlacesUseCase getPlacesUseCase;

  PlacesCubit(this.getPlacesUseCase) : super(PlacesInitial());

  Future<void> fetchPlaces({
    String? query,
    int? cityId,
    int? categoryId,
    int? minRating,
  }) async {
    emit(PlacesLoading());

    final result = await getPlacesUseCase(
      query: query,
      cityId: cityId,
      categoryId: categoryId,
      minRating: minRating,
    );

    result.fold(
      (failure) => emit(PlacesError(failure.message)),
      (places) => emit(PlacesLoaded(places)),
    );
  }

  void reset() {
    emit(PlacesInitial());
  }
}