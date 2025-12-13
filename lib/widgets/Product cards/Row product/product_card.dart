// lib/widgets/product_card.dart
import 'package:brodbay/models/products.dart';
import 'package:brodbay/utils/cart_action.dart';
import 'package:brodbay/widgets/common/rating_star.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;


  const ProductCard({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context, ) {

    final primary = (product.imageUrl.isNotEmpty)
        ? product.imageUrl
        : (product.images.isNotEmpty ? product.images.first : '');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 1.8 / 1,
                child: primary.isNotEmpty
                    ? Image.network(
                        primary,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: const Center(child: Icon(Icons.broken_image)),
                          );
                        },
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                      )
                    : Container(
                        color: Colors.grey[100],
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 36,
                            color: Colors.grey,
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    '${product.currencySymbol}${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFFF6304)),
                  ),
                ),
                const SizedBox(width: 6),
                if (product.regular_price != null)
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      '${product.currencySymbol}${product.regular_price!.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 12, decoration: TextDecoration.lineThrough, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                CompactSingleStar(
                 rating: product.average_rating,   // product.rating comes from model
                   size: 16,
                ),
                const SizedBox(width: 8),
                Text('|${product.sold} sold', style: const TextStyle(fontSize: 12, color: Colors.black)),
                const SizedBox(width: 16),
               /// Responsive Add to Cart Button
    Consumer(
  builder: (context, ref, _) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () {
        handleAddToCart(
          context: context,
          ref: ref,
          product: product,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(
          Icons.shopping_cart_outlined,
          size: 20,
          color: Colors.black,
        ),
      ),
    );
  },
),

              ],
            )
          ],
        ),
      ),
    );
  }
}
