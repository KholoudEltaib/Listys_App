import 'package:equatable/equatable.dart';

class SearchCity extends Equatable {
  final int id;
  final String name;
  final String? nameAr;
  final int countryId;
  final int? placesCount;

  const SearchCity({
    required this.id,
    required this.name,
    this.nameAr,
    required this.countryId,
    this.placesCount,
  });

  String getLocalizedName(String locale) {
    return locale == 'ar' && nameAr != null ? nameAr! : name;
  }

  @override
  List<Object?> get props => [id, name, nameAr, countryId, placesCount];
}