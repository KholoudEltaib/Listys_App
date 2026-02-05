import '../../domain/entities/city_entity.dart';

abstract class CityRepository {
  Future<List<City>> getCitiesByCountryId(int countryId);
}
