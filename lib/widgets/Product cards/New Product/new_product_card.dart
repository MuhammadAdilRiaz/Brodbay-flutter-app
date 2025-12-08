 /* import 'package:flutter/material.dart';

class NewProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const NewProductCard({super.key, this.product = const {}});

  @override
  Widget build(BuildContext context) {
     return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = constraints.maxWidth;        
        double imageHeight = cardWidth * 0.75; 

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         ClipRRect(
  borderRadius: BorderRadius.circular(8),
  child: (product["image"] != null && product["image"].toString().isNotEmpty)
      ? Image.asset(
          product["image"],
          height: imageHeight,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            height: imageHeight,
            width: double.infinity,
            color: Colors.grey.shade200,
            child: const Icon(
              Icons.image_not_supported,
              size: 40,
              color: Colors.grey,
            ),
          ),
        )
      : Container(
          height: imageHeight,
          width: double.infinity,
          color: Colors.grey.shade200,
          child: const Icon(
            Icons.image_not_supported,
            size: 40,
            color: Colors.grey,
          ),
        ),
),

        const  SizedBox(height: 6),

          Text(
            product["title"] ?? "Product Title",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),

          const SizedBox(height: 4),

          Row(
            children: [
              Text(
                "PKR${product['price'] ?? 0}",
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 5),
              if (product["oldPrice"] != null)
                Text(
                  "PKR${product['oldPrice']}",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 4),

          Row(
            children: [
              const Icon(Icons.star, size: 16, color: Colors.orange),
              Text(
                "${product['rating'] ?? 0.0}",
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(width: 5),
              Text(
                "${product['sold'] ?? '0+'} sold",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          )
        ],
      ),
    );
      }
     );
  }
}
*/