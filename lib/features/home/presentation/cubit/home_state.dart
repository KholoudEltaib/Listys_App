import '../../domain/entities/home_entity.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final HomeEntity home;

  HomeLoaded(this.home);
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
