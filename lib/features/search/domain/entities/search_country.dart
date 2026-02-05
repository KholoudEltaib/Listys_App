import 'package:equatable/equatable.dart';

class SearchCountry extends Equatable {
  final int id;
  final String name;
  final String? nameAr;
  final int? citiesCount;

  const SearchCountry({
    required this.id,
    required this.name,
    this.nameAr,
    this.citiesCount,
  });

  String getLocalizedName(String locale) {
    return locale == 'ar' && nameAr != null ? nameAr! : name;
  }

  @override
  List<Object?> get props => [id, name, nameAr, citiesCount];
}