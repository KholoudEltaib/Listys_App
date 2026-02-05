import '../../domain/entities/city_entity.dart';

class CityModel extends City {
  CityModel({required int id, required String name, String? image})
      : super(id: id, name: name, image: image);

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}
