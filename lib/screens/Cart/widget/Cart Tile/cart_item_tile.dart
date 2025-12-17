import 'package:brodbay/models/cart_items.dart';
import 'package:brodbay/providers/cart_providers.dart';
import 'package:brodbay/screens/Cart/widget/Quantity/quantity_controll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartItemTile extends ConsumerWidget {
  final CartItem item;
  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                color: Colors.black12,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Selection tick (center aligned, small)
              GestureDetector(
                onTap: () {
                  ref.read(cartProvider.notifier)
                      .toggleSelection(item.id);
                },
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black),
                    color: item.isSelected
                        ? Colors.black
                        : Colors.transparent,
                  ),
                  child: item.isSelected
                      ? const Icon(
                          Icons.check,
                          size: 12,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),

              const SizedBox(width: 10),

              /// Product image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 12),

              /// Product info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title + delete icon in one row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            ref.read(cartProvider.notifier)
                                .removeItem(item.id);
                          },
                          child: const Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    /// Price row (same style as product card)
                    Row(
                      children: [
                       Text(
                  '${item.currencySymbol}${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6304),
                  ),
                  ),
                  const SizedBox(width: 6,),

                        if (item.regular_price != null)
                   Text(
                    '${item.currencySymbol}${item.regular_price!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 12,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                        ],
                      
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        Positioned(
          bottom: 12,
          right: 16,
          child: QuantityController(item: item),
        ),
      ],
    );
  }
}
