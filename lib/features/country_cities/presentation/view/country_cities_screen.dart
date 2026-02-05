import 'package:flutter/material.dart';
import 'package:listys_app/core/helper/app_constants.dart';
import 'package:listys_app/core/localization/app_localizations.dart';
import 'package:listys_app/features/country_cities/presentation/widget/cities_card.dart';

class CountryCitiesScreen extends StatefulWidget {
  const CountryCitiesScreen({super.key, required this.countryId});
  final int countryId;

  @override
  State<CountryCitiesScreen> createState() => _CountryCitiesScreenState();
}

class _CountryCitiesScreenState extends State<CountryCitiesScreen> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    TitleHeader(title: loc.cities_of_country),
                    const SizedBox(height: 20),
                    CitiesCard(countryId: widget.countryId),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
