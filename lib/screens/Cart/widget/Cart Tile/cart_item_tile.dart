import 'package:brodbay/models/cart_items.dart';
import 'package:brodbay/providers/cart_providers.dart';
import 'package:brodbay/screens/Cart/widget/Quantity/quantity_controll.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class CartItemTile extends ConsumerWidget {
  final CartItem item;
  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Checkbox(
          value: item.isSelected,
          onChanged: (_) {
            ref.read(cartProvider.notifier)
                .toggleSelection(item.id);
          },
        ),
        Image.network(item.image, width: 60),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title),
              Text("\$${item.price}"),
              QuantityController(item: item),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            ref.read(cartProvider.notifier)
                .removeItem(item.id);
          },
        )
      ],
    );
  }
}
