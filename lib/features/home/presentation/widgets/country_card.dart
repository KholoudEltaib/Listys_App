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
          mainAxisSize: MainAxisSize.min, // يخلي الكولوم ياخد مساحة الداتا بس
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
                                width: double.infinity, // يفضل استخدام double.infinity عشان يملأ العرض المتاح
                                fit: BoxFit.cover,
                                placeholderBuilder: (context) => _placeholder(),
                              )
                            : Image.network(
                                country.image,
                                height: 108,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  print('❌ Error loading image for ${country.name}: $error');
                                  return _placeholder();
                                },
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
            
            // جعل النصوص تتجاوب مع المساحة وتتمدد إذا لزم الأمر
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      country.name,
                      maxLines: 2, // ✅ السماح بسطرين
                      overflow: TextOverflow.ellipsis, // وضع نقاط إذا زاد عن سطرين
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                        height: 1.2, // ✅ تظبيط المسافة بين السطرين لشكل مريح للعين
                      ),
                    ),
                    
                    // ✅ التحقق من وجود وصف قبل حجز مساحة له في الـ UI
                    if (country.shortDescription.trim().isNotEmpty) ...[
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
      width: double.infinity,
      color: Colors.grey[800],
      child: const Icon(Icons.image, color: Colors.grey),
    );
  }
}