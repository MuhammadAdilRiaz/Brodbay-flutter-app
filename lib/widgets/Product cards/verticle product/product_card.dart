import 'package:brodbay/models/products.dart';
import 'package:brodbay/utils/cart_action.dart';
import 'package:brodbay/widgets/common/rating_star.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ProductCardLayout {
  home,      
  category,  
}
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final ProductCardLayout layout;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.layout = ProductCardLayout.home,
  });

  Widget _imagePlaceholder() {
  return Container(
    color: Colors.grey.shade200,
    alignment: Alignment.center,
    child: const SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(strokeWidth: 2),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    final primary = product.imageUrl.isNotEmpty
        ? product.imageUrl
        : (product.images.isNotEmpty ? product.images.first : '');

    final bool overlayCart = layout == ProductCardLayout.category;

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
    aspectRatio: 1 / 1, // square card, change if you want
    child: Stack(
      fit: StackFit.expand,
      children: [
        primary.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: primary,
                fit: BoxFit.contain, // ✅ image always fits inside
                placeholder: (context, url) => _imagePlaceholder(),
                errorWidget: (context, url, error) => _imageFallback(),
                useOldImageOnUrlChange: true,
              )
            : _imageFallback(),

        if (overlayCart)
          Positioned(
            right: 6,
            bottom: 6,
            child: _CartButton(
              product: product,
              isOverlay: true,
            ),
          ),
      ],
    ),
  ),
),


            /// TITLE
            Text(
              product.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 6),

            /// PRICE ROW
            Wrap(
              spacing: 6,
              runSpacing: 2,
              children: [
                Text(
                  '${product.currencySymbol}${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6304),
                  ),
                ),
                if (product.regular_price != null)
                  Text(
                    '${product.currencySymbol}${product.regular_price!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 12,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 6),

            /// RATING + SOLD + OPTIONAL CART BELOW
            Row(
              children: [
                CompactSingleStar(
                  rating: product.average_rating,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  '| ${product.sold} sold',
                  style: const TextStyle(fontSize: 12),
                ),
                const Spacer(),

                if (!overlayCart)
                  _CartButton(product: product,
                  isOverlay: false,),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.broken_image, size: 32, color: Colors.grey),
      ),
    );
  }
}

class _CartButton extends ConsumerWidget {
  final Product product;
  final bool isOverlay;

  const _CartButton({
    required this.product,
    required this.isOverlay,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
      
        alignment: Alignment.center,
        decoration: BoxDecoration(
          
          borderRadius: BorderRadius.circular(50),
          border: isOverlay
              ? null
              : Border.all(
                  color: Colors.grey.shade400,
                  width: 1,
                ),
        ),
        child: const Icon(
          Icons.shopping_cart_outlined,
          size: 16,
          color: Colors.black,
        ),
      ),
    );
  }
}
