// lib/providers/category_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_model.dart';
import '../data/category_data.dart';

class RecommendedItem {
  final String title;
  final String image; // local asset path

  RecommendedItem({
    required this.title,
    required this.image,
  });
}

class CategoryState {
  final int selectedIndex;
  final String searchQuery;
  final List<CategoryModel> categories;
  final List<RecommendedItem> items;

  const CategoryState({
    required this.selectedIndex,
    required this.searchQuery,
    required this.categories,
    required this.items,
  });

  CategoryState copyWith({
    int? selectedIndex,
    String? searchQuery,
    List<CategoryModel>? categories,
    List<RecommendedItem>? items,
  }) {
    return CategoryState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      searchQuery: searchQuery ?? this.searchQuery,
      categories: categories ?? this.categories,
      items: items ?? this.items,
    );
  }
}

class CategoryNotifier extends StateNotifier<CategoryState> {
  CategoryNotifier()
      : super(CategoryState(
          selectedIndex: 0,
          searchQuery: '',
          categories: categories, // from data/category_data.dart
          items: [
            // sample recommended items. Replace with your real data or load from repository
            RecommendedItem(title: 'Portable Charger', image: 'assets/images/Hoodies.png'),
            RecommendedItem(title: 'Phone Case', image: 'assets/images/sandal.png'),
            RecommendedItem(title: 'Earbuds', image: 'assets/images/shorts.png'),
            RecommendedItem(title: 'Screen Protector', image: 'assets/images/shoes.png'),
            RecommendedItem(title: 'Car Mount', image: 'assets/images/Hoodies.png'),
            RecommendedItem(title: 'Wireless Speaker', image: 'assets/images/bag.png'),
          ],
        ));

  void selectIndex(int index) {
    if (index == state.selectedIndex) return;
    state = state.copyWith(selectedIndex: index);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setCategories(List<CategoryModel> newList) {
    state = state.copyWith(categories: newList);
  }

  // recommended items methods
  void setRecommendedItems(List<RecommendedItem> newItems) {
    state = state.copyWith(items: newItems);
  }

  void addRecommendedItem(RecommendedItem item) {
    final List<RecommendedItem> copy = List.from(state.items)..add(item);
    state = state.copyWith(items: copy);
  }

  void removeRecommendedItemAt(int index) {
    if (index < 0 || index >= state.items.length) return;
    final List<RecommendedItem> copy = List.from(state.items)..removeAt(index);
    state = state.copyWith(items: copy);
  }
}

/// Public provider for the notifier
final categoryNotifierProvider =
    StateNotifierProvider<CategoryNotifier, CategoryState>((ref) {
  return CategoryNotifier();
});

/// Derived provider: filtered categories by search query
final filteredCategoriesProvider = Provider<List<CategoryModel>>((ref) {
  final state = ref.watch(categoryNotifierProvider);
  final q = state.searchQuery.trim().toLowerCase();
  if (q.isEmpty) return state.categories;
  return state.categories
      .where((c) => c.name.toLowerCase().contains(q))
      .toList();
});

/// Derived provider: recommended items (could be filtered later)
final recommendedItemsProvider = Provider<List<RecommendedItem>>((ref) {
  return ref.watch(categoryNotifierProvider.select((s) => s.items));
});
