import 'package:flutter/material.dart';
import '../SearchBar/Product_Detail_SearchBar.dart';

class ProductDetailAppBar extends StatelessWidget {
  const ProductDetailAppBar({super.key});

  @override
  Widget build(BuildContext context) {
     final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      color: Color(0xFFFF6304),
      child: Padding(
        padding: EdgeInsets.only(
          top: statusBarHeight ,
          left: 10,
          right: 8,
          bottom: 0,
        ),
        child: Column(
          children: [
            ProductDetailSearchbar()
          ],
        ),
      ),
    );
  }
}