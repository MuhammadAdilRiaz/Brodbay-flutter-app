import 'package:brodbay/models/products.dart';
import 'package:brodbay/providers/product_detail_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ColorSelector extends ConsumerWidget {
  final Product product;

  const ColorSelector({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedVariation = ref.watch(selectedVariationProvider(product));

    final selectedColor = ref.watch(selectedColorProvider);
    final isOpen = ref.watch(showColorOptionsProvider);

   final colorAttr = product.attributes
    .where((a) => a.name.toLowerCase() == "colours")
    .toList();

final colors = colorAttr.isNotEmpty
    ? colorAttr.first.terms.map((e) => e.name).toList()
    : <String>[];
if (colors.isEmpty) return const SizedBox.shrink();

if (selectedColor == null && colors.isNotEmpty) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ref.read(selectedColorProvider.notifier).state = colors.first;
  });
}


    return Container(
       margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              ref.read(showColorOptionsProvider.notifier).state = !isOpen;
            },
            child: Row(
              children: [
                const Text(
                  "Colour",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10,),
                Text(
                  selectedColor ?? colors.first,
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
      
          // EXPANDED OPTIONS
          if (isOpen)
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(colors.length, (index) {
                final color = colors[index];
                final isSelected = color == selectedColor;
      
                return GestureDetector(
                  onTap: () {
                    ref.read(selectedColorProvider.notifier).state = color;
      
                    final imageIndex =
                        index < product.images.length ? index : 0;
      
                    ref.read(selectedImageIndexProvider.notifier).state =
                        imageIndex;
      
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? Colors.orange
                            : Colors.grey.shade300,
                      ),
                      color: isSelected
                          ? Colors.orange.withOpacity(0.08)
                          : Colors.white,
                    ),
                    child: Text(
                      color,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Colors.orange
                            : Colors.black87,
                      ),
                    ),
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }
}
