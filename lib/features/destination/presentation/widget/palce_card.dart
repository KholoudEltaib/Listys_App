// features/destination/presentation/widget/destination_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/core/theme/app_color.dart';
import 'package:listys_app/features/destination/domain/entities/place.dart';
import 'package:listys_app/features/destination_details/presentation/view/destination_details_screen.dart';
import 'package:listys_app/features/favorite/presentation/cubit/favorite_cubit.dart';

class DestinationCard extends StatelessWidget {
  final Place place;
  const DestinationCard({
    super.key,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DestinationDetailsScreen(placeId: place.id),
          ),
        );
      },
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          color: const Color(0x07FFFFFF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0x09FFFFFF), width: 1),
        ),
        child: Row(
          children: [
            // Square image on left
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: place.image != null && place.image!.isNotEmpty
                        ? Image.network(
                            place.image!,
                            width: 140,
                            height: 110,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _placeholder(),
                          )
                        : _placeholder(),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: BlocBuilder<FavoriteCubit, dynamic>(
                    builder: (context, state) {
                      final isFavorite = context
                          .read<FavoriteCubit>()
                          .isFavorite(place.id, 'place');

                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          context.read<FavoriteCubit>().toggleFavorite(
                                id: place.id,
                                type: 'place',
                              );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.black,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  ),
                  ),
                ),
              ],
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Name and Rating
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            place.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (place.averageRating != null ||
                            place.rating != null)
                          Row(
                            children: [
                              Icon(Icons.star,
                                  size: 14, color: AppColors.primaryColor),
                              const SizedBox(width: 4),
                              Text(
                                (place.averageRating ?? place.rating ?? 0)
                                    .toStringAsFixed(1),
                                style: const TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Address
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            size: 20, color: Colors.grey[400]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            place.address,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Category and City Info
                    Row(
                      children: [
                        if (place.category != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              place.category!.name,
                              style: const TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (place.city != null)
                          Expanded(
                            child: Text(
                              place.city!.name,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 140,
      height: 110,
      color: Colors.grey[800],
      child: Icon(Icons.image, color: Colors.grey[600]),
    );
  }
}