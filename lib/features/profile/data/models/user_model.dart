// features/profile/data/models/user_model.dart

import 'package:listys_app/features/profile/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.image,
    required super.locale,
    required super.role,
    super.emailVerifiedAt,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
  return UserModel(
    id: json['id'],
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    image: json['image'],
    locale: json['locale'] ?? 'en',
    role: json['role'] ?? 'user',
    emailVerifiedAt: json['email_verified_at'] != null
        ? DateTime.tryParse(json['email_verified_at'])
        : null,
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );
}


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'image': image,
      'locale': locale,
      'role': role,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}