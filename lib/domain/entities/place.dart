// domain/entities/place.dart
class Place {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final String location;
  final DateTime? fromDate;
  final DateTime? toDate;

  Place({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.location,
    this.fromDate,
    this.toDate,
  });
}