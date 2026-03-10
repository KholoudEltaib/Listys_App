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

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await _checkAuthStatus();
    
    // ADD AWAIT HERE
    await result.fold(
      (failure) async {
        emit(AuthUnauthenticated());
      },
      (isAuthenticated) async {
        if (isAuthenticated) {
          final token = await StorageHelper.getToken();
          final userModel = await StorageHelper.getCachedUser();
          
          if (token != null && token.isNotEmpty && userModel != null) {
            emit(AuthAuthenticated(user: userModel, token: token));
          } else {
            emit(AuthUnauthenticated());
          }
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onLoginWithEmailRequested(
    LoginWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('🔵 Login started');
    emit(AuthLoading());
    
    final result = await _loginWithEmail(LoginWithEmailParams(
      email: event.email,
      password: event.password,
    ));
    
    print('🔵 Login result: $result');
    
    // ADD AWAIT HERE (you already have it)
    await result.fold(
      (failure) async {
        print('🔴 Login failed: ${failure.message}');
        emit(AuthError(message: failure.message));
      },
      (authResult) async {
        print('🟢 Login success! Token: ${authResult.token}');
        
        final userModel = UserModel.fromEntity(authResult.user);
        
        await StorageHelper.saveToken(authResult.token);
        await StorageHelper.saveUserData(userModel);
        
        print('🟢 Data saved, emitting authenticated');
        emit(AuthAuthenticated(
          user: userModel,
          token: authResult.token,
        ));
      },
    );
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('🔵 RegisterRequested event received');
    emit(AuthLoading());
    print('🔵 AuthLoading emitted');
    
    final result = await _register(
      RegisterParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );
    
    print('🔵 Register usecase completed, result: $result');
    
    // ADD AWAIT HERE (THIS IS WHAT'S MISSING!)
    await result.fold(
      (failure) async {
        print('🔴 Register failed: ${failure.message}');
        emit(AuthError(message: failure.message));
      },
      (authResult) async {
        print('🟢 Register success! Token: ${authResult.token}');
        
        final userModel = UserModel.fromEntity(authResult.user);
        print('🟢 UserModel created: $userModel');
        
        await StorageHelper.saveToken(authResult.token);
        await StorageHelper.saveUserData(userModel);
        print('🟢 Data saved to storage');
        
        emit(AuthAuthenticated(
          user: userModel,
          token: authResult.token,
        ));
        print('🟢 AuthAuthenticated emitted');
      },
    );
  }

  Future<void> _onLoginWithGoogleRequested(
    LoginWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await _loginWithGoogle(event.context);
    
    await result.fold(
      (failure) async => emit(AuthError(message: failure.message)),
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
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await _logout();
    
    // ADD AWAIT HERE
    await result.fold(
      (failure) async => emit(AuthError(message: failure.message)),
      (_) async {
        await StorageHelper.clearCache();
        emit(AuthUnauthenticated());
      },
    );
  }
}