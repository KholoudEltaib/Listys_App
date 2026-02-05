// // domain/entities/favorite_country.dart

// class FavoriteCountry {
//   final int id;
//   final String name;
//   final String shortDescription;
//   final String image;
//   final List<FavoriteCity> cities;

//   FavoriteCountry({
//     required this.id,
//     required this.name,
//     required this.shortDescription,
//     required this.image,
//     required this.cities,
//   });

//   factory FavoriteCountry.fromJson(Map<String, dynamic> json) {
//     final citiesJson = (json['cities'] as List?) ?? [];
//     return FavoriteCountry(
//       id: json['id'] as int,
//       name: json['name'] as String,
//       shortDescription: (json['short_description'] ?? '') as String,
//       image: (json['image'] ?? '') as String,
//       cities: citiesJson
//           .map((c) => FavoriteCity.fromJson(c as Map<String, dynamic>))
//           .toList(),
//     );
//   }
// }

// class FavoriteCity {
//   final int id;
//   final String name;

//   FavoriteCity({
//     required this.id,
//     required this.name,
//   });

//   factory FavoriteCity.fromJson(Map<String, dynamic> json) => FavoriteCity(
//         id: json['id'] as int,
//         name: json['name'] as String,
//       );
// }
