// features/nearby_map/data/repositories/places_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:listys_app/core/errors/exceptions.dart';
import 'package:listys_app/core/errors/failures.dart';
import 'package:listys_app/core/network/network_info.dart';
import 'package:listys_app/features/nearby_map/data/datasources/places_remote_datasource.dart';
import 'package:listys_app/features/nearby_map/domain/entities/place_entity.dart';
import 'package:listys_app/features/nearby_map/domain/repositories/places_repository.dart';

class PlacesRepositoryImpl implements PlacesRepository {
  final PlacesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PlacesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List< PlacesEntity>>> getAllPlaces() async {
    if (await networkInfo.isConnected) {
      try {
        final places = await remoteDataSource.getAllPlaces();
        return Right(places);
      } on ServerException catch (e) {
        return Left(ServerFailure( message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: "Fail"));
    }
  }

  @override
  Future<Either<Failure, List< PlacesEntity>>> getNearbyPlaces({
    required double userLatitude,
    required double userLongitude,
    double radiusInKm = 50.0,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final places = await remoteDataSource.getAllPlaces();
        
        // Calculate distance for each place and filter by radius
        final nearbyPlaces = places.map((place) {
          final distanceInMeters = Geolocator.distanceBetween(
            userLatitude,
            userLongitude,
            place.latitude,
            place.longitude,
          );
          final distanceInKm = distanceInMeters / 1000;
          
          return place.copyWith(distanceInKm: distanceInKm);
        }).where((place) {
          return place.distanceInKm! <= radiusInKm;
        }).toList();

        // Sort by distance (closest first)
        nearbyPlaces.sort((a, b) => 
          a.distanceInKm!.compareTo(b.distanceInKm!)
        );

        return Right(nearbyPlaces);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure( message:"Fail"));
    }
  }
}