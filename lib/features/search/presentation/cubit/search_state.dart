import 'package:equatable/equatable.dart';
import 'package:listys_app/features/search/domain/entities/search_country.dart';
import 'package:listys_app/features/search/domain/entities/search_city.dart';
import 'package:listys_app/features/search/domain/entities/search_category.dart';
import 'package:listys_app/features/search/domain/entities/search_place.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchCountriesLoaded extends SearchState {
  final List<SearchCountry> countries;

  const SearchCountriesLoaded(this.countries);

  @override
  List<Object?> get props => [countries];
}

class SearchCitiesLoaded extends SearchState {
  final List<SearchCity> cities;
  final int countryId;

  const SearchCitiesLoaded(this.cities, this.countryId);

  @override
  List<Object?> get props => [cities, countryId];
}

class SearchCategoriesLoaded extends SearchState {
  final List<SearchCategory> categories;
  final int cityId;

  const SearchCategoriesLoaded(this.categories, this.cityId);

  @override
  List<Object?> get props => [categories, cityId];
}

class SearchPlacesLoaded extends SearchState {
  final List<SearchPlace> places;
  final String query;

  const SearchPlacesLoaded(this.places, this.query);

  @override
  List<Object?> get props => [places, query];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}

// Suggestions State
class SearchSuggestionsLoaded extends SearchState {
  final List<SearchCountry> countries;
  final List<SearchCategory> popularCategories;

  const SearchSuggestionsLoaded({
    required this.countries,
    required this.popularCategories,
  });

  @override
  List<Object?> get props => [countries, popularCategories];
}