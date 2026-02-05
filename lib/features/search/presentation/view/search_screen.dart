import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/core/helper/app_constants.dart';
import 'package:listys_app/core/localization/app_localizations.dart';
import 'package:listys_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:listys_app/features/search/presentation/cubit/search_state.dart';
import 'package:listys_app/features/search/presentation/widget/search_history.dart';
import 'package:listys_app/features/search/presentation/widget/search_suggestions.dart';
import 'package:listys_app/features/search/presentation/widget/searchbar_filter.dart';
import 'package:listys_app/features/search/presentation/widget/search_results.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SearchCubit>().loadSuggestions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              TitleHeader(title: loc.search_places),
              const SizedBox(height: 20),
              SearchbarFilter(
                controller: _searchController,
                onSearch: (query) {
                  if (query.isNotEmpty) {
                    context.read<SearchCubit>().searchPlaces(query);
                  }
                },
              ),
              const SizedBox(height: 25),
              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    if (state is SearchLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xffFFC629),
                        ),
                      );
                    }

                    if (state is SearchError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.message,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is SearchPlacesLoaded) {
                      return SearchResults(
                        places: state.places,
                        query: state.query,
                      );
                    }

                    if (state is SearchCountriesLoaded) {
                      return SearchSuggestionsWidget(
                        countries: state.countries,
                      );
                    }

                    if (state is SearchSuggestionsLoaded) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            SearchSuggestionsWidget(
                              countries: state.countries,
                            ),
                            const SizedBox(height: 25),
                            HistoryWidget(
                              history: context.read<SearchCubit>().searchHistory,
                              onHistoryTap: (query) {
                                _searchController.text = query;
                                context.read<SearchCubit>().searchPlaces(query);
                              },
                              onHistoryRemove: (query) {
                                context.read<SearchCubit>().removeFromHistory(query);
                              },
                              onClearAll: () {
                                context.read<SearchCubit>().clearHistory();
                              },
                            ),
                          ],
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          const SearchSuggestionsWidget(countries: []),
                          const SizedBox(height: 25),
                          HistoryWidget(
                            history: context.read<SearchCubit>().searchHistory,
                            onHistoryTap: (query) {
                              _searchController.text = query;
                              context.read<SearchCubit>().searchPlaces(query);
                            },
                            onHistoryRemove: (query) {
                              context.read<SearchCubit>().removeFromHistory(query);
                            },
                            onClearAll: () {
                              context.read<SearchCubit>().clearHistory();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}