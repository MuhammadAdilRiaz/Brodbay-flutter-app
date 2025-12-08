// lib/widgets/price_section.dart
import 'package:brodbay/models/products.dart';
import 'package:brodbay/providers/product_detail_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class PriceSection extends ConsumerWidget {
  final Product product;

  const PriceSection({super.key, required this.product});

 

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantity = ref.watch(quantityProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFFFF6304), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top orange bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFFF6304),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(9),
                topRight: Radius.circular(9),
              ),
            ),
            child: const Text(
              "Welcome Deal",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),

          const SizedBox(height: 5),

          // Price row with quantity to the right
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                     Text(
                  '${product.currencySymbol}${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFF6304)),
                ),
                const SizedBox(width: 6),
                if (product.sale_price != null)
                  Text(
                    '${product.currencySymbol}${product.sale_price!.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 12, decoration: TextDecoration.lineThrough, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                    ],
                  ),
                ),

                // Right: quantity selector
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text("Qty"),
                      ),
                      const SizedBox(width: 14),
                      DropdownButton<int>(
                        value: quantity,
                        dropdownColor: Colors.white,
                        underline: const SizedBox(),
                        items: List.generate(10, (i) => i + 1)
                            .map((q) => DropdownMenuItem<int>(value: q, child: Text(q.toString())))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) ref.read(quantityProvider.notifier).state = val;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
