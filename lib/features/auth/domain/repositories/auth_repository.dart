// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_result.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResult>> loginWithEmail(String email, String password);
  Future<Either<Failure, AuthResult>> register(String name, String email, String password);
  Future<Either<Failure, AuthResult>> loginWithInstagram(BuildContext context);
 Future<Either<Failure, AuthResult>> loginWithFacebook(BuildContext context);
  Future<Either<Failure, AuthResult>> loginWithGoogle(BuildContext context);
  Future<Either<Failure, User>> getUserProfile();
  Future<Either<Failure, User>> updateUserProfile({required String name, required String email});
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  });
  Future<Either<Failure, void>> deleteAccount();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, String?>> getToken();
  Future<Either<Failure, void>> saveToken(String token);
  Future<Either<Failure, bool>> isAuthenticated();
  Future<Either<Failure, User?>> getCachedUser();
}
