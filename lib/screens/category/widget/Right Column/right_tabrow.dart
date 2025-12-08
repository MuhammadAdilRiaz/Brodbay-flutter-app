import 'package:brodbay/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/products.dart';
import '../../../../widgets/Product cards/Row product/product_card.dart';

class CategoryTabsScreen extends ConsumerWidget {
  // Provide products from parent. If null, an empty list is used.
  final List<Product>? products;
  final int? selectedCategoryIndex;

  const CategoryTabsScreen({
    this.products,
    this.selectedCategoryIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = selectedCategoryIndex ??
        ref.watch(categoryNotifierProvider.select((s) => s.selectedIndex));

    // Use passed products or fallback to empty list
    final List<Product> productList = products ?? <Product>[];

    return Column(
      children: [
        const SizedBox(height: 10),

        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 180,
              childAspectRatio: 0.60,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: productList.length,
            itemBuilder: (context, index) {
              final product = productList[index];
              return ProductCard(product: product);
            },
          ),
        ),
      ],
    );
  }
}
