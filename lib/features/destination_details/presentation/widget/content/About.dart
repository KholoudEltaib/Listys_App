import 'package:flutter/material.dart';
import 'package:listys_app/core/localization/app_localizations.dart';
import 'package:listys_app/core/theme/app_color.dart';
import 'package:listys_app/features/destination/domain/entities/place.dart';

class About extends StatefulWidget {
  final Place place;

  const About({super.key, required this.place});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final facilities = widget.place.facilities ?? [];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.place.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Location section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Icon(
                                Icons.location_on,
                                color: Colors.grey,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.place.address,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: isExpanded ? null : 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (widget.place.address.length > 100)
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isExpanded = !isExpanded;
                                        });
                                      },
                                      child: Text(
                                        isExpanded ? 'Show less' : 'Show more',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // About section
                    Text(
                      '${loc.about_destination} ${widget.place.name}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.place.description ?? 'No description available.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 16),
                    
                    // ACTUAL FACILITIES FROM MODEL
                    if (facilities.isNotEmpty) ...[
                      Text(
                        loc.facilities,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: facilities.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            return FacilityItem(facility: facilities[index]);
                          },
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 24),
                      Text(
                        loc.facilities,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'No facilities information available',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FacilityItem extends StatelessWidget {
  final Facility facility;

  const FacilityItem({
    super.key,
    required this.facility,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display the facility icon from API
          _buildFacilityIcon(),
          const SizedBox(height: 8),
          Text(
            facility.name,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[400],
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityIcon() {
    if (facility.icon != null && facility.icon!.isNotEmpty) {
      return Image.network(
        facility.icon!,
        width: 28,
        height: 28,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              strokeWidth: 2,
              color: AppColors.primaryColor,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackIcon();
        },
      );
    }
        return _buildFallbackIcon();
  }

  Widget _buildFallbackIcon() {
    // Map common facility names to Material icons as fallback
    IconData getFallbackIcon(String facilityName) {
      final name = facilityName.toLowerCase();
      if (name.contains('wifi')) return Icons.wifi;
      if (name.contains('parking')) return Icons.local_parking;
      if (name.contains('pool')) return Icons.pool;
      if (name.contains('food') || name.contains('restaurant')) return Icons.restaurant;
      if (name.contains('sports') || name.contains('gym')) return Icons.sports_tennis_rounded;
      if (name.contains('ac') || name.contains('air conditioning')) return Icons.ac_unit;
      if (name.contains('tv')) return Icons.tv;
      if (name.contains('elevator') || name.contains('lift')) return Icons.elevator;
      if (name.contains('security')) return Icons.security;
      if (name.contains('breakfast')) return Icons.breakfast_dining;
      if (name.contains('bar')) return Icons.local_bar;
      if (name.contains('spa')) return Icons.spa;
      if (name.contains('fitness') || name.contains('gym')) return Icons.fitness_center;
      if (name.contains('laundry')) return Icons.local_laundry_service;
      if (name.contains('business')) return Icons.business_center;
      if (name.contains('conference')) return Icons.meeting_room;
      if (name.contains('shuttle')) return Icons.directions_bus;
      if (name.contains('beach')) return Icons.beach_access;
      if (name.contains('garden')) return Icons.nature;
      if (name.contains('library')) return Icons.menu_book;
      if (name.contains('playground')) return Icons.child_friendly;
      if (name.contains('pet')) return Icons.pets;
      if (name.contains('wheelchair')) return Icons.accessible;
      if (name.contains('kitchen')) return Icons.kitchen;
      return Icons.check_circle; // Default icon
    }

    return Icon(
      getFallbackIcon(facility.name),
      color: AppColors.primaryColor,
      size: 24,
    );
  }
}

