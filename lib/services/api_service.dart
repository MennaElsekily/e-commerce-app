import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductService {
  final String baseUrl = 'https://dummyjson.com/products';
  static const _timeout = Duration(seconds: 12);

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(baseUrl)).timeout(_timeout);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final list = (data['products'] as List?) ?? [];
      return list.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load products (${response.statusCode})");
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    final response = await http
        .get(Uri.parse('$baseUrl/search?q=$query'))
        .timeout(_timeout);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final list = (data['products'] as List?) ?? [];
      return list.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception("Search failed (${response.statusCode})");
    }
  }

  Future<List<Product>> fetchByCategory(String category) async {
    final response = await http
        .get(Uri.parse('$baseUrl/category/$category'))
        .timeout(_timeout);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final list = (data['products'] as List?) ?? [];
      return list.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception("Category fetch failed (${response.statusCode})");
    }
  }

  Future<Product> fetchProductById(int id) async {
    final response = await http
        .get(Uri.parse('$baseUrl/$id'))
        .timeout(_timeout);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return Product.fromJson(data);
    } else {
      throw Exception("Failed to load product (${response.statusCode})");
    }
  }
}
