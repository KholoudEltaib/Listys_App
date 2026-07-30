import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/core/localization/app_localizations.dart';
import 'package:listys_app/core/theme/shimmer_loading.dart'; // ✅ تم إضافة الـ import
import 'package:listys_app/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:listys_app/features/favorite/presentation/cubit/favorite_state.dart';
import 'package:listys_app/features/favorite/presentation/widgets/button_filter.dart';
import 'package:listys_app/features/home/presentation/widgets/country_card.dart';
import 'package:listys_app/features/home/presentation/widgets/header.dart';

class FavoriteCountry extends StatelessWidget {
  final int currentIndex;
  final Function(int) onSwitch;

  const FavoriteCountry({
    super.key,
    required this.currentIndex,
    required this.onSwitch,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          return Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Header(),
                      const SizedBox(height: 12),
                      Text(
                        loc.favorite_countries ?? 'Favorite Countries',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ButtonFilter(
                        currentIndex: currentIndex,
                        onSwitch: onSwitch,
                      ),
                      const SizedBox(height: 12),
                      
                      Expanded(
                        child: _buildContent(context, state),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, FavoriteState state) {
    final loc = AppLocalizations.of(context)!;
    
    // ✅ تم استبدال مؤشر التحميل بالـ Shimmer
    if (state is FavoriteLoading) {
      return const ShimmerCardGrid(itemCount: 6);
    }

    if (state is FavoriteError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${state.message}',
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<FavoriteCubit>().loadFavorites(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF9B933),
              ),
              child: const Text('Retry', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      );
    }

    if (state is FavoriteLoaded) {
      if (state.countries.isEmpty) {
        return Center(
          child: Text(
            loc.no_favorite_countries ?? 'No favorite countries',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        );
      }

      return GridView.builder(
        itemCount: state.countries.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.95,
        ),
        itemBuilder: (context, index) {
          final country = state.countries[index];
          return CountryCard(country: country);  
        },
      );
    }

    return Center(
      child: Text(
        loc.no_favorite_countries ?? 'No favorite countries',
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}