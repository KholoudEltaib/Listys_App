// features/profile/domain/entities/user.dart

class User {
  final int id;
  final String name;
  final String email;
  final String? image;
  final String locale;
  final String role;
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.image,
    required this.locale,
    required this.role,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 🔹 Full URL for profile image (safe for UI use)
  String get fullImageUrl {
    if (image == null || image!.isEmpty) return '';
    return 'https://listys.net/storage/$image';
  }

  /// 🔹 Helper: check if user has profile image
  bool get hasImage => image != null && image!.isNotEmpty;
}
