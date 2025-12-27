// lib/providers/connectivity_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final connectivityProvider = StateNotifierProvider<ConnectivityNotifier, bool>((ref) {
  return ConnectivityNotifier();
});

class ConnectivityNotifier extends StateNotifier<bool> {
  ConnectivityNotifier() : super(true) {
    _init();
  }

  void _init() {
    Connectivity().onConnectivityChanged.listen((result) {
      state = result != ConnectivityResult.none;
    });

    Connectivity().checkConnectivity().then((result) {
      state = result != ConnectivityResult.none;
    });
  }

  // Add a public method to re-check connectivity
  Future<void> checkConnection() async {
    final result = await Connectivity().checkConnectivity();
    state = result != ConnectivityResult.none;
  }
}
