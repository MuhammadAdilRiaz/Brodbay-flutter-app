import 'package:brodbay/models/product_hive.dart';
import 'package:hive/hive.dart';


class HiveProductCache {
  static const boxName = 'productsBox';

  Box<HiveProduct> get box => Hive.box<HiveProduct>(boxName);

  Future<void> saveProducts(List<HiveProduct> products) async {
    await box.clear(); // optional: overwrite old data
    for (var p in products) {
      await box.put(p.id, p);
    }
  }

  List<HiveProduct> getProducts() {
    return box.values.toList();
  }

  
}
