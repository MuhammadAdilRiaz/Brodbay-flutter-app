import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_model.dart';
import '../models/products.dart'; // your existing product model
import '../services/CategoryServices/category_services.dart';
import '../services/ProductServices/product_services.dart'; // you said this already exists

class CategoryState {
  final int selectedIndex; // 0 => ForYou, 1..n => categories list indexes
  final List<CategoryModel> categories;
  final String searchQuery;
  final Map<int, List<Product>> productsByCategory;
  final bool isLoadingCategories;
  final Map<int, bool> isLoadingProducts;

  const CategoryState({
    required this.selectedIndex,
    required this.categories,
    required this.searchQuery,
    required this.productsByCategory,
    required this.isLoadingCategories,
    required this.isLoadingProducts,
  });

  CategoryState copyWith({
    int? selectedIndex,
    List<CategoryModel>? categories,
    String? searchQuery,
    Map<int, List<Product>>? productsByCategory,
    bool? isLoadingCategories,
    Map<int, bool>? isLoadingProducts,
  }) {
    return CategoryState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      categories: categories ?? this.categories,
      searchQuery: searchQuery ?? this.searchQuery,
      productsByCategory: productsByCategory ?? this.productsByCategory,
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
      isLoadingProducts: isLoadingProducts ?? this.isLoadingProducts,
    );
  }
}

final categoryApiProvider = Provider<CategoryApiService>((ref) {
  return CategoryApiService();
});

final productApiProvider = Provider<ProductService>((ref) {
  return ProductService();
});

final categoryNotifierProvider =
    StateNotifierProvider<CategoryNotifier, CategoryState>((ref) {
  return CategoryNotifier(ref);
});

class CategoryNotifier extends StateNotifier<CategoryState> {
  final Ref ref;
  CategoryNotifier(this.ref)
      : super(
          const CategoryState(
            selectedIndex: 0,
            categories: [],
            searchQuery: '',
            productsByCategory: {},
            isLoadingCategories: false,
            isLoadingProducts: {},
          ),
        ) {
    // auto-load categories when created
    loadCategories();
  }

  Future<void> loadCategories() async {
    state = state.copyWith(isLoadingCategories: true);
    try {
      final api = ref.read(categoryApiProvider);
      final list = await api.fetchCategories();
      state = state.copyWith(categories: list, isLoadingCategories: false);

      // preload first category's products (optional)
      if (list.isNotEmpty) {
        final firstId = list.first.id;
        await loadProductsOfCategory(firstId);
      }
    } catch (e) {
      state = state.copyWith(isLoadingCategories: false);
      print('Failed to load categories: $e');
    }
  }

  Future<void> loadProductsOfCategory(int categoryId) async {
    // if already loading or loaded, skip (you can change the condition as needed)
    final loading = Map<int, bool>.from(state.isLoadingProducts);
    if (loading[categoryId] == true) return;

    loading[categoryId] = true;
    state = state.copyWith(isLoadingProducts: loading);

    try {
      final api = ref.read(productApiProvider);
      final products = await api.fetchProductsByCategory(categoryId);

      final map = Map<int, List<Product>>.from(state.productsByCategory);
      map[categoryId] = products;
      state = state.copyWith(productsByCategory: map);
    } catch (e) {
      print('Failed to load products for category $categoryId: $e');
    } finally {
      loading[categoryId] = false;
      state = state.copyWith(isLoadingProducts: loading);
    }
  }

  void selectCategory(int index) {
    if (index == state.selectedIndex) return;
    state = state.copyWith(selectedIndex: index);

    if (index > 0) {
      final catIndex = index - 1;
      if (catIndex >= 0 && catIndex < state.categories.length) {
        final catId = state.categories[catIndex].id;
        // load products if not already loaded
        if (!state.productsByCategory.containsKey(catId) || state.productsByCategory[catId]!.isEmpty) {
          loadProductsOfCategory(catId);
        }
      }
    }
  }

  void setSearchQuery(String q) {
    state = state.copyWith(searchQuery: q);
  }
}

// Derived providers

final filteredCategoriesProvider = Provider<List<CategoryModel>>((ref) {
  final state = ref.watch(categoryNotifierProvider);
  final q = state.searchQuery.trim().toLowerCase();
  if (q.isEmpty) return state.categories;
  return state.categories.where((c) => c.name.toLowerCase().contains(q)).toList();
});

final selectedCategoryProductsProvider = Provider<List<Product>>((ref) {
  final state = ref.watch(categoryNotifierProvider);
  final idx = state.selectedIndex;
  if (idx == 0) {
    // ForYou logic: show products from first category (or return [] if none)
    if (state.categories.isNotEmpty) {
      final firstId = state.categories.first.id;
      return state.productsByCategory[firstId] ?? [];
    }
    return [];
  }
  final catIndex = idx - 1;
  if (catIndex < 0 || catIndex >= state.categories.length) return [];
  final catId = state.categories[catIndex].id;
  return state.productsByCategory[catId] ?? [];
});
