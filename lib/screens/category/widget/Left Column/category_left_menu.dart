import 'package:brodbay/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class CategoryLeftMenu extends ConsumerWidget {
  const CategoryLeftMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex =
        ref.watch(categoryNotifierProvider.select((s) => s.selectedIndex));
final categories =
    ref.watch(categoryNotifierProvider.select((s) => s.mainCategories));

    final totalItems = 1 + categories.length;

    return Container(
      width: 120,
      color: Colors.grey.shade200,
      child: ListView.builder(
        itemCount: totalItems,
        itemBuilder: (context, index) {
          final isForYou = index == 0;
          final isActive = index == selectedIndex;
          final label = isForYou ? 'ForYou' : categories[index - 1].name;

          return InkWell(
            onTap: () {
              ref.read(categoryNotifierProvider.notifier).selectCategory(index);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              color: isActive ? Colors.white : Colors.transparent,
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        },
      ),
    );
  }
}
