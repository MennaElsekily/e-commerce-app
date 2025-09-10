class Product {
  final int id;
  final String title;
  final String description;
  final num price;
  final double discountPercentage;
  final num rating;
  final int stock;
  final String brand;
  final String category;
  final String thumbnail;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      price: (json['price'] is num) ? json['price'] as num : 0,
      discountPercentage: (json['discountPercentage'] is num)
          ? (json['discountPercentage'] as num).toDouble()
          : 0.0,
      rating: (json['rating'] is num) ? json['rating'] as num : 0,
      stock: json['stock'] ?? 0,
      brand: (json['brand'] ?? 'Unknown').toString(),
      category: (json['category'] ?? 'Uncategorized').toString(),
      thumbnail: json['thumbnail'] ?? 'https://via.placeholder.com/150',
      images: (json['images'] != null) ? List<String>.from(json['images']) : [],
    );
  }
}
