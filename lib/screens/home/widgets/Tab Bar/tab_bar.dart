// lib/widgets/Tab Bar/tab_bar.dart
import 'package:brodbay/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class MainCategoryTabRow extends ConsumerWidget {
  final bool isSticky;
  const MainCategoryTabRow({super.key, this.isSticky = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(categoryNotifierProvider);
    final notifier = ref.read(categoryNotifierProvider.notifier);
    final categories = state.mainCategories;
    final bool useDarkText =
    isSticky || state.selectedIndex != 0;


    final tabs = ['All', ...categories.map((c) => c.name)];

    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final isActive = state.selectedIndex == index;

          return GestureDetector(
            onTap: () {
              notifier.selectCategory(index);
              if (index > 0 && index - 1 < categories.length) {
                notifier.loadProductsOfCategory(categories[index - 1].id);
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.black.withOpacity(0.08)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                tabs[index],
                style: TextStyle(
                  fontWeight:
                      isActive ? FontWeight.bold : FontWeight.normal,
                       color: useDarkText ? Colors.black : Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
