// features/profile/domain/usecases/change_language_usecase.dart
import 'package:listys_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:listys_app/core/errors/failures.dart';

class ChangeLanguageUseCase {
  final ProfileRepository repository;

  ChangeLanguageUseCase(this.repository);

  Future<Either<Failure, void>> call(String locale) async {
    return await repository.changeLanguage(locale);
  }
}