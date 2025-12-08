import 'dart:convert';
import 'package:brodbay/models/products.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'woo_secure_provider.dart';


final productsProvider =
    AsyncNotifierProvider<ProductsNotifier, List<Product>>(
        ProductsNotifier.new);

class ProductsNotifier extends AsyncNotifier<List<Product>> {
  late final WooSecure _woo;

  @override
  Future<List<Product>> build() async {
  _woo = ref.read(wooSecureProvider);
    return await _fetchProducts();
  }

  // --------------------------------------------------------
  // THIS IS THE METHOD YOU REPLACE – SAFE PRODUCT PARSER
  // --------------------------------------------------------
  Future<List<Product>> _fetchProducts({int perPage = 20, int page = 1}) async {
    final resp = await _woo.getProducts(perPage: perPage, page: page);

    print("Status: ${resp.statusCode}");
    print("Body: ${resp.body}");

    if (resp.statusCode >= 400) {
      try {
        final err = json.decode(resp.body);
        if (err is Map && err.containsKey('message')) {
          throw Exception('API error ${resp.statusCode}: ${err['message']}');
        }
      } catch (_) {}
      throw Exception("HTTP ${resp.statusCode}: ${resp.reasonPhrase}");
    }

    final decoded = json.decode(resp.body);

    // Error object instead of list
    if (decoded is Map<String, dynamic>) {
      if (decoded.containsKey("code") && decoded.containsKey("message")) {
        throw Exception(
            "WooCommerce error: ${decoded['message']} (code: ${decoded['code']})");
      }

      // Single product object
      if (decoded.containsKey("id") && decoded.containsKey("name")) {
        return [Product.fromJson(decoded)];
      }

      throw Exception("Unexpected JSON object from server.");
    }

    // Normal list of products
    if (decoded is List) {
      return decoded
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception("Unexpected JSON format: ${decoded.runtimeType}");
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(await _fetchProducts());
  }
}
