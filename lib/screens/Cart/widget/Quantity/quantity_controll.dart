
import 'package:brodbay/models/cart%20model/cart_items.dart';
import 'package:brodbay/providers/cart%20providers/cart_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class QuantityController extends ConsumerStatefulWidget {
  final CartItem item;
  const QuantityController({super.key, required this.item});

  @override
  ConsumerState<QuantityController> createState() => _QuantityControllerState();
}

class _QuantityControllerState extends ConsumerState<QuantityController> {
  late int selectedQty;

  @override
  void initState() {
    super.initState();

    selectedQty = widget.item.quantity;
  }

  @override
  void didUpdateWidget(covariant QuantityController oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.item.quantity != widget.item.quantity) {
      selectedQty = widget.item.quantity;
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    if (item.maxQty <= 0) {
      return const Text(
        'Out of stock',
        style: TextStyle(color: Colors.red),
      );
    }

    final quantities = <int>[];
    for (int i = item.minQty; i <= item.maxQty; i += item.stepQty) {
      quantities.add(i);
    }

    return DropdownButton<int>(
      value: selectedQty,
       dropdownColor: Colors.white,
      underline: const SizedBox(),
      items: quantities
          .map((q) => DropdownMenuItem(
                value: q,
                child: Text(q.toString()),
              ))
          .toList(),
      onChanged: (value) {
        if (value == null) return;

        setState(() {
          selectedQty = value;
        });

        ref.read(cartProvider.notifier).updateQuantity(
              item.id,
              value,
            );
      },
    );
  }
}
