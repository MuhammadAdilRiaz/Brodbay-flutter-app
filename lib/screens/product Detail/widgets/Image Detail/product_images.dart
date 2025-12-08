// lib/widgets/product_images.dart
import 'package:brodbay/models/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/product_detail_providers.dart';


class ProductImages extends ConsumerWidget {
  final Product product;

  const ProductImages({super.key, required this.product});

  bool _looksLikeUrl(String? s) {
    if (s == null) return false;
    final uri = Uri.tryParse(s);
    return uri != null && (uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https'));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedImageIndexProvider);
    final images = <String>[];
    // Prefer list of images if present; otherwise fallback to single image field
    try {
      if ((product.images != null) && (product.images is List) && (product.images as List).isNotEmpty) {
        images.addAll(product.images.cast<String>());
      }
    } catch (_) {
      // ignore if product.images does not exist
    }
    if (images.isEmpty) {
      if (product.imageUrl != null && product.imageUrl.toString().isNotEmpty) {
        images.add(product.imageUrl.toString());
      }
    }

    final mainImage = (images.isNotEmpty && selectedIndex < images.length) ? images[selectedIndex] : (images.isNotEmpty ? images[0] : '');

    // display network if looks like URL, otherwise asset
    final Widget imageWidget = _looksLikeUrl(mainImage)
        ? Image.network(
            mainImage,
            height: 350,
            fit: BoxFit.contain,
            errorBuilder: (c, e, s) => product.imageUrl != null && product.imageUrl.isNotEmpty
                ? Image.asset(product.imageUrl, height: 350, fit: BoxFit.contain)
                : const SizedBox(height: 350),
          )
        : (product.imageUrl != null && product.imageUrl.isNotEmpty
            ? Image.asset(mainImage, height: 350, fit: BoxFit.contain)
            : const SizedBox(height: 350));

    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Center(child: imageWidget),
    );
  }
}
