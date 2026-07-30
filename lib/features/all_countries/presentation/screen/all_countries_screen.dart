import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/core/localization/app_localizations.dart';
import 'package:listys_app/core/theme/shimmer_loading.dart';
import 'package:listys_app/features/home/domain/entities/home_entity.dart';
import 'package:listys_app/features/search/domain/entities/search_country.dart';
import 'package:listys_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:listys_app/features/search/presentation/cubit/search_state.dart';
import 'package:listys_app/features/home/presentation/widgets/header.dart';
// استيراد الكارد الخاص بكِ
import 'package:listys_app/features/home/presentation/widgets/country_card.dart'; 

class AllCountriesScreen extends StatefulWidget {
  const AllCountriesScreen({super.key});

  @override
  State<AllCountriesScreen> createState() => _AllCountriesScreenState();
}

class _AllCountriesScreenState extends State<AllCountriesScreen> {
  @override
  void initState() {
    super.initState();
    // استدعاء الدالة الخاصة بجلب البيانات
    context.read<SearchCubit>().loadSuggestions(); 
  }
  
  

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Colors.transparent, // ✅ تم إرجاع الخلفية الشفافة
      body: SafeArea(
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
                  const SizedBox(width: 12),
                  const Expanded(child: Header()),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                loc.all_countries ?? 'All Countries', 
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    return _buildContent(context, state);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildContent(BuildContext context, SearchState state) {
    final locale = context.read<SearchCubit>().currentLanguage ?? 'en';

    if (state is SearchInitial || state is SearchLoading) {
    return const ShimmerCardGrid(itemCount: 8);
  }

    if (state is SearchError) {
      return Center(
        child: Text(
          'Error: ${state.message}',
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    List<SearchCountry> countries = [];
    bool hasData = false;

    if (state is SearchCountriesLoaded) {
      countries = state.countries;
      hasData = true;
    } else if (state is SearchSuggestionsLoaded) {
      countries = state.countries;
      hasData = true;
    }

    if (hasData) {
      if (countries.isEmpty) {
        return const Center(
          child: Text(
            'No countries available',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        );
      }

      return GridView.builder(
        itemCount: countries.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.95, 
        ),
        itemBuilder: (context, index) {
          final searchCountry = countries[index];
          print('====> Image for ${searchCountry.name} is: "${searchCountry.image}"');
          return CountryCard(
            country: CountryEntity(
              id: searchCountry.id, 
              name: searchCountry.getLocalizedName(locale), 
              shortDescription: '', 
              description: '', 
              image: searchCountry.image ?? '', 
              cities: const [], 
            ),
          );
        },
      );
    }

    return const SizedBox();
  }
}