import 'package:brodbay/providers/splash_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(appInitProvider, (previous, next) {
      next.whenData((_) {
        Navigator.pushReplacementNamed(context, '/home');
      });
    });

    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image(
          image: AssetImage("assets/logos/website-brodbay-logo.png"),
          width: 220,
        ),
      ),
    );
  }
}
