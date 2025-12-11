// lib/providers/home_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeState {
  final bool isSticky;
  final int notificationCount;
  final String query;
  final bool isFocused;
  final int currentIndex;
  final List<String> categories;

  const HomeState({
    this.isSticky = false,
    this.notificationCount = 0,
    this.query = '',
    this.isFocused = false,
    this.currentIndex = 0,
    this.categories = const [
      'Electronics',
      'Fashion',
      'Home',
      'Beauty',
      'Toys',
      'Sports',
    ],
  });

  HomeState copyWith({
    bool? isSticky,
    int? notificationCount,
    String? query,
    bool? isFocused,
    int? currentIndex,
    List<String>? categories,
  }) {
    return HomeState(
      isSticky: isSticky ?? this.isSticky,
      notificationCount: notificationCount ?? this.notificationCount,
      query: query ?? this.query,
      isFocused: isFocused ?? this.isFocused,
      currentIndex: currentIndex ?? this.currentIndex,
      categories: categories ?? this.categories,
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier([HomeState? initial]) : super(initial ?? const HomeState());

  // Scroll handling with hysteresis to prevent flicker:
  // - becomes sticky when offset > _stickThreshold
  // - becomes non-sticky when offset < _unstickThreshold
  static const double _stickThreshold = 60.0;
  static const double _unstickThreshold = 40.0;

  void updateScrollOffset(double offset) {
    final shouldStick = offset > _stickThreshold;
    final shouldUnstick = offset < _unstickThreshold;

    if (shouldStick && !state.isSticky) {
      state = state.copyWith(isSticky: true);
    } else if (shouldUnstick && state.isSticky) {
      state = state.copyWith(isSticky: false);
    }
    // Otherwise keep the current state (hysteresis avoids immediate toggles)
  }

  // Notifications
  void increaseNotification() {
    state = state.copyWith(notificationCount: state.notificationCount + 1);
  }

  void resetNotification() {
    state = state.copyWith(notificationCount: 0);
  }

  // Search bar
  void setQuery(String value) {
    if (value == state.query) return;
    state = state.copyWith(query: value);
  }

  void setSticky(bool value) {
    if (value == state.isSticky) return;
    state = state.copyWith(isSticky: value);
  }

  void setFocused(bool value) {
    if (value == state.isFocused) return;
    state = state.copyWith(isFocused: value);
  }

  // Tab row
  void setIndex(int index) {
    if (index == state.currentIndex) return;
    state = state.copyWith(currentIndex: index);
  }
}

final homeNotifierProvider =
    StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier();
});
