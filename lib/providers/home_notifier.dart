// lib/providers/home_notifier.dart
import 'package:brodbay/models/products.dart';
import 'package:brodbay/providers/connectivity_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brodbay/providers/category_provider.dart';
import 'package:brodbay/models/category_model.dart';

class HomeState {
  final bool isSticky;
  final int notificationCount;
  final String query;
  final bool isFocused;
  final int currentIndex;
  final List<String> categories; 
  final List<Product> products;         // online products
  final List<Product> cachedProducts;   // last fetched / offline

  const HomeState({
    this.isSticky = false,
    this.notificationCount = 0,
    this.query = '',
    this.isFocused = false,
    this.currentIndex = 0,
    this.categories = const [],
    this.products = const [],
    this.cachedProducts = const [],
  });

  HomeState copyWith({
    bool? isSticky,
    int? notificationCount,
    String? query,
    bool? isFocused,
    int? currentIndex,
    List<String>? categories,
    List<Product>? products,
    List<Product>? cachedProducts,
  }) {
    return HomeState(
      isSticky: isSticky ?? this.isSticky,
      notificationCount: notificationCount ?? this.notificationCount,
      query: query ?? this.query,
      isFocused: isFocused ?? this.isFocused,
      currentIndex: currentIndex ?? this.currentIndex,
      categories: categories ?? this.categories,
      products: products ?? this.products,
      cachedProducts: cachedProducts ?? this.cachedProducts,
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  final Ref ref;

  HomeNotifier(this.ref, [HomeState? initial]) : super(initial ?? const HomeState()) {
    _loadCategoriesFromApi();
    fetchProducts(); // fetch products on init
  }

  static const double _stickThreshold = 60.0;
  static const double _unstickThreshold = 40.0;

  void updateScrollOffset(double offset) {
    final shouldStick = offset > _stickThreshold;
    final shouldUnstick = offset < _unstickThreshold;

    if (shouldStick && !state.isSticky) {
      state = state.copyWith(isSticky: true);
    } else if (shouldUnstick && state.isSticky) {
      state = state.copyWith(isSticky: false);
    }
  }

  void increaseNotification() {
    state = state.copyWith(notificationCount: state.notificationCount + 1);
  }

  void resetNotification() {
    state = state.copyWith(notificationCount: 0);
  }

  void setQuery(String value) {
    if (value == state.query) return;
    state = state.copyWith(query: value);
  }

  void setSticky(bool value) {
    if (value == state.isSticky) return;
    state = state.copyWith(isSticky: value);
  }

  void setFocused(bool value) {
    if (value == state.isFocused) return;
    state = state.copyWith(isFocused: value);
  }

  void setIndex(int index) {
    if (index == state.currentIndex) return;
    state = state.copyWith(currentIndex: index);
    try {
      ref.read(categoryNotifierProvider.notifier).selectCategory(index + 1);
    } catch (_) {}
  }

  Future<void> _loadCategoriesFromApi() async {
    try {
      final api = ref.read(categoryApiProvider);
      final List<CategoryModel> list = await api.fetchCategories();
      final mainCategories = list.where((c) => c.parent == 0).toList();
      state = state.copyWith(
        categories: mainCategories.map((c) => c.name).toList(),
      );
    } catch (e) {
      // keep categories empty on error
    }
  }

  /// ----------------------
  /// Products logic
  /// ----------------------
  Future<void> fetchProducts() async {
    try {
      final isOnline = ref.read(connectivityProvider);
      if (!isOnline) {
        // offline -> keep cached products
        state = state.copyWith(products: state.cachedProducts);
        return;
      }

      final productApi = ref.read(productApiProvider);
      final List<Product> fetchedProducts = await productApi.fetchProducts();

      // update both online and cached
      state = state.copyWith(
        products: fetchedProducts,
        cachedProducts: fetchedProducts,
      );
    } catch (e) {
      // error -> fallback to cached products
      state = state.copyWith(products: state.cachedProducts);
    }
  }
}

final homeNotifierProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier(ref);
});
