import '../../domain/entities/home_entity.dart';

// ================= HOME =================
class HomeModel extends HomeEntity {
  HomeModel({
    required super.popularCountries,
    required super.popularPlaces,
    required super.categories,
  });

  // factory HomeModel.fromJson(Map<String, dynamic> json) {
  //   return HomeModel(
  //     popularCountries: (json['popular_countries'] as List)
  //         .map((e) => CountryModel.fromJson(e))
  //         .toList(),
  //     popularPlaces: (json['popular_places'] as List)
  //         .map((e) => PlaceModel.fromJson(e))
  //         .toList(),
  //     categories: (json['categories'] as List)
  //         .map((e) => CategoryModel.fromJson(e))
  //         .toList(),
  //   );
  // }
  factory HomeModel.fromJson(Map<String, dynamic> json) {
  return HomeModel(
    popularCountries: (json['popular_countries'] as List? ?? [])
        .map((e) => CountryModel.fromJson(e))
        .toList(),

    popularPlaces: (json['popular_places'] as List? ?? [])
        .map((e) => PopularPlaceModel.fromJson(e))
        .toList(),

    categories: (json['categories'] as List? ?? [])
        .map((e) => CategoryModel.fromJson(e))
        .toList(),
  );
}

}

// ================= COUNTRY =================
class CountryModel extends CountryEntity {
  CountryModel({
    required super.id,
    required super.name,
    required super.description,
    required super.shortDescription,
    required super.image,
    required super.cities,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    
    return CountryModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      shortDescription: json['short_description'] ?? '',
      image: json['image'] ?? '',
      cities: (json['cities'] as List)
          .map((e) => CityModel.fromJson(e))
          .toList(),
    );
  }
}

class CityModel extends CityEntity {
  CityModel({
    required super.id,
    required super.name,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

// ================= PLACE =================
class PopularPlaceModel extends PlaceEntity {
  PopularPlaceModel({
    required super.id,
    required super.name,
    required super.shortDescription,
    required super.address,
    super.rating,
    required super.cityName,
    required super.countryName,
    required super.categoryName,
    required super.image,
  });

  factory PopularPlaceModel.fromJson(Map<String, dynamic> json) {
    final city = json['city'] as Map<String, dynamic>?;
    final country = city?['country'] as Map<String, dynamic>?;
    final category = json['category'] as Map<String, dynamic>?;
    
    return PopularPlaceModel(
      id: json['id'],
      name: json['name'] ?? '',
      shortDescription: json['short_description'] ?? '',
      address: json['address'] ?? '',
      rating: json['rating'] != null
          ? double.tryParse(json['rating'].toString())
          : null,
      cityName: city?['name'] ?? '',
      countryName: country?['name'] ?? '',
      categoryName: category?['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

// ================= CATEGORY =================
class CategoryModel extends CategoryEntity {
  CategoryModel({
    required super.id,
    required super.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
