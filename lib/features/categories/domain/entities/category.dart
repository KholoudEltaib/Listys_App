// features/categories/domain/entities/category.dart

class Category {
  final int id;
  final String name;
  final String? image;
  final String createdAt;
  final String updatedAt;

  const Category({
    required this.id,
    required this.name,
    this.image,
    required this.createdAt,
    required this.updatedAt,
  });
}