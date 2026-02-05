import 'package:equatable/equatable.dart';

class SearchPlace extends Equatable {
  final int id;
  final String name;
  final String? nameAr;
  final String? description;
  final String? descriptionAr;
  final double? rating;
  final String? image;
  final int cityId;
  final int categoryId;

  const SearchPlace({
    required this.id,
    required this.name,
    this.nameAr,
    this.description,
    this.descriptionAr,
    this.rating,
    this.image,
    required this.cityId,
    required this.categoryId,
  });

  String getLocalizedName(String locale) {
    return locale == 'ar' && nameAr != null ? nameAr! : name;
  }

  String? getLocalizedDescription(String locale) {
    return locale == 'ar' && descriptionAr != null ? descriptionAr : description;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        nameAr,
        description,
        descriptionAr,
        rating,
        image,
        cityId,
        categoryId,
      ];
}