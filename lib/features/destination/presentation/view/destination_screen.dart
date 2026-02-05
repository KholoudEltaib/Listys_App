// features/destination/presentation/view/destination_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/core/helper/app_constants.dart';
import 'package:listys_app/core/di/service_locator.dart';
import 'package:listys_app/features/destination/presentation/cubit/place_cubit.dart';
import 'package:listys_app/features/destination/presentation/cubit/place_state.dart';
import 'package:listys_app/features/destination/presentation/widget/palce_card.dart';
import 'package:listys_app/features/destination/domain/usecases/get_places_usecase.dart';

class DestinationScreen extends StatefulWidget {
  final int? cityId;
  final int? categoryId;
  final String? query;
  final int? minRating;
  final String screenTitle;

  const DestinationScreen({
    super.key,
    this.cityId,
    this.categoryId,
    this.query,
    this.minRating,
    this.screenTitle = 'Destinations',
  });

  @override
  State<DestinationScreen> createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlacesCubit(getIt<GetPlacesUseCase>())
        ..fetchPlaces(
          cityId: widget.cityId,
          categoryId: widget.categoryId,
          query: widget.query,
          minRating: widget.minRating,
        ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    const SizedBox(width: 8),
                    Expanded( 
                      child: TitleHeader(title: widget.screenTitle),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Destination Content
                Expanded(
                  child: BlocBuilder<PlacesCubit, PlacesState>(
                    builder: (context, state) {
                      if (state is PlacesLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      } else if (state is PlacesLoaded) {
                        if (state.places.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_off,
                                  size: 64,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No places found',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Try adjusting your filters',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.separated(
                          itemCount: state.places.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (_, index) =>
                              DestinationCard(place: state.places[index]),
                        );
                      } else if (state is PlacesError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                state.message,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<PlacesCubit>().fetchPlaces(
                                        cityId: widget.cityId,
                                        categoryId: widget.categoryId,
                                        query: widget.query,
                                        minRating: widget.minRating,
                                      );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}