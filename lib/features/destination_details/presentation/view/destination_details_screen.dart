// features/destination_details/presentation/view/destination_details_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/core/helper/app_constants.dart';
import 'package:listys_app/core/di/service_locator.dart';
import 'package:listys_app/features/destination_details/presentation/cubit/place_details_cubit.dart';
import 'package:listys_app/features/destination_details/domain/usecases/get_place_details_usecase.dart';
import 'package:listys_app/features/destination_details/presentation/widget/bottom_buttons.dart';
import 'package:listys_app/features/destination_details/presentation/widget/content_slider.dart';
import 'package:listys_app/features/destination_details/presentation/widget/image_slider_card.dart';

class DestinationDetailsScreen extends StatefulWidget {
  final int placeId;
  const DestinationDetailsScreen({super.key, required this.placeId});

  @override
  State<DestinationDetailsScreen> createState() =>
      _DestinationDetailsScreenState();
}

class _DestinationDetailsScreenState extends State<DestinationDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlaceDetailsCubit(getIt<GetPlaceDetailsUseCase>())
        ..fetchPlaceDetails(widget.placeId),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: BlocBuilder<PlaceDetailsCubit, PlaceDetailsState>(
            builder: (context, state) {
              if (state is PlaceDetailsLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              } else if (state is PlaceDetailsLoaded) {
                final place = state.place;

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Header with place name
                      Row(
                        children: [
                          const SizedBox(width: 8),
                          Expanded(
                            child: TitleHeader(title: place.name),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      ImageSlider(
                        images: place.images.isNotEmpty
                            ? place.images
                                .map((e) => e['image']?.toString() ?? '')
                                .where((url) => url.isNotEmpty)
                                .toList()
                            : place.image != null
                                ? [place.image!]
                                : [],
                      ),

                      const SizedBox(height: 20),

                      // Content Tabs
                      Expanded(
                        child: ChangeContentScreen(place: place),
                      ),
                      const SizedBox(height: 20),

                      // Bottom Buttons
                      BottomButtons(
                        latitude: place.latitude,
                        longitude: place.longitude,
                        placeName: place.name,
                      ),
                    ],
                  ),
                );
              } else if (state is PlaceDetailsError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 64,
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
                          context
                              .read<PlaceDetailsCubit>()
                              .fetchPlaceDetails(widget.placeId);
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
      ),
    );
  }
}
