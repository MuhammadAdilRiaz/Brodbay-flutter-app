import 'package:brodbay/models/checkout%20model/checkout_item.dart';



class CheckoutState {
  final List<CheckoutItem> items;
  final String? selectedAddress;
  final String? paymentMethod;
  final bool isLoading;

  CheckoutState({
    required this.items,
    this.selectedAddress,
    this.paymentMethod,
    this.isLoading = false,
  });

  double get subTotal {
    return items.fold(
      0,
      (total, item) => total + (item.price * item.quantity),
    );
  }

  CheckoutState copyWith({
    List<CheckoutItem>? items,
    String? selectedAddress,
    String? paymentMethod,
    bool? isLoading,
  }) {
    return CheckoutState(
      items: items ?? this.items,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
