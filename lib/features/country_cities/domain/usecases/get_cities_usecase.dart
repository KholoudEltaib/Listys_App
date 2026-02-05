import '../entities/city_entity.dart';
import '../repositories/city_repository.dart';

class GetCitiesUseCase {
  final CityRepository repository;

  GetCitiesUseCase(this.repository);

  Future<List<City>> call(int countryId) async {
    return await repository.getCitiesByCountryId(countryId);
  }
}
