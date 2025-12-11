// lib/services/product_service.dart

import 'dart:convert';
import 'package:brodbay/models/products.dart';
import 'package:http/http.dart' as http;

class ProductService {
  static const _baseUrl = 'https://brodbay.co.uk/wp-json/wc/store/products';
  static const _consumerKey = 'ck_6c90af34e3403f099e41885bf870a08ddc720e18';
  static const _consumerSecret = 'cs_e18f1b6e3961481cb97a93f2b44fb405fc94a6db';

  final http.Client _client;

  ProductService([http.Client? client]) : _client = client ?? http.Client();

  Future<List<Product>> fetchProducts({int perPage = 20, int page = 1}) async {
    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'per_page': perPage.toString(),
      'page': page.toString(),
      'consumer_key': _consumerKey,
      'consumer_secret': _consumerSecret,
    });

    print('ProductService fetchProducts requesting: $uri');

    final res = await _client.get(uri, headers: {'Accept': 'application/json'});

    print('ProductService response status: ${res.statusCode}');
    if (res.body.isNotEmpty) {
      print('ProductService response body snippet: ${res.body.length > 800 ? res.body.substring(0, 800) : res.body}');
    }

    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      final List<dynamic> body = decoded as List<dynamic>;
      return body.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load products: ${res.statusCode} ${res.reasonPhrase}');
    }
  }

  Future<Product> fetchProductById(String id) async {
    final uri = Uri.parse('$_baseUrl/$id').replace(queryParameters: {
      'consumer_key': _consumerKey,
      'consumer_secret': _consumerSecret,
    });

    print('ProductService fetchProductById requesting: $uri');

    final res = await _client.get(uri, headers: {'Accept': 'application/json'});

    print('ProductService response status: ${res.statusCode}');
    if (res.body.isNotEmpty) {
      print('ProductService response body snippet: ${res.body.length > 800 ? res.body.substring(0, 800) : res.body}');
    }

    if (res.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(res.body);
      return Product.fromJson(body);
    } else {
      throw Exception('Failed to load product: ${res.statusCode} ${res.reasonPhrase}');
    }
  }

  void dispose() {
    _client.close();
  }

  /// --- NEW: Fetch products by category id (robust)
  ///
  /// Approach:
  /// 1) Try the store API with ?category={id}
  /// 2) If that returns an empty list (some APIs ignore numeric category),
  ///    fetch a page of products and filter locally by product['categories'] array.
  /// Notes:
  /// - This avoids requiring category slug in CategoryModel.
  /// - You can increase perPage for more coverage if needed.
  Future<List<Product>> fetchProductsByCategory(int categoryId, {int perPage = 50, int page = 1}) async {
    // 1) Try requesting with category query param
    final uriWithCategory = Uri.parse(_baseUrl).replace(queryParameters: {
      'per_page': perPage.toString(),
      'page': page.toString(),
      'category': categoryId.toString(),
      'consumer_key': _consumerKey,
      'consumer_secret': _consumerSecret,
    });

    print('ProductService fetchProductsByCategory requesting: $uriWithCategory');

    final res = await _client.get(uriWithCategory, headers: {'Accept': 'application/json'});

    print('fetchProductsByCategory status: ${res.statusCode}, body length: ${res.body.length}');
    if (res.statusCode == 200 && res.body.isNotEmpty) {
      try {
        final decoded = json.decode(res.body);
        if (decoded is List && decoded.isNotEmpty) {
          // Received direct filtered list from API
          final List<dynamic> list = decoded;
          final mapped = list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
          print('fetchProductsByCategory: API returned ${mapped.length} items for category $categoryId');
          return mapped;
        }
      } catch (e, st) {
        print('fetchProductsByCategory: parse error after category query: $e\n$st');
      }
    }

    // 2) Fallback: fetch a larger page of products and filter by product["categories"] array
    // Try to fetch a reasonably sized page (increase if you have many products)
    final uriAll = Uri.parse(_baseUrl).replace(queryParameters: {
      'per_page': '100',
      'page': '1',
      'consumer_key': _consumerKey,
      'consumer_secret': _consumerSecret,
    });

    print('fetchProductsByCategory fallback: requesting all products snippet: $uriAll');

    final resAll = await _client.get(uriAll, headers: {'Accept': 'application/json'});

    if (resAll.statusCode != 200) {
      print('fetchProductsByCategory fallback failed with status: ${resAll.statusCode}');
      return [];
    }

    if (resAll.body.isEmpty) return [];

    try {
      final decodedAll = json.decode(resAll.body);
      if (decodedAll is List) {
        final filtered = <Product>[];

        for (final item in decodedAll) {
          if (item is Map<String, dynamic>) {
            // product JSON often has 'categories' array of objects with 'id' and 'slug'
            final cats = item['categories'];
            bool matches = false;
            if (cats is List) {
              for (final c in cats) {
                try {
                  if (c is Map) {
                    // match by numeric id if available
                    if (c.containsKey('id')) {
                      final cid = c['id'];
                      if (cid != null && cid.toString() == categoryId.toString()) {
                        matches = true;
                        break;
                      }
                    }
                    // match by slug string if someone passed a slug like 'pet-foods'
                    if (c.containsKey('slug') && c['slug'] != null && c['slug'].toString() == categoryId.toString()) {
                      matches = true;
                      break;
                    }
                  }
                } catch (_) {}
              }
            }
            if (matches) {
              filtered.add(Product.fromJson(item));
            }
          }
        }

        print('fetchProductsByCategory fallback: filtered ${filtered.length} items for category $categoryId');
        return filtered;
      }
    } catch (e, st) {
      print('fetchProductsByCategory fallback parse error: $e\n$st');
    }

    return [];
  }
}
