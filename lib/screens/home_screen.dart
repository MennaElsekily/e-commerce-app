import 'package:e_commerce_app/providers/auth_provider.dart';
import 'package:e_commerce_app/screens/productdetail_screen.dart';
import 'package:e_commerce_app/screens/cart_screen.dart';
import 'package:e_commerce_app/screens/products_screen.dart';
import 'package:e_commerce_app/screens/search_result_screen.dart';
import 'package:e_commerce_app/screens/filter_screen.dart';
import 'package:e_commerce_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/products_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProductsProvider>(context, listen: false);
    provider.fetchProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _onItemTapped(int index) async {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        // Home – no-op
        break;

      case 1:
        // Focus search on Home
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        FocusScope.of(context).requestFocus(_searchFocusNode);
        break;

      case 2:
        // Cart
        await Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const CartScreen()));
        if (!mounted) return;
        setState(() => _selectedIndex = 0); // return highlight to Home
        break;

      case 3:
        // Profile
        await Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
        if (!mounted) return;
        setState(() => _selectedIndex = 0); // return highlight to Home
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final productsProvider = context.watch<ProductsProvider>();
    final user = authProvider.currentUser;

    // Resolve avatar (network/asset/fallback)
    ImageProvider avatarImage;
    final img = user?.profileImage ?? '';
    if (img.isNotEmpty &&
        (img.startsWith('http://') || img.startsWith('https://'))) {
      avatarImage = NetworkImage(img);
    } else if (img.isNotEmpty) {
      avatarImage = AssetImage(img);
    } else {
      avatarImage = const AssetImage('assets/images/profile.jpg');
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(backgroundImage: avatarImage),
        ),
        title: Text(
          "Hello!\n${user?.userName ?? "Guest"}",
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Filter',
            icon: const Icon(Icons.tune, color: Colors.black, size: 26),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FilterScreen()),
              );
            },
          ),
          const SizedBox(width: 4),
          IconButton(
            tooltip: 'Notifications',
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.black,
              size: 26,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 12),
        ],
      ),

      body: productsProvider.isLoading && productsProvider.products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: productsProvider.fetchProducts,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (query) {
                          final q = query.trim();
                          if (q.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SearchResultsScreen(query: q),
                              ),
                            );
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Search by category or name",
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: (_searchController.text.isNotEmpty)
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {});
                                  },
                                )
                              : null,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),

                    // Promo banner
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Get Winter Discount",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "20% Off For Children",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Image.asset("assets/images/kid.png", height: 100),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Featured
                    _buildSectionHeader(
                      context,
                      "Featured",
                      onSeeAll: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProductsScreen(),
                          ),
                        ).then((res) {
                          if (!mounted) return;
                          if (res == 'focus-search') {
                            _onItemTapped(1); // focus the search bar on Home
                          }
                        });
                      },
                    ),
                    _buildHorizontalList(productsProvider.products),

                    const SizedBox(height: 20),

                    // Most Popular
                    _buildSectionHeader(
                      context,
                      "Most Popular",
                      onSeeAll: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProductsScreen(),
                          ),
                        ).then((res) {
                          if (!mounted) return;
                          if (res == 'focus-search') {
                            _onItemTapped(1); // focus the search bar on Home
                          }
                        });
                      },
                    ),
                    _buildHorizontalList(
                      productsProvider.products.reversed.toList(),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        iconSize: 30,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title, {
    required VoidCallback onSeeAll,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextButton(onPressed: onSeeAll, child: const Text("See All")),
        ],
      ),
    );
  }

  Widget _buildHorizontalList(List<Product> products) {
    if (products.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              "No products found",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length > 6 ? 6 : products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailScreen(product: product),
                ),
              );
            },
            child: Container(
              width: 150,
              margin: const EdgeInsets.only(left: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.network(
                        product.thumbnail.isNotEmpty
                            ? product.thumbnail
                            : "https://via.placeholder.com/150",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image, size: 50),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title.isNotEmpty ? product.title : "Untitled",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "\$${product.price}",
                          style: const TextStyle(color: Colors.deepPurple),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
