import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

class LoginWithInstagram {
  final AuthRepository repository;

  LoginWithInstagram(this.repository);

  Future<Either<Failure, AuthResult>> call(BuildContext context) async {
    return await repository.loginWithInstagram(context);
  }
}