import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A simple StateNotifier that holds the selected index for the bottom nav.
class BottomNavNotifier extends StateNotifier<int> {
  BottomNavNotifier() : super(0);

  int get selectedIndex => state;

  void setIndex(int index) {
    if (index == state) return; // same behavior as your ChangeNotifier
    state = index;
  }
}

/// The provider you will import and use in widgets.
/// Usage: ref.watch(bottomNavProvider) to get index
/// and ref.read(bottomNavProvider.notifier).setIndex(i) to change it.
final bottomNavProvider =
    StateNotifierProvider<BottomNavNotifier, int>((ref) => BottomNavNotifier());
