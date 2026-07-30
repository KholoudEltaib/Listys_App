// features/destination_details/presentation/view/destination_details_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart'; // ✅ إضافة مكتبة Shimmer
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
                // ✅ استبدال مؤشر التحميل بتصميم الـ Skeleton المخصص للتفاصيل
                return _buildDetailsShimmer();
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

  // ✅ تصميم الـ Skeleton اللي بيحاكي شاشة التفاصيل
  Widget _buildDetailsShimmer() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[800]!,
        highlightColor: Colors.grey[700]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shimmer Header (يحاكي اسم المكان)
            Row(
              children: [
                const SizedBox(width: 8),
                Container(
                  width: 200,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Shimmer Image Slider
            Container(
              width: double.infinity,
              height: 250, // نفس ارتفاع السلايدر الأصلي
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 20),

            // Shimmer Content Tabs (أزرار التبديل)
            Row(
              children: [
                Container(
                  width: 100,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 100,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Shimmer Text Content (يحاكي التفاصيل الوصفية)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: double.infinity, height: 16, color: Colors.black),
                  const SizedBox(height: 10),
                  Container(width: double.infinity, height: 16, color: Colors.black),
                  const SizedBox(height: 10),
                  Container(width: double.infinity, height: 16, color: Colors.black),
                  const SizedBox(height: 10),
                  Container(width: 200, height: 16, color: Colors.black),
                  const SizedBox(height: 24),
                  
                  // كارت صغير بيحاكي الـ Info Card أو الخريطة
                  Container(
                    width: double.infinity,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Shimmer Bottom Buttons
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}