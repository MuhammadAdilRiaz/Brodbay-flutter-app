
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

    final cartItems = ref.watch(cartProvider);
final isInCart = cartItems.any((e) => e.id == product.id);


    return Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Expanded(
      child: ElevatedButton(
  style: ElevatedButton.styleFrom(
    minimumSize: const Size(0, 42),
    padding: const EdgeInsets.symmetric(horizontal: 12),
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
  child: const Text(
    "Add to Cart",
    style: TextStyle(color: Colors.white),
  ),
)

    ),

    const SizedBox(width: 10),

    Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(0, 42),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {
          // Buy now logic
        },
        child: const Text(
          "Buy Now",
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),
  ],
);

  }
}
