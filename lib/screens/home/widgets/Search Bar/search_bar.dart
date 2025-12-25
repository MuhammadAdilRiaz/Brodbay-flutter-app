// lib/widgets/Search Bar/search_bar.dart
import 'package:brodbay/providers/category_provider.dart';
import 'package:brodbay/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/home_notifier.dart';

class SearchBarWidget extends ConsumerStatefulWidget {
  final bool isSticky;
  const SearchBarWidget({super.key, this.isSticky = false});

  @override
  ConsumerState<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends ConsumerState<SearchBarWidget> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(homeNotifierProvider.notifier);
      final state = ref.read(homeNotifierProvider);
      if (widget.isSticky) notifier.setSticky(true);
      _controller.text = state.query;
    });

    _controller.addListener(() {
      final notifier = ref.read(homeNotifierProvider.notifier);
      notifier.setQuery(_controller.text);
    });

    _focusNode.addListener(() {
      final notifier = ref.read(homeNotifierProvider.notifier);
      notifier.setFocused(_focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeNotifierProvider);
    final categoryIndex = ref.watch(categoryNotifierProvider.select((s) => s.selectedIndex));
    final double topPadding = state.isSticky ? 12.0 : 0.0;
    final theme = ref.watch(themeProvider);
    final bool hasCampaignGradient = theme.homeGradient.isNotEmpty;
    final bool showBorder =
    state.isSticky ||
    categoryIndex != 0 ||
    !hasCampaignGradient;



    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        color: Colors.transparent,
        child: Container(
          height: 55,
          alignment: Alignment.center,
          child: SizedBox(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Search products...',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                // keep TextField filled so it stands out above overlay
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: showBorder
                      ? const BorderSide(color: Colors.grey, width: 1)
                      : BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: showBorder
                      ? const BorderSide(color: Colors.grey, width: 1)
                      : BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: showBorder
                      ? const BorderSide(color: Colors.grey, width: 1)
                      : BorderSide.none,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.camera_alt_outlined,
                          color: Colors.black54, size: 35),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Camera tapped')),
                        );
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          final notifier = ref.read(homeNotifierProvider.notifier);
                          notifier.setSticky(true);
                          _focusNode.unfocus();
                        },
                        child: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
