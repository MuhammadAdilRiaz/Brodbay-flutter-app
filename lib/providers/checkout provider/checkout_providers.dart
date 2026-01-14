import 'package:brodbay/models/checkout_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/checkout_state.dart';


final checkoutProvider =
    StateNotifierProvider<CheckoutNotifier, CheckoutState>(
  (ref) => CheckoutNotifier(),
);

class CheckoutNotifier extends StateNotifier<CheckoutState> {
  CheckoutNotifier() : super(CheckoutState(items: []));

  void setItems(List<CheckoutItem> items) {
    state = state.copyWith(items: items);
  }

  void selectAddress(String address) {
    state = state.copyWith(selectedAddress: address);
  }

  void selectPayment(String method) {
    state = state.copyWith(paymentMethod: method);
  }

  Future<void> placeOrder() async {
    state = state.copyWith(isLoading: true);

    await Future.delayed(const Duration(seconds: 2));

    state = CheckoutState(items: []);
  }
}
