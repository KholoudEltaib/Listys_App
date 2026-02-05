// features/profile/domain/repositories/profile_repository.dart

import 'package:dartz/dartz.dart';
import 'package:listys_app/core/errors/failures.dart';
import 'package:listys_app/features/profile/domain/entities/user.dart';

abstract class ProfileRepository {
  Future<Either<Failure, User>> getProfile();
  
  Future<Either<Failure, User>> updateProfile({
    required String name,
    required String email,
    String? imagePath,
  });
  
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  });
  
  Future<Either<Failure, void>> changeLanguage(String locale);
  Future<Either<Failure, void>> deleteAccount();
}