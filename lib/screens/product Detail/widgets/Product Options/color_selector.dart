import 'package:brodbay/models/products.dart';
import 'package:brodbay/providers/product_detail_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ColorSelector extends ConsumerWidget {
  final Product product;

  const ColorSelector({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedColor = ref.watch(selectedColorProvider);

    final colorAttr = product.attributes
        .where((a) => a.name.toLowerCase() == "colours")
        .toList();

    final colors = colorAttr.isNotEmpty
        ? colorAttr.first.terms.map((e) => e.name).toList()
        : <String>[];

    if (colors.isEmpty) return const SizedBox.shrink();

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      title: const Text(
        "Colour",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(selectedColor ?? colors.first),
      trailing: const Icon(Icons.keyboard_arrow_up),
      onTap: () {
        _openColorBottomSheet(context, ref, colors, product);
      },
    );
  }
}
void _openColorBottomSheet(
  BuildContext context,
  WidgetRef ref,
  List<String> colors,
  Product product,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      final selectedColor = ref.watch(selectedColorProvider);

      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Colour",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: colors.map((color) {
                final isSelected = color == selectedColor;

                return GestureDetector(
                  onTap: () {
                    ref.read(selectedColorProvider.notifier).state = color;

                    final index =
                        colors.indexOf(color) < product.images.length
                            ? colors.indexOf(color)
                            : 0;

                    ref.read(selectedImageIndexProvider.notifier).state = index;

                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                            isSelected ? Colors.orange : Colors.grey.shade300,
                      ),
                      color: isSelected
                          ? Colors.orange.withOpacity(0.08)
                          : Colors.white,
                    ),
                    child: Text(
                      color,
                      style: TextStyle(
                        color:
                            isSelected ? Colors.orange : Colors.black87,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    },
  );
}
