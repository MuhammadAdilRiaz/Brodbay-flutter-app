// lib/widgets/image_detail.dart
import 'package:brodbay/models/product%20model/products.dart';
import 'package:brodbay/providers/product%20detail%20provider/product_detail_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageDetail extends ConsumerWidget {
  final Product product;

  const ImageDetail({super.key, required this.product});

  bool _looksLikeUrl(String? s) {
    if (s == null) return false;
    final uri = Uri.tryParse(s);
    return uri != null && uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ensure product.images is a valid list of strings
    final List<String> images =
        (product.images is List && product.images.isNotEmpty)
            ? product.images.cast<String>()
            : [];

    final selectedIndex = ref.watch(selectedImageIndexProvider);

    return Container(
      color: Colors.white,
      child: SizedBox(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          itemCount: images.length,
          itemBuilder: (context, index) {
            final img = images[index];

            return GestureDetector(
              onTap: () => ref.read(selectedImageIndexProvider.notifier).state = index,
              child: Container(
                width: 120,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Center(
                  child: _looksLikeUrl(img)
                      ? Image.network(
                          img,
                          width: 60,
                          height: 60,
                          fit: BoxFit.contain,
                          errorBuilder: (c, e, s) => const SizedBox(), // NO ASSET FALLBACK
                        )
                      : const SizedBox(), // if not a URL → show empty
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
