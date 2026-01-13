import 'package:brodbay/providers/category_provider.dart';
import 'package:brodbay/screens/product%20Detail/product_detail.dart';
import 'package:brodbay/widgets/Product%20cards/verticle%20product/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


class CategoryProductGrid extends ConsumerWidget {
  const CategoryProductGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(selectedCategoryProductsProvider);

    if (products.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: Text('No products found')),
      );
    }
  
    return MasonryGridView.count(
    crossAxisCount: 2,                    // two columns
    mainAxisSpacing: 8,
    crossAxisSpacing: 8,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.zero,
   itemCount: products.length,
    itemBuilder: (context, index) {
      final p = products[index];
      return ProductCard(
        product: p,
        layout: ProductCardLayout.home,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p)),
        ),
      );
    },
  );
  }
}
