enum GenderFilter { all, men, women }

class FilterOptions {
  final GenderFilter gender;
  final Set<String> brands;
  final double minPrice;
  final double maxPrice;
  final Set<String> colors;

  const FilterOptions({
    this.gender = GenderFilter.all,
    this.brands = const {},
    this.minPrice = 0,
    this.maxPrice = 1000,
    this.colors = const {},
  });

  FilterOptions copyWith({
    GenderFilter? gender,
    Set<String>? brands,
    double? minPrice,
    double? maxPrice,
    Set<String>? colors,
  }) {
    return FilterOptions(
      gender: gender ?? this.gender,
      brands: brands ?? this.brands,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      colors: colors ?? this.colors,
    );
  }
}
