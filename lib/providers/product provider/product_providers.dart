// lib/providers/product_providers.dart
import 'dart:math';
import 'package:brodbay/repositories/product_repositry.dart';
import 'package:brodbay/services/Hive/product_hive_cache.dart';
import 'package:brodbay/services/ProductServices/product_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/product model/products.dart';


final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService();
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(
    ref.read(productServiceProvider),
    HiveProductCache(),
  );
});


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
      final repo = ref.read(productRepositoryProvider);
final list = await repo.getProducts();

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

//
// Product row helpers and derived providers (progressive "view more" increments)
//

const int _productRowLimit = 10;

/// Config holder for product row behavior.
class ProductRowConfig {
  final int limit;
  ProductRowConfig({this.limit = _productRowLimit});
}

final productRowConfigProvider = Provider<ProductRowConfig>((ref) {
  return ProductRowConfig(limit: _productRowLimit);
});

final productRowVisibleCountProvider = StateProvider<int>((ref) => _productRowLimit);

/// Sale detection adapted to your Product model
bool _productHasSale(Product p) {
  try {
    // explicit sale price that is lower than current price
    if (p.sale_price != null && p.sale_price! < p.price) return true;

    // legacy regular price greater than current price
    if (p.regular_price != null && p.regular_price! > p.price) return true;

    // fallback: if sale_price exists even if equal, consider it a sale candidate
    if (p.sale_price != null) return true;
  } catch (_) {
    // ignore parse errors and return false
  }
  return false;
}

/// Provider that returns the "source" list for the horizontal row:
/// try sale-filtered list first, fallback to full product list
final productsRowSourceProvider = Provider<List<Product>>((ref) {
  final async = ref.watch(productsListProvider);

  return async.maybeWhen(
    data: (list) {
      final saleList = list.where((p) => _productHasSale(p)).toList();
      if (saleList.isNotEmpty) return saleList;
      return list;
    },
    orElse: () => <Product>[],
  );
});

/// Metadata about the row: totalCount and whether there are more than the current visibleCount.
class ProductsRowMeta {
  final int totalCount;
  final bool hasMore; // more items are available beyond visibleCount
  ProductsRowMeta({required this.totalCount, required this.hasMore});
}

final productsRowMetaProvider = Provider<ProductsRowMeta>((ref) {
  final src = ref.watch(productsRowSourceProvider);
  final visibleCount = ref.watch(productRowVisibleCountProvider);
  final total = src.length;
  final hasMore = total > visibleCount;
  return ProductsRowMeta(totalCount: total, hasMore: hasMore);
});

/// Final provider UI should watch. Honors visible count state and limit increments.
final visibleProductsProvider = Provider<List<Product>>((ref) {
  final src = ref.watch(productsRowSourceProvider);
  final visibleCount = ref.watch(productRowVisibleCountProvider);
  // clamp to available length
  final int takeCount = min(visibleCount, src.length);
  return src.take(takeCount).toList();
});