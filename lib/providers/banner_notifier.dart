// lib/providers/banner_notifier.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BannerModel {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final DateTime? startAt;
  final DateTime? endAt;
  final bool isActive;
  final String? clickUrl;

  BannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.startAt,
    this.endAt,
    this.isActive = true,
    this.clickUrl,
  });

  BannerModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? imageUrl,
    DateTime? startAt,
    DateTime? endAt,
    bool? isActive,
    String? clickUrl,
  }) {
    return BannerModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imageUrl: imageUrl ?? this.imageUrl,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      isActive: isActive ?? this.isActive,
      clickUrl: clickUrl ?? this.clickUrl,
    );
  }

  bool get isTimeValid {
    final now = DateTime.now().toUtc();
    if (!isActive) return false;
    if (startAt != null && now.isBefore(startAt!.toUtc())) return false;
    if (endAt != null && now.isAfter(endAt!.toUtc())) return false;
    return true;
  }
}

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
  BannerNotifier([BannerState? initial]) : super(initial ?? const BannerState()) {
    // initial local banners
    _banners = [
      BannerModel(
        id: 'Local1',
        title: '11.11 Sale',
        subtitle: 'up to 80% Off',
        imageUrl: 'assets/images/Hoodies.png',
        isActive: true,
      ),
      BannerModel(
        id: 'Local2',
        title: 'Black Friday',
        subtitle: 'Up to 90% Off',
        imageUrl: 'assets/images/shirts.png',
        isActive: true,
      ),
    ];
    state = state.copyWith(banners: List.unmodifiable(_banners));
    _scheduleExpiryCheck();
  }

  List<BannerModel> _banners = [];
  Timer? _expiryTimer;

  List<BannerModel> get banners => List.unmodifiable(_banners);

  List<BannerModel> get liveBanners =>
      _banners.where((b) => b.isTimeValid).toList(growable: false);

  Future<void> fetchBanners() async {
    state = state.copyWith(loading: true, error: null);
    try {
      // keep same behavior as before
      _scheduleExpiryCheck();
      state = state.copyWith(loading: false, error: null);
    } catch (e) {
      // add fallback local banner as in original
      _banners.add(BannerModel(
        id: 'local1',
        title: '11.11 Sale',
        subtitle: 'Up to 80% OFF',
        imageUrl: 'assets/images/Hoodies.png',
      ));
      state = state.copyWith(
        loading: false,
        error: e.toString(),
        banners: List.unmodifiable(_banners),
      );
    }
  }

  void loadLocalBanners() {
    final local = [
      BannerModel(
        id: 'local1',
        title: '11.11 Sale',
        subtitle: 'Up to 80% OFF',
        imageUrl: 'assets/images/Hoodies.png',
      ),
      BannerModel(
        id: 'local2',
        title: 'Black Friday',
        subtitle: 'Massive discounts',
        imageUrl: 'assets/images/shirts.png',
      ),
    ];
    _banners.addAll(local);
    state = state.copyWith(banners: List.unmodifiable(_banners));
    _scheduleExpiryCheck();
  }

  void addBanner(BannerModel banner) {
    _banners.add(banner);
    state = state.copyWith(banners: List.unmodifiable(_banners));
    _scheduleExpiryCheck();
  }

  void updateBanner(String id, BannerModel updated) {
    final idx = _banners.indexWhere((b) => b.id == id);
    if (idx >= 0) {
      _banners[idx] = updated;
      state = state.copyWith(banners: List.unmodifiable(_banners));
    }
  }

  void removeBanner(String id) {
    _banners.removeWhere((b) => b.id == id);
    state = state.copyWith(banners: List.unmodifiable(_banners));
  }

  void _scheduleExpiryCheck() {
    _expiryTimer?.cancel();

    final now = DateTime.now().toUtc();
    DateTime? next;
    for (final b in _banners) {
      if (b.endAt != null && b.endAt!.toUtc().isAfter(now)) {
        next = next == null
            ? b.endAt!.toUtc()
            : (b.endAt!.toUtc().isBefore(next) ? b.endAt!.toUtc() : next);
      }
      if (b.startAt != null && b.startAt!.toUtc().isAfter(now)) {
        final start = b.startAt!.toUtc();
        next = next == null ? start : (start.isBefore(next) ? start : next);
      }
    }

    if (next != null) {
      final duration = next.difference(now) + const Duration(milliseconds: 200);
      _expiryTimer = Timer(duration, () {
        state = state.copyWith(banners: List.unmodifiable(_banners));
        _scheduleExpiryCheck();
      });
    }
  }

  @override
  void dispose() {
    _expiryTimer?.cancel();
    super.dispose();
  }
}

final bannerNotifierProvider =
    StateNotifierProvider<BannerNotifier, BannerState>((ref) {
  return BannerNotifier();
});
