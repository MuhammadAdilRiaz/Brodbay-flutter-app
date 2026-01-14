import 'package:brodbay/models/cart%20model/cart_items.dart';
import 'package:brodbay/models/product%20model/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart providers/cart_providers.dart';


void handleAddToCart({
  required BuildContext context,
  required WidgetRef ref,
  required Product product,
}) {
  final cartNotifier = ref.read(cartProvider.notifier);

  // prevent duplicate entrys
  if (!cartNotifier.isInCart(product.id)) {
    cartNotifier.addItem(
      CartItem(
        id: product.id,
        title: product.title,
        image: product.imageUrl,
        price: product.price,
        regular_price: product.regular_price,
        quantity: product.minQty,
        minQty: product.minQty,
        maxQty: product.maxQty,
        stepQty: product.stepQty,
        sellerId: 'default',
      ),
    );
  }

  // optional feedback
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Added to cart")),
  );
}
