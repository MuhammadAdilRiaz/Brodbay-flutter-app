// lib/widgets/category_right_panel.dart
import 'package:brodbay/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'recommended_section.dart';
import 'right_tabrow.dart'; // existing file you already have

class CategoryRightPanel extends ConsumerWidget {
  const CategoryRightPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch selected index so the panel can react to category changes
    final selectedIndex =
        ref.watch(categoryNotifierProvider.select((s) => s.selectedIndex));

    // You can use selectedIndex to change which recommended items to show
    // or to drive the CategoryTabsScreen inside right_tabrow.dart

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverToBoxAdapter(child: const RecommendedSection()),
      ],
      body: CategoryTabsScreen(selectedCategoryIndex: selectedIndex),
    );
  }
}
