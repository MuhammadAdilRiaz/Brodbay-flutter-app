// lib/screens/category_screen.dart
import 'package:brodbay/providers/connectivity_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widget/Left Column/category_left_menu.dart';
import 'widget/Right Column/right_panel.dart';
import 'widget/searchbar.dart'; // adjust path if needed

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(connectivityProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isOnline
            ? buildOnlineContent()
            : buildOfflineScreen(ref),
      ),
    );
  }

  // Online content – your existing CustomScrollView
  Widget buildOnlineContent() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          elevation: 0,
          backgroundColor: Colors.white,
          toolbarHeight: 70,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Expanded(child: CategorySearchBar()),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Colors.black,
                      size: 30,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            color: const Color(0xFFFF7D26),
            child: const Text(
              "11.11 SALE • Ends Nov 20",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ),
        SliverFillRemaining(
          child: Row(
            children: const [
              CategoryLeftMenu(),
              Expanded(
                child: CategoryRightPanel(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Offline content – full screen No Internet
  Widget buildOfflineScreen(WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          const Text(
            'Oops! No Internet',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
  onPressed: () {
    ref.read(connectivityProvider.notifier).checkConnection();
  },
  child: const Text('Try Again'),
),

        ],
      ),
    );
  }
}
