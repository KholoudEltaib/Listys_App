import 'package:equatable/equatable.dart';

class SearchCategory extends Equatable {
  final int id;
  final String name;
  final String? nameAr;
  final String? icon;

  const SearchCategory({
    required this.id,
    required this.name,
    this.nameAr,
    this.icon,
  });

  String getLocalizedName(String locale) {
    return locale == 'ar' && nameAr != null ? nameAr! : name;
  }

  @override
  List<Object?> get props => [id, name, nameAr, icon];
}