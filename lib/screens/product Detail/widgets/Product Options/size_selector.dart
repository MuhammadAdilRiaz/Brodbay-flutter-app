import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brodbay/providers/product_detail_providers.dart';
import 'package:brodbay/models/products.dart';

class SizeSelector extends ConsumerWidget {
  final Product product;

  const SizeSelector({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedVariation = ref.watch(selectedVariationProvider(product));

    final selectedSize = ref.watch(selectedSizeProvider);
    final isOpen = ref.watch(showSizeOptionsProvider);


    // Safe fetch of sizes
    final sizeAttr = product.attributes
        .where((a) => a.name == "Sizes")
        .toList();

   final sizes = sizeAttr.isNotEmpty
    ? sizeAttr.first.terms.map((e) => e.name).toList()
    : <String>[];

    if (sizes.isEmpty) return SizedBox.shrink();

    if (selectedSize == null && sizes.isNotEmpty) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ref.read(selectedSizeProvider.notifier).state = sizes.first;
  });
}


    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown button
          GestureDetector(
            onTap: () {
              ref.read(showSizeOptionsProvider.notifier).state = !isOpen;
            },
            child: Row(
              children: [
                const Text(
                  "Size",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                Text(
                  selectedSize ?? sizes.first,
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(width: 6),
                Icon(
                  isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 20,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Options appear below
          if (isOpen)
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: sizes.map((size) {
                final isSelected = size == selectedSize;
                return GestureDetector(
                  onTap: () {
                    ref.read(selectedSizeProvider.notifier).state = size;
                 
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: isSelected
                              ? Colors.orange
                              : Colors.grey.shade300),
                      color: isSelected
                          ? Colors.orange.withOpacity(0.08)
                          : Colors.white,
                    ),
                    child: Text(
                      size,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.orange : Colors.black87,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
