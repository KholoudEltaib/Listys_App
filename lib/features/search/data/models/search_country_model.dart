import 'package:listys_app/features/search/domain/entities/search_country.dart';

class SearchCountryModel extends SearchCountry {
  const SearchCountryModel({
    required super.id,
    required super.name,
    super.nameAr,
    super.citiesCount,
  });

  factory SearchCountryModel.fromJson(Map<String, dynamic> json) {
    return SearchCountryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
      citiesCount: json['cities_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'cities_count': citiesCount,
    };
  }
}