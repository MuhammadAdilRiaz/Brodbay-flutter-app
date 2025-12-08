// lib/widgets/title_rating_section.dart
import 'package:brodbay/models/products.dart';
import 'package:brodbay/widgets/common/rating_star.dart';
import 'package:flutter/material.dart';
import 'price_section.dart';

class TitleRatingSection extends StatelessWidget {
  final Product product;

  const TitleRatingSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    product.title ,
                    softWrap: true,
                    maxLines: null,
                    overflow: TextOverflow.visible,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // rating row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
               RatingStars(
                 rating: product.average_rating,   
                   size: 16,
                  ),
                const SizedBox(width: 5),
                Text("|${product.sold }+ sold"),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // PriceSection - contains the quantity dropdown on the right
          PriceSection(product: product),
        ],
      ),
    );
  }
}
