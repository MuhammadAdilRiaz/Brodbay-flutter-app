import 'package:brodbay/widgets/common/rating_star.dart';
import 'package:flutter/material.dart';
import 'package:brodbay/models/product%20model/products.dart';

class HorizontalProductCard extends StatelessWidget {
  final Product product;
  final double width; // responsive width
  final VoidCallback? onTap;

  const HorizontalProductCard({
    super.key,
    required this.product,
    required this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive image height
    final double imageHeight = width / 1.6*1.3;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
       padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE
            ClipRRect(
            borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: imageHeight,
                width: double.infinity,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: Colors.grey[200]),
                ),
              ),
            ),

            /// TITLE
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  
                     const SizedBox(height: 3),     
                
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
                            const SizedBox(height: 3),
                
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
                ],
                            ),
                  ]
                ),
              )
          ],
        ),
      ),
    );
  }
}
