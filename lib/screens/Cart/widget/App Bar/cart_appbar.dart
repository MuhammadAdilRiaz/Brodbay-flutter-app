import 'package:flutter/material.dart';

class CartAppbar extends StatelessWidget {
  const CartAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child:   Row(
          children: [
            IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_ios_new)),
          Expanded(
            child: Center(
              child: Text("Cart", 
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            ),
          ),
         
        ],)
   
    );
  }
}