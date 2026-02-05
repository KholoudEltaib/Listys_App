import 'package:bloc/bloc.dart';
import '../../domain/entities/city_entity.dart';
import '../../domain/usecases/get_cities_usecase.dart';

part 'cities_state.dart';

class CitiesCubit extends Cubit<CitiesState> {
  final GetCitiesUseCase getCitiesUseCase;

  CitiesCubit(this.getCitiesUseCase) : super(CitiesInitial());

  void fetchCities(int countryId) async {
    emit(CitiesLoading());
    try {
      final cities = await getCitiesUseCase(countryId);
      emit(CitiesLoaded(cities));
    } catch (e) {
      emit(CitiesError('Failed to fetch cities'));
    }
  }
}
