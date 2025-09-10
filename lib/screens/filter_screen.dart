// lib/screens/filter_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

const _kPurple = Color(0xFF6C4CFF);

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late Set<String> _brands;
  late Set<String> _categories;
  late RangeValues _priceRange;
  late double _minRating;
  late double _minDiscount;
  late bool _inStockOnly;

  @override
  void initState() {
    super.initState();
    final prov = context.read<ProductsProvider>();
    _brands = {...prov.selectedBrands};
    _categories = {...prov.selectedCategories};
    _priceRange = RangeValues(prov.minPrice, prov.maxPrice);
    _minRating = prov.minRating;
    _minDiscount = prov.minDiscount;
    _inStockOnly = prov.inStockOnly;
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<ProductsProvider>();
    double minP = prov.minPriceAvail;
    double maxP = prov.maxPriceAvail;
    if (minP == maxP) {
      minP = (minP - 1).clamp(0, double.infinity);
      maxP = maxP + 1;
    }

    final brands = prov.allBrands.toList()..sort();
    final categories = prov.allCategories.toList()..sort();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Filter', style: TextStyle(color: Colors.black)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _sectionTitle('Brand'),
          _chipsWrap(
            items: brands.take(8).toList(),
            isSelected: (s) => _brands.contains(s),
            onTap: (s) => setState(() {
              _brands.contains(s) ? _brands.remove(s) : _brands.add(s);
            }),
          ),
          const SizedBox(height: 16),

          _sectionTitle('Category'),
          _chipsWrap(
            items: categories.take(8).toList(),
            isSelected: (s) => _categories.contains(s),
            onTap: (s) => setState(() {
              _categories.contains(s)
                  ? _categories.remove(s)
                  : _categories.add(s);
            }),
          ),
          const SizedBox(height: 16),

          _sectionTitle('Price Range'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$${_priceRange.start.toStringAsFixed(0)}'),
              Text('\$${_priceRange.end.toStringAsFixed(0)}'),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _kPurple,
              thumbColor: _kPurple,
              overlayColor: _kPurple.withOpacity(.15),
              inactiveTrackColor: Colors.black12,
            ),
            child: RangeSlider(
              values: _priceRange,
              min: minP,
              max: maxP,
              onChanged: (v) => setState(() => _priceRange = v),
            ),
          ),
          const SizedBox(height: 8),

          _sectionTitle('Minimum Rating'),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _kPurple,
              thumbColor: _kPurple,
              inactiveTrackColor: Colors.black12,
            ),
            child: Slider(
              value: _minRating,
              min: 0,
              max: 5,
              divisions: 50,
              label: _minRating.toStringAsFixed(1),
              onChanged: (v) => setState(() => _minRating = v),
            ),
          ),

          _sectionTitle('Minimum Discount (%)'),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _kPurple,
              thumbColor: _kPurple,
              inactiveTrackColor: Colors.black12,
            ),
            child: Slider(
              value: _minDiscount,
              min: 0,
              max: 100,
              divisions: 100,
              label: _minDiscount.toStringAsFixed(0),
              onChanged: (v) => setState(() => _minDiscount = v),
            ),
          ),
          const SizedBox(height: 4),

          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SwitchListTile.adaptive(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              title: const Text('In stock only'),
              value: _inStockOnly,
              onChanged: (v) => setState(() => _inStockOnly = v),
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _kPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              onPressed: () {
                final p = context.read<ProductsProvider>();
                p.setPriceRange(_priceRange.start, _priceRange.end);
                p.setMinRating(_minRating);
                p.setMinDiscount(_minDiscount);
                p.setInStockOnly(_inStockOnly);

                for (final b in p.allBrands) {
                  final want = _brands.contains(b);
                  final has = p.selectedBrands.contains(b);
                  if (want != has) p.toggleBrand(b);
                }
                for (final c in p.allCategories) {
                  final want = _categories.contains(c);
                  final has = p.selectedCategories.contains(c);
                  if (want != has) p.toggleCategory(c);
                }

                Navigator.pop(context);
              },
              child: const Text(
                'Apply Filter',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          TextButton(
            onPressed: () {
              final p = context.read<ProductsProvider>();
              p.clearFilters();

              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      t,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  );

  Widget _chipsWrap({
    required List<String> items,
    required bool Function(String) isSelected,
    required void Function(String) onTap,
  }) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final item in items)
          GestureDetector(
            onTap: () => onTap(item),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected(item) ? _kPurple : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                item,
                style: TextStyle(
                  color: isSelected(item) ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
