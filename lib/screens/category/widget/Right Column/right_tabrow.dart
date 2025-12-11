import 'package:brodbay/models/products.dart';
import 'package:brodbay/widgets/Product%20cards/Row%20product/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final productList = products ?? <Product>[];

    if (productList.isEmpty) {
      return const Center(child: Text('No products found'));
    }

    return Column(
      children: [
        const SizedBox(height: 10),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
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
