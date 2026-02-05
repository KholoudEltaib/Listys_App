// features/categories/presentation/view/categories_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/core/helper/app_constants.dart';
import 'package:listys_app/core/di/service_locator.dart';
import 'package:listys_app/core/localization/app_localizations.dart';
import 'package:listys_app/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:listys_app/features/categories/presentation/widget/categories_card.dart';
import 'package:listys_app/features/categories/domain/usecases/get_categories_usecase.dart';

class CategoriesScreen extends StatefulWidget {
  final int cityId;
  final String cityName;

  const CategoriesScreen({
    super.key,
    required this.cityId,
    this.cityName = '',
  });

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => CategoriesCubit(getIt<GetCategoriesUseCase>())
        ..fetchCategories(widget.cityId),
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
                    // IconButton(
                    //   icon: const Icon(Icons.arrow_back, color: Colors.white),
                    //   onPressed: () => Navigator.pop(context),
                    // ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TitleHeader(
                        title: widget.cityName.isNotEmpty
                            ? '${widget.cityName} - ${loc.categories}'
                            : loc.categories,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Categories List
                Expanded(
                  child: CategoriesCard(cityId: widget.cityId),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}