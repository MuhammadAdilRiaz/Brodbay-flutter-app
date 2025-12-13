
import 'package:brodbay/models/products.dart';
import 'package:brodbay/providers/cart_providers.dart';
import 'package:brodbay/utils/cart_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailButton extends ConsumerWidget {
  final Product product;

  const ProductDetailButton({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    /// Check product already in cart or not
    final isInCart = ref.watch(
      cartProvider.select(
        (items) => items.any((e) => e.id == product.id),
      ),
    );

    return Column(
      children: [
        const SizedBox(height: 5),

        /// Add to Cart / Go to Cart
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(100, 35),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.deepOrangeAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () {
            handleAddToCart(
              context: context,
              ref: ref,
              product: product,
            );
          },
          child: Center(
            child: Text(
              isInCart ? "Go to Cart" : "Add to Cart",
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ),

        const SizedBox(height: 5),

        /// Buy Now
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(100, 35),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.deepOrangeAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () {
            // Buy now logic later
          },
          child: const Center(
            child: Text(
              "Buy Now",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
