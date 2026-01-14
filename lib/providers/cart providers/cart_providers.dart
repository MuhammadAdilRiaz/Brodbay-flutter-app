import 'package:brodbay/models/cart%20model/cart_items.dart';
import 'package:brodbay/providers/cart%20providers/cart_notifier.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartProvider =
    StateNotifierProvider<CartNotifier, List<CartItem>>(
  (ref) => CartNotifier(),
);



