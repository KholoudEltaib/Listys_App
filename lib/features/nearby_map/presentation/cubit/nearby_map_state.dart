// features/nearby_map/presentation/cubit/nearby_map_state.dart

import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:listys_app/features/nearby_map/domain/entities/place_entity.dart';

// View Mode Enum
enum ViewMode {
  nearby,      // Within selected radius
  city,        // All places in current city
  unlimited,   // All places regardless of distance
}

abstract class NearbyMapState extends Equatable {
  const NearbyMapState();

  @override
  List<Object?> get props => [];
}

class NearbyMapInitial extends NearbyMapState {}

class NearbyMapLocationLoading extends NearbyMapState {}

class NearbyMapLoading extends NearbyMapState {
  final LatLng? userLocation;

  const NearbyMapLoading({this.userLocation});

  @override
  List<Object?> get props => [userLocation];
}

class NearbyMapLoaded extends NearbyMapState {
  final List<PlacesEntity> places;
  final LatLng userLocation;
  final Set<Marker> markers;
  final PlacesEntity? selectedPlace;
  final ViewMode viewMode;
  final double radius;
  final String? selectedCity;

  const NearbyMapLoaded({
    required this.places,
    required this.userLocation,
    required this.markers,
    this.selectedPlace,
    this.viewMode = ViewMode.nearby,
    this.radius = 50.0,
    this.selectedCity,
  });

  NearbyMapLoaded copyWith({
    List<PlacesEntity>? places,
    LatLng? userLocation,
    Set<Marker>? markers,
    PlacesEntity? selectedPlace,
    ViewMode? viewMode,
    double? radius,
    String? selectedCity,
    bool clearSelection = false,
  }) {
    return NearbyMapLoaded(
      places: places ?? this.places,
      userLocation: userLocation ?? this.userLocation,
      markers: markers ?? this.markers,
      selectedPlace: clearSelection ? null : (selectedPlace ?? this.selectedPlace),
      viewMode: viewMode ?? this.viewMode,
      radius: radius ?? this.radius,
      selectedCity: selectedCity ?? this.selectedCity,
    );
  }

  @override
  List<Object?> get props => [
        places,
        userLocation,
        markers,
        selectedPlace,
        viewMode,
        radius,
        selectedCity,
      ];
}

class NearbyMapError extends NearbyMapState {
  final String message;

  const NearbyMapError({required this.message});

  @override
  List<Object> get props => [message];
}

class NearbyMapLocationPermissionDenied extends NearbyMapState {}

class NearbyMapLocationServiceDisabled extends NearbyMapState {}