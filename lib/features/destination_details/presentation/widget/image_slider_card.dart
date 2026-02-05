// features/destination_details/presentatoin/widget/image_slider_card.dart

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:listys_app/core/theme/app_color.dart';

class ImageSlider extends StatefulWidget {
  final List<String> images;
  
  const ImageSlider({
    super.key,
    this.images = const [],
  });

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final PageController _controller = PageController();

  List<String> get displayImages {
    if (widget.images.isEmpty) {
      // Default placeholder image
      return [
        // 'https://static.tildacdn.one/tild3961-3538-4262-b566-383838626537/david-peters-fBw4rdI.jpg',
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.image,
              size: 64,
              color: Colors.grey,
            ),
          ),
        ).toString(),
      ];
    }
    return widget.images;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _controller,
            itemCount: displayImages.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[800],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    displayImages[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.image,
                            size: 64,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          color: AppColors.primaryColor,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
        
        if (displayImages.length > 1) ...[
          const SizedBox(height: 16),
          SmoothPageIndicator(
            controller: _controller,
            count: displayImages.length,
            effect: const ExpandingDotsEffect(
              expansionFactor: 3,
              dotHeight: 8,
              dotWidth: 8,
              activeDotColor: AppColors.primaryColor,
              dotColor: Colors.grey,
            ),
          ),
        ],
      ],
    );
  }
}