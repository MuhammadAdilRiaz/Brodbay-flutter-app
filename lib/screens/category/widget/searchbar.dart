// lib/widgets/category_search_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/category_provider.dart';

class CategorySearchBar extends ConsumerWidget {
  const CategorySearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If you want to show current query as initial value, you can:
    final query = ref.watch(categoryNotifierProvider.select((s) => s.searchQuery));
    final controller = TextEditingController(text: query);

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          const Icon(Icons.camera_alt_rounded, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Search Now",
                border: InputBorder.none,
                isDense: true,
              ),
              onChanged: (value) {
                ref.read(categoryNotifierProvider.notifier).setSearchQuery(value);
              },
            ),
          ),
          Container(
            height: 30,
            width: 38,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.search,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
