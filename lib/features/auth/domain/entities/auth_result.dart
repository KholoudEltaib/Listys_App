import 'package:equatable/equatable.dart';
import 'package:listys_app/features/auth/domain/entities/user.dart';

class AuthResult extends Equatable {
  final String token;
  final User user;

  const AuthResult({
    required this.token,
    required this.user,
  });

  @override
  List<Object> get props => [token];
}