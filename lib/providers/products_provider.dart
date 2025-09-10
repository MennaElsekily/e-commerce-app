import 'dart:math';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductsProvider with ChangeNotifier {
  final ProductService _productService = ProductService();

  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;

  // ===== Filter state (aligned with dummyjson fields) =====
  final Set<String> _selectedBrands = {};
  final Set<String> _selectedCategories = {};
  bool _inStockOnly = false;

  double _minPrice = 0;
  double _maxPrice = 1000;
  double _minPriceAvail = 0;
  double _maxPriceAvail = 1000;

  double _minRating = 0; // product.rating is num
  double _minDiscount = 0; // product.discountPercentage is double

  // ===== Catalog data for UI =====
  final Set<String> _allBrands = {};
  final Set<String> _allCategories = {};

  // ===== Getters =====
  List<Product> get products => _filteredProducts;
  bool get isLoading => _isLoading;

  Set<String> get allBrands => _allBrands;
  Set<String> get allCategories => _allCategories;

  Set<String> get selectedBrands => _selectedBrands;
  Set<String> get selectedCategories => _selectedCategories;

  bool get inStockOnly => _inStockOnly;

  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  double get minPriceAvail => _minPriceAvail;
  double get maxPriceAvail => _maxPriceAvail;

  double get minRating => _minRating;
  double get minDiscount => _minDiscount;

  // ===== API =====
  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _productService.fetchProducts();

      // price range
      if (_products.isNotEmpty) {
        _minPriceAvail = _products.map((p) => p.price.toDouble()).reduce(min);
        _maxPriceAvail = _products.map((p) => p.price.toDouble()).reduce(max);
      } else {
        _minPriceAvail = 0;
        _maxPriceAvail = 1000;
      }
      _minPrice = _minPriceAvail;
      _maxPrice = _maxPriceAvail;

      // brands & categories
      _allBrands
        ..clear()
        ..addAll(
          _products.map((p) => p.brand).where((b) => b.trim().isNotEmpty),
        );

      _allCategories
        ..clear()
        ..addAll(
          _products.map((p) => p.category).where((c) => c.trim().isNotEmpty),
        );

      // permissive defaults
      _selectedBrands.clear();
      _selectedCategories.clear();
      _inStockOnly = false;
      _minRating = 0;
      _minDiscount = 0;

      _applyFiltersInternal();
    } catch (e) {
      _products = [];
      _filteredProducts = [];
      debugPrint('Error fetching products: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Search (applied on top of the filtered set)
  void searchByCategory(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      _applyFiltersInternal();
    } else {
      _filteredProducts = _filteredProducts.where((p) {
        final title = p.title.toLowerCase();
        final category = p.category.toLowerCase();
        return title.contains(q) || category.contains(q);
      }).toList();
    }
    notifyListeners();
  }

  // ===== Filter setters =====
  void toggleBrand(String brand) {
    if (_selectedBrands.contains(brand)) {
      _selectedBrands.remove(brand);
    } else {
      _selectedBrands.add(brand);
    }
    _applyFiltersInternal();
    notifyListeners();
  }

  void toggleCategory(String category) {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }
    _applyFiltersInternal();
    notifyListeners();
  }

  void setPriceRange(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    _applyFiltersInternal();
    notifyListeners();
  }

  void setMinRating(double value) {
    _minRating = value;
    _applyFiltersInternal();
    notifyListeners();
  }

  void setMinDiscount(double value) {
    _minDiscount = value;
    _applyFiltersInternal();
    notifyListeners();
  }

  void setInStockOnly(bool value) {
    _inStockOnly = value;
    _applyFiltersInternal();
    notifyListeners();
  }

  void clearFilters() {
    _selectedBrands.clear();
    _selectedCategories.clear();
    _inStockOnly = false;
    _minPrice = _minPriceAvail;
    _maxPrice = _maxPriceAvail;
    _minRating = 0;
    _minDiscount = 0;
    _applyFiltersInternal();
    notifyListeners();
  }

  // ===== Core filtering logic =====
  void _applyFiltersInternal() {
    _filteredProducts = _products.where((p) {
      // price
      final price = p.price.toDouble();
      final priceOk = price >= _minPrice && price <= _maxPrice;

      // brand
      final brandOk =
          _selectedBrands.isEmpty || _selectedBrands.contains(p.brand);

      // category
      final categoryOk =
          _selectedCategories.isEmpty ||
          _selectedCategories.contains(p.category);

      // stock
      final stockOk = !_inStockOnly || (p.stock > 0);

      // rating
      final ratingOk = (p.rating is num)
          ? (p.rating as num).toDouble() >= _minRating
          : true;

      // discount
      final discountOk = (p.discountPercentage >= _minDiscount);

      return priceOk &&
          brandOk &&
          categoryOk &&
          stockOk &&
          ratingOk &&
          discountOk;
    }).toList();
  }
}
