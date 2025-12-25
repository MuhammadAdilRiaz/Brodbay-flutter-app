import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brodbay/models/banner_model.dart';

class BannerState {
  final List<BannerModel> banners;
  final bool loading;
  final String? error;

  const BannerState({
    this.banners = const [],
    this.loading = false,
    this.error,
  });

  BannerState copyWith({
    List<BannerModel>? banners,
    bool? loading,
    String? error,
  }) {
    return BannerState(
      banners: banners ?? this.banners,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

class BannerNotifier extends StateNotifier<BannerState> {
  BannerNotifier() : super(const BannerState());

  Timer? _expiryTimer;

  /// Call this from initState or provider init
  Future<void> fetchBanners() async {
    state = state.copyWith(loading: true, error: null);

    try {
      // TEMP: empty list until real API is wired
      final List<BannerModel> apiBanners = [];

      state = state.copyWith(
        banners: apiBanners,
        loading: false,
      );

      _scheduleExpiryCheck(apiBanners);
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: e.toString(),
        banners: const [],
      );
    }
  }

  List<BannerModel> get liveBanners =>
      state.banners.where((b) => b.isTimeValid).toList(growable: false);

  void _scheduleExpiryCheck(List<BannerModel> banners) {
    _expiryTimer?.cancel();

    final now = DateTime.now().toUtc();
    DateTime? nextChange;

    for (final banner in banners) {
      if (banner.startAt != null && banner.startAt!.isAfter(now)) {
        nextChange = banner.startAt;
      }
      if (banner.endAt != null && banner.endAt!.isAfter(now)) {
        nextChange = nextChange == null
            ? banner.endAt
            : banner.endAt!.isBefore(nextChange!)
                ? banner.endAt
                : nextChange;
      }
    }

    if (nextChange != null) {
      _expiryTimer = Timer(
        nextChange!.difference(now),
        () => state = state.copyWith(banners: state.banners),
      );
    }
  }

  @override
  void dispose() {
    _expiryTimer?.cancel();
    super.dispose();
  }
}

final bannerNotifierProvider =
    StateNotifierProvider<BannerNotifier, BannerState>(
  (ref) => BannerNotifier(),
);
