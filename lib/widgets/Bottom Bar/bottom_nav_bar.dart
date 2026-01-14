import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/bottom bar provider/bottom_nav_providers.dart';
import '/screens/home/home.dart';
import '/screens/category/category.dart';
import '/screens/Cart/cart_screen.dart';
import '/screens/Profile/profile.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  static const List<Widget> _screens = <Widget>[
    HomeScreen(),
    CategoryScreen(),
   
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavProvider);

    return WillPopScope(
  onWillPop: () async {
    if (currentIndex != 0) {
      ref.read(bottomNavProvider.notifier).setIndex(0);
      return false;
    }
    return true;
  },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: IndexedStack(
         index: currentIndex > 2 ? currentIndex - 1 : currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFFFF6304),
          unselectedItemColor: Colors.grey,
          onTap: (index) {
  if (index == 2) {
    // Cart tapped → open full screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CartScreen(),
      ),
    );
  } else {
    ref.read(bottomNavProvider.notifier).setIndex(index);
  }
},
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              label: 'User',
            ),
          ],
        ),
      ),
    );
  }
}
