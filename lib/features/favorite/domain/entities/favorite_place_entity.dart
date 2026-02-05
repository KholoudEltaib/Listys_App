
// // domain/entities/favorite_place.dart

// class FavoritePlace {
//   final int id;
//   final String name;
//   final String shortDescription;
//   final String address;
//   final double? rating;
//   final String cityName;
//   final String countryName;
//   final String categoryName;
//   final String image;

//   FavoritePlace({
//     required this.id,
//     required this.name,
//     required this.shortDescription,
//     required this.address,
//     this.rating,
//     required this.cityName,
//     required this.countryName,
//     required this.categoryName,
//     required this.image,
//   });

//   factory FavoritePlace.fromJson(Map<String, dynamic> json) {
//     final city = json['city'] as Map<String, dynamic>?;
//     final country = city != null ? city['country'] as Map<String, dynamic>? : null;
//     final category = json['category'] as Map<String, dynamic>?;

//     final ratingValue = json['rating'];
//     final doubleRating =
//         ratingValue is num ? ratingValue.toDouble() : null;

//     return FavoritePlace(
//       id: json['id'] as int,
//       name: json['name'] as String,
//       shortDescription: (json['short_description'] ?? '') as String,
//       address: (json['address'] ?? '') as String,
//       rating: doubleRating,
//       cityName: (city?['name'] ?? '') as String,
//       countryName: (country?['name'] ?? '') as String,
//       categoryName: (category?['name'] ?? '') as String,
//       image: (json['image'] ?? '') as String,
//     );
//   }
// }

