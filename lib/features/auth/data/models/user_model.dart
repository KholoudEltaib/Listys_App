import 'package:listys_app/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.profileImage,
    super.createdAt,
    super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profile_image'] ?? json['image'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_image': profileImage,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

factory UserModel.fromEntity(User user) {
  return UserModel(
    id: user.id,
    name: user.name,
    email: user.email,
    profileImage: user.profileImage,
    createdAt: user.createdAt,
    updatedAt: user.updatedAt,
  );
}

User toEntity() {
  return User(
    id: id,
    name: name,
    email: email,
    profileImage: profileImage,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

UserModel copyWith({
  String? id,
  String? name,
  String? email,
  String? profileImage,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  return UserModel(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    profileImage: profileImage ?? this.profileImage,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
}















// import '../../domain/entities/user.dart';

// class UserModel extends User {
//   const UserModel({
//     required super.id,
//     required super.name,
//     required super.email,
//     super.profileImage,
//     super.createdAt,
//     super.updatedAt,
//   });

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json['id']?.toString() ?? '',
//       name: json['name'] ?? '',
//       email: json['email'] ?? '',
//       profileImage: json['profile_image'] ?? json['image'],
//       createdAt: json['created_at'] != null 
//           ? DateTime.parse(json['created_at']) 
//           : null,
//       updatedAt: json['updated_at'] != null 
//           ? DateTime.parse(json['updated_at']) 
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'email': email,
//       'profile_image': profileImage,
//       'created_at': createdAt?.toIso8601String(),
//       'updated_at': updatedAt?.toIso8601String(),
//     };
//   }
// }
