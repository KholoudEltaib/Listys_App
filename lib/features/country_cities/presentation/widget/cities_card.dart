import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/features/categories/presentation/view/categories_screen.dart';
import 'package:listys_app/features/country_cities/presentation/cubit/cities_cubit.dart';
import 'package:listys_app/features/country_cities/domain/usecases/get_cities_usecase.dart';
import 'package:listys_app/core/di/service_locator.dart'; 
import 'package:listys_app/core/debug/agent_log.dart';

class CitiesCard extends StatefulWidget {
  final int countryId;
  const CitiesCard({super.key, required this.countryId});

  @override
  State<CitiesCard> createState() => _CitiesCardState();
}

class _CitiesCardState extends State<CitiesCard> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CitiesCubit(getIt<GetCitiesUseCase>())..fetchCities(widget.countryId),
      child: BlocBuilder<CitiesCubit, CitiesState>(
        builder: (context, state) {
          if (state is CitiesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CitiesLoaded) {
            // #region agent log
            agentLog(
              location: 'cities_card.dart:state',
              message: 'CitiesLoaded state in CitiesCard',
              data: {
                'countryId': widget.countryId,
                'citiesCount': state.cities.length,
              },
              hypothesisId: 'H1',
              runId: 'pre-fix',
            );
            // #endregion
            return Column(
              children: state.cities.map((city) {
                return CitiesItem(
                  imageUrl: city.image ?? '',
                  title: city.name,
                  onTap: () {
                  // #region agent log
                  agentLog(
                    location: 'cities_card.dart:onTap',
                    message: 'City tapped in CitiesCard',
                    data: {
                      'countryId': widget.countryId,
                      'cityId': city.id,
                      'cityName': city.name,
                    },
                    hypothesisId: 'H3',
                    runId: 'pre-fix',
                  );
                  // #endregion
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoriesScreen(
                        cityId: city.id,
                        cityName: city.name,
                      ),
                    ),
                  );
                },
                );
              }).toList(),
            );
          } else if (state is CitiesError) {
            // #region agent log
            agentLog(
              location: 'cities_card.dart:error',
              message: 'CitiesError state in CitiesCard',
              data: {
                'countryId': widget.countryId,
                'message': state.message,
              },
              hypothesisId: 'H2',
              runId: 'pre-fix',
            );
            // #endregion
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class CitiesItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final VoidCallback? onTap;

  const CitiesItem({
    super.key,
    required this.imageUrl,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0x07FFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0x09FFFFFF),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _placeholder(),
                      )
                    : _placeholder(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      height: 50,
      width: 50,
      color: Colors.grey[800],
      child: const Icon(Icons.image, color: Colors.grey),
    );
  }
}
