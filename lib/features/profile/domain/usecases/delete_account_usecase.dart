// lib/features/profile/domain/usecases/delete_account_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:listys_app/core/errors/failures.dart';
import 'package:listys_app/features/profile/domain/repositories/profile_repository.dart';

class DeleteAccountUseCase {
  final ProfileRepository repository;

  DeleteAccountUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.deleteAccount();
  }
}