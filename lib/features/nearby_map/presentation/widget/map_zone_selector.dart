// features/nearby_map/presentation/widget/map_zone_selector.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/features/nearby_map/presentation/cubit/nearby_map_cubit.dart';
import 'package:listys_app/features/nearby_map/presentation/cubit/nearby_map_state.dart';

class MapZoneSelector extends StatelessWidget {
  const MapZoneSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NearbyMapCubit, NearbyMapState>(
      builder: (context, state) {
        if (state is! NearbyMapLoaded) return const SizedBox.shrink();

        final cubit = context.read<NearbyMapCubit>();

        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFF9B933).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // _ZoneChip(
              //   icon: Icons.my_location,
              //   label: '10 km',
              //   isSelected: state.viewMode == ViewMode.nearby && state.radius == 10,
              //   onTap: () {
              //     cubit.changeViewMode(ViewMode.nearby);
              //     cubit.changeRadius(10.0);
              //   },
              // ),
              // const SizedBox(width: 4),
              // _ZoneChip(
              //   icon: Icons.location_city,
              //   label: 'City',
              //   isSelected: state.viewMode == ViewMode.city,
              //   onTap: () {
              //     cubit.changeViewMode(ViewMode.city);
              //   },
              // ),
              // const SizedBox(width: 4),
              // _ZoneChip(
              //   icon: Icons.public,
              //   label: 'All',
              //   isSelected: state.viewMode == ViewMode.unlimited,
              //   onTap: () {
              //     cubit.changeViewMode(ViewMode.unlimited);
              //   },
              // ),
              // const SizedBox(width: 4),
              _ZoneChip(
                icon: Icons.tune,
                label: 'Filter Your Zone',
                isSelected: false,
                onTap: () {
                  _showAdvancedOptions(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAdvancedOptions(BuildContext context) {
    final cubit = context.read<NearbyMapCubit>();
    final state = cubit.state as NearbyMapLoaded;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: cubit,
          child: _AdvancedZoneOptions(
            currentRadius: state.radius,
            currentMode: state.viewMode,
          ),
        );
      },
    );
  }
}

class _ZoneChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ZoneChip({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFF9B933)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.black : Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdvancedZoneOptions extends StatefulWidget {
  final double currentRadius;
  final ViewMode currentMode;

  const _AdvancedZoneOptions({
    required this.currentRadius,
    required this.currentMode,
  });

  @override
  State<_AdvancedZoneOptions> createState() => _AdvancedZoneOptionsState();
}

class _AdvancedZoneOptionsState extends State<_AdvancedZoneOptions> {
  late double _selectedRadius;
  late ViewMode _selectedMode;

  @override
  void initState() {
    super.initState();
    _selectedRadius = widget.currentRadius;
    _selectedMode = widget.currentMode;
  }

  @override
  Widget build(BuildContext context) {
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
      child: SingleChildScrollView(
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
                  'Search Zone',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
        
                // Zone Mode Selection
                _buildModeOption(
                  icon: Icons.my_location,
                  title: 'Nearby',
                  subtitle: 'Custom radius (5-200 km)',
                  mode: ViewMode.nearby,
                ),
                const SizedBox(height: 12),
                _buildModeOption(
                  icon: Icons.location_city,
                  title: 'City',
                  subtitle: 'All places in current city',
                  mode: ViewMode.city,
                ),
                const SizedBox(height: 12),
                _buildModeOption(
                  icon: Icons.public,
                  title: 'Unlimited',
                  subtitle: 'Show all available places',
                  mode: ViewMode.unlimited,
                ),
        
                // Radius Slider (only for nearby mode)
                if (_selectedMode == ViewMode.nearby) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'Radius',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
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
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
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
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('5 km', style: TextStyle(color: Colors.white54, fontSize: 12)),
                            Text('200 km', style: TextStyle(color: Colors.white54, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: [5.0, 10.0, 25.0, 50.0, 100.0].map((radius) {
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
                    ),
                  ),
                ],
        
                const SizedBox(height: 24),
        
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
                      final cubit = context.read<NearbyMapCubit>();
                      cubit.loadNearbyPlaces(
                        radiusInKm: _selectedRadius,
                        mode: _selectedMode,
                      );
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Apply',
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
      ),
    );
  }

  Widget _buildModeOption({
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
              ? const Color(0xFFF9B933).withOpacity(0.15)
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
                      color: isSelected ? Colors.white60 : Colors.white54,
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