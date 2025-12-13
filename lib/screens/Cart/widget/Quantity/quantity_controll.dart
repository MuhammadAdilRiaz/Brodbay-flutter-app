import 'package:brodbay/models/cart_items.dart';
import 'package:brodbay/providers/cart_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class QuantityController extends ConsumerWidget {
  final CartItem item;
  const QuantityController({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: item.quantity > 1
              ? () {
                  ref.read(cartProvider.notifier)
                      .updateQuantity(item.id, item.quantity - 1);
                }
              : null,
        ),
        Text(item.quantity.toString()),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            ref.read(cartProvider.notifier)
                .updateQuantity(item.id, item.quantity + 1);
          },
        ),
      ],
    );
  }
}
