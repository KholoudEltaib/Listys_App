import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/core/localization/app_localizations.dart';
import 'package:listys_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:listys_app/features/home/presentation/cubit/home_state.dart';
import 'package:listys_app/features/home/presentation/widgets/country_card.dart';
import 'package:listys_app/features/home/presentation/widgets/header.dart';

class AllCountriesScreen extends StatelessWidget {
  const AllCountriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white12,
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                      const Header(),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    loc.all_popular_countries, 
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _buildContent(context, state),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, HomeState state) {
    final loc = AppLocalizations.of(context)!;
    
    if (state is HomeLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFF9B933)),
      );
    }

    if (state is HomeError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Error: ${state.message}',
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<HomeCubit>().loadHome(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF9B933),
              ),
              child: Text(loc.retry, style: const TextStyle(color: Colors.black)),
            ),
          ],
        ),
      );
    }

    if (state is HomeLoaded) {
      final countries = state.home.popularCountries;

      if (countries.isEmpty) {
        return Center(
          child: Text(
            loc.translate('no_countries_available'),
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        );
      }

      return GridView.builder(
        itemCount: countries.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          final country = countries[index];
          return CountryCard(country: country);
        },
      );
    }

    // Fallback for any other state
    return Center(
      child: Text(
        loc.translate('no_countries_available'),
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}