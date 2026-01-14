import 'package:brodbay/models/checkout_item.dart';
import 'package:brodbay/providers/cart_providers.dart';
import 'package:brodbay/providers/checkout_providers.dart';
import 'package:brodbay/screens/checkout/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartFooter extends ConsumerWidget {
  const CartFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);

    final selectedItems =
        cartItems.where((item) => item.isSelected).toList();

    final total = selectedItems.fold<double>(
      0,
      (sum, item) => sum + item.price * item.quantity,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Total: \$${total.toStringAsFixed(2)}"),

          TextButton(
            onPressed: selectedItems.isEmpty
                ? null
                : () {
                    // 1️⃣ Convert cart items to checkout items
                    final checkoutItems = selectedItems.map((item) {
                      return CheckoutItem(
                        productId: item.id,
                        title: item.title,
                        imageUrl: item.image,
                        price: item.price,
                        quantity: item.quantity,
                      );
                    }).toList();

                    // 2️⃣ Save in checkout provider
                    ref
                        .read(checkoutProvider.notifier)
                        .setItems(checkoutItems);

                    // 3️⃣ Navigate
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CheckoutScreen(),
                      ),
                    );
                  },
            child: const Text(
              "Checkout",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
