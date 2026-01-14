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
  static const String baseUrl = 'https://brodbay.co.uk/wp-json/wc/store/products';
  static const String consumerKey = 'ck_6c90af34e3403f099e41885bf870a08ddc720e18';
  static const String consumerSecret = 'cs_e18f1b6e3961481cb97a93f2b44fb405fc94a6db';
}

class WooSecure {
  final http.Client _client;

  WooSecure([http.Client? client]) : _client = client ?? http.Client();

  /// Returns the raw http.Response so calling code can inspect status/body
  Future<http.Response> getProducts({int perPage = 20, int page = 1}) async {
    final uri = Uri.parse('${WooSecureConfig.baseUrl}').replace(
      queryParameters: {
        'per_page': perPage.toString(),
        'page': page.toString(),
      },
    );

    final credentials =
        '${WooSecureConfig.consumerKey}:${WooSecureConfig.consumerSecret}';
    final encoded = base64Encode(utf8.encode(credentials));

    final headers = {
      'Authorization': 'Basic $encoded',
      'Accept': 'application/json',
    };

    // Debug prints (remove in production)
    print('Requesting: $uri');
    print('Auth prefix: Basic ${encoded.substring(0, 8)}...');

    final response = await _client.get(uri, headers: headers);
    print('Response status: ${response.statusCode}');
    print('Response body snippet: ${response.body.substring(0, response.body.length.clamp(0, 800))}');
    return response;
  }

  void dispose() {
    _client.close();
  }
}
