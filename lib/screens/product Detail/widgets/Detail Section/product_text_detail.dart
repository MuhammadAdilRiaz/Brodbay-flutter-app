// lib/widgets/product_text_detail.dart
import 'package:flutter/material.dart';

class ProductTextDetail extends StatelessWidget {
  final String description;

  const ProductTextDetail({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Product SellPoint",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Wrap(
            children: [
              Text(
                description,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
