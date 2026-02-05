import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:listys_app/core/network/dio_client.dart';
import 'package:listys_app/core/network/network_info.dart';
import 'package:listys_app/core/utils/storage_helper.dart';

// Auth Feature
import 'package:listys_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:listys_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:listys_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:listys_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:listys_app/features/auth/domain/usecases/login_with_email.dart';
import 'package:listys_app/features/auth/domain/usecases/register.dart';
import 'package:listys_app/features/auth/domain/usecases/login_with_instagram.dart';
import 'package:listys_app/features/auth/domain/usecases/login_with_facebook.dart';
import 'package:listys_app/features/auth/domain/usecases/login_with_google.dart';
import 'package:listys_app/features/auth/domain/usecases/logout.dart';
import 'package:listys_app/features/auth/domain/usecases/check_auth_status.dart';
import 'package:listys_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:listys_app/features/categories/data/datasources/category_remote_datasource.dart';
import 'package:listys_app/features/categories/data/repositories/category_repository_impl.dart';
import 'package:listys_app/features/categories/domain/repositories/category_repository.dart';
import 'package:listys_app/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:listys_app/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:listys_app/features/destination/data/datasources/place_remote_datasource.dart';
import 'package:listys_app/features/destination/data/repositories/place_repository_impl.dart';
import 'package:listys_app/features/destination/domain/repositories/place_repository.dart';
import 'package:listys_app/features/destination/domain/usecases/get_places_usecase.dart';
import 'package:listys_app/features/destination/presentation/cubit/place_cubit.dart';
import 'package:listys_app/features/destination_details/data/datasources/place_details_remote_datasource.dart';
import 'package:listys_app/features/destination_details/data/repositories/place_details_repository_impl.dart';
import 'package:listys_app/features/destination_details/domain/repositories/place_details_repository.dart';
import 'package:listys_app/features/destination_details/domain/usecases/get_place_details_usecase.dart';
import 'package:listys_app/features/destination_details/presentation/cubit/place_details_cubit.dart';
import 'package:listys_app/features/favorite/domain/usecases/toggle_favorite_usecase.dart';
import 'package:listys_app/features/favorite/presentation/cubit/favorite_cubit.dart';

// Home Feature
import 'package:listys_app/features/home/domain/usecases/get_home_data_usecase.dart';
import 'package:listys_app/features/home/domain/repositories/home_repository.dart';
import 'package:listys_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:listys_app/features/home/data/datasources/home_remote_datasource.dart';
import 'package:listys_app/features/home/data/datasources/home_local_datasource.dart';
import 'package:listys_app/features/home/presentation/cubit/home_cubit.dart';

// City Feature
import 'package:listys_app/features/country_cities/domain/usecases/get_cities_usecase.dart';
import 'package:listys_app/features/country_cities/domain/repositories/city_repository.dart';
import 'package:listys_app/features/country_cities/data/repositories/city_repository_impl.dart';
import 'package:listys_app/features/country_cities/data/datasources/city_remote_data_source.dart';

// Favorite Feature
import 'package:listys_app/features/favorite/data/datasources/favorite_remote_data_source.dart';
import 'package:listys_app/features/favorite/data/repositories/favorites_repository_impl.dart';
import 'package:listys_app/features/favorite/domain/repositories/favorite_repository.dart';
import 'package:listys_app/features/favorite/domain/usecases/get_favorites_usecase.dart';
import 'package:listys_app/features/nearby_map/data/datasources/places_remote_datasource.dart';
import 'package:listys_app/features/nearby_map/data/repositories/places_repository_impl.dart';
import 'package:listys_app/features/nearby_map/domain/repositories/places_repository.dart';
import 'package:listys_app/features/nearby_map/domain/usecases/get_nearby_places_usecase.dart';
import 'package:listys_app/features/nearby_map/presentation/cubit/nearby_map_cubit.dart';

// Profile Feature
import 'package:listys_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:listys_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:listys_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:listys_app/features/profile/domain/usecases/change_language_usecase.dart';
import 'package:listys_app/features/profile/domain/usecases/change_password_usecase.dart';
import 'package:listys_app/features/profile/domain/usecases/delete_account_usecase.dart';
import 'package:listys_app/features/profile/domain/usecases/get_profile_usecase.dart' hide UpdateProfileUseCase;
import 'package:listys_app/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:listys_app/features/profile/presentation/cubit/profile_cubit.dart';

// Search Feature
import 'package:listys_app/features/search/data/datasources/search_remote_datasource.dart';
import 'package:listys_app/features/search/data/repositories/search_repository_impl.dart';
import 'package:listys_app/features/search/domain/repositories/search_repository.dart';
import 'package:listys_app/features/search/domain/usecases/search_category_usecase.dart';
import 'package:listys_app/features/search/domain/usecases/search_city_usecase.dart';
import 'package:listys_app/features/search/domain/usecases/search_country_usecase.dart';
import 'package:listys_app/features/search/domain/usecases/search_place_usecase.dart';
import 'package:listys_app/features/search/presentation/cubit/search_cubit.dart';

// Localization
import 'package:listys_app/core/localization/locale_cubit/locale_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  print('🚀 Starting Dependency Injection Setup...');

  // ========================================================================
  // CORE DEPENDENCIES
  // ========================================================================
  
  // Initialize async dependencies
  await StorageHelper.init();
  final sharedPrefs = await SharedPreferences.getInstance();

  // External dependencies
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  

  // Network - DioClient (which creates Dio internally)
  getIt.registerLazySingleton<DioClient>(() => DioClient());
  
  // Dio instance from DioClient
  getIt.registerLazySingleton<Dio>(() => getIt<DioClient>().dio);

  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());


  print('✅ Core dependencies registered');

  // ========================================================================
  // LOCALIZATION
  // ========================================================================
  
  getIt.registerLazySingleton<LocaleCubit>(() => LocaleCubit());
  print('✅ Localization registered');

  // ========================================================================
  // AUTH FEATURE
  // ========================================================================
  
  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: getIt<Dio>()),
  );
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      sharedPreferences: getIt<SharedPreferences>(),
      secureStorage: getIt<FlutterSecureStorage>(),
    ),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton<LoginWithEmail>(
    () => LoginWithEmail(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<Register>(
    () => Register(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<LoginWithInstagram>(
    () => LoginWithInstagram(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<LoginWithFacebook>(
    () => LoginWithFacebook(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<LoginWithGoogle>(
    () => LoginWithGoogle(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<Logout>(
    () => Logout(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<CheckAuthStatus>(
    () => CheckAuthStatus(getIt<AuthRepository>()),
  );

  // Bloc
  getIt.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      loginWithEmail: getIt<LoginWithEmail>(),
      register: getIt<Register>(),
      loginWithInstagram: getIt<LoginWithInstagram>(),
      loginWithFacebook: getIt<LoginWithFacebook>(),
      loginWithGoogle: getIt<LoginWithGoogle>(),
      logout: getIt<Logout>(),
      checkAuthStatus: getIt<CheckAuthStatus>(),
      authRepository: getIt<AuthRepository>(),
    ),
  );

  print('✅ Auth feature registered');

  // ========================================================================
  // HOME FEATURE
  // ========================================================================
  
  // Data sources
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSourceImpl(),
  );

  // Repository
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      remote: getIt(),
      local: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(
    () => GetHomeDataUseCase(getIt()),
  );

  // Cubit (Factory - creates new instance each time)
  getIt.registerFactory(
    () => HomeCubit(getIt<GetHomeDataUseCase>(), getIt<LocaleCubit>()),
  );

  print('✅ Home feature registered');

  // ========================================================================
  // CITY FEATURE
  // ========================================================================
  
  // Data sources
  getIt.registerLazySingleton<CityRemoteDataSource>(
    () => CityRemoteDataSourceImpl(getIt<Dio>()),
  );

  // Repository
  getIt.registerLazySingleton<CityRepository>(
    () => CityRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(
    () => GetCitiesUseCase(getIt()),
  );

  print('✅ City feature registered');

  // ========================================================================
  // FAVORITE FEATURE
  // ========================================================================
  
  // Data Sources
  getIt.registerLazySingleton<FavoriteRemoteDataSource>(
    () => FavoriteRemoteDataSourceImpl(dio: getIt()),
  );

  // Repository
  getIt.registerLazySingleton<FavoriteRepository>(
    () => FavoriteRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use Cases
  getIt.registerLazySingleton(() => GetFavoritesUseCase(getIt()));
  getIt.registerLazySingleton(() => ToggleFavoriteUseCase(getIt()));

  // Cubit
  getIt.registerLazySingleton<FavoriteCubit>(  
    () => FavoriteCubit(
      getFavoritesUseCase: getIt(),
      toggleFavoriteUseCase: getIt(),
    ),
  );

  print('✅ Favorite feature registered');

  // ========================================================================
  // SEARCH FEATURE
  // ========================================================================
  
  // Data sources
  getIt.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
  );

  // Repository
  getIt.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => SearchCountriesUseCase(getIt()));
  getIt.registerLazySingleton(() => SearchCitiesUseCase(getIt()));
  getIt.registerLazySingleton(() => SearchCategoriesUseCase(getIt()));
  getIt.registerLazySingleton(() => SearchPlacesUseCase(getIt()));

  // Cubit
  getIt.registerFactory(
    () => SearchCubit(
      searchCountriesUseCase: getIt(),
      searchCitiesUseCase: getIt(),
      searchCategoriesUseCase: getIt(),
      searchPlacesUseCase: getIt(),
    ),
  );

  print('✅ Search feature registered');

  // ========================================================================
  // CATEGORY FEATURE
  // ========================================================================
  
  // Data sources
  getIt.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(dio: getIt<Dio>()),
  );

  // Repository
  getIt.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(
    () => GetCategoriesUseCase(getIt()),
  );

  // Cubit
  getIt.registerFactory(
    () => CategoriesCubit(getIt<GetCategoriesUseCase>()),
  );

  print('✅ Category feature registered'); 

  // ========================================================================
  // DESTINATION/PLACE FEATURE
  // ========================================================================
  
  // Data sources
  getIt.registerLazySingleton<PlaceRemoteDataSource>(
    () => PlaceRemoteDataSourceImpl(dio: getIt<Dio>()),
  );

  // Repository
  getIt.registerLazySingleton<PlaceRepository>(
    () => PlaceRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(
    () => GetPlacesUseCase(getIt()),
  );

  // Cubit
  getIt.registerFactory(
    () => PlacesCubit(getIt<GetPlacesUseCase>()),
  );

  print('✅ Destination/Place feature registered');
  
  // ========================================================================
  // PLACE DETAILS FEATURE
  // ========================================================================
  
  // Data sources
  getIt.registerLazySingleton<PlaceDetailsRemoteDataSource>(
    () => PlaceDetailsRemoteDataSourceImpl(dio: getIt<Dio>()),
  );

  // Repository
  getIt.registerLazySingleton<PlaceDetailsRepository>(
    () => PlaceDetailsRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(
    () => GetPlaceDetailsUseCase(getIt()),
  );

  // Cubit
  getIt.registerFactory(
    () => PlaceDetailsCubit(getIt<GetPlaceDetailsUseCase>()),
  );

  print('✅ Place Details feature registered');

  // ========================================================================
  // PROFILE FEATURE
  // ========================================================================
  
  // Data sources
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(dio: getIt<Dio>()),
  );

  // Repository
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetProfileUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateProfileUseCase(getIt()));
  getIt.registerLazySingleton(() => ChangePasswordUseCase(getIt()));
  getIt.registerLazySingleton(() => ChangeLanguageUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteAccountUseCase(getIt()));
  

  
  // Cubit
  getIt.registerFactory<ProfileCubit>(
  () => ProfileCubit(
    getProfileUseCase: getIt(),
    updateProfileUseCase: getIt(),
    changePasswordUseCase: getIt(),
    changeLanguageUseCase: getIt(),
    deleteAccountUseCase: getIt(),
    
  ),
);


  print('✅ Profile feature registered');

  // ========================================================================
  // NEARBY MAP FEATURE
  // ========================================================================

  getIt.registerLazySingleton<PlacesRemoteDataSource>(
    () => PlacesRemoteDataSourceImpl(dio: getIt<Dio>()),
  );

  getIt.registerLazySingleton<PlacesRepository>(
    () => PlacesRepositoryImpl(
      remoteDataSource: getIt<PlacesRemoteDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  getIt.registerLazySingleton(
    () => GetNearbyPlacesUseCase(getIt<PlacesRepository>()),
  );

  getIt.registerFactory(
    () => NearbyMapCubit(
      getNearbyPlacesUseCase: getIt<GetNearbyPlacesUseCase>(),
    ),
  );

  print('✅ Nearby Map feature registered');

  print('🎉 Dependency Injection Setup Complete!');
}