import 'cart_item.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime date;
  final String paymentMethod;
  final String status;

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.date,
    required this.paymentMethod,
    required this.status,
  });
}
