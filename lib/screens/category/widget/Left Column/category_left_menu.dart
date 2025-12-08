import 'package:brodbay/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryLeftMenu extends ConsumerWidget {
  const CategoryLeftMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // select only selectedIndex to avoid unnecessary rebuilds for other state changes
    final selectedIndex = ref
        .watch(categoryNotifierProvider.select((state) => state.selectedIndex));

    // If you want to use filtered list instead of full categories, swap to:
    // final categories = ref.watch(filteredCategoriesProvider);
    // and then use categories.length and categories[index].name
    final allCategories =
        ref.watch(categoryNotifierProvider.select((s) => s.categories));

    return Container(
      width: 100,
      color: Colors.grey.shade400,
      child: ListView.builder(
        itemCount: allCategories.length,
        itemBuilder: (context, index) {
          final isActive = index == selectedIndex;

          return InkWell(
            onTap: () {
              ref.read(categoryNotifierProvider.notifier).selectIndex(index);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
              color: isActive ? Colors.white : Colors.transparent,
              child: Text(
                allCategories[index].name,
                style: TextStyle(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
