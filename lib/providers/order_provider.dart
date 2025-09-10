// providers/orders_provider.dart
import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

class OrdersProvider with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  void addOrder(
    List<CartItem> cartItems,
    double total,
    String paymentMethod, {
    String status = "active", // ✅ allow setting status
  }) {
    _orders.insert(
      0,
      Order(
        id: DateTime.now().toString(),
        items: cartItems,
        totalAmount: total,
        date: DateTime.now(),
        paymentMethod: paymentMethod,
        status: status,
      ),
    );
    notifyListeners();
  }

  // ✅ helpers
  List<Order> get activeOrders =>
      _orders.where((o) => o.status == "active").toList();

  List<Order> get completedOrders =>
      _orders.where((o) => o.status == "completed").toList();

  List<Order> get canceledOrders =>
      _orders.where((o) => o.status == "canceled").toList();
}
