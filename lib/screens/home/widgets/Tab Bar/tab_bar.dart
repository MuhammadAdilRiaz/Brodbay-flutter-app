// lib/widgets/Tab Bar/tab_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/home_notifier.dart';

class TabRow extends ConsumerWidget {
  final bool isSticky;
  const TabRow({super.key, this.isSticky = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeNotifierProvider);
    final notifier = ref.read(homeNotifierProvider.notifier);
    final categories = state.categories;

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(categories.length, (index) {
            final categoryName = categories[index];
            final bool isSelected = state.currentIndex == index;

            return GestureDetector(
              onTap: () => notifier.setIndex(index),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 14,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.black.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  categoryName,
                  style: TextStyle(
                    color: isSticky ? Colors.black : Colors.white,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
