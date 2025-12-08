// lib/screens/home_screen.dart
import 'package:brodbay/widgets/Header/Sticky%20Header/sticky_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/Product cards/Row product/product_head.dart';
import '../../providers/home_notifier.dart';
import 'widgets/App Bar/app_bar.dart';
import 'widgets/Sale Banner/sale_banner.dart';
import 'widgets/Search Bar/search_bar.dart';
import 'widgets/Tab Bar/tab_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final notifier = ref.read(homeNotifierProvider.notifier);
      notifier.updateScrollOffset(_scrollController.offset);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSticky = ref.watch(homeNotifierProvider.select((s) => s.isSticky));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: isSticky ? 0 : 380,
            decoration: BoxDecoration(
              color: isSticky ? Colors.transparent : null,
              gradient: isSticky
                  ? null
                  : const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFF6304),
                        Color(0xFFFF7D26),
                        Color(0xFFFF944D),
                        Color(0xFFFFB380),
                        Color(0xFFFFD1B3),
                        Color(0xFFFFFFFF),
                      ],
                    ),
            ),
          ),
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              const SliverToBoxAdapter(child: CustomAppBar()),
              _buildStickyHeader(SearchBarWidget(isSticky: isSticky), 90),
              _buildStickyHeader(TabRow(isSticky: isSticky), 55),
              const SliverToBoxAdapter(child: SaleBanner()),
              const SliverToBoxAdapter(
                child: ProductHead(isVertical: false),
              ),
              const SliverToBoxAdapter(
                child: ProductHead(isVertical: true),
              ),
            ],
          ),
        ],
      ),
    );
  }

  SliverPersistentHeader _buildStickyHeader(Widget child, double height) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: StickySliver(height: height, child: child),
    );
  }
}
