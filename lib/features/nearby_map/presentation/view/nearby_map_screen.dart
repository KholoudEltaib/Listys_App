// features/nearby_map/presentation/view/nearby_map_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:listys_app/core/localization/app_localizations.dart';
import 'package:listys_app/core/theme/app_color.dart';
import 'package:listys_app/core/utils/map_styles.dart';
import 'package:listys_app/features/nearby_map/presentation/cubit/nearby_map_cubit.dart';
import 'package:listys_app/features/nearby_map/presentation/cubit/nearby_map_state.dart';
import 'package:listys_app/features/nearby_map/presentation/widget/place_marker_info.dart';
import 'package:listys_app/features/nearby_map/presentation/widget/map_zone_selector.dart';
import 'package:listys_app/core/di/service_locator.dart';

class NearbyMapScreen extends StatelessWidget {
  const NearbyMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NearbyMapCubit>()..loadNearbyPlaces(),
      child: const NearbyMapView(),
    );
  }
}

class NearbyMapView extends StatefulWidget {
  const NearbyMapView({super.key});

  @override
  State<NearbyMapView> createState() => _NearbyMapViewState();
}

class _NearbyMapViewState extends State<NearbyMapView> {
  GoogleMapController? _mapController;


  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    context.read<NearbyMapCubit>().onMapCreated(controller);
    
    print('📍 GoogleMap onMapCreated callback triggered');
    
    // Apply dark style immediately
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      await controller.setMapStyle(MapStyles.dark);
      print('✅ Map style applied successfully!');
    } catch (e) {
      print('❌ Error setting map style: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context, loc),
            Expanded(
              child: BlocConsumer<NearbyMapCubit, NearbyMapState>(
                listener: (context, state) {
                  if (state is NearbyMapError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (state is NearbyMapLocationPermissionDenied) {
                    _showPermissionDialog(context, loc);
                  } else if (state is NearbyMapLocationServiceDisabled) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(loc.please_enable_location_service),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is NearbyMapLocationLoading) {
                    return _buildLoadingState(loc);
                  } else if (state is NearbyMapLoading) {
                    return _buildLoadingMapState(state, loc);
                  } else if (state is NearbyMapLoaded) {
                    return _buildMapView(context, state);
                  } else if (state is NearbyMapError) {
                    return _buildErrorState(context, state, loc);
                  }
                  return _buildLoadingState(loc);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Text(
            loc.nearby_places,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => context.read<NearbyMapCubit>().loadNearbyPlaces(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(AppLocalizations loc) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF9B933)),
          ),
          const SizedBox(height: 16),
          Text(
            loc.getting_your_location,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingMapState(NearbyMapLoading state, AppLocalizations loc) {
    return Stack(
      children: [
        if (state.userLocation != null)
          GoogleMap(
            compassEnabled: false,
            initialCameraPosition: CameraPosition(
              target: state.userLocation!,
              zoom: 12,
            ),
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
        Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF9B933)),
                ),
                const SizedBox(height: 16),
                Text(
                  loc.loading_nearby_places,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapView(BuildContext context, NearbyMapLoaded state) {
    return Stack(
      children: [
        GoogleMap(
          compassEnabled: false,
          onMapCreated: _onMapCreated,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: state.userLocation,
            zoom: 12,
          ),
          markers: state.markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          onTap: (_) {
            context.read<NearbyMapCubit>().clearSelection();
          },
        ),

        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MapZoneSelector(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Color(0xFFF9B933),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${state.places.length} places',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        if (state.selectedPlace != null)
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: PlaceMarkerInfo(place: state.selectedPlace!),
          ),

        Positioned(
          bottom: state.selectedPlace != null ? 350 : 16,
          right: 16,
          child: FloatingActionButton(
            heroTag: 'myLocation',
            backgroundColor: const Color(0xFFF9B933),
            onPressed: () {
              _mapController?.animateCamera(
                CameraUpdate.newLatLngZoom(state.userLocation, 14),
              );
            },
            child: const Icon(Icons.my_location, color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    NearbyMapError state,
    AppLocalizations loc,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF9B933),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              onPressed: () {
                context.read<NearbyMapCubit>().loadNearbyPlaces();
              },
              child: Text(
                loc.try_again,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPermissionDialog(BuildContext context, AppLocalizations loc) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text(
          loc.location_permission_required,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          loc.please_grant_location_permission_in_settings,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              loc.cancel,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF9B933),
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: Text(
              loc.settings,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}




































// // features/nearby_map/presentation/view/nearby_map_screen.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:listys_app/core/localization/app_localizations.dart';
// import 'package:listys_app/core/theme/app_color.dart';
// import 'package:listys_app/features/nearby_map/presentation/cubit/nearby_map_cubit.dart';
// import 'package:listys_app/features/nearby_map/presentation/cubit/nearby_map_state.dart';
// import 'package:listys_app/features/nearby_map/presentation/widget/place_marker_info.dart';
// import 'package:listys_app/features/nearby_map/presentation/widget/map_view_controls.dart';
// import 'package:listys_app/core/di/service_locator.dart';

// class NearbyMapScreen extends StatelessWidget {
//   final ViewMode? initialMode;
//   final double? initialRadius;

//   const NearbyMapScreen({
//     super.key,
//     this.initialMode,
//     this.initialRadius,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => getIt<NearbyMapCubit>()
//         ..loadNearbyPlaces(
//           radiusInKm: initialRadius,
//           mode: initialMode,
//         ),
//       child: const NearbyMapView(),
//     );
//   }
// }

// class NearbyMapView extends StatelessWidget {
//   const NearbyMapView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final loc = AppLocalizations.of(context)!;

//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: AppColors.backgroundGradient,
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               // Custom App Bar
//               _buildAppBar(context, loc),

//               // Map Content
//               Expanded(
//                 child: BlocConsumer<NearbyMapCubit, NearbyMapState>(
//                   listener: (context, state) {
//                     if (state is NearbyMapError) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(state.message),
//                           backgroundColor: Colors.red,
//                         ),
//                       );
//                     } else if (state is NearbyMapLocationPermissionDenied) {
//                       _showPermissionDialog(context, loc);
//                     } else if (state is NearbyMapLocationServiceDisabled) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(loc.please_enable_location_service),
//                           backgroundColor: Colors.orange,
//                         ),
//                       );
//                     }
//                   },
//                   builder: (context, state) {
//                     if (state is NearbyMapLocationLoading) {
//                       return _buildLoadingState(loc);
//                     } else if (state is NearbyMapLoading) {
//                       return _buildLoadingMapState(state, loc);
//                     } else if (state is NearbyMapLoaded) {
//                       return _buildMapView(context, state);
//                     } else if (state is NearbyMapError) {
//                       return _buildErrorState(context, state, loc);
//                     }
//                     return _buildLoadingState(loc);
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAppBar(BuildContext context, AppLocalizations loc) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       child: Row(
//         children: [
//           IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.white),
//             onPressed: () => Navigator.pop(context),
//           ),
//           const SizedBox(width: 8),
//           Text(
//             loc.nearby_places,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const Spacer(),
//           IconButton(
//             icon: const Icon(Icons.tune, color: Colors.white),
//             onPressed: () {
//               MapViewControls.showViewSettings(context);
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.refresh, color: Colors.white),
//             onPressed: () => context.read<NearbyMapCubit>().loadNearbyPlaces(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoadingState(AppLocalizations loc) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const CircularProgressIndicator(
//             valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF9B933)),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             loc.getting_your_location,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoadingMapState(NearbyMapLoading state, AppLocalizations loc) {
//     return Stack(
//       children: [
//         if (state.userLocation != null)
//           GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: state.userLocation!,
//               zoom: 12,
//             ),
//             myLocationEnabled: true,
//             myLocationButtonEnabled: false,
//             zoomControlsEnabled: false,
//           ),
//         Center(
//           child: Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.7),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF9B933)),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   loc.loading_nearby_places,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildMapView(BuildContext context, NearbyMapLoaded state) {
//     return Stack(
//       children: [
//         GoogleMap(
//           initialCameraPosition: CameraPosition(
//             target: state.userLocation,
//             zoom: 12,
//           ),
//           markers: state.markers,
//           myLocationEnabled: true,
//           myLocationButtonEnabled: false,
//           zoomControlsEnabled: false,
//           onMapCreated: (controller) {
//             context.read<NearbyMapCubit>().onMapCreated(controller);
//           },
//           onTap: (_) {
//             context.read<NearbyMapCubit>().clearSelection();
//           },
//         ),

//         // Places count badge with view mode info
//         Positioned(
//           top: 16,
//           left: 16,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.7),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Icon(
//                       Icons.location_on,
//                       color: Color(0xFFF9B933),
//                       size: 20,
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       '${state.places.length} places',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
              
//               const SizedBox(height: 8),
              
//               // View mode indicator
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF9B933).withOpacity(0.9),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       _getViewModeIcon(state.viewMode),
//                       color: Colors.black,
//                       size: 16,
//                     ),
//                     const SizedBox(width: 6),
//                     Text(
//                       _getViewModeText(state.viewMode, state.radius),
//                       style: const TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
              
//               // City filter indicator
//               if (state.selectedCity != null) ...[
//                 const SizedBox(height: 8),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.9),
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Icon(
//                         Icons.filter_alt,
//                         color: Colors.black87,
//                         size: 16,
//                       ),
//                       const SizedBox(width: 6),
//                       Text(
//                         state.selectedCity!,
//                         style: const TextStyle(
//                           color: Colors.black87,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),

//         // Selected place info
//         if (state.selectedPlace != null)
//           Positioned(
//             bottom: 16,
//             left: 16,
//             right: 16,
//             child: PlaceMarkerInfo(place: state.selectedPlace!),
//           ),

//         // My location button
//         Positioned(
//           bottom: state.selectedPlace != null ? 200 : 16,
//           right: 16,
//           child: FloatingActionButton(
//             backgroundColor: const Color(0xFFF9B933),
//             onPressed: () {
//               context.read<NearbyMapCubit>().mapController?.animateCamera(
//                     CameraUpdate.newLatLngZoom(state.userLocation, 14),
//                   );
//             },
//             child: const Icon(Icons.my_location, color: Colors.black),
//           ),
//         ),
//       ],
//     );
//   }

//   IconData _getViewModeIcon(ViewMode mode) {
//     switch (mode) {
//       case ViewMode.nearby:
//         return Icons.my_location;
//       case ViewMode.city:
//         return Icons.location_city;
//       case ViewMode.unlimited:
//         return Icons.public;
//     }
//   }

//   String _getViewModeText(ViewMode mode, double radius) {
//     switch (mode) {
//       case ViewMode.nearby:
//         return 'Within ${radius.toInt()} km';
//       case ViewMode.city:
//         return 'City View';
//       case ViewMode.unlimited:
//         return 'All Places';
//     }
//   }

//   Widget _buildErrorState(
//     BuildContext context,
//     NearbyMapError state,
//     AppLocalizations loc,
//   ) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(
//               Icons.error_outline,
//               color: Colors.red,
//               size: 64,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               state.message,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//               ),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFFF9B933),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 32,
//                   vertical: 16,
//                 ),
//               ),
//               onPressed: () {
//                 context.read<NearbyMapCubit>().loadNearbyPlaces();
//               },
//               child: Text(
//                 loc.try_again,
//                 style: const TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showPermissionDialog(BuildContext context, AppLocalizations loc) {
//     showDialog(
//       context: context,
//       builder: (dialogContext) => AlertDialog(
//         backgroundColor: const Color(0xFF1A1A2E),
//         title: Text(
//           loc.location_permission_required,
//           style: const TextStyle(color: Colors.white),
//         ),
//         content: Text(
//           loc.please_grant_location_permission_in_settings,
//           style: const TextStyle(color: Colors.white70),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(dialogContext),
//             child: Text(
//               loc.cancel,
//               style: const TextStyle(color: Colors.white70),
//             ),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFFF9B933),
//             ),
//             onPressed: () {
//               Navigator.pop(dialogContext);
//               // Open app settings
//               // You can use permission_handler package for this
//             },
//             child: Text(
//               loc.settings,
//               style: const TextStyle(color: Colors.black),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }