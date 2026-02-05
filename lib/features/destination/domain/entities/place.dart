// features/destination/domain/entities/place.dart

import 'package:equatable/equatable.dart';

class Place extends Equatable {
  final int id;
  final String name;
  final String? description;
  final String? shortDescription;
  final String address;
  final String? image;
  final double? price;
  final double? rating;
  final String latitude;
  final String longitude;
  final int cityId;
  final int categoryId;
  final CityInfo? city;
  final CategoryInfo? category;
  final List<Map<String, dynamic>> images;
  final double? averageRating;
  final String createdAt;
  final String updatedAt;
  final String? mainImage;
  final List<Map<String, dynamic>>? gallery;
  final List<Facility>? facilities;
  final List<Review>? reviews;
  final String? googleMapsUrl;
  final int? reviewsCount;

  const Place({
    required this.id,
    required this.name,
    this.description,
    this.shortDescription,
    required this.address,
    this.image,
    this.price,
    this.rating,
    required this.latitude,
    required this.longitude,
    required this.cityId,
    required this.categoryId,
    this.city,
    this.category,
    this.images = const [],
    this.averageRating,
    required this.createdAt,
    required this.updatedAt,
    this.mainImage,
    this.gallery,
    this.facilities,
    this.reviews,
    this.googleMapsUrl,
    this.reviewsCount,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        latitude,
        longitude,
        cityId,
        categoryId,
        createdAt,
        updatedAt,
      ];
}

class CityInfo extends Equatable {
  final int id;
  final String name;
  final String? description;
  final String? image;
  final int countryId;
  final CountryInfo? country; 
  const CityInfo({
    required this.id,
    required this.name,
    this.description,
    this.image,
    required this.countryId,
    this.country,
  });

  @override
  List<Object?> get props => [id, name, countryId];
}

class CountryInfo extends Equatable {
  final int id;
  final String name;
  final String? description;
  final String? shortDescription;
  final String? image;
  final String createdAt;
  final String updatedAt;

  const CountryInfo({
    required this.id,
    required this.name,
    this.description,
    this.shortDescription,
    this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name];
}

class CategoryInfo extends Equatable {
  final int id;
  final String name;
  final String? image;

  const CategoryInfo({
    required this.id,
    required this.name,
    this.image,
  });

  @override
  List<Object?> get props => [id, name];
}

class Facility extends Equatable {
  final int id;
  final String name;
  final String? icon;

  const Facility({
    required this.id,
    required this.name,
    this.icon,
  });

  @override
  List<Object?> get props => [id, name];
}

class Review extends Equatable {
  final int id;
  final double rating;
  final String comment;
  final User user;
  final String createdAt;

  const Review({
    required this.id,
    required this.rating,
    required this.comment,
    required this.user,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, rating, comment, user.id, createdAt];
}

class User extends Equatable {
  final int id;
  final String name;
  final String? image;

  const User({
    required this.id,
    required this.name,
    this.image,
  });

  @override
  List<Object?> get props => [id, name];
}