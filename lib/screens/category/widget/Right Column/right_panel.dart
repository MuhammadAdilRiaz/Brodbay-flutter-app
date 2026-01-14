import 'package:brodbay/providers/category%20provider/category_provider.dart';
import 'package:brodbay/screens/category/widget/Right%20Column/right_tabrow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'recommended_section.dart';


class CategoryRightPanel extends ConsumerWidget {
  const CategoryRightPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex =
        ref.watch(categoryNotifierProvider.select((s) => s.selectedIndex));

    final products = ref.watch(selectedCategoryProductsProvider);

    return NestedScrollView(
      headerSliverBuilder: (context, _) => [
        const SliverToBoxAdapter(child: RecommendedSection()),
      ],
      body: CategoryTabsScreen(
        selectedCategoryIndex: selectedIndex,
        products: products,
      ),
    );
  }
}
