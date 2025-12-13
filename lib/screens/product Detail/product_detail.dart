// lib/screens/product_detail_screen.dart
import 'package:brodbay/models/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/Buttons/Product_detail_button.dart';
import 'widgets/Image Detail/image_detail.dart';
import 'widgets/Image Detail/product_images.dart';
import 'widgets/SearchBar/Product_Detail_SearchBar.dart';
import 'widgets/Detail Section/product_text_detail.dart';
import 'widgets/Detail Section/rating_section.dart';

class ProductDetailScreen extends ConsumerWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFFFF6304),
            elevation: 0,
            title: ProductDetailSearchbar(),
          ),

          // Main large image
          SliverToBoxAdapter(child: ProductImages(product: product)),

          // Thumbnails (different colors)
          SliverToBoxAdapter(child: ImageDetail(product: product)),

          // Title, rating, sold and price section
          SliverToBoxAdapter(child: TitleRatingSection(product: product)),

          // Text details / bullet points
          SliverToBoxAdapter(child: ProductTextDetail(description: product.description )),

          // Buttons (Add to cart etc.)
          SliverToBoxAdapter(child: ProductDetailButton(product: product)),

          // small spacing at bottom so button not covered by nav gestures
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
