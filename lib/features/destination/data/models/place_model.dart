// features/destination/data/models/place_model.dart

import 'package:listys_app/features/destination/domain/entities/place.dart';

class PlaceModel extends Place {
  const PlaceModel({
    required super.id,
    required super.name,
    super.description,
    super.shortDescription,
    required super.address,
    super.image,
    super.mainImage,
    super.gallery,
    super.price,
    super.rating,
    super.averageRating,
    super.reviewsCount,
    required super.latitude,
    required super.longitude,
    super.googleMapsUrl,
    required super.cityId,
    required super.categoryId,
    super.city,
    super.category,
    super.images = const [],
    super.facilities,
    super.reviews,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    /// -------- MAIN IMAGE LOGIC --------
    String? mainImage;
    
    // First check main_image field
    if (json['main_image'] is String && (json['main_image'] as String).isNotEmpty) {
      mainImage = json['main_image'];
    } 
    // Fallback to image field
    else if (json['image'] is String && (json['image'] as String).isNotEmpty) {
      mainImage = json['image'];
    }

    /// -------- GALLERY/IMAGES LOGIC --------
    List<Map<String, dynamic>> gallery = [];
    
    // Check gallery array first
    if (json['gallery'] is List && (json['gallery'] as List).isNotEmpty) {
      gallery = (json['gallery'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => {
                'id': e['id'],
                'image': e['image']?.toString(),
                'url': e['url']?.toString(),
              })
          .where((map) => map['image'] != null) // Filter out null images
          .toList();
    }
    // Fallback to images array
    else if (json['images'] is List && (json['images'] as List).isNotEmpty) {
      gallery = (json['images'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => {
                'id': e['id'],
                'image': e['image']?.toString(),
                'url': e['url']?.toString(),
              })
          .where((map) => map['image'] != null) // Filter out null images
          .toList();
    }

    /// -------- FACILITIES --------
    List<Facility> facilities = [];
    if (json['facilities'] is List) {
      facilities = (json['facilities'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => FacilityModel.fromJson(e))
          .toList();
    }

    /// -------- REVIEWS --------
    List<Review> reviews = [];
    if (json['reviews'] is List) {
      reviews = (json['reviews'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => ReviewModel.fromJson(e))
          .toList();
    }

    /// -------- CITY WITH COUNTRY --------
    CityInfo? city;
    if (json['city'] is Map<String, dynamic>) {
      city = CityInfoModel.fromJson(json['city']);
    }

    /// -------- CATEGORY --------
    CategoryInfo? category;
    if (json['category'] is Map<String, dynamic>) {
      category = CategoryInfoModel.fromJson(json['category']);
    }

    return PlaceModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description']?.toString(),
      shortDescription: json['short_description']?.toString(),
      address: json['address'] as String,
      image: mainImage,
      mainImage: mainImage,
      gallery: gallery,
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      averageRating: json['average_rating'] != null
          ? (json['average_rating'] as num).toDouble()
          : null,
      reviewsCount: json['reviews_count'] != null
          ? (json['reviews_count'] as num).toInt()
          : 0,
      latitude: json['latitude']?.toString() ?? '0.0',
      longitude: json['longitude']?.toString() ?? '0.0',
      googleMapsUrl: json['google_maps_url']?.toString(),
      cityId: json['city_id'] != null
          ? (json['city_id'] as num).toInt()
          : (city?.id ?? 0),
      categoryId: json['category_id'] != null
          ? (json['category_id'] as num).toInt()
          : (category?.id ?? 0),
      city: city,
      category: category,
      facilities: facilities,
      reviews: reviews,
      images: gallery,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'short_description': shortDescription,
      'address': address,
      'image': image,
      'main_image': mainImage,
      'gallery': gallery,
      'price': price,
      'rating': rating,
      'average_rating': averageRating,
      'reviews_count': reviewsCount,
      'latitude': latitude,
      'longitude': longitude,
      'google_maps_url': googleMapsUrl,
      'city_id': cityId,
      'category_id': categoryId,
      'city': city != null ? CityInfoModel.from(city!).toJson() : null,
      'category': category != null
          ? CategoryInfoModel.from(category!).toJson()
          : null,
      'facilities': facilities?.map((f) => FacilityModel.from(f).toJson()).toList(),
      'reviews': reviews?.map((r) => ReviewModel.from(r).toJson()).toList(),
      'images': images,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class CityInfoModel extends CityInfo {
  const CityInfoModel({
    required super.id,
    required super.name,
    super.description,
    super.image,
    required super.countryId,
    super.country,
  });

  factory CityInfoModel.fromJson(Map<String, dynamic> json) {
    CountryInfo? country;
    if (json['country'] is Map<String, dynamic>) {
      country = CountryInfoModel.fromJson(json['country']);
    }
    
    return CityInfoModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description']?.toString(),
      image: json['image']?.toString(),
      countryId: json['country_id'] as int,
      country: country,
    );
  }

  factory CityInfoModel.from(CityInfo city) {
    return CityInfoModel(
      id: city.id,
      name: city.name,
      description: city.description,
      image: city.image,
      countryId: city.countryId,
      country: city.country,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'country_id': countryId,
      'country': country != null
          ? CountryInfoModel.from(country!).toJson()
          : null,
    };
  }
}

class CategoryInfoModel extends CategoryInfo {
  const CategoryInfoModel({
    required super.id,
    required super.name,
    super.image,
  });

  factory CategoryInfoModel.fromJson(Map<String, dynamic> json) {
    return CategoryInfoModel(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image']?.toString(),
    );
  }

  factory CategoryInfoModel.from(CategoryInfo category) {
    return CategoryInfoModel(
      id: category.id,
      name: category.name,
      image: category.image,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}

class FacilityModel extends Facility {
  const FacilityModel({
    required super.id,
    required super.name,
    super.icon,
  });

  factory FacilityModel.fromJson(Map<String, dynamic> json) {
    return FacilityModel(
      id: json['id'] as int,
      name: json['name'] as String,
      icon: json['icon']?.toString(),
    );
  }

  factory FacilityModel.from(Facility facility) {
    return FacilityModel(
      id: facility.id,
      name: facility.name,
      icon: facility.icon,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }
}

class ReviewModel extends Review {
  const ReviewModel({
    required super.id,
    required super.rating,
    required super.comment,
    required super.user,
    required super.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as int,
      rating: (json['rating'] is String)
          ? double.tryParse(json['rating']) ?? 0.0
          : (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      user: UserModel.fromJson(json['user']),
      createdAt: json['created_at'] as String,
    );
  }

  factory ReviewModel.from(Review review) {
    return ReviewModel(
      id: review.id,
      rating: review.rating,
      comment: review.comment,
      user: review.user,
      createdAt: review.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating': rating,
      'comment': comment,
      'user': UserModel.from(user).toJson(),
      'created_at': createdAt,
    };
  }
}

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    super.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image']?.toString(),
    );
  }

  factory UserModel.from(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      image: user.image,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}

class CountryInfoModel extends CountryInfo {
  const CountryInfoModel({
    required super.id,
    required super.name,
    super.description,
    super.shortDescription,
    super.image,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CountryInfoModel.fromJson(Map<String, dynamic> json) {
    return CountryInfoModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description']?.toString(),
      shortDescription: json['short_description']?.toString(),
      image: json['image']?.toString(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  factory CountryInfoModel.from(CountryInfo country) {
    return CountryInfoModel(
      id: country.id,
      name: country.name,
      description: country.description,
      shortDescription: country.shortDescription,
      image: country.image,
      createdAt: country.createdAt,
      updatedAt: country.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'short_description': shortDescription,
      'image': image,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}