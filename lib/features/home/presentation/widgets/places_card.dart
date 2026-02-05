// lib/features/home/presentation/widgets/places_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:listys_app/core/theme/app_color.dart';
import 'package:listys_app/features/destination_details/presentation/view/destination_details_screen.dart';
import 'package:listys_app/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:listys_app/features/home/domain/entities/home_entity.dart';

class PlaceCard extends StatelessWidget {
  final PlaceEntity place;

  const PlaceCard({
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
        width: 350,
        decoration: BoxDecoration(
          color: const Color(0x07FFFFFF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0x09FFFFFF), width: 1),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: place.image.isNotEmpty
              ? (place.image.endsWith('.svg')
                  ? SvgPicture.network(
                      place.image,
                      height: 108,
                      width: 130,
                      fit: BoxFit.cover,
                      placeholderBuilder: (context) => _placeholder(),
                    )
                  : Image.network(
                      place.image,
                      height: 108,
                      width: 130,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _placeholder(),
                    ))
              : _placeholder(),
              ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: BlocBuilder<FavoriteCubit, dynamic>(
                    builder: (context, state) {
                      final isFavorite = context.read<FavoriteCubit>().isFavorite(place.id, 'place');
                      
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          print('❤️ Favorite button tapped: ${place.name}');
                          context.read<FavoriteCubit>().toggleFavorite(
                                id: place.id,
                                type: 'place',
                              );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
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
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                        if (place.rating != null && place.rating! > 0) ...[
                          const SizedBox(width: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star, size: 14, color: AppColors.primaryColor),
                              const SizedBox(width: 4),
                              Text(
                                place.rating!.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 20, color: Colors.grey[400]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            place.address,
                            style: TextStyle(color: Colors.grey[400], fontSize: 16),
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
      height: 108,
      width: 200 - 16,  
      color: Colors.grey[800],
      child: const Icon(Icons.image, color: Colors.grey),
    );
  }
}
