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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          // ✅ شيلنا الـ SingleChildScrollView عشان نثبت الـ Header
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              TitleHeader(title: loc.cities_of_country),
              const SizedBox(height: 20),
              // ✅ حطينا الكارد جوه Expanded عشان ياخد باقي المساحة ويعمل Scroll لوحده
              Expanded(
                child: CitiesCard(countryId: widget.countryId),
              ),
            ],
          ),
        ),
      ),
    );
  }
}