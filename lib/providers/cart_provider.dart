import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  final Map<int, CartItem> _items = {}; // key = product id

  Map<int, CartItem> get items => _items;

  int get itemCount => _items.length;

  double get subtotal =>
      _items.values.fold(0, (sum, item) => sum + item.totalPrice);

  double get discount => 4.0; // just example
  double get delivery => 2.0; // just example
  double get total => subtotal - discount + delivery;

  void addToCart(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity++;
    } else {
      _items[product.id] = CartItem(
        id: product.id,
        title: product.title,
        thumbnail: product.thumbnail,
        price: product.price.toDouble(),
      );
    }
    notifyListeners();
  }

  void removeFromCart(int id) {
    _items.remove(id);
    notifyListeners();
  }

  void increaseQuantity(int id) {
    _items[id]!.quantity++;
    notifyListeners();
  }

  void decreaseQuantity(int id) {
    if (_items[id]!.quantity > 1) {
      _items[id]!.quantity--;
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
