import 'package:brodbay/repositories/category_repositry.dart';
import 'package:brodbay/services/Hive/product_hive_cache.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_model.dart';
import '../models/products.dart';
import '../services/CategoryServices/category_services.dart';
import '../services/ProductServices/product_services.dart';

class CategoryState {
  final int selectedIndex; // 0 = ForYou
  final List<CategoryModel> mainCategories;
  final Map<int, List<CategoryModel>> subCategoriesByParent;
  final Map<int, List<Product>> productsByCategory;
  final bool isLoading;

  const CategoryState({
    required this.selectedIndex,
    required this.mainCategories,
    required this.subCategoriesByParent,
    required this.productsByCategory,
    required this.isLoading,
  });

  CategoryState copyWith({
    int? selectedIndex,
    List<CategoryModel>? mainCategories,
    Map<int, List<CategoryModel>>? subCategoriesByParent,
    Map<int, List<Product>>? productsByCategory,
    bool? isLoading,
  }) {
    return CategoryState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      mainCategories: mainCategories ?? this.mainCategories,
      subCategoriesByParent:
          subCategoriesByParent ?? this.subCategoriesByParent,
      productsByCategory: productsByCategory ?? this.productsByCategory,
      isLoading: isLoading ?? this.isLoading,
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
            mainCategories: [],
            subCategoriesByParent: {},
            productsByCategory: {},
            isLoading: false,
          ),
        ) {
    loadCategories();
  }

  // 🔹 LOAD & SPLIT MAIN / SUB CATEGORIES
  Future<void> loadCategories() async {
    state = state.copyWith(isLoading: true);
    try {
      final api = ref.read(categoryApiProvider);
      final list = await api.fetchCategories();

      final mains = <CategoryModel>[];
      final subs = <int, List<CategoryModel>>{};

      for (final c in list) {
        if (c.parent == 0) {
          mains.add(c);
        } else {
          subs.putIfAbsent(c.parent, () => []).add(c);
        }
      }

      state = state.copyWith(
        mainCategories: mains,
        subCategoriesByParent: subs,
        isLoading: false,
      );

      // preload products for ForYou
      for (final m in mains) {
        loadProductsOfCategory(m.id);
      }
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  // 🔹 LOAD PRODUCTS FOR A CATEGORY
  Future<void> loadProductsOfCategory(int categoryId) async {


    if (state.productsByCategory.containsKey(categoryId)) return;

    try {
    final repo = ref.read(categoryRepositoryProvider);
    final products = await repo.getProductsByCategory(categoryId);


      final map = Map<int, List<Product>>.from(state.productsByCategory);
      map[categoryId] = products;

      state = state.copyWith(productsByCategory: map);
    } catch (_) {}
  }

  // 🔹 SELECT MAIN CATEGORY
  void selectCategory(int index) {
    if (index == state.selectedIndex) return;
    state = state.copyWith(selectedIndex: index);

    if (index > 0 && index - 1 < state.mainCategories.length) {
      final id = state.mainCategories[index - 1].id;
      loadProductsOfCategory(id);
    }
  }
}



/* ───────────────────────
   DERIVED PROVIDERSs
──────────────────────── */

// 🔹 LEFT MENU (MAIN CATEGORIES)
final mainCategoriesProvider = Provider<List<CategoryModel>>((ref) {
  return ref.watch(categoryNotifierProvider).mainCategories;
});

// 🔹 RIGHT SIDE SUB CATEGORIES (RECOMMENDED)
final visibleSubCategoriesProvider =
    Provider<List<CategoryModel>>((ref) {
  final state = ref.watch(categoryNotifierProvider);
  final index = state.selectedIndex;

  if (index == 0) {
    // ForYou → ALL sub categories
    return state.subCategoriesByParent.values.expand((e) => e).toList();
  }

  final mainId = state.mainCategories[index - 1].id;
  return state.subCategoriesByParent[mainId] ?? [];
});

// 🔹 PRODUCTS GRID
final selectedCategoryProductsProvider = Provider<List<Product>>((ref) {
  final state = ref.watch(categoryNotifierProvider);
  final index = state.selectedIndex;

  if (index == 0) {
    // ForYou → all products
    return state.productsByCategory.values.expand((e) => e).toList();
  }

  final mainId = state.mainCategories[index - 1].id;
  return state.productsByCategory[mainId] ?? [];
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository(
    ref.read(categoryApiProvider),
    ref.read(productApiProvider),
    HiveProductCache(),
  );
});
