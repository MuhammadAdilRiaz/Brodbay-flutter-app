import 'package:brodbay/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class RecommendedSection extends ConsumerWidget {
  const RecommendedSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(filteredCategoriesProvider);

    // Use up to 6 categories
    final recommended = categories.length > 6 ? categories.sublist(0, 6) : categories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          child: Text(
            "Recommended",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        if (recommended.isEmpty)
          const SizedBox(
            height: 80,
            child: Center(child: Text("No recommendations available")),
          )
        else
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: recommended.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final cat = recommended[index];
                final hasImage = cat.image.isNotEmpty;

                return Column(
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: hasImage
                            ? Image.network(
                                cat.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, e, st) => const Icon(Icons.broken_image, size: 40),
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                                },
                              )
                            : Container(
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.category, size: 40),
                              ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 80,
                      child: Text(
                        cat.name,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }
}
