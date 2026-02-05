import 'package:listys_app/features/search/domain/entities/search_city.dart';

class SearchCityModel extends SearchCity {
  const SearchCityModel({
    required super.id,
    required super.name,
    super.nameAr,
    required super.countryId,
    super.placesCount,
  });

  factory SearchCityModel.fromJson(Map<String, dynamic> json) {
    return SearchCityModel(
      id: json['id'] as int,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
      countryId: json['country_id'] as int,
      placesCount: json['places_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'country_id': countryId,
      'places_count': placesCount,
    };
  }
}