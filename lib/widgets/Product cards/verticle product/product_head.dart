
import 'package:brodbay/providers/product_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../screens/product Detail/product_detail.dart'; 
import 'product_card.dart'; 


   class ProductHead extends ConsumerWidget {
  const ProductHead({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TITLE
        const Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            'All Products',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        /// VERTICAL PRODUCTS
        productsAsync.when(
          data: (list) {
            if (list.isEmpty) {
              return const Center(child: Text('No products'));
            }

            return MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: list.length,
              itemBuilder: (context, index) {
                final p = list[index];
                return ProductCard(
                  product: p,
                  layout: ProductCardLayout.home,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProductDetailScreen(product: p),
                      ),
                    );
                  },
                );
              },
            );
          },
          loading: () => const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Text(e.toString()),
        ),
      ],
    );
  }
}
