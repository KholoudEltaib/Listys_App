import 'package:listys_app/features/search/domain/entities/search_category.dart';

class SearchCategoryModel extends SearchCategory {
  const SearchCategoryModel({
    required super.id,
    required super.name,
    super.nameAr,
    super.icon,
  });

  factory SearchCategoryModel.fromJson(Map<String, dynamic> json) {
    return SearchCategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
      icon: json['icon'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'icon': icon,
    };
  }
}