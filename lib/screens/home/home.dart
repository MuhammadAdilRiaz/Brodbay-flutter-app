// lib/screens/home_screen.dart
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

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


  static const double _searchBarHeight = 90.0;
  static const double _tabBarHeight = 55.0;
  static const double _appBarContentHeight = 56.0; 
 
  double _overlayFraction = 0.5; 


final bool _useFixedOverlayPixels = false;
static const double _fixedOverlayPixels = 110.0; // change this value if using fixed pixels

  double get _collapseAmount => _appBarContentHeight;

  double _lastOffset = 0.0;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      _lastOffset = _scrollController.offset;
     
      final notifier = ref.read(homeNotifierProvider.notifier);
      notifier.updateScrollOffset(_scrollController.offset);

      setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  double _computeOverlayHeight(double statusBarHeight) {
  final double headerContentOnly =
      _appBarContentHeight + _searchBarHeight + _tabBarHeight;

  if (_useFixedOverlayPixels) {
    return max(statusBarHeight, _fixedOverlayPixels);
  }


  return statusBarHeight +
      (_overlayFraction.clamp(0.0, 1.0) * headerContentOnly) +
      22.0; 
}



  @override
  Widget build(BuildContext context) {
    final isSticky = ref.watch(homeNotifierProvider.select((s) => s.isSticky));
    final double statusBarHeight = MediaQuery.of(context).padding.top;

   
    final double headerHeight =
        statusBarHeight + _appBarContentHeight + _searchBarHeight + _tabBarHeight;

   final double overlayHeight = _computeOverlayHeight(statusBarHeight) ;


   
    final double offset = _lastOffset.clamp(0.0, double.infinity);
    final double translateY = -min(offset, _collapseAmount);

   
    final SystemUiOverlayStyle overlayStyle =
        isSticky ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
         
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
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
             
                SliverToBoxAdapter(
                  child: SizedBox(height: headerHeight),
                ),

                const SliverToBoxAdapter(child: SaleBanner()),
                const SliverToBoxAdapter(
                  child: ProductHead(isVertical: false),
                ),
                const SliverToBoxAdapter(
                  child: ProductHead(isVertical: true),
                ),
                // add other slivers/content as needed...
              ],
            ),

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                ignoring: true,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  height: isSticky ? overlayHeight : 0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 220),
                    opacity: isSticky ? 1.0 : 0.0,
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          height: overlayHeight,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.80),
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black.withOpacity(0.06),
                                width: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Transform.translate(
                offset: Offset(0, translateY),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    
                    const CustomAppBar(),

                    SearchBarWidget(isSticky: isSticky),
                    TabRow(isSticky: isSticky),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
