import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/features/favorite/domain/usecases/get_favorites_usecase.dart';
import 'package:listys_app/features/favorite/domain/usecases/toggle_favorite_usecase.dart';
import 'package:listys_app/features/favorite/presentation/cubit/favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final GetFavoritesUseCase getFavoritesUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;

  FavoriteCubit({
    required this.getFavoritesUseCase,
    required this.toggleFavoriteUseCase,
  }) : super(FavoriteInitial());

  Future<void> loadFavorites() async {
    print('🔄 Loading favorites...');
    emit(FavoriteLoading());

    final result = await getFavoritesUseCase();

    result.fold(
      (failure) {
        print('❌ Failed to load favorites: ${failure.message}');
        emit(FavoriteError(failure.message));
      },
      (favorites) {
        print('✅ Loaded ${favorites.countries.length} countries, ${favorites.places.length} places');
        
        final favoriteCountryIds = favorites.countries.map((c) => c.id).toSet();
        final favoritePlaceIds = favorites.places.map((p) => p.id).toSet();

        if (favorites.countries.isEmpty && favorites.places.isEmpty) {
          emit(FavoriteEmpty());
        } else {
          emit(FavoriteLoaded(
            countries: favorites.countries,
            places: favorites.places,
            favoriteCountryIds: favoriteCountryIds,
            favoritePlaceIds: favoritePlaceIds,
          ));
        }
      },
    );
  }

  Future<void> toggleFavorite({required int id, required String type}) async {
    print('🔄 Toggling favorite - id: $id, type: $type');
    
    final currentState = state;

    // If not loaded yet OR if empty, we can still toggle
    if (currentState is! FavoriteLoaded && currentState is! FavoriteEmpty) {
      print('⚠️ State is ${currentState.runtimeType}, loading favorites first...');
      await loadFavorites();
    }
    
    // After loading, check state again
    final newState = state;
    
    // Handle empty state - create a loaded state with empty lists
    if (newState is FavoriteEmpty) {
      print('📝 Creating new favorite from empty state');
      emit(const FavoriteLoaded(
        countries: [],
        places: [],
        favoriteCountryIds: {},
        favoritePlaceIds: {},
      ));
    }
    
    // Now we should have a FavoriteLoaded state
    final loadedState = state;
    if (loadedState is! FavoriteLoaded) {
      print('❌ Cannot toggle - state is still not FavoriteLoaded after loading');
      return;
    }

    // Optimistic update
    final newFavoriteCountryIds = Set<int>.from(loadedState.favoriteCountryIds);
    final newFavoritePlaceIds = Set<int>.from(loadedState.favoritePlaceIds);
    
    List<dynamic> newCountries = List.from(loadedState.countries);
    List<dynamic> newPlaces = List.from(loadedState.places);

    bool wasAdded = false;

    if (type == 'country') {
      if (newFavoriteCountryIds.contains(id)) {
        print('➖ Removing country $id from favorites');
        newFavoriteCountryIds.remove(id);
        newCountries.removeWhere((c) => c.id == id);
        wasAdded = false;
      } else {
        print('➕ Adding country $id to favorites (current count: ${newFavoriteCountryIds.length})');
        newFavoriteCountryIds.add(id);
        wasAdded = true;
      }
    } else if (type == 'place') {
      if (newFavoritePlaceIds.contains(id)) {
        print('➖ Removing place $id from favorites');
        newFavoritePlaceIds.remove(id);
        newPlaces.removeWhere((p) => p.id == id);
        wasAdded = false;
      } else {
        print('➕ Adding place $id to favorites (current count: ${newFavoritePlaceIds.length})');
        newFavoritePlaceIds.add(id);
        wasAdded = true;
      }
    }

    // Update UI immediately (optimistic update)
    print('🔄 Emitting new state - Countries: ${newCountries.length}, Places: ${newPlaces.length}');
    print('🔄 Favorite IDs - Countries: $newFavoriteCountryIds, Places: $newFavoritePlaceIds');
    
    // Don't emit empty state when adding favorites!
    emit(FavoriteLoaded(
      countries: newCountries.cast(),
      places: newPlaces.cast(),
      favoriteCountryIds: newFavoriteCountryIds,
      favoritePlaceIds: newFavoritePlaceIds,
    ));

    // Make API call
    print('📡 Making API call to toggle favorite...');
    final result = await toggleFavoriteUseCase(id: id, type: type);

    result.fold(
      (failure) {
        print('❌ Failed to toggle favorite: ${failure.message}');
        // Revert to original state on failure
        emit(loadedState);
      },
      (_) {
        print('✅ Successfully toggled favorite on server');
        // Reload to sync with server and get the full item data
        loadFavorites();
      },
    );
  }

  bool isFavorite(int id, String type) {
    final currentState = state;
    if (currentState is FavoriteLoaded) {
      if (type == 'country') {
        return currentState.favoriteCountryIds.contains(id);
      } else if (type == 'place') {
        return currentState.favoritePlaceIds.contains(id);
      }
    }
    return false;
  }
}