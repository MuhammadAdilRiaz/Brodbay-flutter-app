import 'package:html_unescape/html_unescape.dart';

class CategoryModel {
  static final HtmlUnescape _unescape = HtmlUnescape();

  final int id;
  final String name;
  final String image;
  final int parent;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.parent,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    int parseId(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is String) return int.tryParse(v) ?? 0;
      if (v is num) return v.toInt();
      return 0;
    }

    String parseName(dynamic v) {
      if (v == null) return '';
      return _unescape.convert(v.toString());
    }

    String parseImage(dynamic v) {
      try {
        if (v == null) return '';
        if (v is String) return v;
        if (v is Map) {
          if (v['src'] != null) return v['src'].toString();
          if (v['url'] != null) return v['url'].toString();
          if (v['thumbnail'] != null) return v['thumbnail'].toString();
          if (v['sizes'] is Map) {
            final sizes = v['sizes'] as Map;
            return (sizes['thumbnail'] ??
                    sizes['medium'] ??
                    sizes['full'] ??
                    '')
                .toString();
          }
        }
      } catch (_) {}
      return '';
    }

    final imageField =
        json['image'] ??
        json['thumbnail'] ??
        (json['images'] is List && json['images'].isNotEmpty
            ? json['images'][0]
            : null);

    return CategoryModel(
      id: parseId(json['id'] ?? json['term_id']),
      name: parseName(json['name'] ?? json['label']),
      image: parseImage(imageField),
      parent: parseId(json['parent']),
    );
  }
}
