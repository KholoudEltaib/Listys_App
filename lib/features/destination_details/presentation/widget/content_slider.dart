// features/destination_details/presentatoin/widget/content_slider.dart

import 'package:flutter/material.dart';
import 'package:listys_app/core/localization/app_localizations.dart';
import 'package:listys_app/core/theme/app_color.dart';
import 'package:listys_app/features/destination/domain/entities/place.dart';
import 'package:listys_app/features/destination_details/presentation/widget/content/About.dart';
import 'package:listys_app/features/destination_details/presentation/widget/content/gallery.dart';
import 'package:listys_app/features/destination_details/presentation/widget/content/reviews.dart';

class ChangeContentScreen extends StatefulWidget {
  final Place place;

  const ChangeContentScreen({
    super.key,
    required this.place,
  });

  @override
  State<ChangeContentScreen> createState() => _ChangeContentScreenState();
}

class _ChangeContentScreenState extends State<ChangeContentScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // CONTENT SWITCHER BUTTONS
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[850]!.withOpacity(0.9),
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildButton(0, loc.about_destination),
                _buildButton(1, loc.gallery),
                _buildButton(2, loc.reviews),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // CHANGING CONTENT
        Expanded(
          child: IndexedStack(
            index: selectedIndex,
            children: [
              About(place: widget.place),
              Gallery(
                images: widget.place.images
                    .map((e) => e['image']?.toString() ?? '')
                    .where((url) => url.isNotEmpty)
                    .toList(),
              ),
              Reviews(place: widget.place),
            ],
          ),
        ),
      ],
    );
  }

  // SLIDER BUTTONS STYLE
  Widget _buildButton(int index, String title) {
    final bool isSelected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => selectedIndex = index);
        },
        child: Container(
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
