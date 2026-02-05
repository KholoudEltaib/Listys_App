import 'package:listys_app/features/search/domain/entities/search_place.dart';

class SearchPlaceModel extends SearchPlace {
  const SearchPlaceModel({
    required super.id,
    required super.name,
    super.nameAr,
    super.description,
    super.descriptionAr,
    super.rating,
    super.image,
    required super.cityId,
    required super.categoryId,
  });

  factory SearchPlaceModel.fromJson(Map<String, dynamic> json) {
    return SearchPlaceModel(
      id: json['id'] as int,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      image: json['image'] as String?,
      cityId: json['city_id'] as int,
      categoryId: json['category_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'description': description,
      'description_ar': descriptionAr,
      'rating': rating,
      'image': image,
      'city_id': cityId,
      'category_id': categoryId,
    };
  }
}