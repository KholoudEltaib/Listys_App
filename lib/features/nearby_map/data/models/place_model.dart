import 'package:listys_app/features/nearby_map/domain/entities/place_entity.dart';

class PlaceModel extends PlacesEntity {
  const PlaceModel({
    required super.id,
    required super.name,
    required super.description,
    required super.shortDescription,
    required super.address,
    super.image,
    required super.latitude,
    required super.longitude,
    required super.cityName,
    required super.categoryName,
    required super.facilities,
    required super.averageRating,
    super.distanceInKm,
  });

  // ============================================================
  // REPLACE THIS ENTIRE METHOD with the safe version below
  // ============================================================
  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      shortDescription: json['short_description'] as String? ?? '',
      address: json['address'] as String? ?? '',
      image: json['image'] as String?,
      // Safe parsing for coordinates
      latitude: _parseDouble(json['latitude']) ?? 0.0,
      longitude: _parseDouble(json['longitude']) ?? 0.0,
      // Safe nested access
      cityName: (json['city'] as Map<String, dynamic>?)?['name'] as String? ?? 'Unknown',
      categoryName: (json['category'] as Map<String, dynamic>?)?['name'] as String? ?? 'Other',
      // Safe list handling
      facilities: (json['facilities'] as List<dynamic>?)
              ?.map((facility) => FacilityModel.fromJson(facility as Map<String, dynamic>))
              .toList() ??
          [],
      // Safe number parsing - THIS IS THE MAIN FIX
      averageRating: _parseDouble(json['average_rating']) ?? 0.0,
    );
  }

  // ADD THIS HELPER METHOD after the fromJson method
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  // Keep your toJson method exactly as is
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'short_description': shortDescription,
      'address': address,
      'image': image,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'city': {'name': cityName},
      'category': {'name': categoryName},
      'facilities': facilities
          .map((facility) => (facility as FacilityModel).toJson())
          .toList(),
      'average_rating': averageRating,
    };
  }
}

class FacilityModel extends FacilityEntity {
  const FacilityModel({
    required super.id,
    required super.name,
    required super.icon,
  });

  // REPLACE THIS METHOD with safe version
  factory FacilityModel.fromJson(Map<String, dynamic> json) {
    return FacilityModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
    );
  }

  // Keep toJson as is
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }
}

class PlacesResponseModel {
  final bool status;
  final String message;
  final List<PlaceModel> places;

  const PlacesResponseModel({
    required this.status,
    required this.message,
    required this.places,
  });

  // REPLACE THIS METHOD with safe version
  factory PlacesResponseModel.fromJson(Map<String, dynamic> json) {
    return PlacesResponseModel(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      places: (json['data'] as List<dynamic>?)
              ?.map((place) {
                try {
                  return PlaceModel.fromJson(place as Map<String, dynamic>);
                } catch (e) {
                  print('⚠️ Error parsing place: $e');
                  return null;
                }
              })
              .whereType<PlaceModel>() // Filters out nulls
              .toList() ??
          [],
    );
  }
}





























// // features/nearby_map/data/models/place_model.dart


// import 'package:listys_app/features/nearby_map/domain/entities/place_entity.dart';

// class PlaceModel extends PlacesEntity {
//   const PlaceModel({
//     required super.id,
//     required super.name,
//     required super.description,
//     required super.shortDescription,
//     required super.address,
//     super.image,
//     required super.latitude,
//     required super.longitude,
//     required super.cityName,
//     required super.categoryName,
//     required super.facilities,
//     required super.averageRating,
//     super.distanceInKm,
//   });

//   factory PlaceModel.fromJson(Map<String, dynamic> json) {
//     return PlaceModel(
//       id: json['id'] as int,
//       name: json['name'] as String,
//       description: json['description'] as String,
//       shortDescription: json['short_description'] as String,
//       address: json['address'] as String,
//       image: json['image'] as String?,
//       latitude: double.parse(json['latitude'].toString()),
//       longitude: double.parse(json['longitude'].toString()),
//       cityName: json['city']['name'] as String,
//       categoryName: json['category']['name'] as String,
//       facilities: (json['facilities'] as List)
//           .map((facility) => FacilityModel.fromJson(facility))
//           .toList(),
//       averageRating: (json['average_rating'] as num).toDouble(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'description': description,
//       'short_description': shortDescription,
//       'address': address,
//       'image': image,
//       'latitude': latitude.toString(),
//       'longitude': longitude.toString(),
//       'city': {'name': cityName},
//       'category': {'name': categoryName},
//       'facilities': facilities
//           .map((facility) => (facility as FacilityModel).toJson())
//           .toList(),
//       'average_rating': averageRating,
//     };
//   }
// }

// class FacilityModel extends FacilityEntity {
//   const FacilityModel({
//     required super.id,
//     required super.name,
//     required super.icon,
//   });

//   factory FacilityModel.fromJson(Map<String, dynamic> json) {
//     return FacilityModel(
//       id: json['id'] as int,
//       name: json['name'] as String,
//       icon: json['icon'] as String,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'icon': icon,
//     };
//   }
// }

// class PlacesResponseModel {
//   final bool status;
//   final String message;
//   final List<PlaceModel> places;

//   const PlacesResponseModel({
//     required this.status,
//     required this.message,
//     required this.places,
//   });

//   factory PlacesResponseModel.fromJson(Map<String, dynamic> json) {
//     return PlacesResponseModel(
//       status: json['status'] as bool,
//       message: json['message'] as String,
//       places: (json['data'] as List)
//           .map((place) => PlaceModel.fromJson(place))
//           .toList(),
//     );
//   }
// }