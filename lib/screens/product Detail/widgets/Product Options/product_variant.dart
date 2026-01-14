import 'package:brodbay/models/product%20model/products.dart';
import 'package:brodbay/providers/product%20detail%20provider/product_detail_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VariantSelector extends ConsumerWidget {
  final Product product;

  const VariantSelector({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedColor = ref.watch(selectedColorProvider);
    final selectedSize = ref.watch(selectedSizeProvider);

    final colors = product.attributes
        .where((a) => a.name.toLowerCase() == "colours")
        .expand((a) => a.terms)
        .map((e) => e.name)
        .toList();

    final sizes = product.attributes
        .where((a) => a.name == "Sizes")
        .expand((a) => a.terms)
        .map((e) => e.name)
        .toList();

    if (colors.isEmpty && sizes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              _openVariantSheet(context, ref, product, colors, sizes);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "Colour: ${selectedColor ?? colors.first}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              _openVariantSheet(context, ref, product, colors, sizes);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                "Size: ${selectedSize ?? sizes.first}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
void _openVariantSheet(
  BuildContext context,
  WidgetRef ref,
  Product product,
  List<String> colors,
  List<String> sizes,
) {
  showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.white,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  ),
  builder: (_) {
    return Consumer(
      builder: (context, ref, _) {
        final selectedColor = ref.watch(selectedColorProvider);
        final selectedSize = ref.watch(selectedSizeProvider);

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Select Options",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// COLORS
                if (colors.isNotEmpty) ...[
                  const Text(
                    "Colour",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: colors.map((color) {
                      final isSelected = color == selectedColor;

                      return GestureDetector(
                        onTap: () {
                          ref
                              .read(selectedColorProvider.notifier)
                              .state = color;

                          final index = colors.indexOf(color);
                          ref
                              .read(selectedImageIndexProvider.notifier)
                              .state = index;
                        },
                        child: _OptionChip(
                          label: color,
                          isSelected: isSelected,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                ],

                /// SIZES
                if (sizes.isNotEmpty) ...[
                  const Text(
                    "Size",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: sizes.map((size) {
                      final isSelected = size == selectedSize;

                      return GestureDetector(
                        onTap: () {
                          ref
                              .read(selectedSizeProvider.notifier)
                              .state = size;
                        },
                        child: _OptionChip(
                          label: size,
                          isSelected: isSelected,
                        ),
                      );
                    }).toList(),
                  ),
                ],

                const SizedBox(height: 30),

                /// DONE BUTTON
                Center(
                  child: SizedBox(
                    width: 140,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                       style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
                      child: const Text("Done",
                      style: TextStyle(fontSize: 14, color: Colors.orange),),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  },
);
}
class _OptionChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _OptionChip({
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.orange : Colors.grey.shade300,
        ),
        color:
            isSelected ? Colors.orange.withOpacity(0.08) : Colors.white,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: isSelected ? Colors.orange : Colors.black87,
        ),
      ),
    );
  }
}
