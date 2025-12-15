// lib/widgets/category_search_bar.dart
import 'package:flutter/material.dart';

class CategorySearchBar extends StatelessWidget {
  const CategorySearchBar({super.key});

  @override
  Widget build(BuildContext context) {
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
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search Now",
                border: InputBorder.none,
                isDense: true,
              ),
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
