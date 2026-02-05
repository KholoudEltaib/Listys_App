// features/nearby_map/presentation/widgets/map_view_controls.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/core/localization/app_localizations.dart';
import 'package:listys_app/features/nearby_map/presentation/cubit/nearby_map_cubit.dart';
import 'package:listys_app/features/nearby_map/presentation/cubit/nearby_map_state.dart';

class MapViewControls {
  static void showViewSettings(BuildContext context) {
    final cubit = context.read<NearbyMapCubit>();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: cubit,
          child: const _ViewSettingsSheet(),
        );
      },
    );
  }
}

class _ViewSettingsSheet extends StatefulWidget {
  const _ViewSettingsSheet();

  @override
  State<_ViewSettingsSheet> createState() => _ViewSettingsSheetState();
}

class _ViewSettingsSheetState extends State<_ViewSettingsSheet> {
  late ViewMode _selectedMode;
  late double _selectedRadius;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<NearbyMapCubit>();
    _selectedMode = cubit.viewMode;
    _selectedRadius = cubit.currentRadius;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A1A2E),
            Color(0xFF16213E),
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Title
              const Text(
                'View Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              // View Mode Selection
              const Text(
                'View Mode',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              _buildViewModeOption(
                icon: Icons.my_location,
                title: 'Nearby Places',
                subtitle: 'Within custom radius',
                mode: ViewMode.nearby,
              ),

              const SizedBox(height: 8),

              _buildViewModeOption(
                icon: Icons.location_city,
                title: 'Current City',
                subtitle: 'All places in your city',
                mode: ViewMode.city,
              ),

              const SizedBox(height: 8),

              _buildViewModeOption(
                icon: Icons.public,
                title: 'Show All',
                subtitle: 'All available places',
                mode: ViewMode.unlimited,
              ),

              // Radius Slider (only show for nearby mode)
              if (_selectedMode == ViewMode.nearby) ...[
                const SizedBox(height: 24),

                const Text(
                  'Search Radius',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Distance',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${_selectedRadius.toInt()} km',
                            style: const TextStyle(
                              color: Color(0xFFF9B933),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: const Color(0xFFF9B933),
                          inactiveTrackColor: Colors.white.withOpacity(0.1),
                          thumbColor: const Color(0xFFF9B933),
                          overlayColor: const Color(0xFFF9B933).withOpacity(0.2),
                          trackHeight: 4,
                        ),
                        child: Slider(
                          value: _selectedRadius,
                          min: 5,
                          max: 200,
                          divisions: 39,
                          onChanged: (value) {
                            setState(() {
                              _selectedRadius = value;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '5 km',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '200 km',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Quick radius options
                Wrap(
                  spacing: 8,
                  children: [10.0, 25.0, 50.0, 100.0].map((radius) {
                    return FilterChip(
                      label: Text('${radius.toInt()} km'),
                      selected: _selectedRadius == radius,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedRadius = radius;
                          });
                        }
                      },
                      backgroundColor: Colors.white.withOpacity(0.05),
                      selectedColor: const Color(0xFFF9B933).withOpacity(0.3),
                      labelStyle: TextStyle(
                        color: _selectedRadius == radius
                            ? const Color(0xFFF9B933)
                            : Colors.white70,
                        fontWeight: _selectedRadius == radius
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      checkmarkColor: const Color(0xFFF9B933),
                    );
                  }).toList(),
                ),
              ],

              const SizedBox(height: 24),

              // // City Filter (show available cities)
              // BlocBuilder<NearbyMapCubit, NearbyMapState>(
              //   builder: (context, state) {
              //     if (state is NearbyMapLoaded) {
              //       final cities = context.read<NearbyMapCubit>().getAvailableCities();
                    
              //       if (cities.length > 1) {
              //         return Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             const Text(
              //               'Filter by City',
              //               style: TextStyle(
              //                 color: Colors.white,
              //                 fontSize: 16,
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             ),
              //             const SizedBox(height: 12),
              //             Wrap(
              //               spacing: 8,
              //               runSpacing: 8,
              //               children: cities.map((city) {
              //                 return FilterChip(
              //                   label: Text(city),
              //                   selected: state.selectedCity == city,
              //                   onSelected: (selected) {
              //                     if (selected) {
              //                       context.read<NearbyMapCubit>().filterByCity(city);
              //                     } else {
              //                       context.read<NearbyMapCubit>().clearCityFilter();
              //                     }
              //                     Navigator.pop(context);
              //                   },
              //                   backgroundColor: Colors.white.withOpacity(0.05),
              //                   selectedColor: const Color(0xFFF9B933).withOpacity(0.3),
              //                   labelStyle: TextStyle(
              //                     color: state.selectedCity == city
              //                         ? const Color(0xFFF9B933)
              //                         : Colors.white70,
              //                   ),
              //                   checkmarkColor: const Color(0xFFF9B933),
              //                 );
              //               }).toList(),
              //             ),
              //             const SizedBox(height: 24),
              //           ],
              //         );
              //       }
              //     }
              //     return const SizedBox.shrink();
              //   },
              // ),

              // Apply Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF9B933),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    context.read<NearbyMapCubit>().loadNearbyPlaces(
                      radiusInKm: _selectedRadius,
                      mode: _selectedMode,
                    );
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Apply Settings',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewModeOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required ViewMode mode,
  }) {
    final isSelected = _selectedMode == mode;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMode = mode;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFF9B933).withOpacity(0.1)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFF9B933)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFF9B933).withOpacity(0.2)
                    : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? const Color(0xFFF9B933) : Colors.white70,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white60
                          : Colors.white54,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFFF9B933),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}