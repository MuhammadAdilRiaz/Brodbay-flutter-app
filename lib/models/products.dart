// File: lib/models/product.dart
import 'dart:math';

class Product {
  final String id;
  final String imageUrl;
  final List<String> images; 
  final String title;
  final double price; 
  final double? sale_price; 
  final double? regular_price; 
  final double average_rating;
  final String sold; 
  final String description;
  final String currencySymbol; 

  

  Product({
    required this.id,
    required this.imageUrl,
    required this.images,
    required this.title,
    required this.price,
    this.sale_price,
    this.regular_price,
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

    int parseInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v.toString()) ?? 0;
    }

    // --- Prices are nested under `prices` in the API sample ---
    double finalPrice = 0.0;
    double? finalSalePrice;
    double? finalRegularPrice;
    String currencySym = '£';
    int minorUnit = 2; // default fallback

    try {
      final p = json['prices'];
      if (p is Map) {
        // raw values may be strings representing minor units, e.g. "1833"
        final rawPrice = p['price'];
        final rawSale = p['sale_price'];
        final rawRegular = p['regular_price'];
        minorUnit = parseInt(p['currency_minor_unit'] ?? p['currency_minor'] ?? 2);

        // safe parse of minor-unit prices
        double minorPrice = 0.0;
        if (rawPrice != null && rawPrice.toString().isNotEmpty) {
          minorPrice = parseDouble(rawPrice);
        }
        double minorSale = double.nan;
        if (rawSale != null && rawSale.toString().isNotEmpty) {
          minorSale = parseDouble(rawSale);
        }
        double minorRegular = double.nan;
        if (rawRegular != null && rawRegular.toString().isNotEmpty) {
          minorRegular = parseDouble(rawRegular);
        }

        final divisor = pow(10, minorUnit).toDouble();
        if (divisor > 0) {
          finalPrice = minorPrice / divisor;
          if (!minorSale.isNaN) finalSalePrice = minorSale / divisor;
          if (!minorRegular.isNaN) finalRegularPrice = minorRegular / divisor;
        } else {
          finalPrice = minorPrice;
          if (!minorSale.isNaN) finalSalePrice = minorSale;
          if (!minorRegular.isNaN) finalRegularPrice = minorRegular;
        }

        // currency symbol preference from payload
        if (p['currency_symbol'] != null && p['currency_symbol'].toString().isNotEmpty) {
          currencySym = p['currency_symbol'].toString();
        } else if (p['currency_prefix'] != null && p['currency_prefix'].toString().isNotEmpty) {
          currencySym = p['currency_prefix'].toString();
        } else if (p['currency_code'] != null && p['currency_code'].toString().isNotEmpty) {
          currencySym = p['currency_code'].toString();
        }
      } else {
        // fallback: top-level price keys (older APIs)
        final priceVal = parseDouble(json['price']);
        final saleVal = json.containsKey('sale_price') ? (json['sale_price'] == null ? null : parseDouble(json['sale_price'])) : null;
        final regularVal = json.containsKey('regular_price') ? (json['regular_price'] == null ? null : parseDouble(json['regular_price'])) : null;
        finalPrice = priceVal;
        finalSalePrice = saleVal;
        finalRegularPrice = regularVal;
        if (json.containsKey('currency') && json['currency'] != null) currencySym = json['currency'].toString();
      }
    } catch (_) {
      // leave defaults
    }

    // If regular_price equals current price, hide it (avoid showing identical crossed price)
    if (finalRegularPrice != null && (finalRegularPrice - finalPrice).abs() < 0.0001) {
      finalRegularPrice = null;
    }

    // If sale_price equals current price, null it so UI won't show duplicate
    if (finalSalePrice != null && (finalSalePrice - finalPrice).abs() < 0.0001) {
      finalSalePrice = null;
    }

    // ratings and review count
    final ratingVal = parseDouble(json['average_rating'] ?? json['rating'] ?? 0);

    // sold / total sales mapping - prefer total_sales numeric value
    String soldText = '';
    try {
      if (json.containsKey('total_sales') && json['total_sales'] != null && json['total_sales'].toString().isNotEmpty) {
        final ts = parseInt(json['total_sales']);
        soldText = '${ts}sold';
      } else if (json.containsKey('sold') && json['sold'] != null && json['sold'].toString().isNotEmpty) {
        final ts = parseInt(json['sold']);
        soldText = '${ts}sold';
      } else if (json['stock_availability'] is Map && json['stock_availability']['text'] != null) {
        // attempt to extract digits from "50 in stock" or similar
        final txt = json['stock_availability']['text'].toString();
        final match = RegExp(r'(\d+)').firstMatch(txt);
        if (match != null) {
          soldText = '${match.group(1)}';
        } else {
          soldText = '';
        }
      } else {
        soldText = '';
      }
    } catch (_) {
      soldText = '';
    }
   

    // description/title mapping (prefer name / title)
    final titleVal = (json['title'] ?? json['name'] ?? '').toString();
    final descVal = (json['description'] ?? json['short_description'] ?? '').toString();

    return Product(
      id: json['id']?.toString() ?? '',
      imageUrl: primaryImage,
      images: parsedImages,
      title: titleVal,
      price: finalPrice,
      sale_price: finalSalePrice,
      regular_price: finalRegularPrice,
      average_rating: ratingVal,
      sold: soldText,
      description: descVal,
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
      'regular_price': regular_price,
      'rating': average_rating,
      'sold': sold,
      'description': description,
      'currency': currencySymbol,
    };
  }
}
