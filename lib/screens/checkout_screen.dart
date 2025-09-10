// screens/checkout_screen.dart
import 'package:e_commerce_app/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../models/cart_item.dart';
import 'order_history_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final double total;
  const CheckoutScreen({super.key, required this.total});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _paymentMethod = "paypal";

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Check Out", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Address
            Row(
              children: const [
                Icon(Icons.location_on, color: Colors.deepPurple),
                SizedBox(width: 8),
                Expanded(child: Text("325 15th Eighth Avenue, New York")),
              ],
            ),
            const SizedBox(height: 16),

            // Delivery time
            Row(
              children: const [
                Icon(Icons.access_time, color: Colors.deepPurple),
                SizedBox(width: 8),
                Text("6:00 pm, Wednesday 20"),
              ],
            ),
            const SizedBox(height: 24),

            // Order Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _SummaryRow(
                    label: "Items",
                    value: "${cartProvider.itemCount}",
                  ),
                  _SummaryRow(
                    label: "Total",
                    value: "\$${widget.total.toStringAsFixed(2)}",
                    isBold: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Payment methods
            const Text(
              "Choose payment method",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildPaymentOption(
              icon: "assets/images/paypal.png",
              title: "Paypal",
              value: "paypal",
              color: const Color(0xff00186A),
            ),
            _buildPaymentOption(
              icon: "assets/images/credit.png",
              title: "Credit Card",
              value: "credit",
              color: const Color(0xff00186A),
            ),
            _buildPaymentOption(
              icon: "assets/images/coin.png",
              title: "Cash",
              value: "cash",
              color: const Color(0xffC78C00),
            ),

            const Spacer(),

            // Checkout button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final ordersProvider = Provider.of<OrdersProvider>(
                  context,
                  listen: false,
                );

                final List<CartItem> items = cartProvider.items.values.toList();

                ordersProvider.addOrder(items, widget.total, _paymentMethod);

                cartProvider.clearCart();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
                );
              },
              child: Text("Pay with ${_paymentMethod.toUpperCase()}"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return ListTile(
      leading: ImageIcon(AssetImage(icon), color: color),
      title: Text(title),
      trailing: Radio<String>(
        value: value,
        groupValue: _paymentMethod,
        onChanged: (val) => setState(() => _paymentMethod = val!),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
