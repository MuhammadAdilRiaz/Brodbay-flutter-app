// lib/widgets/product_text_detail.dart
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';


class ProductTextDetail extends StatelessWidget {
  final String description;

  const ProductTextDetail({super.key, required this.description});

  String _stripHtml(String html) {
    // basic tag removal
    final withoutTags = html.replaceAll(RegExp(r'<[^>]*>'), ' ');
    // decode HTML entities like &rsquo; &amp; etc.
    return HtmlUnescape().convert(withoutTags).replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  @override
  Widget build(BuildContext context) {
    final clean = _stripHtml(description);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Product SellPoint",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 4),
          Text(
            clean,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}
