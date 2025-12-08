import 'package:flutter/material.dart';

class CartAppbar extends StatelessWidget {
  const CartAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Text("Cart", 
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
          const Spacer(),
          IconButton(onPressed: (){}, 
          icon: Icon(Icons.favorite_border_outlined)),
          IconButton(onPressed: (){},
           icon: Icon(Icons.delete_forever_outlined))
        ],)
      ],
    );
  }
}