import 'package:brodbay/models/cart_items.dart';
import 'package:brodbay/providers/cart_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class QuantityController extends ConsumerWidget {
  final CartItem item;
  const QuantityController({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If backend stock is 0, show disabled state
    if (item.stock == 0) {
      return const Text(
        'Out of stock',
        style: TextStyle(fontSize: 12, color: Colors.red),
      );
    }

    // 🔑 CRITICAL FIX: ensure value exists in dropdown items
    final int safeQuantity =
        item.quantity.clamp(1, item.stock);

    return DropdownButton<int>(
      value: safeQuantity,
      underline: const SizedBox(),
      items: List.generate(
        item.stock,
        (index) {
          final value = index + 1;
          return DropdownMenuItem<int>(
            value: value,
            child: Text(value.toString()),
          );
        },
      ),
      onChanged: (value) {
        if (value != null) {
          ref
              .read(cartProvider.notifier)
              .updateQuantity(item.id, value);
        }
      },
    );
  }
}
