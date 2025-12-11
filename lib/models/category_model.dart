// File: lib/models/category_model.dart

class CategoryModel {
  final int id;
  final String name;
  final String image; // full URL or empty string

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    // id parsing
    int parseId(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is String) return int.tryParse(v) ?? 0;
      if (v is num) return v.toInt();
      return 0;
    }

    // name parsing
    String parseName(dynamic v) {
      if (v == null) return '';
      return v.toString();
    }

    // image parsing - handle object or string or missing
    String parseImage(dynamic v) {
      try {
        if (v == null) return '';
        if (v is String) return v;
        if (v is Map) {
          // common keys used by WooCommerce
          if (v.containsKey('src') && v['src'] != null) return v['src'].toString();
          if (v.containsKey('url') && v['url'] != null) return v['url'].toString();
          if (v.containsKey('thumbnail') && v['thumbnail'] != null) return v['thumbnail'].toString();
          if (v.containsKey('sizes') && v['sizes'] is Map && (v['sizes']['thumbnail'] ?? v['sizes']['medium'] ?? v['sizes']['full']) != null) {
            final sizes = v['sizes'] as Map;
            return (sizes['thumbnail'] ?? sizes['medium'] ?? sizes['full']).toString();
          }
        }
      } catch (_) {}
      return '';
    }

    // Some API variants store image under 'image', others under 'images' array or 'thumbnail'
    dynamic imageField = json['image'] ?? json['thumbnail'] ?? (json['images'] is List ? (json['images'].isNotEmpty ? json['images'][0] : null) : null);

    return CategoryModel(
      id: parseId(json['id'] ?? json['term_id'] ?? 0),
      name: parseName(json['name'] ?? json['label'] ?? ''),
      image: parseImage(imageField),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}
