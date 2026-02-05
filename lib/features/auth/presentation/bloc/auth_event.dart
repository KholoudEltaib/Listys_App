// features/auth/presentation/bloc/auth_event.dart
import 'package:flutter/material.dart';

abstract class AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

class LoginWithEmailRequested extends AuthEvent {
  final String email;
  final String password;

  LoginWithEmailRequested({
    required this.email,
    required this.password,
  });
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;

  RegisterRequested({
    required this.name,
    required this.email,
    required this.password,
  });
}

class LoginWithFacebookRequested extends AuthEvent {
  final BuildContext context;

  LoginWithFacebookRequested({ required this.context});
}

class LoginWithGoogleRequested extends AuthEvent {
  final BuildContext context;

  LoginWithGoogleRequested({ required this.context});
} 

class LoginWithInstagramRequested extends AuthEvent {
  final BuildContext context;

  LoginWithInstagramRequested({ required this.context});
}

class LogoutRequested extends AuthEvent {}


