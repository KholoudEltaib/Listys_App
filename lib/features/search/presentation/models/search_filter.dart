class SearchFilter {
  final int? selectedCountryId;
  final int? selectedCityId;
  final int? selectedCategoryId;
  final double? minRating;
  final DateTime? startDate;
  final DateTime? endDate;

  const SearchFilter({
    this.selectedCountryId,
    this.selectedCityId,
    this.selectedCategoryId,
    this.minRating,
    this.startDate,
    this.endDate,
  });

  SearchFilter copyWith({
    int? selectedCountryId,
    int? selectedCityId,
    int? selectedCategoryId,
    double? minRating,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return SearchFilter(
      selectedCountryId: selectedCountryId ?? this.selectedCountryId,
      selectedCityId: selectedCityId ?? this.selectedCityId,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      minRating: minRating ?? this.minRating,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  SearchFilter clear() {
    return const SearchFilter();
  }

  bool get hasActiveFilters =>
      selectedCountryId != null ||
      selectedCityId != null ||
      selectedCategoryId != null ||
      minRating != null ||
      startDate != null ||
      endDate != null;
}