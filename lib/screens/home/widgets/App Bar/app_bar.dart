// lib/widgets/Header/Custom App Bar/custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brodbay/providers/home%20provider/home_notifier.dart';

class CustomAppBar extends ConsumerWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    // only watch the notification count to minimize rebuilds
    final notificationCount =
        ref.watch(homeNotifierProvider.select((s) => s.notificationCount));

    return Padding(
      padding: EdgeInsets.only(
        top: statusBarHeight,
        left: 10,
        right: 8,
        bottom: 0,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                "assets/logos/website-brodbay-logo.png",
                height: 20,
              ),
              const Spacer(),

              // Keep the same IconButton but add a small badge using Stack
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: () {
                      // reset notifications when tapped
                      ref.read(homeNotifierProvider.notifier).resetNotification();
                    },
                    icon: Icon(
                      Icons.notifications_none_outlined,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      size: 30,
                    ),
                  ),

                  // Badge - only shown when notificationCount > 0
                  if (notificationCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          notificationCount > 99
                              ? '99+'
                              : notificationCount.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
