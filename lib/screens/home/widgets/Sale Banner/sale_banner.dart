// lib/widgets/Sale Banner/sale_banner.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brodbay/providers/banner_notifier.dart';

class SaleBanner extends ConsumerWidget {
  const SaleBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannerState = ref.watch(bannerNotifierProvider);

    if (bannerState.loading) {
      return SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // compute live banners from state.banners to preserve previous behavior
    final banners = bannerState.banners.where((b) {
      final now = DateTime.now().toUtc();
      if (!b.isActive) return false;
      if (b.startAt != null && now.isBefore(b.startAt!.toUtc())) return false;
      if (b.endAt != null && now.isAfter(b.endAt!.toUtc())) return false;
      return true;
    }).toList(growable: false);

    if (banners.isEmpty) {
      // Fallback UI when no live banners available
      return SizedBox(
        height: 200,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFFFF6304),
          ),
          alignment: Alignment.center,
          child: const Text(
            'No active promotions',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: banners.length,
        itemBuilder: (context, index) {
          final banner = banners[index];

          final isNetwork = banner.imageUrl.startsWith('http');

          return GestureDetector(
            onTap: () {
              if (banner.clickUrl != null) {
                // handle navigation to clickUrl or deep link
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Color(0xFFFF6304),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    banner.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    banner.subtitle,
                    style: const TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: isNetwork
                              ? Image.network(
                                  banner.imageUrl,
                                  height: 80,
                                  width: 100,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  banner.imageUrl,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: isNetwork
                              ? Image.network(
                                  banner.imageUrl,
                                  height: 80,
                                  width: 100,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  banner.imageUrl,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: isNetwork
                              ? Image.network(
                                  banner.imageUrl,
                                  height: 80,
                                  width: 100,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  banner.imageUrl,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
