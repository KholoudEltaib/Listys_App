// features/destination_details/presentation/cubit/place_details_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:listys_app/features/destination/domain/entities/place.dart';
import 'package:listys_app/features/destination_details/domain/usecases/get_place_details_usecase.dart';

// States
abstract class PlaceDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PlaceDetailsInitial extends PlaceDetailsState {}

class PlaceDetailsLoading extends PlaceDetailsState {}

class PlaceDetailsLoaded extends PlaceDetailsState {
  final Place place;

  PlaceDetailsLoaded(this.place);

  @override
  List<Object?> get props => [place];
}

class PlaceDetailsError extends PlaceDetailsState {
  final String message;

  PlaceDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class PlaceDetailsCubit extends Cubit<PlaceDetailsState> {
  final GetPlaceDetailsUseCase getPlaceDetailsUseCase;

  PlaceDetailsCubit(this.getPlaceDetailsUseCase) : super(PlaceDetailsInitial());

  Future<void> fetchPlaceDetails(int placeId) async {
    emit(PlaceDetailsLoading());

    final result = await getPlaceDetailsUseCase(placeId);

    result.fold(
      (failure) => emit(PlaceDetailsError(failure.message)),
      (place) => emit(PlaceDetailsLoaded(place)),
    );
  }
}