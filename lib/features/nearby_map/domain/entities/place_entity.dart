// features/nearby_map/domain/entities/place_entity.dart

import 'package:equatable/equatable.dart';

class PlacesEntity extends Equatable {
  final int id;
  final String name;
  final String description;
  final String shortDescription;
  final String address;
  final String? image;
  final double latitude;
  final double longitude;
  final String cityName;
  final String categoryName;
  final List<FacilityEntity> facilities;
  final double averageRating;
  final double? distanceInKm; // Distance from user's location

  const PlacesEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.shortDescription,
    required this.address,
    this.image,
    required this.latitude,
    required this.longitude,
    required this.cityName,
    required this.categoryName,
    required this.facilities,
    required this.averageRating,
    this.distanceInKm,
  });

  PlacesEntity copyWith({
    int? id,
    String? name,
    String? description,
    String? shortDescription,
    String? address,
    String? image,
    double? latitude,
    double? longitude,
    String? cityName,
    String? categoryName,
    List<FacilityEntity>? facilities,
    double? averageRating,
    double? distanceInKm,
  }) {
    return PlacesEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      address: address ?? this.address,
      image: image ?? this.image,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      cityName: cityName ?? this.cityName,
      categoryName: categoryName ?? this.categoryName,
      facilities: facilities ?? this.facilities,
      averageRating: averageRating ?? this.averageRating,
      distanceInKm: distanceInKm ?? this.distanceInKm,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        shortDescription,
        address,
        image,
        latitude,
        longitude,
        cityName,
        categoryName,
        facilities,
        averageRating,
        distanceInKm,
      ];
}

class FacilityEntity extends Equatable {
  final int id;
  final String name;
  final String icon;

  const FacilityEntity({
    required this.id,
    required this.name,
    required this.icon,
  });

  @override
  List<Object> get props => [id, name, icon];
}