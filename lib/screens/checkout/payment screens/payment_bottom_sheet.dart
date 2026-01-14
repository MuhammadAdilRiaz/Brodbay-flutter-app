/*import 'package:brodbay/providers/checkout_providers.dart';
import 'package:brodbay/screens/checkout/payment%20screens/add_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class PaymentBottomSheet extends ConsumerWidget {
  const PaymentBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(checkoutProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Select Payment Method',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          ListTile(
            title: const Text('Cash on Delivery'),
            onTap: () {
              notifier.selectPayment('Cash on Delivery');
              Navigator.pop(context);
            },
          ),

          ListTile(
            title: const Text('Wallet'),
            onTap: () {
              notifier.selectPayment('Wallet');
              Navigator.pop(context);
            },
          ),

          ListTile(
            title: const Text('Card'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddCardScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
*/