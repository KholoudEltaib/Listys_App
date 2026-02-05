class HomeEntity {
  final List<CountryEntity> popularCountries;
  final List<PlaceEntity> popularPlaces;
  final List<CategoryEntity> categories;

  HomeEntity({
    required this.popularCountries,
    required this.popularPlaces,
    required this.categories,
  });
}

// ---------------- COUNTRY ----------------
class CountryEntity {
  final int id;
  final String name;
  final String shortDescription;
  final String description;
  final String image;
  final List<CityEntity> cities;

  CountryEntity({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.description,
    required this.image,
    required this.cities,
  });
}

class CityEntity {
  final int id;
  final String name;

  CityEntity({
    required this.id,
    required this.name,
  });
}

// ---------------- PLACE ----------------
class PlaceEntity {
  final int id;
  final String name;
  final String shortDescription;
  final String address;
  final double? rating;
  final String cityName;
  final String countryName;
  final String categoryName;
  final String image;
  

  PlaceEntity({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.address,
    this.rating,
    required this.cityName,
    required this.countryName,
    required this.categoryName,
    required this.image,
  });
}

// ---------------- CATEGORY ----------------
class CategoryEntity {
  final int id;
  final String name;

  CategoryEntity({
    required this.id,
    required this.name,
  });
}
