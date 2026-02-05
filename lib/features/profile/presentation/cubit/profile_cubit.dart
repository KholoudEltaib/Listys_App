// features/profile/presentation/cubit/profile_cubit.dart


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:listys_app/features/profile/domain/entities/user.dart';
import 'package:listys_app/features/profile/domain/usecases/delete_account_usecase.dart';
import 'package:listys_app/features/profile/domain/usecases/get_profile_usecase.dart' hide UpdateProfileUseCase;
import 'package:listys_app/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:listys_app/features/profile/domain/usecases/change_password_usecase.dart';
import 'package:listys_app/features/profile/domain/usecases/change_language_usecase.dart';


// States
abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;

  ProfileLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileUpdateLoading extends ProfileState {}

class ProfileUpdateSuccess extends ProfileState {
  final User user;

  ProfileUpdateSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileUpdateError extends ProfileState {
  final String message;

  ProfileUpdateError(this.message);

  @override
  List<Object?> get props => [message];
}

class PasswordChangeLoading extends ProfileState {}

class PasswordChangeSuccess extends ProfileState {}

class PasswordChangeError extends ProfileState {
  final String message;

  PasswordChangeError(this.message);

  @override
  List<Object?> get props => [message];
}

class LanguageChangeLoading extends ProfileState {}

class LanguageChangeSuccess extends ProfileState {}

class LanguageChangeError extends ProfileState {
  final String message;

  LanguageChangeError(this.message);

  @override
  List<Object?> get props => [message];
}

class AccountDeletionLoading extends ProfileState {}

class AccountDeleted extends ProfileState {}

class AccountDeletionError extends ProfileState {
  final String message;

  AccountDeletionError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileImageUploading extends ProfileState {}

class ProfileImageUploadSuccess extends ProfileState {
  final User user;
  ProfileImageUploadSuccess(this.user);
  @override
  List<Object?> get props => [user];
}

class ProfileImageUploadError extends ProfileState {
  final String message;
  ProfileImageUploadError(this.message);
  @override
  List<Object?> get props => [message];
}

// Cubit
class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final ChangePasswordUseCase changePasswordUseCase;
  final ChangeLanguageUseCase changeLanguageUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;


  User? _cachedUser;

  ProfileCubit({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.changePasswordUseCase,
    required this.changeLanguageUseCase,
    required this.deleteAccountUseCase,
  }) : super(ProfileInitial());

  User? get cachedUser => _cachedUser;

  Future<void> fetchProfile() async {
    emit(ProfileLoading());

    final result = await getProfileUseCase();

    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (user) {
        _cachedUser = user;
        emit(ProfileLoaded(user));
      },
    );
  }

  Future<void> updateProfileImage(String imagePath) async {
  if (_cachedUser == null) return;

  emit(ProfileImageUploading());

  final result = await updateProfileUseCase(
    name: _cachedUser!.name,
    email: _cachedUser!.email,
    imagePath: imagePath,
  );

  result.fold(
    (failure) {
      emit(ProfileImageUploadError(failure.message));
    },
    (user) {
      _cachedUser = user;
      emit(ProfileImageUploadSuccess(user));
    },
  );
}


  Future<void> updateProfile({
    required String name,
    required String email,
    String? imagePath,
  }) async {
    emit(ProfileUpdateLoading());

    final result = await updateProfileUseCase(
      name: name,
      email: email,
      imagePath: imagePath,
    );

    result.fold(
      (failure) => emit(ProfileUpdateError(failure.message)),
      (user) {
        _cachedUser = user;
        emit(ProfileUpdateSuccess(user));
      },
    );
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    if (isClosed) return;
    
    emit(PasswordChangeLoading());

    final result = await changePasswordUseCase(
      currentPassword: currentPassword,
      newPassword: newPassword,
      newPasswordConfirmation: newPasswordConfirmation,
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(PasswordChangeError(failure.message)),
      (_) => emit(PasswordChangeSuccess()),
    );
  }

  Future<void> changeLanguage(String locale) async {
    emit(LanguageChangeLoading());

    final result = await changeLanguageUseCase(locale);

    result.fold(
      (failure) => emit(LanguageChangeError(failure.message)),
      (_) => emit(LanguageChangeSuccess()),
    );
  }

  void resetToLoaded() {
    if (!isClosed && _cachedUser != null) {
      emit(ProfileLoaded(_cachedUser!));
    }
  }

  Future<void> deleteAccount() async {
    if (isClosed) return;
    
    print('🔥 ProfileCubit: Starting account deletion');
    emit(AccountDeletionLoading());

    try {
      final result = await deleteAccountUseCase();

      if (isClosed) {
        print('⚠️ ProfileCubit: Cubit closed during deletion');
        return;
      }

      result.fold(
        (failure) {
          print('❌ ProfileCubit: Delete account failed: ${failure.message}');
          emit(AccountDeletionError(failure.message));
        },
        (_) {
          print('✅ ProfileCubit: Account deleted successfully');
          _cachedUser = null;
          emit(AccountDeleted());
        },
      );
    } catch (e) {
      print('❌ ProfileCubit: Exception during deletion: $e');
      if (!isClosed) {
        emit(AccountDeletionError('Failed to delete account: $e'));
      }
    }
  }
}