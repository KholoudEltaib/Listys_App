import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:listys_app/features/search/domain/usecases/search_category_usecase.dart';
import 'package:listys_app/features/search/domain/usecases/search_city_usecase.dart';
import 'package:listys_app/features/search/domain/usecases/search_country_usecase.dart';
import 'package:listys_app/features/search/domain/usecases/search_place_usecase.dart';
import 'package:listys_app/features/search/presentation/cubit/search_state.dart';
import 'package:listys_app/features/search/presentation/models/search_filter.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchCountriesUseCase searchCountriesUseCase;
  final SearchCitiesUseCase searchCitiesUseCase;
  final SearchCategoriesUseCase searchCategoriesUseCase;
  final SearchPlacesUseCase searchPlacesUseCase;

  SearchFilter currentFilter = const SearchFilter();
  List<String> searchHistory = [];
  String? currentLanguage;

  SearchCubit({
    required this.searchCountriesUseCase,
    required this.searchCitiesUseCase,
    required this.searchCategoriesUseCase,
    required this.searchPlacesUseCase,
  }) : super(SearchInitial()) {
    _loadSearchHistory();
    _loadCurrentLanguage();
  }

  // Load current language from SharedPreferences
  Future<void> _loadCurrentLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    currentLanguage = prefs.getString('app_language') ?? 'en';
  }

  // Change language
  Future<void> changeLanguage(String language) async {
    currentLanguage = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', language);
  }

  // Search Countries
  Future<void> searchCountries(String query) async {
    if (query.isEmpty) return;

    emit(SearchLoading());

    final result = await searchCountriesUseCase(
      query: query,
      language: currentLanguage,
    );

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (countries) => emit(SearchCountriesLoaded(countries)),
    );
  }

  // Search Cities
  Future<void> searchCities(String query, int countryId) async {
    if (query.isEmpty) return;

    emit(SearchLoading());

    final result = await searchCitiesUseCase(
      query: query,
      countryId: countryId,
      language: currentLanguage,
    );

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (cities) => emit(SearchCitiesLoaded(cities, countryId)),
    );
  }

  // Search Categories
  Future<void> searchCategories(String query, int cityId) async {
    if (query.isEmpty) return;

    emit(SearchLoading());

    final result = await searchCategoriesUseCase(
      query: query,
      cityId: cityId,
      language: currentLanguage,
    );

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (categories) => emit(SearchCategoriesLoaded(categories, cityId)),
    );
  }

  // Search Places with filters
  Future<void> searchPlaces(String query) async {
    if (query.isEmpty || currentFilter.selectedCityId == null) {
      emit(const SearchError('Please select a city first'));
      return;
    }

    emit(SearchLoading());

    final result = await searchPlacesUseCase(
      query: query,
      cityId: currentFilter.selectedCityId!,
      categoryId: currentFilter.selectedCategoryId,
      minRating: currentFilter.minRating,
      language: currentLanguage,
    );

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (places) {
        _addToHistory(query);
        emit(SearchPlacesLoaded(places, query));
      },
    );
  }

  // Load initial suggestions
  Future<void> loadSuggestions() async {
    emit(SearchLoading());

    // Load popular countries
    final countriesResult = await searchCountriesUseCase(
      query: '',
      language: currentLanguage,
    );

    countriesResult.fold(
      (failure) => emit(SearchError(failure.message)),
      (countries) {
        // You can also load popular categories here
        emit(SearchSuggestionsLoaded(
          countries: countries.take(8).toList(),
          popularCategories: [], // Add logic to load categories
        ));
      },
    );
  }

  // Update filter
  void updateFilter(SearchFilter filter) {
    currentFilter = filter;
  }

  // Clear filter
  void clearFilter() {
    currentFilter = const SearchFilter();
  }

  // Apply specific filter
  void applyCountryFilter(int countryId) {
    currentFilter = currentFilter.copyWith(selectedCountryId: countryId);
  }

  void applyCityFilter(int cityId) {
    currentFilter = currentFilter.copyWith(selectedCityId: cityId);
  }

  void applyCategoryFilter(int categoryId) {
    currentFilter = currentFilter.copyWith(selectedCategoryId: categoryId);
  }

  void applyRatingFilter(double rating) {
    currentFilter = currentFilter.copyWith(minRating: rating);
  }

  void applyDateFilter(DateTime? startDate, DateTime? endDate) {
    currentFilter = currentFilter.copyWith(
      startDate: startDate,
      endDate: endDate,
    );
  }

  // Search History Management
  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    searchHistory = prefs.getStringList('search_history') ?? [];
  }

  Future<void> _addToHistory(String query) async {
    if (!searchHistory.contains(query)) {
      searchHistory.insert(0, query);
      if (searchHistory.length > 10) {
        searchHistory = searchHistory.sublist(0, 10);
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('search_history', searchHistory);
    }
  }

  Future<void> removeFromHistory(String query) async {
    searchHistory.remove(query);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('search_history', searchHistory);
  }

  Future<void> clearHistory() async {
    searchHistory.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('search_history');
  }


  // Clear search results
  void clearSearch() {
    emit(SearchInitial());
  }
}