import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/category_model.dart';

class CategoryApiService {
  static const String _endpoint =
      "https://brodbay.co.uk/wp-json/wc/store/v1/products/categories";

  final http.Client _client;

  CategoryApiService({http.Client? client})
      : _client = client ?? http.Client();

  Future<List<CategoryModel>> fetchCategories({
    int perPage = 100,
    int page = 1,
  }) async {
    final uri = Uri.parse(_endpoint).replace(
      queryParameters: {
        'per_page': perPage.toString(),
        'page': page.toString(),
      },
    );

    final response = await _client.get(uri, headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to load categories: ${response.statusCode}');
    }

    final body = response.body;
    if (body.isEmpty) return [];

    final decoded = json.decode(body);

    if (decoded is List) {
      return decoded
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    if (decoded is Map) {
      // some endpoints wrap list in data / categories
      if (decoded.containsKey('categories') && decoded['categories'] is List) {
        return (decoded['categories'] as List)
            .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      if (decoded.containsKey('data') && decoded['data'] is List) {
        return (decoded['data'] as List)
            .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      // single object
      if (decoded.containsKey('id') && decoded.containsKey('name')) {
        return [CategoryModel.fromJson(decoded.cast<String, dynamic>())];
      }
    }

    return [];
  }

  void dispose() {
    _client.close();
  }
}
