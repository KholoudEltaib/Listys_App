// lib/features/favorite/presentation/cubit/favorite_state.dart
import 'package:equatable/equatable.dart';
import 'package:listys_app/features/home/domain/entities/home_entity.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<CountryEntity> countries;
  final List<PlaceEntity> places;
  final Set<int> favoriteCountryIds;
  final Set<int> favoritePlaceIds;

  const FavoriteLoaded({
    required this.countries,
    required this.places,
    required this.favoriteCountryIds,
    required this.favoritePlaceIds,
  });

  FavoriteLoaded copyWith({
    List<CountryEntity>? countries,
    List<PlaceEntity>? places,
    Set<int>? favoriteCountryIds,
    Set<int>? favoritePlaceIds,
  }) {
    return FavoriteLoaded(
      countries: countries ?? this.countries,
      places: places ?? this.places,
      favoriteCountryIds: favoriteCountryIds ?? this.favoriteCountryIds,
      favoritePlaceIds: favoritePlaceIds ?? this.favoritePlaceIds,
    );
  }

  @override
  List<Object?> get props => [countries, places, favoriteCountryIds, favoritePlaceIds];
}

class FavoriteEmpty extends FavoriteState {}

class FavoriteError extends FavoriteState {
  final String message;

  const FavoriteError(this.message);

  @override
  List<Object?> get props => [message];
}

class FavoriteToggling extends FavoriteState {
  final int id;
  final String type;

  const FavoriteToggling({required this.id, required this.type});

  @override
  List<Object?> get props => [id, type];
}