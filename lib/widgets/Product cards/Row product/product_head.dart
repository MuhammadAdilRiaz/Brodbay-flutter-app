// lib/widgets/product_head.dart
import 'dart:math';

import 'package:brodbay/models/products.dart';
import 'package:brodbay/providers/product_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../screens/product Detail/product_detail.dart';
import 'product_card.dart';

class ProductHead extends ConsumerWidget {
  final bool isVertical;
  const ProductHead({super.key, this.isVertical = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Row(
            children: [
              const Text('Products', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const Spacer(),
              TextButton(onPressed: (){}, child: const Text("Seeall",
               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.grey)))
            ],
          ),
        ),
        productsAsync.when(
          data: (list) {
            if (list.isEmpty) {
              return const SizedBox( child: Center(child: Text('No products')));
            }
            if (isVertical) {
  return MasonryGridView.count(
    crossAxisCount: 2,                    // two columns
    mainAxisSpacing: 8,
    crossAxisSpacing: 8,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.zero,
    itemCount: list.length,
    itemBuilder: (context, index) {
      final p = list[index];
      return ProductCard(
        product: p,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p)),
        ),
      );
    },
  );
}

           // Horizontal row: use Riverpod derived providers for all logic
            final visible = ref.watch(visibleProductsProvider);
            final meta = ref.watch(productsRowMetaProvider);
            final currentVisibleCount = ref.watch(productRowVisibleCountProvider);
            final cfg = ref.watch(productRowConfigProvider);
            final cardWidth = MediaQuery.of(context).size.width * 0.45;
            final widthLimit = cardWidth > 172 ? 172.0 : cardWidth;
            final double imageHeight = widthLimit / 1.8;
            final double titleHeight = 20.0;
            final double priceRowHeight = 20.0;
            final double ratingRowHeight = 18.0;
            final double innerVerticalGaps = 8.0 + 6.0 + 6.0;
            final double cardHeight = imageHeight + titleHeight + priceRowHeight + ratingRowHeight + innerVerticalGaps + 18.0;

            // show view more tile if there are more items beyond currentVisibleCount
            final showViewMoreTile = meta.hasMore;
            // when all items shown, we will show View less tile (instead of View more)
            final allItemsVisible = !meta.hasMore;

            final int totalItems = visible.length + (showViewMoreTile ? 1 : 0) + (allItemsVisible ? 0 : 0);
            // note: when allItemsVisible == true, visible.length == total source length

            return SizedBox(
              height: cardHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: visible.length + (showViewMoreTile ? 1 : 0) + (allItemsVisible ? 1 : 0),
                itemBuilder: (context, index) {
                  // When we still have more items, place the "View more" tile after the currently visible items
                  if (index == visible.length && showViewMoreTile) {
                    return Container(
                      width: widthLimit,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      child: GestureDetector(
                        onTap: () {

                          final next = min(currentVisibleCount + cfg.limit, meta.totalCount);
                          ref.read(productRowVisibleCountProvider.notifier).state = next;
                        },
                       
                         
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text('View more', textAlign: TextAlign.center),
                                  SizedBox(width: 6),
                                    Icon(Icons.arrow_circle_right_outlined),
                                ],
                              ),
                            ),
                          ),
                        
                      ),
                    );
                  }

                  if (index == visible.length && allItemsVisible) {
                    return Container(
                      width: widthLimit,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      child: GestureDetector(
                        onTap: () {
                          ref.read(productRowVisibleCountProvider.notifier).state = cfg.limit;
                        },
                     
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.remove),
                                  SizedBox(height: 6),
                                  Text('View less', textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          ),
                       
                      ),
                    );
                  }

                  final Product p = visible[index];
                  return Container(
                    width: widthLimit,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    child: ProductCard(
                      product: p,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p)),
                      ),
                    ),
                  );
                },
              ),
            );
          },
          loading: () => const SizedBox(height: 120, child: Center(child: CircularProgressIndicator())),
          error: (err, st) => SizedBox(height: 120, child: Center(child: Text('Error: ${err.toString()}'))),
        ),
      ],
    );
  }
}
