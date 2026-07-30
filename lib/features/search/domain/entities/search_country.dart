import 'package:equatable/equatable.dart';

class SearchCountry extends Equatable {
  final int id;
  final String name;
  final String? nameAr;
  final int? citiesCount;
  final String? image;

  const SearchCountry({
    required this.id,
    required this.name,
    this.nameAr,
    this.citiesCount,
    this.image
  });

  factory SearchCountry.fromJson(Map<String, dynamic> json) {

    print('===> Raw JSON inside Model for ${json['name']}: $json');
    
    return SearchCountry(
      id: json['id'],
      name: json['name'] ?? '',
      image: json['image'], 
    );
  }

  String getLocalizedName(String locale) {
    return locale == 'ar' && nameAr != null ? nameAr! : name;
  }

  @override
  List<Object?> get props => [id, name, nameAr, citiesCount, image];
}