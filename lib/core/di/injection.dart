// import 'package:dio/dio.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:listys_app/core/di/service_locator.dart';
// import 'package:listys_app/core/network/dio_client.dart';
// import 'package:listys_app/core/utils/storage_helper.dart';
// import 'package:listys_app/features/auth/data/datasources/auth_local_datasource.dart';
// import 'package:listys_app/features/auth/data/datasources/auth_remote_datasource.dart';
// import 'package:listys_app/features/auth/data/repositories/auth_repository_impl.dart';
// import 'package:listys_app/features/auth/domain/repositories/auth_repository.dart';
// import 'package:listys_app/features/auth/domain/usecases/login_with_email.dart';
// import 'package:listys_app/features/auth/domain/usecases/register.dart';
// import 'package:listys_app/features/auth/domain/usecases/login_with_instagram.dart';
// import 'package:listys_app/features/auth/domain/usecases/login_with_facebook.dart';
// import 'package:listys_app/features/auth/domain/usecases/login_with_google.dart';
// import 'package:listys_app/features/auth/domain/usecases/logout.dart';
// import 'package:listys_app/features/auth/domain/usecases/check_auth_status.dart';
// import 'package:listys_app/features/favorite/data/datasources/favorite_remote_data_source.dart';
// import 'package:listys_app/features/favorite/data/repositories/favorites_repository_impl.dart';
// import 'package:listys_app/features/favorite/domain/repositories/favorite_repository.dart';
// import 'package:listys_app/features/favorite/domain/usecases/get_favorites_usecase.dart';
// import 'package:listys_app/features/favorite/presentation/cubit/favorites_cubit.dart';
// import 'package:listys_app/features/search/data/datasources/search_remote_datasource.dart';
// import 'package:listys_app/features/search/data/repositories/search_repository_impl.dart';
// import 'package:listys_app/features/search/domain/repositories/search_repository.dart';
// import 'package:listys_app/features/search/domain/usecases/search_category_usecase.dart';
// import 'package:listys_app/features/search/domain/usecases/search_city_usecase.dart';
// import 'package:listys_app/features/search/domain/usecases/search_country_usecase.dart';
// import 'package:listys_app/features/search/domain/usecases/search_place_usecase.dart';
// import 'package:listys_app/features/search/presentation/cubit/search_cubit.dart';

// // final getIt = GetIt.instance;

// Future<void> configureDependencies() async {
//   // Initialize async dependencies
//   await StorageHelper.init();
//   final sharedPrefs = await SharedPreferences.getInstance();

//   // External dependencies
//   getIt.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
//   getIt.registerLazySingleton<FlutterSecureStorage>(
//     () => const FlutterSecureStorage(),
//   );
//   // Network
//   getIt.registerLazySingleton<DioClient>(() => DioClient());
//   getIt.registerLazySingleton<Dio>(
//     () => getIt<DioClient>().dio,
//   );

//   // Data sources
//   getIt.registerLazySingleton<AuthRemoteDataSource>(
//     () => AuthRemoteDataSourceImpl(dio: getIt<Dio>()),
//   );
//   getIt.registerLazySingleton<AuthLocalDataSource>(
//     () => AuthLocalDataSourceImpl(
//       sharedPreferences: getIt<SharedPreferences>(),
//       secureStorage: getIt<FlutterSecureStorage>(),
//     ),
//   );

//   // Repository
//   getIt.registerLazySingleton<AuthRepository>(
//     () => AuthRepositoryImpl(
//       remoteDataSource: getIt<AuthRemoteDataSource>(),
//       localDataSource: getIt<AuthLocalDataSource>(),
//     ),
//   );

//   // Use cases
//   getIt.registerLazySingleton<LoginWithEmail>(
//     () => LoginWithEmail(getIt<AuthRepository>()),
//   );
//   getIt.registerLazySingleton<Register>(
//     () => Register(getIt<AuthRepository>()),
//   );
//   getIt.registerLazySingleton<LoginWithInstagram>(
//     () => LoginWithInstagram(getIt<AuthRepository>()),
//   );
//   getIt.registerLazySingleton<LoginWithFacebook>(
//     () => LoginWithFacebook(getIt<AuthRepository>()),
//   );
//   getIt.registerLazySingleton<LoginWithGoogle>(
//     () => LoginWithGoogle(getIt<AuthRepository>()),
//   );
//   getIt.registerLazySingleton<Logout>(
//     () => Logout(getIt<AuthRepository>()),
//   );
//   getIt.registerLazySingleton<CheckAuthStatus>(
//     () => CheckAuthStatus(getIt<AuthRepository>()),
//   );


//   // Favorite dependencies
//   getIt.registerLazySingleton<FavoritesRemoteDataSource>(
//     () {
//       print('🔧 Registering FavoritesRemoteDataSource');
//       return FavoritesRemoteDataSource();
//     },
//   );
  
//   // Repository - needs data source
//   getIt.registerLazySingleton<FavoritesRepository>(
//     () {
//       print('🔧 Registering FavoritesRepository');
//       return FavoritesRepositoryImpl(getIt<FavoritesRemoteDataSource>());
//     },
//   );
  
//   // UseCase - needs repository
//   getIt.registerLazySingleton<GetFavoritesUseCase>(
//     () {
//       print('🔧 Registering GetFavoritesUseCase');
//       return GetFavoritesUseCase(getIt<FavoritesRepository>());
//     },
//   );
  
//   // Cubit - MUST be factory (not singleton) - needs use case
//   getIt.registerFactory<FavoritesCubit>(
//     () {
//       print('🔧 Creating FavoritesCubit instance');
//       return FavoritesCubit(getIt<GetFavoritesUseCase>());
//     },
//   );


//   //Features Search  
// Future<void> init() async {
//   // ========== Features - Search ==========
  
//   // Cubit
//   getIt.registerFactory(
//     () => SearchCubit(
//       searchCountriesUseCase: getIt(),
//       searchCitiesUseCase: getIt(),
//       searchCategoriesUseCase: getIt(),
//       searchPlacesUseCase: getIt(),
//     ),
//   );

//   // Use cases
//   getIt.registerLazySingleton(() => SearchCountriesUseCase(getIt()));
//   getIt.registerLazySingleton(() => SearchCitiesUseCase(getIt()));
//   getIt.registerLazySingleton(() => SearchCategoriesUseCase(getIt()));
//   getIt.registerLazySingleton(() => SearchPlacesUseCase(getIt()));

//   // Repository
//   getIt.registerLazySingleton<SearchRepository>(
//     () => SearchRepositoryImpl(remoteDataSource: getIt()),
//   );

//   // Data sources
//   getIt.registerLazySingleton<SearchRemoteDataSource>(
//     () => SearchRemoteDataSourceImpl(dioClient: getIt()),
//   );

//   // ========== Core ==========
  
//   // Dio Client
//   getIt.registerLazySingleton(() => DioClient());
  
//   // Dio
//   getIt.registerLazySingleton(() => Dio());

//   // ========== External ==========
  
//   // SharedPreferences
//   final sharedPreferences = await SharedPreferences.getInstance();
//   getIt.registerLazySingleton(() => sharedPreferences);
// }
// }
