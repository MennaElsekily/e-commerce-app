import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final double ratingValue = (product.rating as num).toDouble();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    product.thumbnail,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Center(child: Icon(Icons.broken_image, size: 50)),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(
                        Icons.favorite_border,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),

            // 📋 Product Details
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "\$${product.price.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        ..._buildStars(ratingValue),
                        const SizedBox(width: 6),
                        Text(
                          ratingValue.toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 📝 Description
                    const Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.description,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),

            // 🛒 Bottom Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 6,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // ✅ Buy Now button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Provider.of<CartProvider>(
                          context,
                          listen: false,
                        ).addToCart(product);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to cart')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "Buy Now",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 🛍 Cart icon → go to CartScreen
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(
                        Icons.shopping_bag,
                        color: Color(0xff9E9E9E),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CartScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStars(double rating) {
    const starColor = Colors.amber;
    final fullStars = rating.floor();
    final hasHalf = (rating - fullStars) >= 0.25 && (rating - fullStars) < 0.75;
    final totalStars = 5;

    final stars = <Widget>[];
    for (int i = 0; i < fullStars && i < totalStars; i++) {
      stars.add(const Icon(Icons.star, color: starColor, size: 18));
    }
    if (hasHalf && stars.length < totalStars) {
      stars.add(const Icon(Icons.star_half, color: starColor, size: 18));
    }
    while (stars.length < totalStars) {
      stars.add(const Icon(Icons.star_border, color: starColor, size: 18));
    }
    return stars;
  }
}
