/*
import 'package:hive/hive.dart';

import '../models/products.dart';

class ProductCache {
  static late Box _box;

  static Future<void> init() async {
    _box = await Hive.openBox('productsBox');
  }

  static Future<List<Product>> loadProducts() async {
    final data = _box.get('products', defaultValue: []);
    return (data as List).map((e) => Product.fromJson(Map<String,dynamic>.from(e))).toList();
  }

  static Future<void> saveProducts(List<Product> products) async {
    final data = products.map((p) => p.toJson()).toList();
    await _box.put('products', data);
  }
}
*/

