import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/core/localization/app_localizations.dart';
import 'package:listys_app/core/theme/app_color.dart';
import 'package:listys_app/features/country_cities/presentation/view/country_cities_screen.dart';
import 'package:listys_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:listys_app/features/search/presentation/cubit/search_state.dart';
import 'package:listys_app/features/search/presentation/widget/filter_bottom_sheet.dart';

class SearchbarFilter extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSearch;

  const SearchbarFilter({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  State<SearchbarFilter> createState() => _SearchbarFilterState();
}

class _SearchbarFilterState extends State<SearchbarFilter> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _showResults = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchFocusNode.removeListener(_onFocusChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final cubit = context.read<SearchCubit>();
    cubit.searchCountries(_searchController.text);
  }

  void _onFocusChanged() {
    setState(() {
      _showResults = _searchFocusNode.hasFocus && _searchController.text.isNotEmpty;
    });
  }

  void _onCountrySelected(BuildContext context, dynamic country, String locale) {
    _searchFocusNode.unfocus();
    setState(() {
      _showResults = false;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CountryCitiesScreen(
          countryId: country.id,
        ),
      ),
    );
  }

  void _clearSearch() {
    _searchController.clear();
    final cubit = context.read<SearchCubit>();
    cubit.clearSearch();
    setState(() {
      _showResults = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final cubit = context.read<SearchCubit>();
    final locale = cubit.currentLanguage ?? 'en';

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[700]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: loc.search_for_any_place,
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          border: InputBorder.none,
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, color: Colors.grey),
                                  onPressed: _clearSearch,
                                )
                              : null,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _showResults = _searchFocusNode.hasFocus && value.isNotEmpty;
                          });
                        },
                        onTap: () {
                          if (_searchController.text.isNotEmpty) {
                            setState(() {
                              _showResults = true;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // const SizedBox(width: 12),
            // Container(
            //   height: 48,
            //   width: 48,
            //   decoration: BoxDecoration(
            //     color: AppColors.primaryColor,
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            //   child: IconButton(
            //     icon: const Icon(Icons.tune, color: Colors.black),
            //     onPressed: () {
            //       showFilterBottomSheet(context, context.read<SearchCubit>());
            //     },
            //   ),
            // ),
          ],
        ),
        
        // Results dropdown shown conditionally
        if (_showResults) ...[
          const SizedBox(height: 8),
          _buildResultsDropdown(context, locale),
        ],
      ],
    );
  }

  Widget _buildResultsDropdown(BuildContext context, String locale) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      decoration: BoxDecoration(
        color: const Color(0xFF373739),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state is SearchLoading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(
                  color: Color(0xffFFC629),
                ),
              ),
            );
          } else if (state is SearchCountriesLoaded) {
            if (state.countries.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'No countries found',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shrinkWrap: true,
              itemCount: state.countries.length,
              itemBuilder: (context, index) {
                final country = state.countries[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    title: Text(
                      country.getLocalizedName(locale),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                    onTap: () => _onCountrySelected(context, country, locale),
                  ),
                );
              },
            );
          } else if (state is SearchError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  state.message,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Search for a country to see results',
                style: TextStyle(
                  color: Colors.grey[600],
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