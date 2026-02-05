// features/profile/domain/usecases/get_profile_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:listys_app/core/errors/failures.dart';
import 'package:listys_app/features/profile/domain/entities/user.dart';
import 'package:listys_app/features/profile/domain/repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<Either<Failure, User>> call() async {
    return await repository.getProfile();
  }
}

// features/profile/domain/usecases/update_profile_usecase.dart
class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, User>> call({
    required String name,
    required String email,
    String? imagePath,
  }) async {
    return await repository.updateProfile(
      name: name,
      email: email,
      imagePath: imagePath,
    );
  }
}
