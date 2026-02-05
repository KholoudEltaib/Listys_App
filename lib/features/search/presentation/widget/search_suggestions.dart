import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/core/localization/app_localizations.dart';
import 'package:listys_app/features/search/domain/entities/search_country.dart';
import 'package:listys_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:listys_app/features/country_cities/presentation/view/country_cities_screen.dart';

class SearchSuggestionsWidget extends StatelessWidget {
  final List<SearchCountry> countries;

  const SearchSuggestionsWidget({
    super.key,
    required this.countries,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final cubit = context.read<SearchCubit>();
    final locale = cubit.currentLanguage ?? 'en';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
        loc.suggetions,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: countries.map((country) {
            final isSelected = cubit.currentFilter.selectedCountryId == country.id;
            return GestureDetector(
              onTap: () {
                cubit.applyCountryFilter(country.id);
                // Navigate to CountryCitiesScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CountryCitiesScreen(countryId: country.id),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xffFFC629)
                      : const Color(0xFF373739),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  country.getLocalizedName(locale),
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}