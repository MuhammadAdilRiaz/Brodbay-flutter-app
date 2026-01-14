import 'package:brodbay/models/category%20model/category_model.dart';
import 'package:brodbay/providers/category%20provider/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubCategoryTabRow extends ConsumerWidget {
  const SubCategoryTabRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(categoryNotifierProvider);
    final subCategories = ref.watch(visibleSubCategoriesProvider);

    // Same as Category screen
    if (state.selectedIndex == 0) return const SizedBox.shrink();

    final tabs = [
      CategoryModel(
        id: 0,
        name: 'All',
        image: state.mainCategories[state.selectedIndex - 1].image,
        parent: 0,
      ),
      ...subCategories,
    ];

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final cat = tabs[index];

          return Container(
            margin: const EdgeInsets.only(right: 12),
            width: 70,
            child: Column(
              children: [
                ClipOval(
                  child: Image.network(
                    cat.image,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 56,
                      height: 56,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.category),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  cat.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
