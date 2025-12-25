import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brodbay/providers/banner_notifier.dart';

class SaleBanner extends ConsumerWidget {
  const SaleBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bannerNotifierProvider);

    if (state.loading) {
      return const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final now = DateTime.now().toUtc();
    final banners = state.banners.where((b) {
      if (!b.isActive) return false;
      if (b.startAt != null && now.isBefore(b.startAt!.toUtc())) return false;
      if (b.endAt != null && now.isAfter(b.endAt!.toUtc())) return false;
      return true;
    }).toList();

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

          return GestureDetector(
            onTap: () {
              if (banner.clickUrl != null) {
                // navigate or deep link
              }
            },
            child: Image.network(
              banner.imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (c, w, p) {
                if (p == null) return w;
                return const Center(child: CircularProgressIndicator());
              },
            ),
          );
        },
      ),
    );
  }
}
