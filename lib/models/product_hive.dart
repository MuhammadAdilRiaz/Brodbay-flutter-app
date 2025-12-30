import 'package:hive/hive.dart';
import 'products.dart';

part 'product_hive.g.dart';

@HiveType(typeId: 0)
class HiveProduct extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String imageUrl;
  @HiveField(3)
  final List<String> images;
  @HiveField(4)
  final double price;
  @HiveField(5)
  final double? salePrice;
  @HiveField(6)
  final double? regularPrice;
  @HiveField(7)
  final double averageRating;
  @HiveField(8)
  final String sold;

  HiveProduct({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.images,
    required this.price,
    this.salePrice,
    this.regularPrice,
    required this.averageRating,
    required this.sold,
  });

  factory HiveProduct.fromProduct(Product p) {
    return HiveProduct(
      id: p.id,
      title: p.title,
      imageUrl: p.imageUrl,
      images: p.images,
      price: p.price,
      salePrice: p.sale_price,
      regularPrice: p.regular_price,
      averageRating: p.average_rating,
      sold: p.sold,
    );
  }

  Product toProduct() {
    return Product(
      id: id,
      title: title,
      imageUrl: imageUrl,
      images: images,
      price: price,
      sale_price: salePrice,
      regular_price: regularPrice,
      average_rating: averageRating,
      sold: sold,
      minQty: 1,
      maxQty: 1,
      stepQty: 1,
      description: '',
      attributes: [],
      variations: [],
    );
  }
}
