// lib/features/home/presentation/widgets/country_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:listys_app/features/country_cities/presentation/view/country_cities_screen.dart';
import 'package:listys_app/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:listys_app/features/home/domain/entities/home_entity.dart';

class CountryCard extends StatelessWidget {
  final CountryEntity country;

  const CountryCard({
    super.key,
    required this.country,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CountryCitiesScreen(countryId: country.id),
          ),
        );
      },
      child: Container(
        width: 200,
        padding: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0x07FFFFFF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0x09FFFFFF), width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: country.image.isNotEmpty
              ? (country.image.endsWith('.svg')
                  ? SvgPicture.network(
                      country.image,
                      height: 108,
                      width: 230,
                      fit: BoxFit.cover,
                      placeholderBuilder: (context) => _placeholder(),
                    )
                  : Image.network(
                      country.image,
                      height: 108,
                      width: 200 - 16,
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
                      final isFavorite = context.read<FavoriteCubit>().isFavorite(country.id, 'country');
                      
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          print('❤️ Favorite tapped: ${country.name}');
                          context.read<FavoriteCubit>().toggleFavorite(
                                id: country.id,
                                type: 'country',
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
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    country.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    country.shortDescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                      height: 1.25,
                    ),
                  ),
                ],
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