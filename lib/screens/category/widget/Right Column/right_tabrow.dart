import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:brodbay/models/products.dart';
import 'package:brodbay/widgets/Product cards/Row product/product_card.dart';

class CategoryTabsScreen extends ConsumerWidget {
  final List<Product>? products;
  final int? selectedCategoryIndex;

  const CategoryTabsScreen({
    this.products,
    this.selectedCategoryIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productList = products ?? [];

    if (productList.isEmpty) {
      return const Center(child: Text('No products found'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        
        final double availableWidth = constraints.maxWidth;

        // Decide columns based on right panel width
        int crossAxisCount = 2; // default for medium screens

        if (availableWidth >= 900) {
          crossAxisCount = 3; // large screens
        }

        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: MasonryGridView.count(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            itemCount: productList.length,
            itemBuilder: (context, index) {
              final product = productList[index];
              return ProductCard(product: product);
            },
          ),
        );
      },
    );
  }
}
