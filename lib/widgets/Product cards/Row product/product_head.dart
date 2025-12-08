// lib/widgets/product_head.dart
import 'package:brodbay/providers/product_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.78,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final p = list[index];
                  return ProductCard(
                    product: p,
                    onTap: () 
                    => Navigator.push(
                      context,
                     MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p,)),
                    ),
                  );
                },
              );
            }

            final cardWidth = MediaQuery.of(context).size.width * 0.45;
            final widthLimit = cardWidth > 172 ? 172.0 : cardWidth;
            return SizedBox(
              height: widthLimit * 1.5,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final p = list[index];
                  return Container(
                    width: widthLimit,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    child: ProductCard(
                      product: p,
                      onTap: () 
                      => Navigator.push(
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
