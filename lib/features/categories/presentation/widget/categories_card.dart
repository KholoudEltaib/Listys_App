// features/categories/presentation/widget/categories_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart'; // ✅ تم إضافة مكتبة الـ Shimmer
import 'package:listys_app/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:listys_app/features/categories/presentation/cubit/categories_satet.dart';
import 'package:listys_app/features/destination/presentation/view/destination_screen.dart';

class CategoriesCard extends StatelessWidget {
  final int cityId;

  const CategoriesCard({super.key, required this.cityId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        if (state is CategoriesLoading) {
          // ✅ تم استبدال مؤشر التحميل بتصميم الـ Skeleton
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(
              6, // نعرض 6 كروت وهمية أثناء التحميل
              (index) => const CategoryShimmerSkeleton(),
            ),
          );
        } else if (state is CategoriesLoaded) {
          if (state.categories.isEmpty) {
            return const Center(
              child: Text(
                'No categories found',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            );
          }

          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: state.categories.map((category) {
              return CategoryItem(
                imageUrl: category.image ?? '',
                title: category.name,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DestinationScreen(
                        cityId: cityId,
                        categoryId: category.id,
                        screenTitle: category.name,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
        } else if (state is CategoriesError) {
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
                    context.read<CategoriesCubit>().fetchCategories(cityId);
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
    );
  }
}

// ✅ كلاس الهيكل الوهمي (Skeleton) اللي بيحاكي شكل الكارت الحقيقي
class CategoryShimmerSkeleton extends StatelessWidget {
  const CategoryShimmerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalPadding = 16 * 2;
    double spacing = 12;
    double itemWidth = (screenWidth - horizontalPadding - spacing) / 2;

    return Container(
      width: itemWidth,
      padding: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0x07FFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x09FFFFFF), width: 1),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[800]!,
        highlightColor: Colors.grey[700]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // مساحة الصورة الوهمية
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 108,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.black, // الـ Shimmer بيحتاج لون مصمت عشان يظهر
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
              ),
            ),
            // مساحة النص الوهمي
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Container(
                height: 18,
                width: itemWidth * 0.7, // النص بياخد 70% من عرض الكارت
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// الكارت الحقيقي (لم يتغير)
class CategoryItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final VoidCallback? onTap;

  const CategoryItem({
    super.key,
    required this.imageUrl,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalPadding = 16 * 2;
    double spacing = 12;
    double itemWidth = (screenWidth - horizontalPadding - spacing) / 2;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: itemWidth,
        padding: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0x07FFFFFF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0x09FFFFFF), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        height: 108,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _placeholder(),
                      )
                    : _placeholder(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      height: 108,
      color: Colors.grey[800],
      child: const Icon(Icons.image, color: Colors.grey),
    );
  }
}