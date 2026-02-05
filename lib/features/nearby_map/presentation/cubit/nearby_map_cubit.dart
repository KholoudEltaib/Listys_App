// features/nearby_map/presentation/cubit/nearby_map_cubit.dart

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:listys_app/core/utils/map_styles.dart';

import 'package:listys_app/features/nearby_map/domain/entities/place_entity.dart';
import 'package:listys_app/features/nearby_map/domain/usecases/get_nearby_places_usecase.dart';
import 'package:listys_app/features/nearby_map/presentation/cubit/nearby_map_state.dart';

class NearbyMapCubit extends Cubit<NearbyMapState> {
  final GetNearbyPlacesUseCase getNearbyPlacesUseCase;
  GoogleMapController? mapController;

  double _currentRadius = 50.0;
  ViewMode _viewMode = ViewMode.nearby;
  String? _selectedCity;

  NearbyMapCubit({
    required this.getNearbyPlacesUseCase,
  }) : super(NearbyMapInitial());

  double get currentRadius => _currentRadius;
  ViewMode get viewMode => _viewMode;
  String? get selectedCity => _selectedCity;

  // --------------------------------------------------
  // LOAD PLACES
  // --------------------------------------------------
  Future<void> loadNearbyPlaces({
    double? radiusInKm,
    ViewMode? mode,
  }) async {
    if (radiusInKm != null) _currentRadius = radiusInKm;
    if (mode != null) _viewMode = mode;

    emit(NearbyMapLocationLoading());

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(NearbyMapLocationPermissionDenied());
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      emit(NearbyMapLocationPermissionDenied());
      return;
    }

    if (!await Geolocator.isLocationServiceEnabled()) {
      emit(NearbyMapLocationServiceDisabled());
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final userLocation =
          LatLng(position.latitude, position.longitude);

      emit(NearbyMapLoading(userLocation: userLocation));

      double effectiveRadius;
      switch (_viewMode) {
        case ViewMode.nearby:
          effectiveRadius = _currentRadius;
          break;
        case ViewMode.city:
          effectiveRadius = 100.0;
          break;
        case ViewMode.unlimited:
          effectiveRadius = double.infinity;
          break;
      }

      final result = await getNearbyPlacesUseCase(
        NearbyPlacesParams(
          userLatitude: position.latitude,
          userLongitude: position.longitude,
          radiusInKm: effectiveRadius,
        ),
      );

      result.fold(
        (failure) =>
            emit(NearbyMapError(message: failure.message)),
        (places) async {
          List<PlacesEntity> filteredPlaces = places;

          if (_viewMode == ViewMode.city && places.isNotEmpty) {
            _selectedCity = _getMostCommonCity(places);
            filteredPlaces = places
                .where((p) => p.cityName == _selectedCity)
                .toList();
          }

          final markers =
              await _createMarkers(filteredPlaces, userLocation);

          emit(NearbyMapLoaded(
          places: filteredPlaces,
          userLocation: userLocation,
          markers: markers,
          viewMode: _viewMode,
          radius: _currentRadius,
          selectedCity: _selectedCity,
        ));

        if (filteredPlaces.isNotEmpty) {
          _fitMarkersInView(filteredPlaces, userLocation);
        }
        },
      );
    } catch (e) {
      emit(NearbyMapError(
        message: 'Failed to get location: $e',
      ));
    }
  }

  void clearSelection() {
  if (state is NearbyMapLoaded) {
    final current = state as NearbyMapLoaded;
    emit(current.copyWith(clearSelection: true));
  }
}


  // --------------------------------------------------
  // MARKERS
  // --------------------------------------------------
  Future<Set<Marker>> _createMarkers(
    List<PlacesEntity> places,
    LatLng userLocation,
  ) async {
    final markers = <Marker>{};

    // User marker
    markers.add(
      Marker(
        markerId: const MarkerId('user_location'),
        position: userLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueBlue,
        ),
        infoWindow: const InfoWindow(title: 'Your Location'),
      ),
    );

    for (final place in places) {
      final categoryStyle = _getCategoryStyle(place.categoryName);

      final icon = await _createCircularMarker(
        imageUrl: place.image,
        fallbackIcon: categoryStyle.icon,
        borderColor: categoryStyle.borderColor,
      );


      markers.add(
        Marker(
          markerId: MarkerId('place_${place.id}'),
          position: LatLng(place.latitude, place.longitude),
          icon: icon,
          onTap: () => selectPlace(place),
          infoWindow: InfoWindow(
            title: place.name,
            snippet: place.distanceInKm != null
                ? '${place.distanceInKm!.toStringAsFixed(1)} km away'
                : place.cityName,
          ),
        ),
      );
    }

    return markers;
  }

  // --------------------------------------------------
  // CIRCULAR MARKER
  // --------------------------------------------------
  Future<BitmapDescriptor> _createCircularMarker({
    String? imageUrl,
    required IconData fallbackIcon,
    required Color borderColor,
    double size = 120,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..isAntiAlias = true;

    final center = Offset(size / 2, size / 2);
    final radius = size / 2;

    paint.color = Colors.white;
    canvas.drawCircle(center, radius, paint);

    paint
  ..color = borderColor
  ..style = PaintingStyle.stroke
  ..strokeWidth = 10;
    canvas.drawCircle(center, radius - 3, paint);

    paint.style = PaintingStyle.fill;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        final response = await http.get(Uri.parse(imageUrl));
        final codec = await ui.instantiateImageCodec(
          response.bodyBytes,
          targetWidth: size.toInt(),
          targetHeight: size.toInt(),
        );
        final frame = await codec.getNextFrame();

        canvas.save();
        canvas.clipPath(
          Path()
            ..addOval(Rect.fromCircle(
              center: center,
              radius: radius - 8,
            )),
        );

        canvas.drawImageRect(
          frame.image,
          Rect.fromLTWH(
            0,
            0,
            frame.image.width.toDouble(),
            frame.image.height.toDouble(),
          ),
          Rect.fromLTWH(8, 8, size - 16, size - 16),
          Paint(),
        );

        canvas.restore();
      } catch (_) {
        _drawFallbackIcon(canvas, center, fallbackIcon);
      }
    } else {
      _drawFallbackIcon(canvas, center, fallbackIcon);
    }

    final picture = recorder.endRecording();
    final image =
        await picture.toImage(size.toInt(), size.toInt());
    final bytes =
        await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(
      bytes!.buffer.asUint8List(),
    );
  }

  void _drawFallbackIcon(
    Canvas canvas,
    Offset center,
    IconData icon,
  ) {
    final painter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: 60,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: Colors.black87,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    painter.layout();
    painter.paint(
      canvas,
      Offset(
        center.dx - painter.width / 2,
        center.dy - painter.height / 2,
      ),
    );
  }

  // --------------------------------------------------
  // HELPERS
  // --------------------------------------------------
  String _getMostCommonCity(List<PlacesEntity> places) {
    final map = <String, int>{};
    for (final p in places) {
      map[p.cityName] = (map[p.cityName] ?? 0) + 1;
    }
    return map.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    ).key;
  }

  Future<void> _fitMarkersInView(
    List<PlacesEntity> places,
    LatLng userLocation,
  ) async {
    if (mapController == null || places.isEmpty) return;

    double minLat = userLocation.latitude;
    double maxLat = userLocation.latitude;
    double minLng = userLocation.longitude;
    double maxLng = userLocation.longitude;

    for (final p in places) {
      minLat = p.latitude < minLat ? p.latitude : minLat;
      maxLat = p.latitude > maxLat ? p.latitude : maxLat;
      minLng = p.longitude < minLng ? p.longitude : minLng;
      maxLng = p.longitude > maxLng ? p.longitude : maxLng;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    await mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 60),
    );
  }

  // --------------------------------------------------
  // SELECTION
  // --------------------------------------------------
  void selectPlace(PlacesEntity place) {
    if (state is NearbyMapLoaded) {
      final current = state as NearbyMapLoaded;
      emit(current.copyWith(selectedPlace: place));

      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(place.latitude, place.longitude),
          15,
        ),
      );
    }
  }

void onMapCreated(GoogleMapController controller) {
  mapController = controller;
  print('🗺️ Map controller created');
  _applyMapStyle();
}

void _applyMapStyle() {
  print('🎨 Attempting to apply map style...');
  
  if (mapController == null) {
    print('❌ Map controller is null!');
    return;
  }
  
  Future.delayed(const Duration(milliseconds: 500), () async {
    try {
      print('🔄 Setting map style now...');
      await mapController!.setMapStyle(MapStyles.dark);
      print('✅ Map style applied successfully');
    } catch (e) {
      print('❌ Error applying map style: $e');
    }
  });
}

Future<void> _setMapStyle() async {
  if (mapController == null) return;
  
  try {
    // Wait a bit longer for map to fully initialize
    await Future.delayed(const Duration(milliseconds: 300));
    await mapController?.setMapStyle(MapStyles.dark);
    print('✅ Map style applied successfully');
  } catch (e) {
    print('❌ Error setting map style: $e');
  }
}

  @override
  Future<void> close() {
    mapController?.dispose();
    return super.close();
  }

    _CategoryStyle _getCategoryStyle(String category) {
  switch (category.toLowerCase()) {
    case 'hotel' || 'فندق':
      return const _CategoryStyle(
        borderColor: Colors.yellow,
        icon: Icons.hotel,
      );

    case 'restaurant' || 'breakfast' || 'lunch' || "مطعم" || 'عشاء' || 'فطور' :
      return const _CategoryStyle(
        borderColor: Colors.red,
        icon: Icons.restaurant,
      );

    case 'attraction' || 'معلم سياحي':
      return const _CategoryStyle(
        borderColor: Colors.blue,
        icon: Icons.attractions,
      );

    case 'shopping' || 'متجر':
      return const _CategoryStyle(
        borderColor: Colors.purple,
        icon: Icons.shopping_bag,
      );

    case 'coffee' || 'قهوة':
      return const _CategoryStyle(
        borderColor: Colors.brown,
        icon: Icons.coffee_outlined,
      );

    case 'park' || 'منتزه':
      return const _CategoryStyle(
        borderColor: Colors.green,
        icon: Icons.park,
      );

    default:
      return const _CategoryStyle(
        borderColor: Colors.black,
        icon: Icons.place,
      );
  }
}

}

class _CategoryStyle {
  final Color borderColor;
  final IconData icon;

  const _CategoryStyle({
    required this.borderColor,
    required this.icon,
  });

}

