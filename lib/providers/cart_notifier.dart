import 'package:brodbay/models/cart_items.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(CartItem item) {
    state = [...state, item];
  }

  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }

  void toggleSelection(String id) {
  state = [
    for (final item in state)
      if (item.id == id)
        item.copyWith(isSelected: !item.isSelected)
      else
        item
  ];
}

void updateQuantity(String id, int qty) {
  state = [
    for (final item in state)
      if (item.id == id)
        item.copyWith(quantity: qty)
      else
        item
  ];
}
bool isInCart(String productId) {
  return state.any((item) => item.id == productId);
}
void addOrIgnore(CartItem item) {
  final exists = state.any((e) => e.id == item.id);
  if (!exists) {
    state = [...state, item];
  }
}

}
