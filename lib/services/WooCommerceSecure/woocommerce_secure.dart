// lib/services/WooCommerceSecure/woocommerce_secure.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final wooSecureProvider = Provider<WooSecure>((ref) {
  final client = WooSecure();
  ref.onDispose(() => client.dispose());
  return client;
});

class WooSecureConfig {
  // Base root for WooCommerce REST API - do NOT include /products here
  static const String baseUrl = 'https://brodbay.co.uk/wp-json/wc/v3';
  static const String consumerKey = 'ck_6c90af34e3403f099e41885bf870a08ddc720e18';
  static const String consumerSecret = 'cs_e18f1b6e3961481cb97a93f2b44fb405fc94a6db';
}

class WooSecure {
  final http.Client _client;

  WooSecure([http.Client? client]) : _client = client ?? http.Client();

  /// Request products using query parameters for keys (most-compatible)
  Future<http.Response> getProducts({int perPage = 20, int page = 1}) async {
    final uri = Uri.parse('${WooSecureConfig.baseUrl}/products').replace(
      queryParameters: {
        'per_page': perPage.toString(),
        'page': page.toString(),
        'consumer_key': WooSecureConfig.consumerKey,
        'consumer_secret': WooSecureConfig.consumerSecret,
      },
    );

    // Debug prints
    print('Requesting: $uri');

    final response = await _client.get(uri, headers: {
      'Accept': 'application/json',
    });

    print('Response status: ${response.statusCode}');
    print('Response body snippet: ${response.body.length > 800 ? response.body.substring(0, 800) : response.body}');
    return response;
  }

  void dispose() {
    _client.close();
  }
}
