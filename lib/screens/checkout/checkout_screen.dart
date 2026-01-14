import 'package:brodbay/providers/checkout_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkout = ref.watch(checkoutProvider);
    final notifier = ref.read(checkoutProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// Order Summary
          const Text(
            'Order Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          ...checkout.items.map((item) {
            return Card(
              child: ListTile(
                leading: Image.network(
                  item.imageUrl,
                  width: 50,
                  errorBuilder: (_, __, ___) =>
                      Container(width: 50, color: Colors.grey[200]),
                ),
                title: Text(item.title),
                subtitle: Text('Qty ${item.quantity}'),
                trailing:
                    Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
              ),
            );
          }),

          const SizedBox(height: 16),

          /// Address
          ListTile(
            title: const Text('Delivery Address'),
            subtitle: Text(
              checkout.selectedAddress ?? 'Select address',
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              notifier.selectAddress('221B Baker Street, London');
            },
          ),

          const Divider(),

          /// Payment
          ListTile(
            title: const Text('Payment Method'),
            subtitle: Text(
              checkout.paymentMethod ?? 'Select payment',
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              notifier.selectPayment('Cash on Delivery');
            },
          ),
        ],
      ),

      /// Bottom Bar
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: checkout.isLoading
              ? null
              : () async {
                  await notifier.placeOrder();
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
          child: checkout.isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  'Place Order • \$${checkout.subTotal.toStringAsFixed(2)}',
                ),
        ),
      ),
    );
  }
}
