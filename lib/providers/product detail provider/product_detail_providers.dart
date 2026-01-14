import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/product model/products.dart';

/// ----------------------------
/// BASIC UI STATES
/// ----------------------------

final selectedImageIndexProvider = StateProvider<int>((ref) => 0);
final quantityProvider = StateProvider<int>((ref) => 1);

final showColorOptionsProvider = StateProvider<bool>((ref) => false);
final showSizeOptionsProvider = StateProvider<bool>((ref) => false);

/// ----------------------------
/// SELECTED ATTRIBUTES
/// ----------------------------

final selectedColorProvider = StateProvider<String?>((ref) => null);
final selectedSizeProvider = StateProvider<String?>((ref) => null);

/// ----------------------------
/// SELECTED VARIATION (SAFE)
/// ----------------------------

final selectedVariationProvider = Provider.family<ProductVariation?, Product>(
  (ref, product) {
    final color = ref.watch(selectedColorProvider);
    final size = ref.watch(selectedSizeProvider);

    if (color == null || size == null) return null;

    try {
      return product.variations.firstWhere(
        (v) =>
            v.attributes.any((a) => a.name == "Colours" && a.value == color) &&
            v.attributes.any((a) => a.name == "Sizes" && a.value == size),
      );
    } catch (_) {
      return null;
    }
  },
);


/// ----------------------------
/// CURRENT PRODUCT (directly from constructor)
/// ----------------------------

final currentProductProvider = Provider<Product?>((ref) => null);
