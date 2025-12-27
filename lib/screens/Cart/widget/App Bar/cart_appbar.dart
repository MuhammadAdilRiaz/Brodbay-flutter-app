import 'package:flutter/material.dart';

class CartAppbar extends StatelessWidget {
  const CartAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight, // 👈 minimum recommended height
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// Back button (left)
          Positioned(
            left: 0,
            child: IconButton(
              padding: EdgeInsets.zero, // 👈 removes extra height
              constraints: const BoxConstraints(), // 👈 removes default size
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

          /// Center title
          const Text(
            "Cart",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
