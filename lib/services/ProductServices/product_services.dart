// lib/services/product_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/products.dart';

class ProductService {
  // Base is the root of the WooCommerce REST API
  static const _baseUrl = 'https://brodbay.co.uk/wp-json/wc/v3';
  // Provide your keys here (consider moving to secure storage in production)
  static const _consumerKey = 'ck_6c90af34e3403f099e41885bf870a08ddc720e18';
  static const _consumerSecret = 'cs_e18f1b6e3961481cb97a93f2b44fb405fc94a6db';

  Future<List<Product>> fetchProducts({int perPage = 20, int page = 1}) async {
    final uri = Uri.parse('$_baseUrl/products').replace(queryParameters: {
      'per_page': perPage.toString(),
      'page': page.toString(),
      'consumer_key': _consumerKey,
      'consumer_secret': _consumerSecret,
    });

    // Debug: show the final request url
    print('ProductService fetchProducts requesting: $uri');

    final res = await http.get(uri);

    print('ProductService response status: ${res.statusCode}');
    print('ProductService response body snippet: ${res.body.length > 800 ? res.body.substring(0, 800) : res.body}');

    if (res.statusCode == 200) {
      final List<dynamic> body = json.decode(res.body);
      return body.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load products: ${res.statusCode} ${res.reasonPhrase}');
    }
  }

  Future<Product> fetchProductById(String id) async {
    final uri = Uri.parse('$_baseUrl/products/$id').replace(queryParameters: {
      'consumer_key': _consumerKey,
      'consumer_secret': _consumerSecret,
    });

    print('ProductService fetchProductById requesting: $uri');

    final res = await http.get(uri);

    print('ProductService response status: ${res.statusCode}');
    print('ProductService response body snippet: ${res.body.length > 800 ? res.body.substring(0, 800) : res.body}');

    if (res.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(res.body);
      return Product.fromJson(body);
    } else {
      throw Exception('Failed to load product: ${res.statusCode} ${res.reasonPhrase}');
    }
  }
}
