part of 'cities_cubit.dart';

abstract class CitiesState {}

class CitiesInitial extends CitiesState {}
class CitiesLoading extends CitiesState {}
class CitiesLoaded extends CitiesState {
  final List<City> cities;
  CitiesLoaded(this.cities);
}
class CitiesError extends CitiesState {
  final String message;
  CitiesError(this.message);
}
