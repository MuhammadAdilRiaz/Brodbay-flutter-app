import 'package:brodbay/models/cart_items.dart';
import 'package:brodbay/models/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_providers.dart';


void handleAddToCart({
  required BuildContext context,
  required WidgetRef ref,
  required Product product,
}) {
  final cartNotifier = ref.read(cartProvider.notifier);
  final alreadyInCart = cartNotifier.isInCart(product.id);

  if (!alreadyInCart) {
    cartNotifier.addOrIgnore(
      CartItem(
        id: product.id,
        title: product.title,
        image: product.imageUrl,
        price: product.price,
        quantity: 1,
        sellerId: 'default',
      ),
    );
  }

 Navigator.of(context).pushNamed('/cart');
}
