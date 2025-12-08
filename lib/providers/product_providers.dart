// lib/providers/product_providers.dart
import 'package:brodbay/services/ProductServices/product_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/products.dart';

/// A simple provider for the ProductService (network layer).
final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService();
});

/// AsyncNotifierProvider that holds the list of products and exposes
/// async loading/error/data states.
final productsListProvider =
    AsyncNotifierProvider<ProductsListNotifier, List<Product>>(
  ProductsListNotifier.new,
);

class ProductsListNotifier extends AsyncNotifier<List<Product>> {
  late final ProductService _service;

  @override
  Future<List<Product>> build() async {
    // initialize service and load data on first watch
    _service = ref.read(productServiceProvider);
    return loadInitial();
  }

  /// Loads initial list from the service.
  Future<List<Product>> loadInitial() async {
    state = const AsyncValue.loading();
    try {
      final list = await _service.fetchProducts();
      state = AsyncValue.data(list);
      return list;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Refresh / reload
  Future<void> refresh() async {
    await loadInitial();
  }

  bool get isLoading => state.isLoading;
  Object? get error => state.hasError ? state.error : null;

  Product? findById(String id) {
    final current = state.value;
    if (current == null) return null;
    try {
      return current.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  void addProduct(Product p) {
    final current = state.value ?? <Product>[];
    final newList = [p, ...current];
    state = AsyncValue.data(newList);
  }

  void removeById(String id) {
    final current = state.value ?? <Product>[];
    final newList = current.where((p) => p.id != id).toList();
    state = AsyncValue.data(newList);
  }

  List<Product> search(String query) {
    final current = state.value ?? <Product>[];
    final q = query.toLowerCase();
    if (q.isEmpty) return current;
    return current.where((p) => p.title.toLowerCase().contains(q)).toList();
  }
}

/// Derived provider to get a Product by id synchronously (or null).
final productByIdProvider = Provider.family<Product?, String>((ref, id) {
  final async = ref.watch(productsListProvider);
  return async.when(
    data: (list) {
      try {
        return list.firstWhere((p) => p.id == id);
      } catch (_) {
        return null;
      }
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredProductsProvider = Provider<List<Product>>((ref) {
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final asyncList = ref.watch(productsListProvider);

  return asyncList.maybeWhen(
    data: (list) {
      if (query.isEmpty) return list;
      return list.where((p) => p.title.toLowerCase().contains(query)).toList();
    },
    orElse: () => <Product>[],
  );
});
