// features/profile/data/repositories/profile_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:listys_app/core/errors/failures.dart';
import 'package:listys_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:listys_app/features/profile/domain/entities/user.dart';
import 'package:listys_app/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> getProfile() async {
    try {
      final user = await remoteDataSource.getProfile();
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

@override
Future<Either<Failure, User>> updateProfile({
  required String name,
  required String email,
  String? imagePath,
}) async {
  try {
    final user = await remoteDataSource.updateProfile(
      name: name,
      email: email,
      imagePath: imagePath,
    );
    return Right(user);
  } catch (e) {
    return Left(
      ServerFailure(
        message: e.toString().replaceFirst('Exception: ', ''),
      ),
    );
  }
}


  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      await remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changeLanguage(String locale) async {
    try {
      await remoteDataSource.changeLanguage(locale);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await remoteDataSource.deleteAccount();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}