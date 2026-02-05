# Flutter Clean Architecture Refactoring - Complete Summary

## 📁 New Folder Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_constants.dart          # App-wide constants (paths, keys, etc.)
│   │   └── api_endpoints.dart          # API endpoint definitions
│   ├── errors/
│   │   ├── exceptions.dart             # Exception classes (ServerException, NetworkException, etc.)
│   │   └── failures.dart              # Failure classes for Either pattern
│   ├── network/
│   │   └── dio_client.dart            # Dio client with interceptors
│   ├── utils/
│   │   └── storage_helper.dart        # Storage helper (SecureStorage + SharedPreferences)
│   ├── localization/
│   │   └── app_localizations.dart     # Re-export from l10n
│   ├── theme/                         # Theme files (existing)
│   ├── widgets/                       # Common widgets (existing)
│   └── di/
│       └── injection.dart            # Dependency injection setup
│
└── features/
    └── auth/                          # Example feature structure
        ├── data/
        │   ├── models/
        │   │   ├── auth_result_model.dart
        │   │   └── user_model.dart
        │   ├── datasources/
        │   │   ├── auth_local_datasource.dart    # FlutterSecureStorage + SharedPreferences
        │   │   └── auth_remote_datasource.dart   # Dio-based API calls
        │   └── repositories/
        │       └── auth_repository_impl.dart
        ├── domain/
        │   ├── entities/
        │   │   ├── auth_result.dart
        │   │   └── user.dart
        │   ├── repositories/
        │   │   └── auth_repository.dart
        │   └── usecases/
        │       ├── login_with_email.dart
        │       ├── register.dart
        │       ├── login_with_instagram.dart
        │       ├── login_with_facebook.dart
        │       ├── login_with_google.dart
        │       ├── logout.dart
        │       └── check_auth_status.dart
        └── presentation/
            ├── bloc/
            │   ├── auth_bloc.dart
            │   ├── auth_event.dart
            │   └── auth_state.dart
            ├── screens/
            └── widgets/
```

## 🔑 Key Code Examples

### 1. Dio Client Setup (`lib/core/network/dio_client.dart`)

```dart
class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Request interceptor - Add token to headers
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await StorageHelper.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          final locale = await StorageHelper.getLocale();
          if (locale != null) {
            options.headers['lang'] = locale;
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          // Handle 401, network errors, etc.
          if (error.response?.statusCode == 401) {
            StorageHelper.clearCache();
            // Emit logout event
          }
          return handler.next(error);
        },
      ),
    );
  }
}
```

### 2. Storage Helper (`lib/core/utils/storage_helper.dart`)

```dart
class StorageHelper {
  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static SharedPreferences? _prefs;

  // Token Management (Secure Storage)
  static Future<void> saveToken(String token) async {
    await _secureStorage.write(key: AppConstants.tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _secureStorage.read(key: AppConstants.tokenKey);
  }

  // User Data Management (SharedPreferences)
  static Future<void> saveUserData(UserModel user) async {
    await init();
    final userJson = json.encode(user.toJson());
    await _prefs!.setString(AppConstants.userDataKey, userJson);
  }

  static Future<UserModel?> getCachedUser() async {
    await init();
    final userJson = _prefs!.getString(AppConstants.userDataKey);
    if (userJson != null) {
      final userMap = json.decode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    }
    return null;
  }

  // Clear all cache
  static Future<void> clearCache() async {
    await removeToken();
    await removeUserData();
  }
}
```

### 3. Local Data Source (`lib/features/auth/data/datasources/auth_local_datasource.dart`)

```dart
abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> removeToken();
  Future<bool> hasToken();
  Future<void> saveUserData(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;

  @override
  Future<void> saveToken(String token) async {
    // Save to secure storage
    await secureStorage.write(key: AppConstants.tokenKey, value: token);
  }

  @override
  Future<void> saveUserData(UserModel user) async {
    // Save to SharedPreferences
    final userJson = json.encode(user.toJson());
    await sharedPreferences.setString(AppConstants.userDataKey, userJson);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final userJson = sharedPreferences.getString(AppConstants.userDataKey);
    if (userJson != null) {
      return UserModel.fromJson(json.decode(userJson));
    }
    return null;
  }
}
```

### 4. BLoC/Cubit Example (`lib/features/auth/presentation/bloc/auth_bloc.dart`)

```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  // ... other use cases

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final authResult = await _checkAuthStatus();
    await authResult.fold(
      (failure) async => emit(AuthUnauthenticated()),
      (isAuthenticated) async {
        if (isAuthenticated) {
          // Get cached user data and token
          final tokenResult = await _authRepository.getToken();
          final userResult = await _authRepository.getCachedUser();
          
          tokenResult.fold(
            (_) => emit(AuthUnauthenticated()),
            (token) {
              userResult.fold(
                (_) => emit(AuthUnauthenticated()),
                (user) {
                  if (token != null && token.isNotEmpty && user != null) {
                    emit(AuthAuthenticated(user: user, token: token));
                  } else {
                    emit(AuthUnauthenticated());
                  }
                },
              );
            },
          );
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }
}
```

### 5. Use Case Example (`lib/features/auth/domain/usecases/login_with_email.dart`)

```dart
class LoginWithEmail implements UseCase<AuthResult, LoginWithEmailParams> {
  final AuthRepository repository;

  LoginWithEmail(this.repository);

  @override
  Future<Either<Failure, AuthResult>> call(LoginWithEmailParams params) async {
    return await repository.loginWithEmail(params.email, params.password);
  }
}

class LoginWithEmailParams extends Equatable {
  final String email;
  final String password;

  const LoginWithEmailParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}
```

### 6. Repository Implementation (`lib/features/auth/data/repositories/auth_repository_impl.dart`)

```dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  @override
  Future<Either<Failure, AuthResult>> loginWithEmail(
    String email, 
    String password,
  ) async {
    try {
      final authResult = await remoteDataSource.loginWithEmail(email, password);
      await localDataSource.saveToken(authResult.token);
      await localDataSource.saveUserData(authResult.user as UserModel);
      return Right(authResult);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}
```

### 7. Localization Setup (`lib/main.dart`)

```dart
FutureBuilder<String?>(
  future: StorageHelper.getLocale(),
  builder: (context, snapshot) {
    final savedLocale = snapshot.data;
    final locale = savedLocale != null 
        ? Locale(savedLocale)
        : AppLocalizations.supportedLocales.first;
    final isRTL = locale.languageCode == 'ar';
    
    return MaterialApp(
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: locale,
      builder: (context, child) {
        return Directionality(
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          child: GradientBackground(child: child!),
        );
      },
    );
  },
)
```

### 8. Dependency Injection (`lib/core/di/injection.dart`)

```dart
Future<void> configureDependencies() async {
  await StorageHelper.init();
  final sharedPrefs = await SharedPreferences.getInstance();

  // External dependencies
  sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // Network
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<Dio>(() => sl<DioClient>().dio);

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      sharedPreferences: sl<SharedPreferences>(),
      secureStorage: sl<FlutterSecureStorage>(),
    ),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<LoginWithEmail>(
    () => LoginWithEmail(sl<AuthRepository>()),
  );
  // ... other use cases
}
```

## ✅ Completed Features

1. ✅ **Clean Architecture Structure** - Data/Domain/Presentation layers
2. ✅ **Dio Client** - With interceptors, token handling, error management
3. ✅ **Secure Storage** - FlutterSecureStorage for tokens
4. ✅ **User Data Caching** - SharedPreferences for user data
5. ✅ **Localization** - Arabic + English with RTL support
6. ✅ **BLoC Pattern** - Auth BLoC with proper state management
7. ✅ **Error Handling** - Either<Failure, T> pattern throughout
8. ✅ **Dependency Injection** - GetIt setup with all dependencies

## 🚀 Next Steps

1. Refactor remaining features (home, favorite, profile, etc.) to follow the same structure
2. Convert remaining UI logic to BLoC/Cubit
3. Add unit tests for use cases and repositories
4. Implement proper error handling in UI layer
5. Add more use cases as needed

## 📝 Notes

- All imports updated from `core/error` to `core/errors`
- Remote data source uses Dio instead of http.Client
- Token stored securely using FlutterSecureStorage
- User data cached in SharedPreferences
- RTL support automatically handled based on locale
- Auto-login on app launch checks token and cached user data

