import 'package:brodbay/services/Hive/product_hive_cache.dart';
import '../models/products.dart';
import '../services/ProductServices/product_services.dart';
import '../models/product_hive.dart';

class ProductRepository {
  final ProductService api;
  final HiveProductCache cache;

  ProductRepository(this.api, this.cache);

  Future<List<Product>> getProducts() async {
    try {
      final products = await api.fetchProducts();
      // cache HiveProduct
      final hiveList = products.map((p) => HiveProduct.fromProduct(p)).toList();
      await cache.saveProducts(hiveList);
      return products;
    } catch (_) {
      final cached = cache.getProducts().map((h) => h.toProduct()).toList();
      if (cached.isNotEmpty) return cached;
      rethrow;
    }
  }
}
