import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/core/localization/app_localizations.dart';
import 'package:listys_app/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:listys_app/features/favorite/presentation/cubit/favorite_state.dart';
import 'package:listys_app/features/favorite/presentation/widgets/button_filter.dart';
import 'package:listys_app/features/home/presentation/widgets/header.dart';
import 'package:listys_app/features/home/presentation/widgets/places_card.dart';

class FavoritePlace extends StatelessWidget {
  final int currentIndex;
  final Function(int) onSwitch;

  const FavoritePlace({
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
                        loc.favorite_places,
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
    if (state is FavoriteLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFF9B933)),
      );
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
                backgroundColor: const Color.fromARGB(255, 249, 51, 51),
              ),
              child: const Text('favRetry', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      );
    }

    if (state is FavoriteLoaded) {
      if (state.places.isEmpty) {
        return Center(
          child: Text(
            loc.no_favorite_places,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        );
      }

    return ListView.separated(
      itemCount: state.places.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final place = state.places[index];
        return PlaceCard(place: place);  
      },
    );
    }

    return Center(
      child: Text(
        loc.no_favorite_places,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}