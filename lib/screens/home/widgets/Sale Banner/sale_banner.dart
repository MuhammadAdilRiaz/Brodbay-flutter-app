import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brodbay/providers/banner_notifier.dart';

class SaleBanner extends ConsumerWidget {
  const SaleBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<BannerState>(bannerNotifierProvider, (_, __) {});

    final notifier = ref.read(bannerNotifierProvider.notifier);
    final state = ref.watch(bannerNotifierProvider);

    if (!state.loading && state.banners.isEmpty) {
      notifier.fetchBanners();
    }

    if (state.loading) {
      return const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final banners =
        state.banners.where((b) => b.isTimeValid).toList(growable: false);

    if (banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 180,
      width: double.infinity,
      child: PageView.builder(
        itemCount: banners.length,
        itemBuilder: (_, index) {
          final banner = banners[index];

          return Image.network(
            banner.imageUrl,
            width: double.infinity,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
