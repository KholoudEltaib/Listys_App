import 'package:flutter/material.dart';
import 'package:listys_app/core/theme/app_color.dart';
import 'package:listys_app/features/home/domain/entities/home_entity.dart';

class PlacesFilter extends StatefulWidget {
  final List<CategoryEntity> categories;

  const PlacesFilter({super.key, required this.categories});

  @override
  State<PlacesFilter> createState() => _PlacesFilterState();
}

class _PlacesFilterState extends State<PlacesFilter> {
  int selectedPlaceFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          final category = widget.categories[index];
          final isSelected = index == selectedPlaceFilterIndex;
          return GestureDetector(
            onTap: () => setState(() => selectedPlaceFilterIndex = index),
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryColor : const Color(0xFF373739),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                category.name,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}