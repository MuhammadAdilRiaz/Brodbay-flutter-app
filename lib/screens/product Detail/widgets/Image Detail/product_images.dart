import 'package:brodbay/models/product%20model/products.dart';
import 'package:brodbay/providers/product%20detail%20provider/product_detail_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class ProductImages extends ConsumerWidget {
  final Product product;

  const ProductImages({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final images = product.images;
    final currentIndex = ref.watch(selectedImageIndexProvider);

    return Stack(
      children: [
        SizedBox(
          height: 420,
          child: PageView.builder(
            itemCount: images.length,
            onPageChanged: (index) {
              ref.read(selectedImageIndexProvider.notifier).state = index;
            },
            itemBuilder: (context, index) {
              return Image.network(
                images[index],
                fit: BoxFit.cover,
                width: double.infinity,
              );
            },
          ),
        ),

        /// DOT INDICATOR
        Positioned(
          bottom: 12,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              images.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: i == currentIndex ? 10 : 6,
                height: i == currentIndex ? 10 : 6,
                decoration: BoxDecoration(
                  color: i == currentIndex
                      ? Colors.white
                      : Colors.white54,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
