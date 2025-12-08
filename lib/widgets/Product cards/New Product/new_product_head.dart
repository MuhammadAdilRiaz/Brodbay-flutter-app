
 /* import 'package:brodbay_project/widgets/Product%20cards/Row%20product/product_data.dart';
import 'package:flutter/material.dart';

class NewProductHead extends StatelessWidget {
  const NewProductHead({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Top Selling",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'montserrat',
                  ),
                ),
                Text(
                  "See all",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

             GridView.builder(
                      itemCount: products.length,
                      shrinkWrap: true,                      
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero, 
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,                  
                        childAspectRatio: 0.70,              
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 0,
                      ),
                      itemBuilder: (context, index) {
                        return NewProductCard();
                       },
                    )

        ],
      );
  }
}
*/