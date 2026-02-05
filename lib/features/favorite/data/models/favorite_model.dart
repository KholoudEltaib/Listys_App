// lib/features/favorite/data/models/favorite_model.dart
import 'package:listys_app/features/favorite/domain/entities/favorite_entity.dart';
import 'package:listys_app/features/home/data/models/home_model.dart';

class FavoriteModel extends FavoriteEntity {
  FavoriteModel({
    required super.countries,
    required super.places,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      countries: (json['countries'] as List<dynamic>?)
              ?.map((c) => CountryModel.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
      places: (json['places'] as List<dynamic>?)
              ?.map((p) => PopularPlaceModel.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}