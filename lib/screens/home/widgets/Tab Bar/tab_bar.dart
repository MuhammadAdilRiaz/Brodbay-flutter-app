// lib/widgets/Tab Bar/tab_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/home_notifier.dart';

class TabRow extends ConsumerWidget {
  final bool isSticky;
  const TabRow({super.key, this.isSticky = false});

  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeNotifierProvider);
    final homeNotifier = ref.read(homeNotifierProvider.notifier);
    final labels = homeState.categories;

    if (labels.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: const Text(
          'Categories',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      );
    }
       final displayCount = labels.length > 8 ? 8 : labels.length;
    final displayLabels = labels.sublist(0, displayCount);

    
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(displayLabels.length, (index) {
            final fullName = displayLabels[index];
            final label = fullName;
            final bool isSelected = homeState.currentIndex == index;

            return GestureDetector(
              onTap: () => homeNotifier.setIndex(index),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 14,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.black.withOpacity(0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  label,
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
