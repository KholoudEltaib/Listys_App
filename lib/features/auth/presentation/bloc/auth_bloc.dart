// features/auth/presentation/bloc/auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_with_email.dart';
import '../../domain/usecases/register.dart';
import '../../domain/usecases/login_with_google.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/check_auth_status.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';
import '../../../../core/utils/storage_helper.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithEmail _loginWithEmail;
  final Register _register;
  final LoginWithGoogle _loginWithGoogle;
  final Logout _logout;
  final CheckAuthStatus _checkAuthStatus;
  final AuthRepository _authRepository;

  AuthBloc({
    required LoginWithEmail loginWithEmail,
    required Register register,
    required LoginWithGoogle loginWithGoogle,
    required Logout logout,
    required CheckAuthStatus checkAuthStatus,
    required AuthRepository authRepository,
  })  : _loginWithEmail = loginWithEmail,
        _register = register,
        _loginWithGoogle = loginWithGoogle,
        _logout = logout,
        _checkAuthStatus = checkAuthStatus,
        _authRepository = authRepository,
        super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoginWithEmailRequested>(_onLoginWithEmailRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LoginWithGoogleRequested>(_onLoginWithGoogleRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  // ─── Auth Check ───────────────────────────────────────────────────────────

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _checkAuthStatus();

    await result.fold(
      (failure) async {
        // Could not check status — treat as unauthenticated
        await StorageHelper.clearCache();
        emit(AuthUnauthenticated());
      },
      (isAuthenticated) async {
        if (!isAuthenticated) {
          emit(AuthUnauthenticated());
          return;
        }

        final token = await StorageHelper.getToken();
        final userModel = await StorageHelper.getCachedUser();

        if (token != null && token.isNotEmpty && userModel != null) {
          emit(AuthAuthenticated(user: userModel, token: token));
        } else {
          // Token or user missing — clear everything and force re-login
          await StorageHelper.clearCache();
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  // ─── Email Login ──────────────────────────────────────────────────────────

  Future<void> _onLoginWithEmailRequested(
    LoginWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    // Clear any stale cached session before a fresh login attempt.
    // This prevents old tokens from leaking into the new session.
    await StorageHelper.clearCache();

    try {
      final result = await _loginWithEmail(LoginWithEmailParams(
        email: event.email,
        password: event.password,
      ));

      await result.fold(
        (failure) async {
          // Wrong credentials, network error, 401, etc.
          emit(AuthError(message: failure.message));
        },
        (authResult) async {
          final userModel = UserModel.fromEntity(authResult.user);

          // Always await storage writes so the state is consistent
          await StorageHelper.saveToken(authResult.token);
          await StorageHelper.saveUserData(userModel);

          emit(AuthAuthenticated(
            user: userModel,
            token: authResult.token,
          ));
        },
      );
    } catch (e) {
      // Unexpected runtime error — never leave the user stuck on loading
      emit( AuthError(message: 'Something went wrong. Please try again.'));
    }
  }

  // ─── Register ─────────────────────────────────────────────────────────────

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    await StorageHelper.clearCache();

    try {
      final result = await _register(
        RegisterParams(
          name: event.name,
          email: event.email,
          password: event.password,
        ),
      );

      await result.fold(
        (failure) async {
          emit(AuthError(message: failure.message));
        },
        (authResult) async {
          final userModel = UserModel.fromEntity(authResult.user);

          await StorageHelper.saveToken(authResult.token);
          await StorageHelper.saveUserData(userModel);

          emit(AuthAuthenticated(
            user: userModel,
            token: authResult.token,
          ));
        },
      );
    } catch (e) {
      emit( AuthError(message: 'Something went wrong. Please try again.'));
    }
  }

  // ─── Google Login ─────────────────────────────────────────────────────────

  Future<void> _onLoginWithGoogleRequested(
    LoginWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    await StorageHelper.clearCache();

    try {
      final result = await _loginWithGoogle(event.context);

      await result.fold(
        (failure) async {
          emit(AuthError(message: failure.message));
        },
        (authResult) async {
          final userModel = UserModel.fromEntity(authResult.user);

          await StorageHelper.saveToken(authResult.token);
          await StorageHelper.saveUserData(userModel);

          emit(AuthAuthenticated(
            user: userModel,
            token: authResult.token,
          ));
        },
      );
    } catch (e) {
      emit( AuthError(message: 'Google sign-in failed. Please try again.'));
    }
  }

  // ─── Logout ───────────────────────────────────────────────────────────────

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _logout();

    await result.fold(
      (failure) async {
        // Even if the server-side logout fails, clear local data
        // so the user is never stuck in a broken authenticated state.
        await StorageHelper.clearCache();
        emit(AuthUnauthenticated());
      },
      (_) async {
        await StorageHelper.clearCache();
        emit(AuthUnauthenticated());
      },
    );
  }
}