class CartItem {
  final int id; // product id
  final String title; // product name
  final String thumbnail; // product image
  final double price; // product price
  int quantity; // how many in cart

  CartItem({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.price,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;
}
