import 'package:brodbay/services/Hive/product_hive_cache.dart';

import '../models/category_model.dart';
import '../models/products.dart';
import '../services/CategoryServices/category_services.dart';
import '../services/ProductServices/product_services.dart';
import '../models/product_hive.dart';

class CategoryRepository {
  final CategoryApiService categoryApi;
  final ProductService productApi;
  final HiveProductCache cache;

  CategoryRepository(this.categoryApi, this.productApi, this.cache);

  Future<List<CategoryModel>> getCategories() async {
    return await categoryApi.fetchCategories();
  }

  Future<List<Product>> getProductsByCategory(int categoryId) async {
    try {
      final products = await productApi.fetchProductsByCategory(categoryId);

      // save products in Hive
      await cache.saveProducts(
        products.map((e) => HiveProduct.fromProduct(e)).toList(),
      );

      return products;
    } catch (_) {
      // fallback to cached products
      final cached = cache
    .getProducts()
    .map((e) => e.toProduct())
    .toList();

if (cached.isNotEmpty) return cached;
rethrow;

    }
  }
}
