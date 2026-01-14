/*import 'package:brodbay/providers/address_provider.dart';
import 'package:brodbay/providers/checkout_providers.dart';
import 'package:brodbay/screens/checkout/address%20screens/add_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddressBottomSheet extends ConsumerWidget {
  const AddressBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addresses = ref.watch(addressProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Select Address',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          ...addresses.map((address) {
            return ListTile(
              title: Text(address.name),
              subtitle: Text(address.addressLine),
              onTap: () {
                ref
                    .read(checkoutProvider.notifier)
                    .selectAddress(address);
                Navigator.pop(context);
              },
            );
          }),

          const Divider(),

          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddAddressScreen(),
                ),
              );
            },
            child: const Text('Add New Address'),
          ),
        ],
      ),
    );
  }
}
*/