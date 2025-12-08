import 'package:flutter/material.dart';

class ProductDetailButton extends StatelessWidget {
  const ProductDetailButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         SizedBox(height: 5),
         
            ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(100, 35),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.deepOrangeAccent,
                   shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
            ),
            ),
                onPressed: () {},
             child: Center(
              child: Text("Add To Cart",
              style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white), ),
            ),),
         

       SizedBox( height: 5,),
      
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(100, 35),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.deepOrangeAccent,
                   shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
            ),
            ),
                onPressed: () {},
             child: Center(
              child: Text("Buy Now",
              style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white), ),
            ),),
       
      ],
    );
  }
}