// lib/features/favorite/domain/entities/favorite_entity.dart
import 'package:listys_app/features/home/domain/entities/home_entity.dart';

class FavoriteEntity {
  final List<CountryEntity> countries;
  final List<PlaceEntity> places;

  FavoriteEntity({
    required this.countries,
    required this.places,
  });
}