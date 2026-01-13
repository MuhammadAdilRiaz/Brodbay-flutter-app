import 'package:brodbay/models/products.dart';
import 'package:brodbay/screens/product%20Detail/widgets/Product%20Options/product_variant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/Image Detail/product_images.dart';
import 'widgets/Product Options/color_selector.dart';
import 'widgets/Product Options/size_selector.dart';
import 'widgets/SearchBar/Product_Detail_SearchBar.dart';
import 'widgets/Detail Section/product_text_detail.dart';
import 'widgets/Detail Section/rating_section.dart';
import 'widgets/Buttons/Product_detail_button.dart';

class ProductDetailScreen extends ConsumerWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// MAIN SCROLL VIEW
          CustomScrollView(
            slivers: [
              /// IMAGE SLIDER
              SliverToBoxAdapter(
                child: ProductImages(product: product),
              ),

              /// PRODUCT DETAILS
              SliverToBoxAdapter(
  child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleRatingSection(product: product),

        const SizedBox(height: 16),
        VariantSelector(product: product),

        const SizedBox(height: 16),
        ProductTextDetail(description: product.description),

        const SizedBox(height: 20),
      ],
    
  ),
),

            ],
          ),

          /// FLOATING APP BAR
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: const ProductDetailSearchbar(),
          ),
        ],
      ),

      /// BOTTOM BUTTON
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: ProductDetailButton(product: product),
        ),
      ),
    );
  }
}
