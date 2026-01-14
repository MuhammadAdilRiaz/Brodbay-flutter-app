import 'dart:math';
import 'package:brodbay/widgets/Product%20cards/Row%20product/horizontal_product_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brodbay/models/product%20model/products.dart';
import 'package:brodbay/providers/product%20provider/product_providers.dart';

import '../../../screens/product Detail/product_detail.dart';

class HorizontalProductList extends ConsumerWidget {
  const HorizontalProductList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visible = ref.watch(visibleProductsProvider);
    final meta = ref.watch(productsRowMetaProvider);
    final currentVisibleCount = ref.watch(productRowVisibleCountProvider);
    final cfg = ref.watch(productRowConfigProvider);

    // Responsive card width based on screen
    final double screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth = min(screenWidth * 0.45, 172);

    return SizedBox(
      height: cardWidth / 1.6 + 120, // dynamic height = image + content
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: visible.length +
              (meta.hasMore ? 1 : 0) +
              (!meta.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            // VIEW MORE
            if (index == visible.length && meta.hasMore) {
              return _ViewMoreTile(
                width: cardWidth,
                onTap: () {
                  final next =
                      min(currentVisibleCount + cfg.limit, meta.totalCount);
                  ref
                      .read(productRowVisibleCountProvider.notifier)
                      .state = next;
                },
              );
            }
        
            // VIEW LESS
            if (index == visible.length && !meta.hasMore) {
              return _ViewLessTile(
                width: cardWidth,
                onTap: () {
                  ref.read(productRowVisibleCountProvider.notifier).state =
                      cfg.limit;
                },
              );
            }
        
            final Product p = visible[index];
        
            return HorizontalProductCard(
              width: cardWidth,
              product: p,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(product: p),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _ViewMoreTile extends StatelessWidget {
  final double width;
  final VoidCallback onTap;
  const _ViewMoreTile({required this.width, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: onTap,
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('View more'),
              SizedBox(width: 6),
              Icon(Icons.arrow_circle_right_outlined),
            ],
          ),
        ),
      ),
    );
  }
}

class _ViewLessTile extends StatelessWidget {
  final double width;
  final VoidCallback onTap;
  const _ViewLessTile({required this.width, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: onTap,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.remove),
              SizedBox(height: 6),
              Text('View less'),
            ],
          ),
        ),
      ),
    );
  }
}
