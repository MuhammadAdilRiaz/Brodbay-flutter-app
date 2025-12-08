
class Product {
  final String id;
  final String imageUrl;
  final List<String> images; // list of image urls (different colors)
  final String title;
  final double price;
  final double? sale_price;
  final double average_rating;
  final String sold;
  final String description;
  final String currencySymbol; // e.g. £ or $ or PKR

  Product({
    required this.id,
    required this.imageUrl,
    required this.images,
    required this.title,
    required this.price,
    this.sale_price,
    required this.average_rating,
    required this.sold,
    required this.description,
    this.currencySymbol = '£',
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // extract images list safely
    List<String> parsedImages = [];
    try {
      if (json['images'] is List) {
        parsedImages = (json['images'] as List)
            .map((e) {
              if (e is String) return e;
              if (e is Map && e.containsKey('src')) return e['src'].toString();
              return e.toString();
            })
            .where((s) => s.isNotEmpty)
            .toList();
      }
    } catch (_) {
      parsedImages = [];
    }

    // determine primary image - prefer images[0].src then check common keys
    String primaryImage = '';
    if (parsedImages.isNotEmpty) {
      primaryImage = parsedImages.first;
    } else {
      // legacy keys sometimes used in custom APIs
      primaryImage = (json['image_url'] ?? json['image'] ?? json['featured_image'] ?? '').toString();
    }

    // parse numeric fields defensively
    double parseDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    final priceVal = parseDouble(json['price']);
    final salepriceVal = json.containsKey('sale_price') ? (json['sale_price'] == null ? null : parseDouble(json['sale_price'])) : null;
    final ratingVal = parseDouble(json['average_rating']);


    // optional: try to read currency symbol from incoming payload if present
    String currencySym = '£';
    if (json.containsKey('currency') && (json['currency'] is String) && json['currency'].toString().isNotEmpty) {
      final cur = json['currency'].toString().toUpperCase();
      // a small mapping, extend as required
      if (cur == 'GBP' || cur == '£') currencySym = '£';
      else if (cur == 'USD' || cur == '\$') currencySym = '\$';
      else if (cur == 'PKR') currencySym = 'PKR';
      else currencySym = cur; // fallback show value
    }

    return Product(
      id: json['id']?.toString() ?? '',
      imageUrl: primaryImage,
      images: parsedImages,
      title: json['title'] ?? json['name'] ?? '',
      price: priceVal,
      sale_price: salepriceVal,
     average_rating: ratingVal,
      sold: json['sold']?.toString() ?? json['total_sales']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      currencySymbol: currencySym,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'images': images,
      'title': title,
      'price': price,
      'sale_price': sale_price,
      'rating': average_rating,
      'sold': sold,
      'description': description,
      'currency': currencySymbol,
    };
  }
}
