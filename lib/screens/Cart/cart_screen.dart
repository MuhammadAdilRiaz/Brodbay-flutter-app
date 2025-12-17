import 'package:brodbay/providers/cart_providers.dart';
import 'package:brodbay/providers/product_providers.dart';
import 'package:brodbay/screens/Cart/widget/Cart%20Tile/cart_item_tile.dart';
import 'package:brodbay/screens/Cart/widget/Footer/cart_footer.dart';
import 'package:brodbay/screens/product%20Detail/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../widgets/Product cards/Row product/product_card.dart';
import 'widget/App Bar/cart_appbar.dart';
import 'widget/Empty Cart/empty_cart.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final isCartEmpty = cartItems.isEmpty;
    final products = ref.watch(filteredProductsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [

          /// Sliver AppBar
          SliverAppBar(
            pinned: true,
            toolbarHeight: 80,
           automaticallyImplyLeading: false, 
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  children: const [
                    Expanded(child: CartAppbar()),
                  ],
                 ),
                 ),
                  ),
                ),
               SliverToBoxAdapter(
                  child: isCartEmpty
                 ? const EmptyCartView()
                 : const SizedBox.shrink(),
                 ),

                  if (!isCartEmpty)
                   SliverList(
                     delegate: SliverChildBuilderDelegate(
                     (context, index) {
                       return CartItemTile(
                  item: cartItems[index],
                  );
                 },
                   childCount: cartItems.length,
                    ),
                       ),
                       if (!isCartEmpty)
                       const SliverToBoxAdapter(
                       child: CartFooter(),
                       ),


                        SliverToBoxAdapter(
                        child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text(
                       "You May Also Like",
                        style: TextStyle(
                       fontSize: 16,
                       fontWeight: FontWeight.bold,
                        ),
                      ),
                   ),
                  ),

    SliverPadding(
  padding: const EdgeInsets.symmetric(horizontal: 12),
  sliver: SliverMasonryGrid.count(
    crossAxisCount: 2,
    mainAxisSpacing: 8,
    crossAxisSpacing: 8,
    childCount: products.length,
    itemBuilder: (context, index) {
      final p = products[index];
      return ProductCard(
        product: p,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailScreen(product: p),
            ),
          );
        },
      );
    },
  ),
),

          const SliverToBoxAdapter(
            child: SizedBox(height: 120),
          ),
        ],
      ),
    );
  }
}
