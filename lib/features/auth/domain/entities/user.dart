// features/auth/domain/entities/user.dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, email, profileImage, createdAt, updatedAt];

  @override
  bool get stringify => true;
}


















// import 'package:equatable/equatable.dart';

// class User extends Equatable {
//   final String id;
//   final String name;
//   final String email;
//   final String? profileImage;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;

//   const User({
//     required this.id,
//     required this.name,
//     required this.email,
//     this.profileImage,
//     this.createdAt,
//     this.updatedAt,
//   });

//   @override
//   List<Object?> get props => [
//         id,
//         name,
//         email,
//         profileImage,
//         createdAt,
//         updatedAt,
//       ];
// }
