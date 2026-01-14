import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brodbay/providers/product%20provider/product_providers.dart';
import 'horizontal_product_list.dart';

class HorizontalProductHead extends ConsumerWidget {
  const HorizontalProductHead({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visible = ref.watch(visibleProductsProvider);

    final bool hasSaleProduct = visible.any(
      (p) => p.sale_price != null && p.sale_price! < p.price,
    );

    final String title =
        hasSaleProduct ? 'Super Deal' : 'Recommended';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const HorizontalProductList(),
      ],
    );
  }
}
