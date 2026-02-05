import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/core/theme/app_color.dart';
import 'package:listys_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:listys_app/features/search/presentation/cubit/search_state.dart';
import 'package:listys_app/features/search/presentation/models/search_filter.dart';

class FilterBottomSheet extends StatefulWidget {
  final SearchCubit searchCubit;

  const FilterBottomSheet({super.key, required this.searchCubit});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late SearchFilter tempFilter;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    tempFilter = widget.searchCubit.currentFilter;
    startDate = tempFilter.startDate;
    endDate = tempFilter.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      height: MediaQuery.of(context).size.height * 0.70,
      decoration: const BoxDecoration(
        color: Color(0xFF1D1D1D),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Filter by",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          dividerLine(),

          // POPULAR FILTERS (Countries)
          const SizedBox(height: 15),
          const Text(
            "Select Country",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),

          const SizedBox(height: 12),
          BlocBuilder<SearchCubit, SearchState>(
            bloc: widget.searchCubit,
            builder: (context, state) {
              if (state is SearchCountriesLoaded) {
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: state.countries.take(8).map((country) {
                    final isSelected = tempFilter.selectedCountryId == country.id;
                    final locale = widget.searchCubit.currentLanguage ?? 'en';
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          tempFilter = tempFilter.copyWith(
                            selectedCountryId: country.id,
                          );
                        });
                        // Load cities when country is selected
                        widget.searchCubit.searchCities('', country.id);
                      },
                      child: filterChip(
                        country.getLocalizedName(locale),
                        selected: isSelected,
                      ),
                    );
                  }).toList(),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Cities Filter (shown after country selection)
          if (tempFilter.selectedCountryId != null) ...[
            const SizedBox(height: 15),
            const Text(
              "Select City",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 12),
            BlocBuilder<SearchCubit, SearchState>(
              bloc: widget.searchCubit,
              builder: (context, state) {
                if (state is SearchCitiesLoaded) {
                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: state.cities.take(8).map((city) {
                      final isSelected = tempFilter.selectedCityId == city.id;
                      final locale = widget.searchCubit.currentLanguage ?? 'en';
                      
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            tempFilter = tempFilter.copyWith(
                              selectedCityId: city.id,
                            );
                          });
                          // Load categories when city is selected
                          widget.searchCubit.searchCategories('', city.id);
                        },
                        child: filterChip(
                          city.getLocalizedName(locale),
                          selected: isSelected,
                        ),
                      );
                    }).toList(),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],

          // Categories Filter (shown after city selection)
          if (tempFilter.selectedCityId != null) ...[
            const SizedBox(height: 15),
            const Text(
              "Select Category",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 12),
            BlocBuilder<SearchCubit, SearchState>(
              bloc: widget.searchCubit,
              builder: (context, state) {
                if (state is SearchCategoriesLoaded) {
                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: state.categories.take(6).map((category) {
                      final isSelected = tempFilter.selectedCategoryId == category.id;
                      final locale = widget.searchCubit.currentLanguage ?? 'en';
                      
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            tempFilter = tempFilter.copyWith(
                              selectedCategoryId: category.id,
                            );
                          });
                        },
                        child: filterChip(
                          category.getLocalizedName(locale),
                          selected: isSelected,
                        ),
                      );
                    }).toList(),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],

          const SizedBox(height: 25),
          const Text(
            "Trip Dates",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),

          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: startDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() {
                        startDate = picked;
                      });
                    }
                  },
                  child: dateBox(
                    startDate != null
                        ? "${startDate!.day} ${_getMonthName(startDate!.month)} ${startDate!.year}"
                        : "Start Date",
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: endDate ?? startDate ?? DateTime.now(),
                      firstDate: startDate ?? DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() {
                        endDate = picked;
                      });
                    }
                  },
                  child: dateBox(
                    endDate != null
                        ? "${endDate!.day} ${_getMonthName(endDate!.month)} ${endDate!.year}"
                        : "End Date",
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),
          const Text(
            "Star Rating",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),

          const SizedBox(height: 12),
          Row(
            children: [
              ratingBox("4.0", tempFilter.minRating == 4.0, () {
                setState(() {
                  tempFilter = tempFilter.copyWith(minRating: 4.0);
                });
              }),
              const SizedBox(width: 10),
              ratingBox("4.2", tempFilter.minRating == 4.2, () {
                setState(() {
                  tempFilter = tempFilter.copyWith(minRating: 4.2);
                });
              }),
              const SizedBox(width: 10),
              ratingBox("4.5", tempFilter.minRating == 4.5, () {
                setState(() {
                  tempFilter = tempFilter.copyWith(minRating: 4.5);
                });
              }),
              const SizedBox(width: 10),
              ratingBox("4.8", tempFilter.minRating == 4.8, () {
                setState(() {
                  tempFilter = tempFilter.copyWith(minRating: 4.8);
                });
              }),
            ],
          ),

          const Spacer(),

          // APPLY BUTTON
          GestureDetector(
            onTap: () {
              widget.searchCubit.updateFilter(tempFilter.copyWith(
                startDate: startDate,
                endDate: endDate,
              ));
              Navigator.pop(context);
            },
            child: Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: const Text(
                "Apply",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // CLEAR ALL BUTTON
          GestureDetector(
            onTap: () {
              setState(() {
                tempFilter = const SearchFilter();
                startDate = null;
                endDate = null;
              });
              widget.searchCubit.clearFilter();
            },
            child: Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: const Text(
                "Clear All",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}

void showFilterBottomSheet(BuildContext context, SearchCubit searchCubit) {
  // Load countries first
  searchCubit.searchCountries('');

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return FilterBottomSheet(searchCubit: searchCubit);
    },
  );
}

Widget dividerLine() {
  return Container(
    height: 1,
    width: double.infinity,
    color: Colors.white.withOpacity(0.1),
  );
}

Widget filterChip(String text, {bool selected = false}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    decoration: BoxDecoration(
      color: selected ? AppColors.primaryColor : const Color(0xFF373739),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: selected ? Colors.black : Colors.grey,
      ),
    ),
  );
}

Widget dateBox(String date) {
  return Container(
    height: 55,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.grey[850],
      borderRadius: BorderRadius.circular(6),
    ),
    child: Row(
      children: [
        const Icon(Icons.calendar_today, size: 18, color: Colors.white70),
        const SizedBox(width: 10),
        Text(
          date,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    ),
  );
}

Widget ratingBox(String rating, bool selected, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? AppColors.primaryColor : const Color(0xFF373739),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(
            Icons.star,
            color: selected ? Colors.black : AppColors.primaryColor,
            size: 20,
          ),
          const SizedBox(width: 6),
          Text(
            rating,
            style: TextStyle(
              color: selected ? Colors.black : AppColors.primaryColor,
            ),
          ),
        ],
      ),
    ),
  );
}
