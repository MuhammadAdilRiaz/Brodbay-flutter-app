import 'package:flutter/material.dart';

import 'widget/App Bar/cart_appbar.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:  CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              toolbarHeight: 80,
              flexibleSpace: SafeArea(
                child: Padding(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row( children: [
                  Expanded(child: CartAppbar())
                ],),
                )),
            )
          ],
        ),
    );
  }
}