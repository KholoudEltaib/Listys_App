import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:listys_app/features/favorite/presentation/cubit/favorite_state.dart';
import 'package:listys_app/features/favorite/presentation/screens/empty_favorite.dart';
import 'package:listys_app/features/favorite/presentation/screens/favorite_country.dart';
import 'package:listys_app/features/favorite/presentation/screens/favorite_place.dart';

class FavoritesRoot extends StatefulWidget {
  const FavoritesRoot({super.key});

  @override
  State<FavoritesRoot> createState() => _FavoritesRootState();
}

class _FavoritesRootState extends State<FavoritesRoot> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load favorites when screen opens
    context.read<FavoriteCubit>().loadFavorites();
  }

  void switchPage(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          // Show empty state if no favorites
          if (state is FavoriteEmpty) {
            return const EmptyFavorite();
          }

          return SafeArea(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              children: [
                FavoriteCountry(
                  currentIndex: _currentIndex,
                  onSwitch: switchPage,
                ),
                FavoritePlace(
                  currentIndex: _currentIndex,
                  onSwitch: switchPage,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}