import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brodbay/providers/product_detail_providers.dart';
import 'package:brodbay/models/products.dart';

class SizeSelector extends ConsumerWidget {
  final Product product;

  const SizeSelector({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSize = ref.watch(selectedSizeProvider);

    final sizeAttr = product.attributes
        .where((a) => a.name == "Sizes")
        .toList();

    final sizes = sizeAttr.isNotEmpty
        ? sizeAttr.first.terms.map((e) => e.name).toList()
        : <String>[];

    if (sizes.isEmpty) return const SizedBox.shrink();

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      title: const Text(
        "Size",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(selectedSize ?? sizes.first),
      trailing: const Icon(Icons.keyboard_arrow_up),
      onTap: () {
        _openSizeBottomSheet(context, ref, sizes);
      },
    );
  }
}
void _openSizeBottomSheet(
  BuildContext context,
  WidgetRef ref,
  List<String> sizes,
) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      final selectedSize = ref.watch(selectedSizeProvider);

      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Size",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: sizes.map((size) {
                final isSelected = size == selectedSize;

                return GestureDetector(
                  onTap: () {
                    ref.read(selectedSizeProvider.notifier).state = size;
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
                      size,
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
