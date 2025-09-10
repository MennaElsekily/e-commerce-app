import 'cart_item.dart';

class Cart {
  final List<CartItem> items;

  Cart({this.items = const []});

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);

  double get shipping => 20.0;

  double get total => subtotal + shipping;
}
